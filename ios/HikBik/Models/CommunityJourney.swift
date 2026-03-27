// MARK: - Community Macro Journey — 用戶數據，由 MacroJourneyBuilder 生成，禁止與 Official 共用
// JSON 與 MacroJourneyPost 結構一致，並擴展作者、點贊、評論等社交欄位。
// 詳情頁使用 CommunityMacroDetailView（作者區 + 點對點地圖 + 社交操作欄）。

import Foundation
import CoreLocation

// MARK: - 與 Builder 導出 100% 匹配的行程內容（復用 MacroJourneyModel 的 days/location 結構）

/// 社區版行程：Builder JSON + 社交欄位。解碼時無 author/likeCount 則用預設。
struct CommunityJourney: Codable {
    var journeyName: String
    var days: [CommunityJourneyDay]
    var selectedStates: [String]
    var duration: String?
    var vehicle: String?
    var pace: String?
    /// 範本對位：難度/強度標籤
    var difficulty: String?
    /// 範本對位：頂部 Tag 組（城市、天數、載具、難度等），與 selectedStates/duration 等同步存檔
    var tags: [String]?
    /// 州選擇器：詳情頁首位標籤必讀此欄（與 MacroJourneyPost.state 一致）
    var state: String

    /// 作者資訊（頂部 User Profile）
    var author: CommunityAuthor?
    var likeCount: Int
    var commentCount: Int
    /// 當前用戶是否已點贊/收藏（本地狀態或從服務端同步）
    var isLiked: Bool
    var isFavorited: Bool
    /// 經過 ImageUploadService 處理的封面 URL（16:10、最大 1920、JPEG 85%），優先於 days.first?.photoURL
    var coverImageURL: String?
    /// 媒體池：多圖輪播 URL 數組，與 PostMediaStore 同步；為空時詳情用 coverImageURL / 首日圖
    var imageUrls: [String]?
    /// 封面比例，明確記錄 16/10，有助於 UI 渲染穩定性
    var aspectRatio: Double?
    /// 全線概覽（對應 `MacroJourneyPost.overallDescription`）；Feed 頂層 `summary.description` 會在 `from(_:summaryDescription:)` 中合併至此。
    var overallDescription: String?

    init(
        journeyName: String = "",
        days: [CommunityJourneyDay] = [],
        selectedStates: [String] = [],
        duration: String? = nil,
        vehicle: String? = nil,
        pace: String? = nil,
        difficulty: String? = nil,
        tags: [String]? = nil,
        state: String = "",
        author: CommunityAuthor? = nil,
        likeCount: Int = 0,
        commentCount: Int = 0,
        isLiked: Bool = false,
        isFavorited: Bool = false,
        coverImageURL: String? = nil,
        imageUrls: [String]? = nil,
        aspectRatio: Double? = 16.0 / 10.0,
        overallDescription: String? = nil
    ) {
        self.journeyName = journeyName
        self.days = days
        self.selectedStates = selectedStates
        self.duration = duration
        self.vehicle = vehicle
        self.pace = pace
        self.difficulty = difficulty
        self.tags = tags
        self.state = state
        self.author = author
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isLiked = isLiked
        self.isFavorited = isFavorited
        self.coverImageURL = coverImageURL
        self.imageUrls = imageUrls
        self.aspectRatio = aspectRatio
        self.overallDescription = overallDescription
    }

    enum CodingKeys: String, CodingKey {
        case journeyName, days, selectedStates, duration, vehicle, pace, difficulty, tags, state
        case author, likeCount, commentCount, isLiked, isFavorited
        case coverImageURL, imageUrls, aspectRatio
        case overallDescription
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        journeyName = try c.decode(String.self, forKey: .journeyName)
        days = try c.decode([CommunityJourneyDay].self, forKey: .days)
        selectedStates = (try? c.decode([String].self, forKey: .selectedStates)) ?? []
        duration = try c.decodeIfPresent(String.self, forKey: .duration)
        vehicle = try c.decodeIfPresent(String.self, forKey: .vehicle)
        pace = try c.decodeIfPresent(String.self, forKey: .pace)
        difficulty = try c.decodeIfPresent(String.self, forKey: .difficulty)
        tags = try c.decodeIfPresent([String].self, forKey: .tags)
        state = (try? c.decode(String.self, forKey: .state)) ?? ""
        if state.isEmpty, !selectedStates.isEmpty {
            state = selectedStates.sorted().joined(separator: " · ")
        }
        author = try c.decodeIfPresent(CommunityAuthor.self, forKey: .author)
        likeCount = (try? c.decode(Int.self, forKey: .likeCount)) ?? 0
        commentCount = (try? c.decode(Int.self, forKey: .commentCount)) ?? 0
        isLiked = (try? c.decode(Bool.self, forKey: .isLiked)) ?? false
        isFavorited = (try? c.decode(Bool.self, forKey: .isFavorited)) ?? false
        coverImageURL = try c.decodeIfPresent(String.self, forKey: .coverImageURL)
        imageUrls = try c.decodeIfPresent([String].self, forKey: .imageUrls)
        aspectRatio = try c.decodeIfPresent(Double.self, forKey: .aspectRatio)
        overallDescription = try c.decodeIfPresent(String.self, forKey: .overallDescription)
    }

