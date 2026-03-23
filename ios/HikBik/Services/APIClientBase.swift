// MARK: - 通用網絡層：Auth Header、JSON 編解碼、錯誤攔截
// 後端部署後替換 baseURL 與 authToken 來源即可

import Foundation

/// 網絡層錯誤（便於 UI 統一處理）
enum APIError: LocalizedError {
    case invalidURL(String)
    case noData
    case decoding(Error)
    /// HTTP 成功（常見 200）但 JSON 與模型不符；控制台會印出完整 raw body
    case responseDecodingFailed(httpStatus: Int, rawBody: String, underlying: Error)
    case serverError(statusCode: Int, message: String?)
    case network(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL(let path): return "Invalid URL: \(path)"
        case .noData: return "No response data"
        case .decoding(let e): return "Decode error: \(e.localizedDescription)"
        case .responseDecodingFailed(let code, _, let err):
            return "伺服器回傳 HTTP \(code)，但資料格式與 App 預期不符。請在 Xcode 控制台搜尋「API RAW RESPONSE」查看完整原文。解析細節：\(err.localizedDescription)"
        case .serverError(let code, let msg): return msg ?? "Server error (\(code))"
        case .network(let e): return e.localizedDescription
        case .unauthorized: return "Unauthorized"
        }
    }
}

/// 通用 API 客戶端：Base URL、Auth Token、JSON、錯誤處理
/// 統一使用 `APIConfig.baseURL`；DEBUG 可設環境變數 `HIKBIK_API_BASE` 覆蓋（便於本地調試）。
final class APIClientBase {
    static let shared = APIClientBase()

    var baseURL: String {
        #if DEBUG
        if let override = ProcessInfo.processInfo.environment["HIKBIK_API_BASE"], !override.isEmpty {
            return override
        }
        #endif
        return APIConfig.baseURL
    }

    /// Auth Token：登錄後由 AuthService 或 Keychain 寫入，未登錄可為 nil
    var authToken: String? {
        // TODO: 從 Keychain / UserDefaults 讀取，例如 AuthService.currentToken
        UserDefaults.standard.string(forKey: "hikbik.authToken")
    }

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    /// 換取 Token 的匿名端點：**禁止**附帶 `Authorization`（勿用舊 Bearer 換新 Token）。
    private static let pathsWithoutAuthorization: Set<String> = [
        "auth/login",
        "auth/register",
        "auth/send-otp",
        "auth/verify-otp",
        "auth/check-email"
    ]

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    // MARK: - 請求入口

