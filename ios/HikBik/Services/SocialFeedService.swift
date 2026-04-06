// MARK: - 全網社區 Feed：GET /api/social/feed
import Foundation
import SwiftUI

/// 單條 Feed（宏觀 / 微觀），供列表與計數使用。
enum SocialFeedEntry {
    case macro(GrandJourneyItem)
    case micro(DetailedTrackItem)
}

// MARK: - API 原始結構

/// 後端標準封裝：`{ "data": [...] }` 或 `{ "data": { "posts": [...] } }`；亦支援根級 `posts`。
private struct SocialFeedRootDTO: Decodable {
    let posts: [SocialFeedPostRowDTO]?
    /// `data` 為陣列時直接為 Feed 行列表。
    let dataAsArray: [SocialFeedPostRowDTO]?
    /// `data` 為物件且內含 `posts` 時（舊版相容）。
    let dataNestedPosts: [SocialFeedPostRowDTO]?
    /// 部分後端使用 `results`
    let results: [SocialFeedPostRowDTO]?

    enum CodingKeys: String, CodingKey {
        case posts
        case data
        case results
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        posts = try c.decodeIfPresent([SocialFeedPostRowDTO].self, forKey: .posts)
        results = try c.decodeIfPresent([SocialFeedPostRowDTO].self, forKey: .results)
        guard c.contains(.data) else {
            dataAsArray = nil
            dataNestedPosts = nil
            return
        }
        if let arr = try? c.decode([SocialFeedPostRowDTO].self, forKey: .data) {
            dataAsArray = arr
            dataNestedPosts = nil
            return
        }
        if let wrap = try? c.decode(SocialFeedDataWrapperDTO.self, forKey: .data) {
            dataAsArray = nil
            dataNestedPosts = wrap.posts
            return
        }
        dataAsArray = nil
        dataNestedPosts = nil
    }
}

private struct SocialFeedDataWrapperDTO: Decodable {
    let posts: [SocialFeedPostRowDTO]?
}

/// summary：列表卡片建議 18 個可視化欄位（皆可選，與後端演進相容）。
private struct SocialFeedSummaryDTO: Decodable {
    var id: String?
    var postId: String?
    var authorId: String?
    var authorName: String?
    var authorSubtitle: String?
    var authorAvatarUrl: String?
    var authorFollowersCount: Int?
    var imageUrl: String?
    /// 後端常見 `cover_image`（`convertFromSnakeCase` → `coverImage`）
    var coverImage: String?
    var coverImageUrl: String?
    var imageUrls: [String]?
    var journeyName: String?
    var title: String?
    var days: Int?
    var label: String?
    var mileage: String?
    var vehicle: String?
    var waypoints: [String]?
    var stateIds: [String]?
    var tags: [String]?
    var likeCount: Int?
    var commentCount: Int?
    var createdAt: String?
    var routeName: String?
    var routeId: String?
    var distance: String?
    var elevationGain: String?
    var difficulty: String?
    var activityTag: String?
    var heroImage: String?
    var heroImages: [String]?
    /// Feed/API 頂層摘要正文（與 payload.overallDescription 對齊時由後端填寫）。
    var description: String?
}

private enum SocialFeedPayloadDTO: Decodable {
    case macro(MacroJourneyPost)
    case micro(DetailedTrackPost)

    init(from decoder: Decoder) throws {
        if let m = try? MacroJourneyPost(from: decoder) {
            self = .macro(m)
            return
        }
        if let d = try? DetailedTrackPost(from: decoder) {
            self = .micro(d)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "payload 無法解為 MacroJourneyPost 或 DetailedTrackPost"))
    }
}

private struct SocialFeedPostRowDTO: Decodable {
    let postCategory: String
    let summary: SocialFeedSummaryDTO
    let id: String?
    let postId: String?
    let payload: SocialFeedPayloadDTO?

