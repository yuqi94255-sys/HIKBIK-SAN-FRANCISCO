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

    /// 發布與 Feed 頂層 `imageUrls` 僅接受此前綴的遠端圖（禁止 `file://` 混入 DB）。
    private static let cloudinaryHTTPSPrefix = "https://res.cloudinary.com"

    static func isCloudinaryHTTPS(_ raw: String) -> Bool {
        let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.lowercased().hasPrefix(cloudinaryHTTPSPrefix)
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
        let url = try Self.extractImageURL(from: data)
        guard Self.isCloudinaryHTTPS(url) else {
            throw APIError.decoding(
                NSError(
                    domain: "SocialPublish",
                    code: -6,
                    userInfo: [NSLocalizedDescriptionKey: "上傳回傳非 Cloudinary HTTPS URL（預期 \(Self.cloudinaryHTTPSPrefix)）：\(url.prefix(120))"]
                )
            )
        }
        return url
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

    /// `POST /api/social/publish`，body：`postCategory`、**`renderData`**（詳細行程 Days / Description 等，完整模型），以及頂層 `imageUrls` / `coverImageUrl`（供 Feed 列表拍扁預覽）。
    /// 僅當 HTTP 狀態碼為 **201** 時視為成功；其餘狀態碼拋 `APIError.serverError`。
    func publish(category: CommunityPostCategoryAPI, macro: MacroJourneyPost?, micro: DetailedTrackPost?) async throws {
        print("🌐 [NETWORK] 準備向 Render 發射數據...")
        let feedImageUrls: [String]
        let encodedRenderData: Data
        switch category {
        case .communityMacro:
            guard let macroIn = macro else {
                throw APIError.decoding(NSError(domain: "SocialPublish", code: -3, userInfo: [NSLocalizedDescriptionKey: "COMMUNITY_MACRO 缺少 MacroJourneyPost"]))
            }
            var macroClean = macroIn
            Self.stripNonCloudinaryFromMacro(&macroClean)
            feedImageUrls = Self.filterCloudinaryOnly(Self.flattenMacroImageUrlsForFeed(macroClean))
            encodedRenderData = try payloadEncoder.encode(macroClean)
        case .communityMicro:
            guard let microIn = micro else {
                throw APIError.decoding(NSError(domain: "SocialPublish", code: -4, userInfo: [NSLocalizedDescriptionKey: "COMMUNITY_MICRO 缺少 DetailedTrackPost"]))
            }
            var microClean = microIn
            Self.stripNonCloudinaryFromMicro(&microClean)
            feedImageUrls = Self.filterCloudinaryOnly(Self.flattenMicroImageUrlsForFeed(microClean))
            encodedRenderData = try payloadEncoder.encode(microClean)
        }
        guard let renderDataObj = try JSONSerialization.jsonObject(with: encodedRenderData) as? [String: Any] else {
            throw APIError.decoding(NSError(domain: "SocialPublish", code: -5, userInfo: [NSLocalizedDescriptionKey: "renderData 序列化失敗"]))
        }
        let cover = feedImageUrls.first ?? ""
        var body: [String: Any] = [
            "postCategory": category.rawValue,
            "renderData": renderDataObj,
            "imageUrls": feedImageUrls,
            "coverImageUrl": cover
        ]
        if category == .communityMacro, let m = macro {
            let summaryText = m.overallDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            body["summary"] = ["description": summaryText]
        }
        Self.printPublishBodyForDebug(body)
        let (data, http) = try await APIClientBase.shared.postWithResponse(publishPath, body: body)
        guard http.statusCode == 201 else {
            let raw = String(data: data, encoding: .utf8) ?? ""
            throw APIError.serverError(
                statusCode: http.statusCode,
                message: "發布失敗：預期 HTTP 201，實際 \(http.statusCode)。\(raw.prefix(500))"
            )
        }
    }

    /// 宏觀 Feed 頂層：按日掃描 `days[].images`（若空則 `dayPhotos`），拍扁去重、保序；**不修改** `MacroJourneyPost`。
    private static func flattenMacroImageUrlsForFeed(_ macro: MacroJourneyPost) -> [String] {
        var ordered: [String] = []
        var seen = Set<String>()
        for day in macro.days {
            // 合併 images 與 dayPhotos（常互為副本）；去重由 seen 處理，避免僅 images == [] 時漏掉 dayPhotos
            let row = (day.images ?? []) + (day.dayPhotos ?? [])
            for u in row {
                let t = u.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !t.isEmpty, !seen.contains(t) else { continue }
                seen.insert(t)
                ordered.append(t)
            }
        }
        return ordered
    }

    /// 微觀 Feed 頂層：先 `heroImages`，再補 `heroImage`，再掃 `viewPointNodes[].imageUrls`；去重保序；**不修改** `DetailedTrackPost`。
    private static func flattenMicroImageUrlsForFeed(_ micro: DetailedTrackPost) -> [String] {
        var ordered: [String] = []
        var seen = Set<String>()
        func append(_ raw: String) {
            let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !t.isEmpty, !seen.contains(t) else { return }
            seen.insert(t)
            ordered.append(t)
        }
        if let heroes = micro.heroImages {
            for u in heroes { append(u) }
        }
        if let one = micro.heroImage {
            append(one)
        }
        for node in micro.viewPointNodes {
            for u in node.imageUrls ?? [] {
                append(u)
            }
        }
        return ordered
    }

    private static func filterCloudinaryOnly(_ urls: [String]) -> [String] {
        urls.filter { isCloudinaryHTTPS($0) }
    }

    /// 移除宏觀 `renderData`（編碼前模型）內任何非 Cloudinary 的圖片字串（含 `file://`）。
    private static func stripNonCloudinaryFromMacro(_ macro: inout MacroJourneyPost) {
        for i in macro.days.indices {
            macro.days[i].images = stripNonCloudinaryImageStrings(macro.days[i].images)
            macro.days[i].dayPhotos = stripNonCloudinaryImageStrings(macro.days[i].dayPhotos)
        }
    }

    private static func stripNonCloudinaryImageStrings(_ urls: [String]?) -> [String]? {
        guard let urls else { return nil }
        let f = urls.filter { isCloudinaryHTTPS($0) }
        return f.isEmpty ? nil : f
    }

    private static func stripNonCloudinaryFromMicro(_ micro: inout DetailedTrackPost) {
        if let h = micro.heroImage, !isCloudinaryHTTPS(h) { micro.heroImage = nil }
        micro.heroImages = stripNonCloudinaryImageStrings(micro.heroImages)
        var nodes = micro.viewPointNodes
        for i in nodes.indices {
            nodes[i].imageUrls = stripNonCloudinaryImageStrings(nodes[i].imageUrls)
        }
        micro.viewPointNodes = nodes
    }

    /// 與 `collectMacroJPEGDataForCloudUpload` 順序一致：先封面（`coverImageCount` 張），再按日分配 `dayPhotoSlotCounts[i]` 張。
    private static func applyCloudURLsToMacroDays(
        _ macro: inout MacroJourneyPost,
        cloudURLs: [String],
        coverImageCount: Int,
        dayPhotoSlotCounts: [Int]?
    ) {
        guard !cloudURLs.isEmpty else { return }
        var idx = 0
        let K = min(max(0, coverImageCount), cloudURLs.count)
        let coverSlice = K > 0 ? Array(cloudURLs[0..<K]) : []
        idx = K

        let counts: [Int] = {
            if let slots = dayPhotoSlotCounts, !slots.isEmpty {
                var c = slots
                while c.count < macro.days.count {
                    let i = c.count
                    let d = macro.days[i]
                    c.append(max((d.images ?? []).count, (d.dayPhotos ?? []).count))
                }
                return c
            }
            return macro.days.map { d in
                max((d.images ?? []).count, (d.dayPhotos ?? []).count)
            }
        }()

        for i in macro.days.indices {
            let need = i < counts.count ? counts[i] : 0
            guard need > 0 else { continue }
            let end = min(idx + need, cloudURLs.count)
            guard idx < end else {
                macro.days[i].images = nil
                macro.days[i].dayPhotos = nil
                continue
            }
            let slice = Array(cloudURLs[idx..<end])
            idx = end
            macro.days[i].images = slice
            macro.days[i].dayPhotos = slice
        }

        if !coverSlice.isEmpty, !macro.days.isEmpty {
            var d0 = macro.days[0]
            let existing = d0.images ?? []
            let merged = coverSlice + existing
            d0.images = merged
            d0.dayPhotos = merged
            macro.days[0] = d0
        }
    }

    private static func printPublishBodyForDebug(_ body: [String: Any]) {
        if let rd = body["renderData"] {
            if rd is NSNull {
                print("⚠️ [PUBLISH] renderData is JSON null — 後端可能收到 null")
            } else if let dict = rd as? [String: Any] {
                print("✅ [PUBLISH] renderData 已設置（非 null），頂層鍵數量: \(dict.count)")
            } else {
                print("✅ [PUBLISH] renderData 已設置（非 null），類型: \(Swift.type(of: rd))")
            }
        } else {
            print("⚠️ [PUBLISH] renderData 鍵缺失")
        }
        guard let data = try? JSONSerialization.data(withJSONObject: body, options: [.sortedKeys, .prettyPrinted]),
              let s = String(data: data, encoding: .utf8) else {
            print("📤 [PUBLISH] Final request body: <無法序列化>")
            return
        }
        print("📤 [PUBLISH] Final request body (pre-POST):\n\(s)")
        if s.contains("file:") {
            print("⚠️ [PUBLISH] WARNING: serialized body still contains \"file:\" — 請檢查 renderData / imageUrls")
        }
    }

    /// 宏觀：優先解 `draft.macroJourneyJSON`，否則用草稿座標與編輯器文案組最小 `MacroJourneyPost`。
    /// - Parameters:
    ///   - coverImageCount: 與 `collectMacroJPEGDataForCloudUpload` 開頭封面張數一致。
    ///   - dayPhotoSlotCounts: 每日上傳槽位數（與 `stops` 每日照片數一致）；`nil` 時由當前 `macro.days` 推斷。
    func buildMacroForPublish(
        draft: DraftItem,
        title: String,
        description: String,
        cloudURLs: [String],
        coverImageCount: Int = 0,
        dayPhotoSlotCounts: [Int]? = nil
    ) -> MacroJourneyPost {
        if let json = draft.macroJourneyJSON, let d = json.data(using: .utf8),
           var macro = try? JSONDecoder().decode(MacroJourneyPost.self, from: d) {
            let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { macro.journeyName = t }
            let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
            if !cloudURLs.isEmpty {
                Self.applyCloudURLsToMacroDays(&macro, cloudURLs: cloudURLs, coverImageCount: coverImageCount, dayPhotoSlotCounts: dayPhotoSlotCounts)
            } else {
                Self.stripNonCloudinaryFromMacro(&macro)
            }
            if !macro.days.isEmpty {
                var d0 = macro.days[0]
                if !desc.isEmpty {
                    d0.text = desc
                    d0.description = desc
                    d0.notes = desc
                }
                macro.days[0] = d0
            }
            Self.stripNonCloudinaryFromMacro(&macro)
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
        var post = MacroJourneyPost(
            journeyName: name,
            days: [day],
            selectedStates: [],
            duration: draft.durationSeconds.map { sec in
                let h = Int(sec / 3600)
                return h > 0 ? "\(h)h" : "\(max(1, Int(sec / 60)))min"
            },
            state: stateStr
        )
        Self.stripNonCloudinaryFromMacro(&post)
        return post
    }
}
