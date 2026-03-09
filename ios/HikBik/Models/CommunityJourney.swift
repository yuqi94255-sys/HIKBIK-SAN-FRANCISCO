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

    /// 作者資訊（頂部 User Profile）
    var author: CommunityAuthor?
    var likeCount: Int
    var commentCount: Int
    /// 當前用戶是否已點贊/收藏（本地狀態或從服務端同步）
    var isLiked: Bool
    var isFavorited: Bool
    /// 經過 ImageUploadService 處理的封面 URL（16:10、最大 1920、JPEG 85%），優先於 days.first?.photoURL
    var coverImageURL: String?
    /// 封面比例，明確記錄 16/10，有助於 UI 渲染穩定性
    var aspectRatio: Double?

    init(
        journeyName: String = "",
        days: [CommunityJourneyDay] = [],
        selectedStates: [String] = [],
        duration: String? = nil,
        vehicle: String? = nil,
        pace: String? = nil,
        author: CommunityAuthor? = nil,
        likeCount: Int = 0,
        commentCount: Int = 0,
        isLiked: Bool = false,
        isFavorited: Bool = false,
        coverImageURL: String? = nil,
        aspectRatio: Double? = 16.0 / 10.0
    ) {
        self.journeyName = journeyName
        self.days = days
        self.selectedStates = selectedStates
        self.duration = duration
        self.vehicle = vehicle
        self.pace = pace
        self.author = author
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isLiked = isLiked
        self.isFavorited = isFavorited
        self.coverImageURL = coverImageURL
        self.aspectRatio = aspectRatio
    }

    enum CodingKeys: String, CodingKey {
        case journeyName, days, selectedStates, duration, vehicle, pace
        case author, likeCount, commentCount, isLiked, isFavorited
        case coverImageURL, aspectRatio
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        journeyName = try c.decode(String.self, forKey: .journeyName)
        days = try c.decode([CommunityJourneyDay].self, forKey: .days)
        selectedStates = (try? c.decode([String].self, forKey: .selectedStates)) ?? []
        duration = try c.decodeIfPresent(String.self, forKey: .duration)
        vehicle = try c.decodeIfPresent(String.self, forKey: .vehicle)
        pace = try c.decodeIfPresent(String.self, forKey: .pace)
        author = try c.decodeIfPresent(CommunityAuthor.self, forKey: .author)
        likeCount = (try? c.decode(Int.self, forKey: .likeCount)) ?? 0
        commentCount = (try? c.decode(Int.self, forKey: .commentCount)) ?? 0
        isLiked = (try? c.decode(Bool.self, forKey: .isLiked)) ?? false
        isFavorited = (try? c.decode(Bool.self, forKey: .isFavorited)) ?? false
        coverImageURL = try c.decodeIfPresent(String.self, forKey: .coverImageURL)
        aspectRatio = try c.decodeIfPresent(Double.self, forKey: .aspectRatio)
    }

    /// 從 MacroJourneyPost 建構（可傳入經預處理的 coverImageURL）
    static func from(_ post: MacroJourneyPost, author: CommunityAuthor? = nil, likeCount: Int = 0, commentCount: Int = 0, coverImageURL: String? = nil) -> CommunityJourney {
        let days = post.days.map { d in
            CommunityJourneyDay(
                id: d.id,
                dayNumber: d.dayNumber,
                location: d.location.map { CommunityGeoLocation(latitude: $0.latitude, longitude: $0.longitude) },
                locationName: d.locationName,
                dateString: d.dateString,
                notes: d.notes
            )
        }
        return CommunityJourney(
            journeyName: post.journeyName,
            days: days,
            selectedStates: post.selectedStates,
            duration: post.duration,
            vehicle: post.vehicle,
            pace: post.pace,
            author: author,
            likeCount: likeCount,
            commentCount: commentCount,
            coverImageURL: coverImageURL,
            aspectRatio: 16.0 / 10.0
        )
    }
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

    enum CodingKeys: String, CodingKey {
        case id, dayNumber, location, locationName, dateString, notes
        case photoURL, recommendedStay, hasWater, hasFuel, signalStrength
    }

    init(id: UUID? = nil, dayNumber: Int = 1, location: CommunityGeoLocation? = nil, locationName: String? = nil, dateString: String? = nil, notes: String? = nil, photoURL: String? = nil, recommendedStay: String? = nil, hasWater: Bool? = nil, hasFuel: Bool? = nil, signalStrength: Int? = nil) {
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
