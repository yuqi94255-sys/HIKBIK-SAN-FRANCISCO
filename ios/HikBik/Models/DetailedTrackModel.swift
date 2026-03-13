// MARK: - Detailed Track Builder — isolated model. 6 categories, sub-units = ViewPointNode.
import Foundation
import UIKit
import CoreLocation

/// Mandatory category: 6 land types only (order: Forest, Park, Grassland, NRA, State Park, State Forest).
enum DetailedTrackCategory: String, CaseIterable, Identifiable, Codable {
    case nationalForest = "National Forest"
    case nationalPark = "National Park"
    case nationalGrassland = "National Grassland"
    case nationalRecreationArea = "National Recreation Area"
    case statePark = "State Park"
    case stateForest = "State Forest"
    public var id: String { rawValue }
}

/// Activity type per view point.
enum ViewPointActivityType: String, CaseIterable, Identifiable, Codable {
    case hiking = "Hiking"
    case mtb = "MTB"
    case overlanding = "Overlanding"
    case camping = "Camping"
    case climbing = "Climbing"
    case paddling = "Paddling"
    case summit = "Summit"
    case fishing = "Fishing"
    case boating = "Boating"
    public var id: String { rawValue }
}

/// One node in a Detailed Track: name + activity + location from map + at least 1 photo + professional data.
struct ViewPointNode: Identifiable, Codable {
    var id: UUID
    var title: String
    var activityType: ViewPointActivityType
    var latitude: Double?
    var longitude: Double?
    /// Number of photos (actual image data not encoded in JSON).
    var photoCount: Int
    /// Professional data (optional).
    var arrivalTime: String?
    var elevation: String?
    /// Survival & Amenities: 1:1 with UI (Water capsule, Fuel capsule, Signal bar 0–5).
    var hasWater: Bool
    var hasFuel: Bool
    /// 0–5: number of orange blocks in SignalStrengthBar.
    var signalStrength: Int
    var recommendedStay: String?

    init(id: UUID = UUID(), title: String = "", activityType: ViewPointActivityType = .hiking, latitude: Double? = nil, longitude: Double? = nil, photoCount: Int = 0, arrivalTime: String? = nil, elevation: String? = nil, hasWater: Bool = false, hasFuel: Bool = false, signalStrength: Int = 0, recommendedStay: String? = nil) {
        self.id = id
        self.title = title
        self.activityType = activityType
        self.latitude = latitude
        self.longitude = longitude
        self.photoCount = photoCount
        self.arrivalTime = arrivalTime
        self.elevation = elevation
        self.hasWater = hasWater
        self.hasFuel = hasFuel
        self.signalStrength = min(5, max(0, signalStrength))
        self.recommendedStay = recommendedStay
    }

    var hasValidLocation: Bool { latitude != nil && longitude != nil }
    var hasAtLeastOnePhoto: Bool { photoCount >= 1 }
    var isComplete: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && hasValidLocation && hasAtLeastOnePhoto
    }

    enum CodingKeys: String, CodingKey {
        case id, title, activityType, latitude, longitude, photoCount
        case arrivalTime, elevation, hasWater, hasFuel, signalStrength, recommendedStay
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        activityType = try c.decode(ViewPointActivityType.self, forKey: .activityType)
        latitude = try c.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try c.decodeIfPresent(Double.self, forKey: .longitude)
        photoCount = try c.decode(Int.self, forKey: .photoCount)
        arrivalTime = try c.decodeIfPresent(String.self, forKey: .arrivalTime)
        elevation = try c.decodeIfPresent(String.self, forKey: .elevation)
        hasWater = (try? c.decode(Bool.self, forKey: .hasWater)) ?? false
        hasFuel = (try? c.decode(Bool.self, forKey: .hasFuel)) ?? false
        let raw = (try? c.decode(Int.self, forKey: .signalStrength)) ?? 0
        signalStrength = min(5, max(0, raw))
        recommendedStay = try c.decodeIfPresent(String.self, forKey: .recommendedStay)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(activityType, forKey: .activityType)
        try c.encodeIfPresent(latitude, forKey: .latitude)
        try c.encodeIfPresent(longitude, forKey: .longitude)
        try c.encode(photoCount, forKey: .photoCount)
        try c.encodeIfPresent(arrivalTime, forKey: .arrivalTime)
        try c.encodeIfPresent(elevation, forKey: .elevation)
        try c.encode(hasWater, forKey: .hasWater)
        try c.encode(hasFuel, forKey: .hasFuel)
        try c.encode(signalStrength, forKey: .signalStrength)
        try c.encodeIfPresent(recommendedStay, forKey: .recommendedStay)
    }
}

