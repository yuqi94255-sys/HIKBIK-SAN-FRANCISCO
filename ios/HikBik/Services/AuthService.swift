// MARK: - Auth Service — 註冊/登錄後端接口（查重、註冊）
// 接真實後端時替換 baseURL 與請求體即可，調用方無需改動。

import Foundation

/// 註冊時後端返回的錯誤（如郵箱已被使用）
struct AuthError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

/// 是否為「郵箱已被使用」類錯誤（後端可能返回 "Email already in use" 或類似文案）
func isEmailAlreadyInUse(_ error: Error) -> Bool {
    let text = (error as? AuthError)?.message ?? error.localizedDescription
    return text.lowercased().contains("email") && (text.lowercased().contains("already") || text.lowercased().contains("in use") || text.lowercased().contains("exists"))
}

enum AuthService {
    /// 與 `AuthService.updateProfile` / `fetchCurrentUserProfile` 同實例入口（老闆要求：`AuthService.shared`）。
    static let shared = Shared()

    /// PATCH 成功回包：`{ "data": { ...UserProfile } }` 時用 `response.data` 賦值到 VM。
    struct UpdateProfileResponse {
        let data: UserProfile
    }

    struct Shared {
        func updateProfile(firstName: String, lastName: String, bio: String) async throws -> UpdateProfileResponse {
            try await AuthService.updateProfile(firstName: firstName, lastName: lastName, bio: bio)
        }

        func patchProfileAvatar(avatarUrl: String) async throws -> UpdateProfileResponse {
            try await AuthService.patchProfileAvatar(avatarUrl: avatarUrl)
        }

        func fetchCurrentUserProfile() async throws -> UserProfile {
            try await AuthService.fetchCurrentUserProfile()
        }
    }

    /// 與主後端同源，見 `APIConfig.baseURL`
    private static var baseURL: String { APIConfig.baseURL }

    /// 必須與 `AuthManager` / `APIClientBase` 完全一致（根治「登入失憶」）。
    static let authTokenUserDefaultsKey = "hikbik.authToken"

    /// 將後端回傳的 JWT / session 寫入 UserDefaults（`verifyOTP` / `login` / `register` 成功後調用）。
    static func persistAuthToken(_ token: String?) {
        if let t = token, !t.isEmpty {
            UserDefaults.standard.set(t, forKey: "hikbik.authToken")
            assert(authTokenUserDefaultsKey == "hikbik.authToken")
            print("🔑 Auth token saved to UserDefaults (hikbik.authToken)")
        } else {
            UserDefaults.standard.removeObject(forKey: "hikbik.authToken")
        }
    }

    /// 從 JSON 響應體解析 JWT（頂層或 `data` 嵌套；鍵名可微調）。
    static func parseAuthTokenFromResponseData(_ data: Data) -> String? {
        guard !data.isEmpty else { return nil }
        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return extractTokenFromJSONObject(obj)
    }