    enum CodingKeys: String, CodingKey {
        case postCategory, summary, id, postId, payload
        case renderData = "render_data"
        case authorId, authorName, authorSubtitle, authorAvatarUrl, authorFollowersCount
        case imageUrl, coverImage, coverImageUrl, imageUrls
        case journeyName, title, days, label, mileage, vehicle, waypoints, stateIds, tags
        case likeCount, commentCount, createdAt
        case routeName, routeId, distance, elevationGain, difficulty, activityTag, heroImage, heroImages
        case description
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        postCategory = (try c.decodeIfPresent(String.self, forKey: .postCategory))?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() ?? ""
        id = try c.decodeIfPresent(String.self, forKey: .id)
        postId = try c.decodeIfPresent(String.self, forKey: .postId)
        if let nested = try c.decodeIfPresent(SocialFeedSummaryDTO.self, forKey: .summary) {
            summary = nested
        } else {
            // 兼容扁平回傳：欄位直接位於 row 頂層（無 summary 容器）
            summary = SocialFeedSummaryDTO(
                id: id,
                postId: postId,
                authorId: try c.decodeIfPresent(String.self, forKey: .authorId),
                authorName: try c.decodeIfPresent(String.self, forKey: .authorName),
                authorSubtitle: try c.decodeIfPresent(String.self, forKey: .authorSubtitle),
                authorAvatarUrl: try c.decodeIfPresent(String.self, forKey: .authorAvatarUrl),
                authorFollowersCount: try c.decodeIfPresent(Int.self, forKey: .authorFollowersCount),
                imageUrl: try c.decodeIfPresent(String.self, forKey: .imageUrl),
                coverImage: try c.decodeIfPresent(String.self, forKey: .coverImage),
                coverImageUrl: try c.decodeIfPresent(String.self, forKey: .coverImageUrl),
                imageUrls: try c.decodeIfPresent([String].self, forKey: .imageUrls),
                journeyName: try c.decodeIfPresent(String.self, forKey: .journeyName),
                title: try c.decodeIfPresent(String.self, forKey: .title),
                days: try c.decodeIfPresent(Int.self, forKey: .days),
                label: try c.decodeIfPresent(String.self, forKey: .label),
                mileage: try c.decodeIfPresent(String.self, forKey: .mileage),
                vehicle: try c.decodeIfPresent(String.self, forKey: .vehicle),
                waypoints: try c.decodeIfPresent([String].self, forKey: .waypoints),
                stateIds: try c.decodeIfPresent([String].self, forKey: .stateIds),
                tags: try c.decodeIfPresent([String].self, forKey: .tags),
                likeCount: try c.decodeIfPresent(Int.self, forKey: .likeCount),
                commentCount: try c.decodeIfPresent(Int.self, forKey: .commentCount),
                createdAt: try c.decodeIfPresent(String.self, forKey: .createdAt),
                routeName: try c.decodeIfPresent(String.self, forKey: .routeName),
                routeId: try c.decodeIfPresent(String.self, forKey: .routeId),
                distance: try c.decodeIfPresent(String.self, forKey: .distance),
                elevationGain: try c.decodeIfPresent(String.self, forKey: .elevationGain),
                difficulty: try c.decodeIfPresent(String.self, forKey: .difficulty),
                activityTag: try c.decodeIfPresent(String.self, forKey: .activityTag),
                heroImage: try c.decodeIfPresent(String.self, forKey: .heroImage),
                heroImages: try c.decodeIfPresent([String].self, forKey: .heroImages),
                description: try c.decodeIfPresent(String.self, forKey: .description)
            )
        }
        var p: SocialFeedPayloadDTO?
        if c.contains(.payload), !(try c.decodeNil(forKey: .payload)) {
            p = try? c.decode(SocialFeedPayloadDTO.self, forKey: .payload)
        }
        if p == nil, c.contains(.renderData), !(try c.decodeNil(forKey: .renderData)) {
            p = try? c.decode(SocialFeedPayloadDTO.self, forKey: .renderData)
        }
        payload = p
    }
}

// MARK: - Service

final class SocialFeedService {
    static let shared = SocialFeedService()
    private init() {}

    private let feedPath = "social/feed"