    /// 從 MacroJourneyPost 建構（可傳入經預處理的 coverImageURL）。若傳入 imageUrls 則優先使用（發布時 PostMediaStore 寫入的 URL 數組）。
    /// - Parameter summaryDescription: Feed/API 頂層 `summary.description`，僅在 payload 無 `overallDescription` 時作為後備。
    static func from(_ post: MacroJourneyPost, author: CommunityAuthor? = nil, likeCount: Int = 0, commentCount: Int = 0, coverImageURL: String? = nil, imageUrls: [String]? = nil, summaryDescription: String? = nil) -> CommunityJourney {
        let imgsFirst: (JourneyDay) -> String? = { ($0.images ?? $0.dayPhotos)?.first }
        let days = post.days.map { d in
            let recs = d.recommendations?.map { CommunityRecommendation(title: $0.title, link: $0.link) }
            let imgs = d.images ?? d.dayPhotos
            let body = d.text ?? d.description ?? d.notes
            return CommunityJourneyDay(
                id: d.id,
                dayNumber: d.dayNumber,
                location: d.location.map { CommunityGeoLocation(latitude: $0.latitude, longitude: $0.longitude) },
                locationName: d.locationName,
                dateString: d.dateString,
                notes: d.notes,
                photoURL: imgsFirst(d),
                recommendedStay: d.recommendedStay,
                dayPhotos: imgs,
                description: body,
                recommendations: recs,
                images: imgs,
                text: body,
                airbnbLink: d.airbnbLink ?? d.recommendations?.first?.link
            )
        }
        let stateDisplay = post.state.trimmingCharacters(in: .whitespaces).isEmpty
            ? post.selectedStates.sorted().joined(separator: " · ")
            : post.state
        var specTags = post.tags ?? []
        if specTags.isEmpty {
            if !stateDisplay.isEmpty { specTags.append(stateDisplay) }
            if let du = post.duration, !du.isEmpty { specTags.append(du) }
            if let v = post.vehicle, !v.isEmpty { specTags.append(v) }
            if let p = post.pace, !p.isEmpty { specTags.append(p) }
            if let diff = post.difficulty, !diff.isEmpty { specTags.append(diff) }
        } else if !stateDisplay.isEmpty, specTags.first != stateDisplay {
            specTags.insert(stateDisplay, at: 0)
        }
        /// 全流程多圖：優先使用傳入的 imageUrls（發布時寫入的），否則由封面 + 各日 images/dayPhotos 合併
        var allImageUrls: [String] = imageUrls ?? []
        if allImageUrls.isEmpty {
            if let cover = coverImageURL, !cover.isEmpty { allImageUrls.append(cover) }
            for d in post.days {
                let imgs = d.images ?? d.dayPhotos ?? []
                for url in imgs where !url.isEmpty { allImageUrls.append(url) }
            }
            if allImageUrls.isEmpty, let c = coverImageURL, !c.isEmpty { allImageUrls = [c] }
        }

        let overviewMerged: String? = {
            let o = post.overallDescription?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let o, !o.isEmpty { return o }
            let s = summaryDescription?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let s, !s.isEmpty { return s }
            return nil
        }()

        return CommunityJourney(
            journeyName: post.journeyName,
            days: days,
            selectedStates: post.selectedStates,
            duration: post.duration,
            vehicle: post.vehicle,
            pace: post.pace,
            difficulty: post.difficulty ?? post.pace,
            tags: specTags.isEmpty ? nil : specTags,
            state: stateDisplay,
            author: author,
            likeCount: likeCount,
            commentCount: commentCount,
            coverImageURL: coverImageURL,
            imageUrls: allImageUrls.isEmpty ? nil : allImageUrls,
            aspectRatio: 16.0 / 10.0,
            overallDescription: overviewMerged
        )
    }
}

/// 社區版單條推薦（如 Airbnb）。詳情頁渲染為可點擊卡片。
struct CommunityRecommendation: Codable {
    var title: String?
    var link: String?
}

