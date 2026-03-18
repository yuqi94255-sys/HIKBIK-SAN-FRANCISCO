// MARK: - RIDB API Service（GET /recareas 等），網路層自動注入 apikey Header

import Foundation

enum RIDBError: LocalizedError {
    case invalidURL
    case noData
    case decoding(Error)
    case serverError(Int, String?)
    case missingAPIKey

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid RIDB URL"
        case .noData: return "No response data"
        case .decoding(let e): return "Decode error: \(e.localizedDescription)"
        case .serverError(let code, let msg): return msg ?? "Server error (\(code))"
        case .missingAPIKey: return "RIDB API Key not configured"
        }
    }
}

final class RIDBService {
    static let shared = RIDBService()

    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
        decoder = JSONDecoder()
        // RIDB 回傳為 PascalCase（RecAreaID, RECDATA），由 Models 的 CodingKeys 對應
    }

    /// 備用 Key（plist 讀取失敗時暫時寫死測試，上線前移除或改為從環境變數讀取）
    private static let fallbackAPIKey = "9c45146a-1e7f-4cd1-8f97-d368da678c69"

    /// 所有對外請求統一注入 apikey 與 accept（Header 名全小寫、無空格）
    private func addRIDBHeaders(to request: inout URLRequest) {
        var key = RIDBAPIConfig.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if key.isEmpty {
            key = Self.fallbackAPIKey
            #if DEBUG
            print("[RIDB] 使用備用 Key 測試（plist 未讀到時）")
            #endif
        }
        request.setValue(key, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "accept")
    }

    /// GET /recareas，可選 query / state / limit / offset；Header 自動注入 apikey
    func fetchRecAreas(query: String? = nil, state: String? = nil, limit: Int = 50, offset: Int = 0) async throws -> [OutdoorDestination] {
        var key = RIDBAPIConfig.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if key.isEmpty { key = Self.fallbackAPIKey }
        guard !key.isEmpty else { throw RIDBError.missingAPIKey }

        var components = URLComponents(string: RIDBAPIConfig.baseURL + "/recareas")
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        if let q = query, !q.isEmpty { queryItems.append(URLQueryItem(name: "query", value: q)) }
        if let s = state, !s.isEmpty { queryItems.append(URLQueryItem(name: "state", value: s)) }
        components?.queryItems = queryItems

        guard let url = components?.url else { throw RIDBError.invalidURL }

        var request = URLRequest(url: url)
        addRIDBHeaders(to: &request)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw error
        }

        guard let http = response as? HTTPURLResponse else { throw RIDBError.noData }
        if http.statusCode >= 400 {
            let message = String(data: data, encoding: .utf8)
            throw RIDBError.serverError(http.statusCode, message)
        }

        let ridbResponse: RIDBRecAreaResponse
        do {
            ridbResponse = try decoder.decode(RIDBRecAreaResponse.self, from: data)
        } catch {
            throw RIDBError.decoding(error)
        }

        let list = ridbResponse.recData ?? []
        return list.map(RIDBAdapter.toOutdoorDestination)
    }

    /// 取得休閒區媒體圖片 URL（呼叫 GET /recareas/{recAreaID}/media）
    /// - Parameter recAreaID: 休閒區 ID（對應 NationalForest.id）
    /// - Returns: 圖片 URL 陣列；若 API 無數據或失敗則回傳空陣列，由呼叫端以本地 photos 補齊
    func fetchMedia(forRecAreaID recAreaID: String) async throws -> [URL] {
        guard !recAreaID.isEmpty else { return [] }
        var currentKey = RIDBAPIConfig.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if currentKey.isEmpty { currentKey = Self.fallbackAPIKey }
        #if DEBUG
        print("[API Auth Check] Key 長度: \(currentKey.count)")
        let keyPreview = String(currentKey.prefix(4)) + "..."
        print("[API Auth Check] Key 開頭為: \(keyPreview)")
        #endif
        guard !currentKey.isEmpty else { throw RIDBError.missingAPIKey }

        let path = "\(RIDBAPIConfig.baseURL)/recareas/\(recAreaID)/media"
        guard let url = URL(string: path) else { throw RIDBError.invalidURL }

        var request = URLRequest(url: url)
        addRIDBHeaders(to: &request)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw error
        }

        guard let http = response as? HTTPURLResponse else { throw RIDBError.noData }
        if http.statusCode == 404 {
            #if DEBUG
            print("[RIDB Debug] No media found for ID: \(recAreaID) (404)")
            #endif
            return []
        }
        if http.statusCode >= 400 {
            let message = String(data: data, encoding: .utf8)
            #if DEBUG
            print("[RIDB Debug] No media found for ID: \(recAreaID) (HTTP \(http.statusCode))")
            #endif
            throw RIDBError.serverError(http.statusCode, message)
        }

        let mediaResponse: RIDBRecAreaMediaResponse
        do {
            mediaResponse = try decoder.decode(RIDBRecAreaMediaResponse.self, from: data)
        } catch {
            #if DEBUG
            print("[RIDB Debug] No media found for ID: \(recAreaID) (decode error: \(error.localizedDescription))")
            #endif
            throw RIDBError.decoding(error)
        }

        let rawStrings = (mediaResponse.recData ?? [])
            .compactMap { $0.url?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        // RIDB 可能回傳 http，強制改為 https 以通過 ATS，避免 App Transport Security 阻擋
        let urls = rawStrings.compactMap { raw -> URL? in
            let normalized = raw.lowercased().hasPrefix("http://") ? "https" + raw.dropFirst(4) : raw
            return URL(string: normalized)
        }
        if urls.isEmpty {
            #if DEBUG
            print("[RIDB Debug] No media found for ID: \(recAreaID)")
            #endif
        }
        return urls
    }

    /// 取得休閒區媒體圖片 URL（對應 GET https://ridb.recreation.gov/api/v1/recareas/{ID}/media）
    /// - Parameter id: 休閒區 ID（RecAreaID）
    /// - Returns: 圖片 URL 陣列
    func fetchMedia(for id: String) async throws -> [URL] {
        try await fetchMedia(forRecAreaID: id)
    }

    /// 取得休閒區媒體圖片 URL（相容舊呼叫方式，內部轉調 fetchMedia(forRecAreaID:)）
    func fetchMedia(recAreaId: String) async throws -> [URL] {
        try await fetchMedia(forRecAreaID: recAreaId)
    }

    /// 依名稱查詢 RIDB，回傳第一個名稱相符的 RecAreaID（用於本地 id 與 RIDB 不一致時）
    func resolveRecAreaIDByName(areaName: String) async -> String? {
        guard !areaName.isEmpty else { return nil }
        let query = areaName
            .replacingOccurrences(of: " National Recreation Area", with: "")
            .replacingOccurrences(of: " NRA", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return nil }
        do {
            let list = try await fetchRecAreas(query: query, limit: 15)
            let lower = areaName.lowercased()
            if let match = list.first(where: { $0.name.lowercased().contains(query.lowercased()) || lower.contains($0.name.lowercased()) }) {
                return match.id
            }
            return list.first?.id
        } catch {
            return nil
        }
    }

    /// 取得單一休閒區詳情（GET /recareas/{recAreaID}），用於 NRA 詳情頁全量數據
    func fetchRecArea(recAreaID: String) async throws -> RIDBRecArea {
        guard !recAreaID.isEmpty else { throw RIDBError.invalidURL }
        var key = RIDBAPIConfig.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if key.isEmpty { key = Self.fallbackAPIKey }
        guard !key.isEmpty else { throw RIDBError.missingAPIKey }
        let path = "\(RIDBAPIConfig.baseURL)/recareas/\(recAreaID)"
        guard let url = URL(string: path) else { throw RIDBError.invalidURL }
        var request = URLRequest(url: url)
        addRIDBHeaders(to: &request)
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw RIDBError.noData }
        if http.statusCode == 404 {
            throw RIDBError.serverError(404, "RecArea not found")
        }
        if http.statusCode >= 400 {
            throw RIDBError.serverError(http.statusCode, String(data: data, encoding: .utf8))
        }
        do {
            return try decoder.decode(RIDBRecArea.self, from: data)
        } catch {
            if let wrapper = try? decoder.decode(RIDBRecAreaResponse.self, from: data),
               let first = wrapper.recData?.first {
                return first
            }
            throw RIDBError.decoding(error)
        }
    }

    /// 取得休閒區下設施列表（GET /recareas/{recAreaId}/facilities），用於 NRA 詳情頁動態設施
    func fetchFacilities(recAreaId: String) async throws -> [RIDBFacility] {
        guard !recAreaId.isEmpty else { return [] }
        var key = RIDBAPIConfig.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if key.isEmpty { key = Self.fallbackAPIKey }
        guard !key.isEmpty else { throw RIDBError.missingAPIKey }
        let path = "\(RIDBAPIConfig.baseURL)/recareas/\(recAreaId)/facilities"
        guard let url = URL(string: path) else { throw RIDBError.invalidURL }
        var request = URLRequest(url: url)
        addRIDBHeaders(to: &request)
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw RIDBError.noData }
        if http.statusCode == 404 || http.statusCode >= 400 {
            return []
        }
        let decoded = try? decoder.decode(RIDBFacilitiesResponse.self, from: data)
        return decoded?.recData ?? []
    }

    /// 取得休閒區活動名稱列表（若 API 有對應端點可在此擴充；目前回傳空陣列，由呼叫端用本地資料補齊）
    func fetchActivities(recAreaId: String) async throws -> [String] {
        guard !recAreaId.isEmpty else { return [] }
        // RIDB 若有 GET /recareas/{id}/activities 等端點可在此請求並解析
        return []
    }
}