/// 作者信息：社交頭像、暱稱、認證標記
struct DetailedTrackAuthor: Codable, Equatable {
    var name: String
    var avatarUrl: String?
    var isVerified: Bool

    init(name: String = "", avatarUrl: String? = nil, isVerified: Bool = false) {
        self.name = name
        self.avatarUrl = avatarUrl
        self.isVerified = isVerified
    }
}

/// Full Detailed Track post: category + name + duration + view points + optional elevation/amenities (JSON export).
/// 社交屬性：author、rating、reviewCount、heroImage、routeID（唯一標識，用於收藏/點贊同步與持久化）。
struct DetailedTrackPost: Codable {
    var category: DetailedTrackCategory?
    var routeName: String
    var totalDurationMinutes: Int
    var viewPointNodes: [ViewPointNode]
    var elevationGain: String?
    var elevationPeak: String?
    var amenitiesDisplay: [String]?
    var author: DetailedTrackAuthor?
    var rating: Float?
    var reviewCount: Int?
    var heroImage: String?
    /// 唯一路線 ID，用於 SocialDataManager 收藏/點贊持久化；nil 時由 effectiveRouteID 生成穩定 fallback。
    var routeID: String?

    init(category: DetailedTrackCategory? = nil, routeName: String = "", totalDurationMinutes: Int = 0, viewPointNodes: [ViewPointNode] = [], elevationGain: String? = nil, elevationPeak: String? = nil, amenitiesDisplay: [String]? = nil, author: DetailedTrackAuthor? = nil, rating: Float? = nil, reviewCount: Int? = nil, heroImage: String? = nil, routeID: String? = nil) {
        self.category = category
        self.routeName = routeName
        self.totalDurationMinutes = totalDurationMinutes
        self.viewPointNodes = viewPointNodes
        self.elevationGain = elevationGain
        self.elevationPeak = elevationPeak
        self.amenitiesDisplay = amenitiesDisplay
        self.author = author
        self.rating = rating
        self.reviewCount = reviewCount
        self.heroImage = heroImage
        self.routeID = routeID
    }

    /// 用於持久化的穩定 ID：優先 routeID，否則用 routeName + 首點座標生成，確保同路線重開 App 一致。
    var effectiveRouteID: String {
        if let id = routeID, !id.isEmpty { return id }
        let first = viewPointNodes.first
        let lat = first?.latitude ?? 0
        let lon = first?.longitude ?? 0
        let safeName = String(routeName.prefix(60)).map { $0.isLetter || $0.isNumber ? String($0) : "_" }.joined()
        return "dt_\(safeName)_\(Int(lat * 1e5))_\(Int(lon * 1e5))"
    }

    var isReadyToPublish: Bool {
        guard !routeName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard category != nil else { return false }
        guard totalDurationMinutes > 0 else { return false }
        guard viewPointNodes.count >= 2 else { return false }
        return viewPointNodes.allSatisfy(\.isComplete)
    }

    /// 時間智能校準：依 itinerary 首尾 arrivalTime 計算實際時長。先試 "h:mm a"，失敗則試 "HH:mm"，無效時回傳 nil。
    var calculatedRealDuration: String? {
        guard viewPointNodes.count >= 2,
              let first = viewPointNodes.first?.arrivalTime, !first.trimmingCharacters(in: .whitespaces).isEmpty,
              let last = viewPointNodes.last?.arrivalTime, !last.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        let ref = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))!
        let formats = ["h:mm a", "HH:mm", "H:mm"]
        for fmt in formats {
            let formatter = DateFormatter()
            formatter.dateFormat = fmt
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.defaultDate = ref
            if let d1 = formatter.date(from: first), let d2 = formatter.date(from: last) {
                var interval = d2.timeIntervalSince(d1)
                if interval < 0 { interval += 24 * 3600 }
                let totalMinutes = Int(interval / 60)
                if totalMinutes < 60 { return "\(totalMinutes)min" }
                let h = totalMinutes / 60
                let m = totalMinutes % 60
                return m > 0 ? "\(h)h \(m)min" : "\(h)h"
            }
        }
        return nil
    }
}