    /// 主線：`SocialPublishService` → `GET /api/social/feed`。
    func fetchFeed() async throws -> [SocialFeedEntry] {
        let data: Data
        do {
            data = try await SocialPublishService.shared.fetchPostsData()
            print("✅ [SocialFeedService] GET /api/social/feed 成功，\(data.count) bytes")
        } catch {
            print("❌ [SocialFeedService] GET /api/social/feed 失敗: \(error.localizedDescription) — \(error)")
            throw error
        }
        if let rawString = String(data: data, encoding: .utf8) {
            print("🔥 [SocialFeed RAW] \(rawString.prefix(4000))\(rawString.count > 4000 ? "…(truncated)" : "")")
        }
        do {
            let rows = try decodePostRows(from: data)
            if rows.isEmpty {
                print("⚠️ [SocialFeedService] 解碼成功但帖子列為空（請核對後端欄位與 post_category / render_data）")
            }
            return buildEntries(from: rows)
        } catch let decodingError as DecodingError {
            print("❌ [DECODE ERROR] 具體原因: \(decodingError)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [RAW JSON] 原始數據: \(jsonString)")
            }
            throw decodingError
        } catch let apiError as APIError {
            if case .decodingError(let innerError) = apiError, let decodingError = innerError as? DecodingError {
                print("❌ [DECODE ERROR] 具體原因: \(decodingError)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 [RAW JSON] 原始數據: \(jsonString)")
                }
                throw decodingError
            }
            throw apiError
        }
    }

    /// 與 `social/posts`、`me/liked` 等與 Feed 相同 JSON 形狀的響應解碼共用。
    func entriesFromPostsPayload(_ data: Data) throws -> [SocialFeedEntry] {
        let rows = try decodePostRows(from: data)
        return buildEntries(from: rows)
    }

    private func buildEntries(from rows: [SocialFeedPostRowDTO]) -> [SocialFeedEntry] {
        var out: [SocialFeedEntry] = []
        out.reserveCapacity(rows.count)
        for row in rows {
            let cat: String = {
                if !row.postCategory.isEmpty { return row.postCategory }
                switch row.payload {
                case .some(.macro): return "COMMUNITY_MACRO"
                case .some(.micro): return "COMMUNITY_MICRO"
                case .none: return "COMMUNITY_MACRO"
                }
            }()
            let u = cat.uppercased()
            if u.contains("MACRO") || u == "COMMUNITY_MACRO" || u == "GRAND_JOURNEY" {
                if let g = mapMacro(row) { out.append(.macro(g)) }
            } else if u.contains("MICRO") || u == "COMMUNITY_MICRO" || u == "DETAILED_TRACK" {
                if let d = mapMicro(row) { out.append(.micro(d)) }
            } else {
                print("⚠️ [SocialFeedService] 略過未知 postCategory=\(cat) id=\(row.postId ?? row.id ?? "?")")
            }
        }
        return out
    }

    private func decodePostRows(from data: Data) throws -> [SocialFeedPostRowDTO] {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        var lastDecodingError: DecodingError?

        do {
            let root = try dec.decode(SocialFeedRootDTO.self, from: data)
            if let p = root.posts { return p }
            if let p = root.results { return p }
            if let p = root.dataAsArray { return p }
            if let p = root.dataNestedPosts { return p }
        } catch let e as DecodingError {
            lastDecodingError = e
        }

        do {
            let arr = try dec.decode([SocialFeedPostRowDTO].self, from: data)
            return arr
        } catch let e as DecodingError {
            lastDecodingError = e
        }

        if let e = lastDecodingError {
            throw e
        }
        throw APIError.decodingError(NSError(domain: "SocialFeed", code: -1, userInfo: [NSLocalizedDescriptionKey: "無法解析 feed JSON"]))
    }

    private func mapMacro(_ row: SocialFeedPostRowDTO) -> GrandJourneyItem? {
        let s = row.summary
        let title = s.journeyName ?? s.title ?? "Journey"
        let days = max(1, s.days ?? 1)
        let macroPost: MacroJourneyPost? = {
            guard let p = row.payload else { return nil }
            if case let .macro(m) = p { return m }
            return nil
        }()
        let mongoId = macroPost?.id
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .flatMap { $0.isEmpty ? nil : $0 }
        let coverResolved = s.coverImageUrl ?? s.coverImage ?? macroPost?.coverImage
        let imageUrls = s.imageUrls ?? (coverResolved.map { [$0] } ?? s.heroImages)
        let firstImage = s.imageUrl ?? coverResolved ?? imageUrls?.first ?? "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"
        let journeyIdStr = mongoId ?? s.postId ?? s.id ?? row.postId ?? row.id
        let journeyId = journeyIdStr.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        let routeId = s.routeId.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        let stableId = journeyId ?? UUID().uuidString

        let community: CommunityJourney? = {
            if let m = macroPost {
                return CommunityJourney.from(
                    m,
                    author: authorFromSummary(s),
                    likeCount: s.likeCount ?? 0,
                    commentCount: s.commentCount ?? 0,
                    coverImageURL: coverResolved ?? s.imageUrl,
                    imageUrls: imageUrls,
                    summaryDescription: s.description
                )
            }
            let day = CommunityJourneyDay(
                dayNumber: 1,
                photoURL: firstImage,
                description: s.description,
                images: imageUrls
            )
            let stateLabel = (s.stateIds ?? []).map { $0.uppercased() }.joined(separator: " · ")
            return CommunityJourney(
                journeyName: title,
                days: [day],
                selectedStates: s.stateIds ?? [],
                duration: s.days.map { "\($0) days" },
                vehicle: s.vehicle,
                tags: s.tags,
                state: stateLabel,
                author: authorFromSummary(s),
                likeCount: s.likeCount ?? 0,
                commentCount: s.commentCount ?? 0,
                coverImageURL: coverResolved ?? s.imageUrl,
                imageUrls: imageUrls,
                overallDescription: s.description
            )
        }()
        return GrandJourneyItem(
            id: stableId,
            authorId: s.authorId ?? "unknown",
            authorName: s.authorName ?? "Explorer",
            authorSubtitle: s.authorFollowersCount.map { "\($0) followers" } ?? s.authorSubtitle ?? "",
            authorAvatarUrl: s.authorAvatarUrl,
            isFollowing: false,
            imageUrl: firstImage,
            imageUrls: imageUrls,
            days: days,
            label: s.label ?? "JOURNEY",
            title: title,
            mileage: s.mileage ?? "—",
            vehicle: s.vehicle ?? "—",
            waypoints: s.waypoints ?? [],
            likeCount: s.likeCount ?? 0,
            commentCount: s.commentCount ?? 0,
            stateIds: s.stateIds ?? [],
            tags: s.tags ?? [],
            createdAt: parseDate(s.createdAt),
            macroCommunityJourney: community,
            journeyId: journeyId,
            routeId: routeId
        )
    }

    private func mapMicro(_ row: SocialFeedPostRowDTO) -> DetailedTrackItem? {
        let s = row.summary
        let title = s.routeName ?? s.title ?? "Route"
        let urls: [String] = {
            if let h = s.heroImages, !h.isEmpty { return h }
            if let u = s.imageUrls, !u.isEmpty { return u }
            if let one = s.heroImage ?? s.imageUrl { return [one] }
            return ["https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800"]
        }()
        let diff = s.difficulty ?? "Moderate"
        var detail: DetailedTrackPost? = {
            guard let p = row.payload else { return nil }
            if case let .micro(d) = p { return d }
            return nil
        }()
        let journeyIdStr = s.postId ?? s.id ?? row.postId ?? row.id
        let journeyId = journeyIdStr.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        let routeFromSummary = s.routeId.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        let routeFromDetail = detail?.routeID.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        let routeId = routeFromSummary ?? routeFromDetail
        if var d = detail {
            if d.routeID == nil || (d.routeID?.isEmpty == true) {
                d.routeID = routeId ?? journeyId
            }
            detail = d
        }
        let stableId = journeyId ?? UUID().uuidString
        return DetailedTrackItem(
            id: stableId,
            authorId: s.authorId ?? "unknown",
            authorName: s.authorName ?? "Explorer",
            authorSubtitle: s.authorSubtitle ?? "",
            authorAvatarUrl: s.authorAvatarUrl,
            isFollowing: false,
            imageUrls: urls,
            activityTag: s.activityTag ?? "TRAIL",
            title: title,
            distance: s.distance ?? "—",
            elevationGain: s.elevationGain ?? "—",
            difficulty: diff,
            difficultyColor: difficultyColor(for: diff),
            elevationProfileHeights: [0.35, 0.55, 0.7, 0.5, 0.6, 0.45],
            likeCount: s.likeCount ?? 0,
            commentCount: s.commentCount ?? 0,
            detailTrackPost: detail,
            journeyId: journeyId,
            routeId: routeId
        )
    }

    private func authorFromSummary(_ s: SocialFeedSummaryDTO) -> CommunityAuthor? {
        guard let name = s.authorName, !name.isEmpty else { return nil }
        return CommunityAuthor(id: s.authorId ?? "unknown", displayName: name, avatarURL: s.authorAvatarUrl)
    }

    private func parseDate(_ raw: String?) -> Date? {
        guard let raw, !raw.isEmpty else { return nil }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = iso.date(from: raw) { return d }
        iso.formatOptions = [.withInternetDateTime]
        return iso.date(from: raw)
    }

    private func difficultyColor(for text: String) -> Color {
        let t = text.lowercased()
        if t.contains("expert") || t.contains("extreme") { return Color(hex: "EF4444") }
        if t.contains("hard") { return Color(hex: "F97316") }
        return Color(hex: "10B981")
    }
}