    /// 遞迴從字典取 token（含 `data` 為 `null`、嵌套物件等）。
    private static func extractTokenFromJSONObject(_ obj: [String: Any]) -> String? {
        let keys = ["token", "accessToken", "access_token", "jwt", "bearer"]
        for k in keys {
            if let s = obj[k] as? String, !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return s }
        }
        guard let dataVal = obj["data"] else { return nil }
        if dataVal is NSNull { return nil }
        if let s = dataVal as? String, !s.isEmpty { return s }
        if let nested = dataVal as? [String: Any] { return extractTokenFromJSONObject(nested) }
        return nil
    }

    /// 解析 `verify-otp` 回包：後端結構微調時仍盡量判斷；**只要 `success` 為 true（或等價）即視為成功**，`data` 可為 null。
    /// - Returns: `(ok, token)`；`ok == false` 時應拋錯或顯示 `message`。
    static func interpretVerifyOTPResponse(_ data: Data) -> (ok: Bool, token: String?, failureMessage: String?) {
        let raw = String(data: data, encoding: .utf8) ?? ""
        print("📟 [verify-otp RAW RESPONSE]\n\(raw)")

        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return (true, nil, nil)
        }

        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            let low = trimmed.lowercased()
            if low == "ok" || low == "success" || low == "\"ok\"" {
                return (true, nil, nil)
            }
            return (false, nil, "無法解析驗證回應。請在 Xcode 控制台查看「verify-otp RAW RESPONSE」原文。")
        }

        let token = extractTokenFromJSONObject(obj)

        if let explicitFail = obj["success"] as? Bool, explicitFail == false {
            let msg = (obj["message"] as? String) ?? (obj["error"] as? String) ?? (obj["msg"] as? String) ?? "驗證未通過"
            return (false, nil, msg)
        }
        if let s = obj["success"] as? String {
            let l = s.lowercased()
            if l == "false" || l == "0" || l == "no" {
                let msg = (obj["message"] as? String) ?? (obj["error"] as? String) ?? "驗證未通過"
                return (false, nil, msg)
            }
        }

        if let explicit = obj["success"] as? Bool, explicit {
            return (true, token, nil)
        }
        if let s = obj["success"] as? String, ["true", "1", "yes", "ok"].contains(s.lowercased()) {
            return (true, token, nil)
        }
        if let i = obj["success"] as? Int {
            if i == 0 {
                let msg = (obj["message"] as? String) ?? (obj["error"] as? String) ?? "驗證未通過"
                return (false, nil, msg)
            }
            return (true, token, nil)
        }

        if let st = obj["status"] as? String {
            let l = st.lowercased()
            if ["error", "fail", "failed"].contains(l) {
                let msg = (obj["message"] as? String) ?? (obj["error"] as? String) ?? "驗證未通過"
                return (false, nil, msg)
            }
            if ["ok", "success", "true"].contains(l) {
                return (true, token, nil)
            }
        }

        if token != nil {
            return (true, token, nil)
        }
        if obj["data"] is NSNull {
            return (true, nil, nil)
        }
        return (true, token, nil)
    }

    /// 從 JSON 響應體解析並寫入 UserDefaults。
    static func persistAuthTokenFromResponseData(_ data: Data) {
        persistAuthToken(parseAuthTokenFromResponseData(data))
    }

    /// 密碼登錄（老用戶）：POST `auth/login`，成功時保存 token。發送前會清空本地舊 Token，且 **`auth/login` 不帶 Authorization**。
    static func login(email: String, password: String) async throws {
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !e.isEmpty, !password.isEmpty else {
            throw AuthError(message: "Invalid email or password")
        }
        await MainActor.run {
            AuthManager.shared.stripAuthTokenBeforeCredentialLogin()
        }
        let data = try await APIClientBase.shared.post("auth/login", body: ["email": e, "password": password])
        persistAuthTokenFromResponseData(data)
    }

    /// `GET auth/check-email` 回包需含 **`isExistingUser`**（優先）或 `exists` / `registered`（相容舊後端）。
    private struct EmailAuthStatusResponse: Decodable {
        let isExistingUser: Bool?
        let exists: Bool?
        let registered: Bool?
    }

    /// 輸入 Email 後點「下一步」：向後端問路，**老用戶**走密碼登入，**新用戶**走驗證碼。
    static func resolveEmailIsExistingUser(_ email: String) async throws -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw AuthError(message: "Please enter a valid email address.")
        }
        #if DEBUG
        if trimmed.lowercased() == "existing@test.com" { return true }
        #endif
        let q: [String: String] = ["email": trimmed]
        let res: EmailAuthStatusResponse = try await APIClientBase.shared.get("auth/check-email", query: q)
        if let v = res.isExistingUser { return v }
        if let e = res.exists { return e }
        if let r = res.registered { return r }
        return false
    }

    /// 停止輸入 debounce 用：失敗時回 `false`，不拋錯。
    static func checkEmailExists(_ email: String) async -> Bool {
        do {
            return try await resolveEmailIsExistingUser(email)
        } catch {
            print("AuthService.checkEmailExists: \(error.localizedDescription)")
            return false
        }
    }

    /// 註冊。後端返回「郵箱已被使用」時拋出 AuthError(message: "Email already in use")；成功回包若含 token 會寫入 UserDefaults。
    static func register(
        email: String,
        firstName: String,
        middleName: String,
        lastName: String,
        password: String
    ) async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        #if DEBUG
        if trimmedEmail.lowercased() == "existing@test.com" {
            throw AuthError(message: "Email already in use")
        }
        #endif
        let body: [String: Any] = [
            "email": trimmedEmail,
            "firstName": firstName,
            "middleName": middleName,
            "lastName": lastName,
            "password": password
        ]
        let data = try await APIClientBase.shared.post("auth/register", body: body)
        persistAuthTokenFromResponseData(data)
    }

    /// 發送郵箱驗證碼（POST `/auth/send-otp`）。請求前會在控制台打印完整 URL，失敗時打印 URLError 細節。
    static func sendOTP(email: String) async throws {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        print("📡 準備請求：\(APIConfig.baseURL)auth/send-otp")
        do {
            _ = try await APIClientBase.shared.post("auth/send-otp", body: ["email": trimmed])
        } catch {
            if let error = error as? URLError {
                print("❌ 網路層錯誤: \(error.localizedDescription), Code: \(error.code.rawValue)")
            } else if case APIError.network(let underlying) = error {
                if let urlErr = underlying as? URLError {
                    print("❌ 網路層錯誤: \(urlErr.localizedDescription), Code: \(urlErr.code.rawValue)")
                } else {
                    print("❌ 其他錯誤: \(error)")
                }
            } else {
                print("❌ 其他錯誤: \(error)")
            }
            throw error
        }
    }

    /// 比對郵箱驗證碼（POST `auth/verify-otp`）。HTTP 成功後以 **`interpretVerifyOTPResponse`** 容錯解析；`success == true` 或等價即成功，`data` 可為 null。
    /// 若有 token 會寫入 `hikbik.authToken`。
    static func verifyOTP(email: String, code: String) async throws -> Data {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !trimmedCode.isEmpty else {
            throw AuthError(message: "Invalid Verification Code")
        }
        print("🚀 [VERIFY] 正在對比驗證碼: \(trimmedCode)")
        do {
            let data = try await APIClientBase.shared.post("auth/verify-otp", body: ["email": trimmedEmail, "code": trimmedCode])
            let outcome = interpretVerifyOTPResponse(data)
            if !outcome.ok {
                throw AuthError(message: outcome.failureMessage ?? "Verification failed")
            }
            if let t = outcome.token, !t.isEmpty {
                persistAuthToken(t)
            }
            return data
        } catch {
            if let err = error as? URLError {
                print("❌ 網路層錯誤: \(err.localizedDescription), Code: \(err.code.rawValue)")
            } else if case APIError.network(let underlying) = error {
                if let urlErr = underlying as? URLError {
                    print("❌ 網路層錯誤: \(urlErr.localizedDescription), Code: \(urlErr.code.rawValue)")
                } else {
                    print("❌ 其他錯誤: \(error)")
                }
            } else {
                print("❌ 其他錯誤: \(error)")
            }
            throw error
        }
    }

    /// 是否為驗證碼錯誤／過期（HTTP 400 或 401），用於 UI 顯示固定文案。
    static func isInvalidOrExpiredOTPError(_ error: Error) -> Bool {
        if case APIError.unauthorized = error { return true }
        if case APIError.serverError(let status, _) = error {
            return status == 400 || status == 401
        }
        return false
    }

    /// 拉取當前登錄用戶 Profile（MongoDB 同步）；需 `hikbik.authToken`。
    /// 統一 `GET /api/users/me`（路徑無前導 `/`，由 `APIClientBase` 與 `baseURL` 拼接；見控制台 `🚀 [FINAL URL]`）。
    /// **優先解 `json["data"]`**，再嘗試頂層 `UserProfile`。
    static func fetchCurrentUserProfile() async throws -> UserProfile {
        let data = try await APIClientBase.shared.getData("users/me")
        do {
            return try decodeUserProfileFromAPIBody(data)
        } catch {
            print("DEBUG_JSON decode UserProfile failed: \(error)")
            throw APIError.decoding(error)
        }
    }

    private static var userProfileJSONDecoder: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }

    /// **必須先解 `json["data"]`**（後端標準包一層），再解頂層；會 `print("DEBUG_JSON: …")`。
    private static func decodeUserProfileFromAPIBody(_ data: Data) throws -> UserProfile {
        let jsonString = String(data: data, encoding: .utf8) ?? ""
        print("DEBUG_JSON: \(jsonString)")

        guard !data.isEmpty else {
            throw APIError.noData
        }

        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            if let p = try? userProfileJSONDecoder.decode(UserProfile.self, from: data) {
                return p
            }
            throw APIError.noData
        }

        // 1) 最高優先：`data` 物件（PATCH/GET 常見）
        if let dataVal = obj["data"] {
            if let nestedDict = dataVal as? [String: Any],
               let nestedData = try? JSONSerialization.data(withJSONObject: nestedDict),
               let p = try? userProfileJSONDecoder.decode(UserProfile.self, from: nestedData) {
                return p
            }
            if let dataStr = dataVal as? String,
               let inner = dataStr.data(using: .utf8),
               let p = try? userProfileJSONDecoder.decode(UserProfile.self, from: inner) {
                return p
            }
        }

        // 2) 頂層即 UserProfile
        if let p = try? userProfileJSONDecoder.decode(UserProfile.self, from: data) {
            return p
        }

        // 3) 其他常見鍵
        for key in ["user", "profile", "me"] {
            if let nestedDict = obj[key] as? [String: Any],
               let nestedData = try? JSONSerialization.data(withJSONObject: nestedDict),
               let p = try? userProfileJSONDecoder.decode(UserProfile.self, from: nestedData) {
                return p
            }
        }

        throw APIError.decoding(
            NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "無法從 JSON 解出 UserProfile（已嘗試 data / 頂層 / user）"])
        )
    }

    /// 同步頭像 URL：`PATCH /api/users/profile`，body `{ "avatarUrl": "https://..." }`。
    static func patchProfileAvatar(avatarUrl: String) async throws -> UpdateProfileResponse {
        let body: [String: Any] = ["avatarUrl": avatarUrl]
        let data = try await APIClientBase.shared.patch("users/profile", body: body)
        let raw = String(data: data, encoding: .utf8) ?? ""
        print("📝 [PATCH PROFILE avatarUrl] response: \(raw.isEmpty ? "<empty>" : raw)")

        if data.isEmpty {
            let user = try await fetchCurrentUserProfile()
            return UpdateProfileResponse(data: user)
        }
        do {
            let user = try decodeUserProfileFromAPIBody(data)
            return UpdateProfileResponse(data: user)
        } catch {
            print("PATCH users/profile 解碼失敗，改拉 auth/me：\(error.localizedDescription)")
            let user = try await fetchCurrentUserProfile()
            return UpdateProfileResponse(data: user)
        }
    }

    /// 更新當前用戶：`PATCH /api/users/me`，body 為 `{ firstName, lastName, bio }`。
    /// 回傳 **`UpdateProfileResponse`**：`saveTapped` 請用 `response.data` 寫入 `userProfileVM.profile`。
    static func updateProfile(firstName: String, lastName: String, bio: String) async throws -> UpdateProfileResponse {
        print("[API] 發送更新請求：bio: [\(bio)]（欄位名為 bio，非 user_bio）")
        print("📝 [PATCH PROFILE] \(APIConfig.baseURL)users/me")
        let body: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "bio": bio
        ]
        let data = try await APIClientBase.shared.patch("users/me", body: body)
        let raw = String(data: data, encoding: .utf8) ?? ""
        print("[API] PATCH users/me response body: \(raw.isEmpty ? "<empty>" : raw)")

        if data.isEmpty {
            let user = try await fetchCurrentUserProfile()
            return UpdateProfileResponse(data: user)
        }

        do {
            let user = try decodeUserProfileFromAPIBody(data)
            return UpdateProfileResponse(data: user)
        } catch {
            print("PATCH body 解碼失敗，改拉 GET users/me：\(error.localizedDescription)")
            let user = try await fetchCurrentUserProfile()
            return UpdateProfileResponse(data: user)
        }
    }

    /// 上傳頭像：`POST /api/users/avatar`（multipart，欄位名 `avatar`）。
    static func uploadUserAvatar(imageData: Data) async throws {
        let mime = mimeTypeForImageData(imageData)
        let ext = mime.contains("png") ? "png" : (mime.contains("gif") ? "gif" : "jpg")
        _ = try await APIClientBase.shared.postMultipart(
            path: "users/avatar",
            fieldName: "avatar",
            fileName: "avatar.\(ext)",
            mimeType: mime,
            fileData: imageData
        )
    }

    private static func mimeTypeForImageData(_ data: Data) -> String {
        guard data.count >= 8 else { return "image/jpeg" }
        if data[0] == 0x89 && data[1] == 0x50 { return "image/png" }
        if data[0] == 0xFF && data[1] == 0xD8 { return "image/jpeg" }
        if data[0] == 0x47 && data[1] == 0x49 { return "image/gif" }
        return "image/jpeg"
    }
}
