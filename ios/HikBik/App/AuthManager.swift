// MARK: - Auth Manager — 全局登入狀態（Guest vs Member 唯一判斷基準）
import SwiftUI
import Combine

/// 單例：`isLoggedIn == true` 為會員；遊客瀏覽為 `false`（與是否完成 Landing 無關，由 `HikBikApp` 控制是否進入主界面）。
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    /// 持久化鍵（新）；兼容舊版 AppStorage `isLoggedIn`
    private static let storageKey = "hikbik.AuthManager.isLoggedIn"
    private static let legacyKey = "isLoggedIn"
    /// 與 `APIClientBase` / `AuthService` 一致
    private static let authTokenKey = "hikbik.authToken"

    @Published private(set) var isLoggedIn: Bool

    @Published var mockUserName: String

    private init() {
        let token = UserDefaults.standard.string(forKey: Self.authTokenKey)
        let hasToken = token != nil && !(token?.isEmpty ?? true)
        // 有有效 Token 視為已登入（修復冷啟動回到註冊頁）
        if hasToken {
            isLoggedIn = true
            UserDefaults.standard.set(true, forKey: Self.storageKey)
            UserDefaults.standard.set(true, forKey: Self.legacyKey)
        } else if UserDefaults.standard.object(forKey: Self.storageKey) != nil {
            isLoggedIn = UserDefaults.standard.bool(forKey: Self.storageKey)
        } else {
            let legacy = UserDefaults.standard.bool(forKey: Self.legacyKey)
            isLoggedIn = legacy
            UserDefaults.standard.set(legacy, forKey: Self.storageKey)
        }
        mockUserName = UserDefaults.standard.string(forKey: "mockUserName") ?? ""
    }

    /// 與 `AuthService` / `APIClientBase` 一致；驗證成功時必須寫入此鍵。
    static var storedAuthTokenKey: String { authTokenKey }

    /// App 根視圖 `onAppear`：再次依本地 Token 同步登入狀態、關閉 Landing、拉取 Profile。
    @MainActor
    func syncSessionAtLaunch(userState: UserState) {
        let token = UserDefaults.standard.string(forKey: Self.authTokenKey)
        let hasToken = token != nil && !(token?.isEmpty ?? true)
        guard hasToken else { return }
        if !isLoggedIn { setLoggedIn(true) }
        userState.userStatus = .registered
        userState.showLandingFromApp = false
        Task { await UserProfileViewModel.shared.refreshFromServerIfLoggedIn() }
    }

    private func persistMockUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: "mockUserName")
    }

    private func persistLoggedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Self.storageKey)
        UserDefaults.standard.set(value, forKey: Self.legacyKey)
    }

    /// 設置登入狀態（郵件註冊 / 登入 / Apple / 登出 均走此入口）
    func setLoggedIn(_ value: Bool) {
        guard isLoggedIn != value else { return }
        isLoggedIn = value
        persistLoggedIn(value)
        objectWillChange.send()
    }

    /// Mock Apple 登錄：觸感回饋 + 設為已登錄 + 預設用戶名
    func mockAppleLogin() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if mockUserName.isEmpty {
            mockUserName = "Apple User"
            persistMockUserName(mockUserName)
        }
        let parts = mockUserName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        let first = parts.first.map(String.init) ?? "Apple"
        let last = parts.count > 1 ? String(parts[1]) : ""
        UserProfileViewModel.shared.save(UserProfile(firstName: first, lastName: last, email: ""))
        withAnimation(.spring()) {
            setLoggedIn(true)
        }
    }

    func logout() {
        mockUserName = ""
        persistMockUserName("")
        UserDefaults.standard.removeObject(forKey: Self.authTokenKey)
        UserProfileViewModel.shared.clear()
        withAnimation(.spring()) {
            setLoggedIn(false)
        }
    }

    /// 進入郵件/密碼登入或註冊流程時呼叫：清空 **`hikbik.authToken`**，避免舊 Bearer 被帶上換新 Token。
    /// 僅移除 Token 並同步 `isLoggedIn`；**不**清空 Profile（與全量 `logout` 區分）。
    func stripAuthTokenBeforeCredentialLogin() {
        UserDefaults.standard.removeObject(forKey: Self.authTokenKey)
        if isLoggedIn {
            setLoggedIn(false)
        }
    }
}
