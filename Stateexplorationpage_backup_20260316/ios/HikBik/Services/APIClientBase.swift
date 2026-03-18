// MARK: - 通用網絡層：Auth Header、JSON 編解碼、錯誤攔截
// 後端部署後替換 baseURL 與 authToken 來源即可

import Foundation

/// 網絡層錯誤（便於 UI 統一處理）
enum APIError: LocalizedError {
    case invalidURL(String)
    case noData
    case decoding(Error)
    case serverError(statusCode: Int, message: String?)
    case network(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL(let path): return "Invalid URL: \(path)"
        case .noData: return "No response data"
        case .decoding(let e): return "Decode error: \(e.localizedDescription)"
        case .serverError(let code, let msg): return msg ?? "Server error (\(code))"
        case .network(let e): return e.localizedDescription
        case .unauthorized: return "Unauthorized"
        }
    }
}

/// 通用 API 客戶端：Base URL、Auth Token、JSON、錯誤處理
final class APIClientBase {
    static let shared = APIClientBase()

    /// 後端 Base URL，正式環境替換為實際域名
    var baseURL: String {
        #if DEBUG
        return ProcessInfo.processInfo.environment["HIKBIK_API_BASE"] ?? "https://api.hikbik.example"
        #else
        return "https://api.hikbik.example"
        #endif
    }

    /// Auth Token：登錄後由 AuthService 或 Keychain 寫入，未登錄可為 nil
    var authToken: String? {
        // TODO: 從 Keychain / UserDefaults 讀取，例如 AuthService.currentToken
        UserDefaults.standard.string(forKey: "hikbik.authToken")
    }

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

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
        let data = try await request(path: path, method: "GET", query: query, body: nil as Data?)
        return try decoder.decode(T.self, from: data)
    }

    func post<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let bodyData = try encoder.encode(body)
        let data = try await request(path: path, method: "POST", query: [:], body: bodyData)
        return try decoder.decode(T.self, from: data)
    }

    func post(_ path: String, body: [String: Any]) async throws -> Data {
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        return try await request(path: path, method: "POST", query: [:], body: bodyData)
    }

    func put<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let bodyData = try encoder.encode(body)
        let data = try await request(path: path, method: "PUT", query: [:], body: bodyData)
        return try decoder.decode(T.self, from: data)
    }

    /// PUT 且不解析響應（適用 204 No Content 或忽略 body）
    func put<B: Encodable>(_ path: String, body: B) async throws {
        let bodyData = try encoder.encode(body)
        _ = try await request(path: path, method: "PUT", query: [:], body: bodyData)
    }

    func put(_ path: String, body: Data?) async throws -> Data {
        try await request(path: path, method: "PUT", query: [:], body: body)
    }

    // MARK: - 底層 request

    private func request(path: String, method: String, query: [String: String], body: Data?) async throws -> Data {
        let pathNormalized = path.hasPrefix("/") ? path : "/" + path
        guard var components = URLComponents(string: baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL),
              let base = components.url else {
            throw APIError.invalidURL(baseURL + pathNormalized)
        }
        guard let url = URL(string: pathNormalized, relativeTo: base)?.absoluteURL else {
            throw APIError.invalidURL(baseURL + pathNormalized)
        }
        var finalComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !query.isEmpty {
            finalComponents?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let finalURL = finalComponents?.url else {
            throw APIError.invalidURL(baseURL + pathNormalized)
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = authToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            request.httpBody = body
        }
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
            let message = (try? JSONDecoder().decode([String: String].self, from: data))?["message"] ?? (String(data: data, encoding: .utf8).flatMap { $0.isEmpty ? nil : $0 })
            throw APIError.serverError(statusCode: http.statusCode, message: message)
        }
        return data
    }
}
