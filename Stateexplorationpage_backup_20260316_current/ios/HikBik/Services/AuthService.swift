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
    /// 後端「檢查郵箱是否已註冊」接口的 base URL，接真實後端時替換
    private static let baseURL = "https://api.hikbik.example"

    /// 校驗該 Email 是否已存在。停止輸入 500ms 後調用。
    /// - Returns: true 表示已存在（帳號已註冊），false 表示不存在可註冊
    static func checkEmailExists(_ email: String) async -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        // 模擬網絡延遲；接真實後端時改為 URLSession 請求，例如 GET /auth/check-email?email=xxx
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
        #if DEBUG
        // 測試用：特定郵箱視為已存在
        if trimmed.lowercased() == "existing@test.com" { return true }
        #endif
        // 真實實現示例（取消註釋並配置 baseURL 後使用）：
        // guard let url = URL(string: "\(baseURL)/auth/check-email?email=\(trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else { return false }
        // let (data, _) = try await URLSession.shared.data(from: url)
        // let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        // return (json?["exists"] as? Bool) ?? false
        return false
    }

    /// 註冊。後端返回「郵箱已被使用」時拋出 AuthError(message: "Email already in use")
    static func register(
        email: String,
        firstName: String,
        middleName: String,
        lastName: String,
        password: String
    ) async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        try await Task.sleep(nanoseconds: 800_000_000) // 模擬 0.8s 請求
        #if DEBUG
        if trimmedEmail.lowercased() == "existing@test.com" {
            throw AuthError(message: "Email already in use")
        }
        #endif
        // 真實實現：POST /auth/register，解析 409 或 4xx 錯誤體中的 message，拋出 AuthError(message: ...)
    }
}
