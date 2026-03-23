// MARK: - User Profile — 數據驅動（UserDefaults + `GET auth/me` 與 MongoDB 同步）
import Foundation
import SwiftUI

/// Profile 頁與登入流程共用的用戶資料源；單例以便 `AuthManager` / `LandingView` / `TrackDataManager` 寫入。
final class UserProfileViewModel: ObservableObject {
    static let shared = UserProfileViewModel()

    private static let storageKey = "hikbik.userProfile"
    private static let legacyUserDataKey = "hikbik_user"
    private static let legacyUserNameKey = "hikbik_user_name"

    /// 已登入且本地或遠端已成功載入後非 nil；尚未載入完成前可能為 nil（顯示 Loading）。
    /// 老闆要求：`EditProfileSheet` 成功後可直接 `userProfileVM.profile = updatedProfile`（會持久化）。
    @Published var profile: UserProfile? {
        didSet {
            guard !isRestoringFromDisk else { return }
            if let user = profile {
                writeUserToPersistence(user, writeLegacyJSON: true)
            } else {
                clearPersistenceKeysOnly()
            }
        }
    }

    /// 正在向後端拉取 Profile（與 `profile == nil` 組合可顯示 ProgressView）。
    @Published private(set) var isLoadingRemoteProfile = false

    /// 從 UserDefaults 讀入時暫停 `didSet` 寫回，避免重複 I/O。
    private var isRestoringFromDisk = false

    private init() {
        loadFromStorage()
    }

    /// 從磁碟重新載入（例如他處已寫入 UserDefaults）。
    func reloadFromStorage() {
        loadFromStorage()
    }

    /// 登入狀態下從 `GET auth/me` 更新 MongoDB 欄位（firstName、bio、following 等）；失敗時保留本地快取。
    /// 亦在已寫入 `hikbik.authToken` 但 `AuthManager` 尚未切換時拉取（註冊/OTP 成功與 `onComplete` 之間）。
    func refreshFromServerIfLoggedIn() async {
        let token = UserDefaults.standard.string(forKey: AuthService.authTokenUserDefaultsKey)
        let hasToken = token != nil && !(token?.isEmpty ?? true)
        guard AuthManager.shared.isLoggedIn || hasToken else { return }
        await MainActor.run { isLoadingRemoteProfile = true }
        do {
            let remote = try await AuthService.fetchCurrentUserProfile()
            await MainActor.run {
                save(remote)
                isLoadingRemoteProfile = false
            }
        } catch {
            await MainActor.run { isLoadingRemoteProfile = false }
            print("UserProfileViewModel: fetch auth/me failed — \(error.localizedDescription)")
        }
    }

    private func loadFromStorage() {
        isRestoringFromDisk = true
        defer { isRestoringFromDisk = false }

        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            profile = decoded
            return
        }
        // 舊版：hikbik_user JSON（name / email）
        if let data = UserDefaults.standard.data(forKey: Self.legacyUserDataKey),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            let name = (json["name"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let email = (json["email"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if !name.isEmpty || !email.isEmpty {
                let parts = name.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                let first = parts.first.map(String.init) ?? ""
                let last = parts.count > 1 ? String(parts[1]) : ""
                let migrated = UserProfile(
                    firstName: first.isEmpty ? "Member" : first,
                    lastName: last,
                    email: email
                )
                isRestoringFromDisk = true
                profile = migrated
                isRestoringFromDisk = false
                writeUserToPersistence(migrated, writeLegacyJSON: false)
                return
            }
        }
        if let legacyName = UserDefaults.standard.string(forKey: Self.legacyUserNameKey)?
            .trimmingCharacters(in: .whitespacesAndNewlines), !legacyName.isEmpty {
            let migrated = UserProfile(firstName: legacyName, lastName: "", email: "")
            isRestoringFromDisk = true
            profile = migrated
            isRestoringFromDisk = false
            writeUserToPersistence(migrated, writeLegacyJSON: false)
            return
        }
        profile = nil
    }

    /// 登入/註冊成功後寫入（會同步舊鍵以便其他模組相容）。
    func save(_ user: UserProfile) {
        profile = user
    }

    /// **主線程**寫入：`PATCH /users/me` 回傳 JSON 解出後立刻覆寫 `@Published profile`（不靠隱式 fetch）。
    @MainActor
    func replaceProfileImmediately(_ user: UserProfile) {
        save(user)
    }

    /// 老闆要求：在主線程把 PATCH 回傳寫入 `@Published profile`。
    /// 若已在主線程則**同步**賦值，避免再包一層 `async` 導致 `dismiss` 早於更新執行。
    func applyPatchResponseOnMainThread(_ user: UserProfile) {
        if Thread.isMainThread {
            profile = user
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.profile = user
            }
        }
    }

    private func writeUserToPersistence(_ user: UserProfile, writeLegacyJSON: Bool) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
        let display = [user.firstName, user.lastName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        UserDefaults.standard.set(display.isEmpty ? user.firstName : display, forKey: Self.legacyUserNameKey)
        if writeLegacyJSON {
            let legacy: [String: Any] = [
                "name": display.isEmpty ? user.firstName : display,
                "email": user.email
            ]
            if let data = try? JSONSerialization.data(withJSONObject: legacy) {
                UserDefaults.standard.set(data, forKey: Self.legacyUserDataKey)
            }
        }
    }

    private func clearPersistenceKeysOnly() {
        UserDefaults.standard.removeObject(forKey: Self.storageKey)
        UserDefaults.standard.removeObject(forKey: Self.legacyUserDataKey)
        UserDefaults.standard.removeObject(forKey: Self.legacyUserNameKey)
    }

    func clear() {
        profile = nil
    }
}
