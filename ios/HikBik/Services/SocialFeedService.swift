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

    enum CodingKeys: String, CodingKey {
        case posts
        case data
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        posts = try c.decodeIfPresent([SocialFeedPostRowDTO].self, forKey: .posts)
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
    var imageUrl: String?
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
        case authorId, authorName, authorSubtitle, authorAvatarUrl
        case imageUrl, coverImageUrl, imageUrls
        case journeyName, title, days, label, mileage, vehicle, waypoints, stateIds, tags
        case likeCount, commentCount, createdAt
        case routeName, routeId, distance, elevationGain, difficulty, activityTag, heroImage, heroImages
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        postCategory = try c.decode(String.self, forKey: .postCategory)
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
                imageUrl: try c.decodeIfPresent(String.self, forKey: .imageUrl),
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
                heroImages: try c.decodeIfPresent([String].self, forKey: .heroImages)
            )
        }
        if c.contains(.payload) {
            payload = try? c.decode(SocialFeedPayloadDTO.self, forKey: .payload)
        } else {
            payload = nil
        }
    }
}

// MARK: - Service

final class SocialFeedService {
    static let shared = SocialFeedService()
    private init() {}

    private let feedPath = "social/feed"

    /// 呼叫 `GET /api/social/feed`，依 `postCategory` 映射為 `GrandJourneyItem` / `DetailedTrackItem`。
    /// `APIClientBase.getData` 回傳完整 HTTP body，**不**拆 `{ data: ... }`；陣列須在下方 `decodePostRows` 從 `data` 鍵讀取。
    func fetchFeed() async throws -> [SocialFeedEntry] {
        let data = try await APIClientBase.shared.getData("/social/feed")
        if let rawString = String(data: data, encoding: .utf8) {
            print("🔥 [CEO DEBUG] 這是 Render 吐出來的原始東西：")
            print(rawString)
        }
        do {
            let rows = try decodePostRows(from: data)
            var out: [SocialFeedEntry] = []
            out.reserveCapacity(rows.count)
            for row in rows {
                let cat = row.postCategory.uppercased()
                if cat.contains("MACRO") || cat == "COMMUNITY_MACRO" || cat == "GRAND_JOURNEY" {
                    if let g = mapMacro(row) { out.append(.macro(g)) }
                } else if cat.contains("MICRO") || cat == "COMMUNITY_MICRO" || cat == "DETAILED_TRACK" {
                    if let d = mapMicro(row) { out.append(.micro(d)) }
                }
            }
            return out
        } catch let decodingError as DecodingError {
            print("❌ [DECODE ERROR] 具體原因: \(decodingError)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [RAW JSON] 原始數據: \(jsonString)")
            }
            throw decodingError
        } catch let apiError as APIError {
            if case .decoding(let innerError) = apiError, let decodingError = innerError as? DecodingError {
                print("❌ [DECODE ERROR] 具體原因: \(decodingError)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 [RAW JSON] 原始數據: \(jsonString)")
                }
                throw decodingError
            }
            throw apiError
        }
    }

    private func decodePostRows(from data: Data) throws -> [SocialFeedPostRowDTO] {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        var lastDecodingError: DecodingError?

        do {
            let root = try dec.decode(SocialFeedRootDTO.self, from: data)
            if let p = root.posts { return p }
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
        throw APIError.decoding(NSError(domain: "SocialFeed", code: -1, userInfo: [NSLocalizedDescriptionKey: "無法解析 feed JSON"]))
    }

    private func mapMacro(_ row: SocialFeedPostRowDTO) -> GrandJourneyItem? {
        let s = row.summary
        let pid = s.postId ?? s.id ?? row.postId ?? row.id ?? UUID().uuidString
        let title = s.journeyName ?? s.title ?? "Journey"
        let imageUrls = s.imageUrls ?? (s.coverImageUrl.map { [$0] } ?? s.heroImages)
        let firstImage = s.imageUrl ?? s.coverImageUrl ?? imageUrls?.first ?? "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"
        let days = max(1, s.days ?? 1)
        let macroPost: MacroJourneyPost? = {
            guard let p = row.payload else { return nil }
            if case let .macro(m) = p { return m }
            return nil
        }()
        let community: CommunityJourney? = {
            if let m = macroPost {
                return CommunityJourney.from(m, author: authorFromSummary(s), likeCount: s.likeCount ?? 0, commentCount: s.commentCount ?? 0, coverImageURL: s.coverImageUrl ?? s.imageUrl, imageUrls: imageUrls)
            }
            return nil
        }()
        return GrandJourneyItem(
            id: "cloud_\(pid)",
            authorId: s.authorId ?? "unknown",
            authorName: s.authorName ?? "Explorer",
            authorSubtitle: s.authorSubtitle ?? "",
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
            macroCommunityJourney: community
        )
    }

    private func mapMicro(_ row: SocialFeedPostRowDTO) -> DetailedTrackItem? {
        let s = row.summary
        let pid = s.postId ?? s.id ?? row.postId ?? row.id ?? UUID().uuidString
        let title = s.routeName ?? s.title ?? "Route"
        let urls: [String] = {
            if let h = s.heroImages, !h.isEmpty { return h }
            if let u = s.imageUrls, !u.isEmpty { return u }
            if let one = s.heroImage ?? s.imageUrl { return [one] }
            return ["https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800"]
        }()
        let diff = s.difficulty ?? "Moderate"
        let detail: DetailedTrackPost? = {
            guard let p = row.payload else { return nil }
            if case let .micro(d) = p { return d }
            return nil
        }()
        return DetailedTrackItem(
            id: "cloud_\(pid)",
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
            detailTrackPost: detail
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