    func get<T: Decodable>(_ path: String, query: [String: String] = [:]) async throws -> T {
        let (data, http) = try await performRequest(path: path, method: "GET", query: query, body: nil as Data?)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("📟 [API RAW RESPONSE — JSON decode failed] GET \(path) HTTP \(http.statusCode)")
            print(String(data: data, encoding: .utf8) ?? "")
            throw APIError.responseDecodingFailed(httpStatus: http.statusCode, rawBody: String(data: data, encoding: .utf8) ?? "", underlying: error)
        }
    }

    /// 原始響應 Data（供 `AuthService` 印 `DEBUG_JSON` 後自訂解碼）。
    func getData(_ path: String, query: [String: String] = [:]) async throws -> Data {
        let (data, _) = try await performRequest(path: path, method: "GET", query: query, body: nil as Data?)
        return data
    }

    func post<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let bodyData = try encoder.encode(body)
        let (data, http) = try await performRequest(path: path, method: "POST", query: [:], body: bodyData)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("📟 [API RAW RESPONSE — JSON decode failed] POST \(path) HTTP \(http.statusCode)")
            print(String(data: data, encoding: .utf8) ?? "")
            throw APIError.responseDecodingFailed(httpStatus: http.statusCode, rawBody: String(data: data, encoding: .utf8) ?? "", underlying: error)
        }
    }

    func post(_ path: String, body: [String: Any]) async throws -> Data {
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let (data, _) = try await performRequest(path: path, method: "POST", query: [:], body: bodyData)
        return data
    }

    func put<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let bodyData = try encoder.encode(body)
        let (data, http) = try await performRequest(path: path, method: "PUT", query: [:], body: bodyData)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("📟 [API RAW RESPONSE — JSON decode failed] PUT \(path) HTTP \(http.statusCode)")
            print(String(data: data, encoding: .utf8) ?? "")
            throw APIError.responseDecodingFailed(httpStatus: http.statusCode, rawBody: String(data: data, encoding: .utf8) ?? "", underlying: error)
        }
    }

    /// PUT 且不解析響應（適用 204 No Content 或忽略 body）
    func put<B: Encodable>(_ path: String, body: B) async throws {
        let bodyData = try encoder.encode(body)
        _ = try await performRequest(path: path, method: "PUT", query: [:], body: bodyData)
    }

    func put(_ path: String, body: Data?) async throws -> Data {
        let (data, _) = try await performRequest(path: path, method: "PUT", query: [:], body: body)
        return data
    }

    /// PATCH，body 為 JSON 字典（鍵名按調用方傳入，不強制轉 snake_case，便於與後端約定 camelCase）。
    func patch(_ path: String, body: [String: Any]) async throws -> Data {
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let (data, _) = try await performRequest(path: path, method: "PATCH", query: [:], body: bodyData)
        return data
    }

    /// `multipart/form-data` 上傳（例如 `POST /api/users/avatar`）。
    func postMultipart(path: String, fieldName: String, fileName: String, mimeType: String, fileData: Data) async throws -> Data {
        let pathNormalized = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard var finalComponents = URLComponents(string: baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL) else {
            throw APIError.invalidURL(baseURL + "/" + pathNormalized)
        }
        let basePath = finalComponents.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if basePath.isEmpty {
            finalComponents.path = "/" + pathNormalized
        } else if !pathNormalized.isEmpty {
            finalComponents.path = "/" + basePath + "/" + pathNormalized
        } else {
            finalComponents.path = "/" + basePath
        }
        guard let finalURL = finalComponents.url else {
            throw APIError.invalidURL(baseURL + "/" + pathNormalized)
        }

        let boundary = "Boundary-\(UUID().uuidString.replacingOccurrences(of: "-", with: ""))"
        var body = Data()
        let prefix = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\nContent-Type: \(mimeType)\r\n\r\n"
        guard let prefixData = prefix.data(using: .utf8),
              let suffixData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else {
            throw APIError.noData
        }
        body.append(prefixData)
        body.append(fileData)
        body.append(suffixData)

        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = authToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        print("🚀 [MULTIPART] \(finalURL.absoluteString) field=\(fieldName) bytes=\(fileData.count)")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.network(error)
        }
        guard let http = response as? HTTPURLResponse else {
            throw APIError.noData
        }
        if http.statusCode == 401 {
            throw APIError.unauthorized
        }
        if http.statusCode >= 400 {
            print("📟 [API RAW RESPONSE — HTTP \(http.statusCode)] multipart \(path)")
            print(String(data: data, encoding: .utf8) ?? "")
            let message = (try? JSONDecoder().decode([String: String].self, from: data))?["message"] ?? (String(data: data, encoding: .utf8).flatMap { $0.isEmpty ? nil : $0 })
            throw APIError.serverError(statusCode: http.statusCode, message: message)
        }
        return data
    }

    // MARK: - 底層 request

    /// 回傳 `(data, http)`，供解碼失敗時印出狀態碼與原文。
    private func performRequest(path: String, method: String, query: [String: String], body: Data?) async throws -> (Data, HTTPURLResponse) {
        let pathNormalized = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard var finalComponents = URLComponents(string: baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL) else {
            throw APIError.invalidURL(baseURL + "/" + pathNormalized)
        }
        let basePath = finalComponents.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if basePath.isEmpty {
            finalComponents.path = "/" + pathNormalized
        } else if !pathNormalized.isEmpty {
            finalComponents.path = "/" + basePath + "/" + pathNormalized
        } else {
            finalComponents.path = "/" + basePath
        }
        if !query.isEmpty {
            finalComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let finalURL = finalComponents.url else {
            throw APIError.invalidURL(baseURL + "/" + pathNormalized)
        }
        let pathKey = pathNormalized.trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
        let attachAuth = Self.shouldAttachAuthorizationHeader(pathKey: pathKey)

        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if attachAuth, let token = authToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if !attachAuth {
            #if DEBUG
            print("🔓 [API] Anonymous auth path — omitting Authorization header: \(pathKey)")
            #endif
        }
        if let body = body {
            request.httpBody = body
        }
        print("🚀 [FINAL URL] \(request.url?.absoluteString ?? "URL 拼裝失敗")")
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            if let error = error as? URLError {
                print("❌ 網路層錯誤: \(error.localizedDescription), Code: \(error.code.rawValue)")
            } else {
                print("❌ 其他錯誤: \(error)")
            }
            throw APIError.network(error)
        }
        guard let http = response as? HTTPURLResponse else {
            throw APIError.noData
        }
        if http.statusCode == 401 {
            throw APIError.unauthorized
        }
        if http.statusCode >= 400 {
            print("📟 [API RAW RESPONSE — HTTP \(http.statusCode)] \(request.url?.absoluteString ?? path)")
            print(String(data: data, encoding: .utf8) ?? "")
            let message = (try? JSONDecoder().decode([String: String].self, from: data))?["message"] ?? (String(data: data, encoding: .utf8).flatMap { $0.isEmpty ? nil : $0 })
            throw APIError.serverError(statusCode: http.statusCode, message: message)
        }
        return (data, http)
    }

    private static func shouldAttachAuthorizationHeader(pathKey: String) -> Bool {
        !pathsWithoutAuthorization.contains(pathKey)
    }
}
