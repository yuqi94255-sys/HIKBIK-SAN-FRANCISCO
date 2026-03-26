// MARK: - 社區發布：上傳圖片 → 替換雲端 URL → POST publish
import Foundation

/// 與後端 `/api/social/publish` 對齊的帖子類型（`postCategory` 欄位）。
enum CommunityPostCategoryAPI: String, Codable {
    case communityMacro = "COMMUNITY_MACRO"
    case communityMicro = "COMMUNITY_MICRO"

    static func from(postCategory: PostCategory) -> CommunityPostCategoryAPI {
        switch postCategory {
        case .grandJourney: return .communityMacro
        case .detailedTrack, .livelyActivity: return .communityMicro
        }
    }
}

/// 單例入口：`SocialPublishService.shared.publish(…)`。發布成功須伺服器回傳 **HTTP 201**，否則拋錯（不寫入本地發布列表）。
final class SocialPublishService {
    static let shared = SocialPublishService()
    private init() {}

    private let uploadPath = "social/upload-image"
    private let publishPath = "social/publish"

    /// `payload` 內維持 **camelCase**（與 iOS `Codable` 預設一致）；頂層仍手寫 `postCategory`。
    private var payloadEncoder: JSONEncoder {
        let e = JSONEncoder()
        return e
    }

    /// 循環上傳多張 JPEG；任一失敗則拋錯（中止後續發布）。
    func uploadAllJPEGData(_ items: [Data]) async throws -> [String] {
        var urls: [String] = []
        for data in items {
            let url = try await uploadSocialImage(jpegData: data)
            urls.append(url)
        }
        return urls
    }

    /// `POST /api/social/upload-image`（multipart，欄位名 `file`，與後端 Multer 一致）。
    func uploadSocialImage(jpegData: Data) async throws -> String {
        let data = try await APIClientBase.shared.postMultipart(
            path: uploadPath,
            fieldName: "file",
            fileName: "post_\(UUID().uuidString.prefix(8)).jpg",
            mimeType: "image/jpeg",
            fileData: jpegData
        )
        return try Self.extractImageURL(from: data)
    }

    /// 從上傳回包解析 Cloudinary / 通用 `url`（支援 `data`、`secure_url`）。
    private static func extractImageURL(from data: Data) throws -> String {
        let raw = String(data: data, encoding: .utf8) ?? ""
        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw APIError.decoding(NSError(domain: "SocialPublish", code: -1, userInfo: [NSLocalizedDescriptionKey: "上傳回應非 JSON：\(raw.prefix(200))"]))
        }
        if let url = firstString(in: obj, keys: ["url", "secureUrl", "secure_url", "imageUrl", "imageURL"]) {
            return url
        }
        if let nested = obj["data"] as? [String: Any],
           let url = firstString(in: nested, keys: ["url", "secureUrl", "secure_url", "imageUrl"]) {
            return url
        }
        throw APIError.decoding(NSError(domain: "SocialPublish", code: -2, userInfo: [NSLocalizedDescriptionKey: "上傳回應缺少 url：\(raw.prefix(300))"]))
    }

    private static func firstString(in dict: [String: Any], keys: [String]) -> String? {
        for k in keys {
            if let s = dict[k] as? String, !s.isEmpty { return s }
        }
        return nil
    }

    /// `POST /api/social/publish`，body：`{ "postCategory": "…", "payload": <模型物件> }`
    /// 僅當 HTTP 狀態碼為 **201** 時視為成功；其餘狀態碼拋 `APIError.serverError`。
    func publish(category: CommunityPostCategoryAPI, macro: MacroJourneyPost?, micro: DetailedTrackPost?) async throws {
        print("🌐 [NETWORK] 準備向 Render 發射數據...")
        let payloadData: Data
        switch category {
        case .communityMacro:
            guard let macro else {
                throw APIError.decoding(NSError(domain: "SocialPublish", code: -3, userInfo: [NSLocalizedDescriptionKey: "COMMUNITY_MACRO 缺少 MacroJourneyPost"]))
            }
            payloadData = try payloadEncoder.encode(macro)
        case .communityMicro:
            guard let micro else {
                throw APIError.decoding(NSError(domain: "SocialPublish", code: -4, userInfo: [NSLocalizedDescriptionKey: "COMMUNITY_MICRO 缺少 DetailedTrackPost"]))
            }
            payloadData = try payloadEncoder.encode(micro)
        }
        guard let payloadObj = try JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            throw APIError.decoding(NSError(domain: "SocialPublish", code: -5, userInfo: [NSLocalizedDescriptionKey: "payload 序列化失敗"]))
        }
        let body: [String: Any] = [
            "postCategory": category.rawValue,
            "payload": payloadObj
        ]
        let (data, http) = try await APIClientBase.shared.postWithResponse(publishPath, body: body)
        guard http.statusCode == 201 else {
            let raw = String(data: data, encoding: .utf8) ?? ""
            throw APIError.serverError(
                statusCode: http.statusCode,
                message: "發布失敗：預期 HTTP 201，實際 \(http.statusCode)。\(raw.prefix(500))"
            )
        }
    }

    /// 宏觀：優先解 `draft.macroJourneyJSON`，否則用草稿座標與編輯器文案組最小 `MacroJourneyPost`。
    func buildMacroForPublish(draft: DraftItem, title: String, description: String, cloudURLs: [String]) -> MacroJourneyPost {
        if let json = draft.macroJourneyJSON, let d = json.data(using: .utf8),
           var macro = try? JSONDecoder().decode(MacroJourneyPost.self, from: d) {
            let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { macro.journeyName = t }
            let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
            if !macro.days.isEmpty {
                var d0 = macro.days[0]
                if !cloudURLs.isEmpty {
                    d0.images = cloudURLs
                    d0.dayPhotos = cloudURLs
                }
                if !desc.isEmpty {
                    d0.text = desc
                    d0.description = desc
                    d0.notes = desc
                }
                macro.days[0] = d0
            }
            return macro
        }
        return fallbackMacroPost(draft: draft, title: title, description: description, cloudURLs: cloudURLs)
    }

    private func fallbackMacroPost(draft: DraftItem, title: String, description: String, cloudURLs: [String]) -> MacroJourneyPost {
        let wp = draft.waypoints.first
        let geo = wp.map { GeoLocation(latitude: $0.latitude, longitude: $0.longitude) }
        let stateStr: String = {
            if let n = draft.locationName, !n.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return n }
            return "United States"
        }()
        let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let day = JourneyDay(
            dayNumber: 1,
            location: geo,
            locationName: draft.locationName,
            notes: desc.isEmpty ? nil : desc,
            images: cloudURLs.isEmpty ? nil : cloudURLs,
            text: desc.isEmpty ? nil : desc,
            dayPhotos: cloudURLs.isEmpty ? nil : cloudURLs,
            description: desc.isEmpty ? nil : desc
        )
        let name = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? draft.title : title
        return MacroJourneyPost(
            journeyName: name,
            days: [day],
            selectedStates: [],
            duration: draft.durationSeconds.map { sec in
                let h = Int(sec / 3600)
                return h > 0 ? "\(h)h" : "\(max(1, Int(sec / 60)))min"
            },
            state: stateStr
        )
    }
}