/// 社區版單日：與 MacroJourneyPost.days 對應。可選欄位為空時詳情頁對應區塊自動隱藏。
struct CommunityJourneyDay: Codable {
    var id: UUID?
    var dayNumber: Int
    var location: CommunityGeoLocation?
    var locationName: String?
    var dateString: String?
    var notes: String?
    /// 當日封面圖 URL，為空則不顯示照片區。
    var photoURL: String?
    /// 住宿推薦，為空則不顯示該區塊。
    var recommendedStay: String?
    /// 生存設施（與微觀 ViewPoint 一致），全為空則不顯示 Amenities 區。
    var hasWater: Bool?
    var hasFuel: Bool?
    var signalStrength: Int?
    /// 當日多張照片 URL/路徑。詳情頁橫向滾動照片牆。
    var dayPhotos: [String]?
    /// 當日詳細文字介紹。
    var description: String?
    /// 當日推薦（title + link）。詳情頁渲染為「Book on Airbnb」等卡片。
    var recommendations: [CommunityRecommendation]?
    /// 規格：照片牆 URL 列表（與 dayPhotos 同義）
    var images: [String]?
    /// 規格：當日正文
    var text: String?
    /// 規格：Airbnb 主連結
    var airbnbLink: String?

    enum CodingKeys: String, CodingKey {
        case id, dayNumber, location, locationName, dateString, notes
        case photoURL, recommendedStay, hasWater, hasFuel, signalStrength
        case dayPhotos, description, recommendations
        case images, text, airbnbLink
    }

    init(id: UUID? = nil, dayNumber: Int = 1, location: CommunityGeoLocation? = nil, locationName: String? = nil, dateString: String? = nil, notes: String? = nil, photoURL: String? = nil, recommendedStay: String? = nil, hasWater: Bool? = nil, hasFuel: Bool? = nil, signalStrength: Int? = nil, dayPhotos: [String]? = nil, description: String? = nil, recommendations: [CommunityRecommendation]? = nil, images: [String]? = nil, text: String? = nil, airbnbLink: String? = nil) {
        self.id = id
        self.dayNumber = dayNumber
        self.location = location
        self.locationName = locationName
        self.dateString = dateString
        self.notes = notes
        self.photoURL = photoURL
        self.recommendedStay = recommendedStay
        self.hasWater = hasWater
        self.hasFuel = hasFuel
        self.signalStrength = signalStrength
        self.dayPhotos = images ?? dayPhotos
        self.description = text ?? description
        self.recommendations = recommendations
        self.images = images ?? dayPhotos
        self.text = text ?? description ?? notes
        self.airbnbLink = airbnbLink
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try? c.decode(UUID.self, forKey: .id)
        dayNumber = try c.decode(Int.self, forKey: .dayNumber)
        location = try c.decodeIfPresent(CommunityGeoLocation.self, forKey: .location)
        locationName = try c.decodeIfPresent(String.self, forKey: .locationName)
        dateString = try c.decodeIfPresent(String.self, forKey: .dateString)
        notes = try c.decodeIfPresent(String.self, forKey: .notes)
        photoURL = try c.decodeIfPresent(String.self, forKey: .photoURL)
        recommendedStay = try c.decodeIfPresent(String.self, forKey: .recommendedStay)
        hasWater = try c.decodeIfPresent(Bool.self, forKey: .hasWater)
        hasFuel = try c.decodeIfPresent(Bool.self, forKey: .hasFuel)
        signalStrength = try c.decodeIfPresent(Int.self, forKey: .signalStrength)
        let dp = try c.decodeIfPresent([String].self, forKey: .dayPhotos)
        let im = try c.decodeIfPresent([String].self, forKey: .images)
        dayPhotos = im ?? dp
        images = im ?? dp
        let desc = try c.decodeIfPresent(String.self, forKey: .description)
        let txt = try c.decodeIfPresent(String.self, forKey: .text)
        description = txt ?? desc
        text = txt ?? desc ?? notes
        recommendations = try c.decodeIfPresent([CommunityRecommendation].self, forKey: .recommendations)
        airbnbLink = try c.decodeIfPresent(String.self, forKey: .airbnbLink)
        if airbnbLink == nil, let link = recommendations?.first?.link, !link.isEmpty { airbnbLink = link }
    }

    var hasAnyAmenity: Bool {
        (hasWater == true) || (hasFuel == true) || (signalStrength.map { $0 > 0 } ?? false)
    }
}

struct CommunityGeoLocation: Codable {
    var latitude: Double
    var longitude: Double
}

/// 作者資訊（User Profile 區塊）
struct CommunityAuthor: Codable {
    var id: String
    var displayName: String
    var avatarURL: String?
}
