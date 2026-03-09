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

/// Full Detailed Track post: category + name + duration + view points.
struct DetailedTrackPost: Codable {
    var category: DetailedTrackCategory?
    var routeName: String
    var totalDurationMinutes: Int
    var viewPointNodes: [ViewPointNode]

    init(category: DetailedTrackCategory? = nil, routeName: String = "", totalDurationMinutes: Int = 0, viewPointNodes: [ViewPointNode] = []) {
        self.category = category
        self.routeName = routeName
        self.totalDurationMinutes = totalDurationMinutes
        self.viewPointNodes = viewPointNodes
    }

    var isReadyToPublish: Bool {
        guard !routeName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard category != nil else { return false }
        guard totalDurationMinutes > 0 else { return false }
        guard viewPointNodes.count >= 2 else { return false }
        return viewPointNodes.allSatisfy(\.isComplete)
    }
}
