// MARK: - Auth Manager — 全局身份管理，DEBUG 強制登出 / RELEASE 持久化
import SwiftUI

/// 單例：登錄狀態持久化，開發模式下每次啟動強制顯示登錄頁
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @AppStorage("isLoggedIn")
    var isLoggedIn: Bool = false

    @AppStorage("mockUserName")
    var mockUserName: String = ""

    private init() {
        #if DEBUG
        // 開發模式：每次從 Xcode 運行時強制顯示登錄頁
        isLoggedIn = false
        #endif
    }

    /// Mock Apple 登錄：觸感回饋 + 動畫設為已登錄 + 預設用戶名
    func mockAppleLogin() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        mockUserName = "Apple User"
        withAnimation(.spring()) {
            isLoggedIn = true
        }
        objectWillChange.send()
    }

    func logout() {
        mockUserName = ""
        withAnimation(.spring()) {
            isLoggedIn = false
        }
        objectWillChange.send()
    }
}
