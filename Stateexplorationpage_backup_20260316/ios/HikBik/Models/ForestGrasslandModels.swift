// 与 national-forests-data.ts / national-grasslands-data.ts 对应
import Foundation

struct NationalForest: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let state: String
    let states: [String]?
    let region: String
    let description: String
    let established: String?
    let acres: Int?
    let visitors: String?
    let highlights: [String]?
    let activities: [String]?
    let bestTime: [String]?
    let coordinates: ParkCoordinates?
    let websiteUrl: String?
    let phone: String?
    let address: String?
    let campgrounds: Int?
    let trailMiles: Int?
    let peakElevation: Int?
    let terrain: [String]?
    let difficulty: String?
    let crowdLevel: String?
    let nearestCity: String?
    let photos: [String]?
}

struct NationalGrassland: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let state: String
    let states: [String]?
    let region: String
    let classification: String
    let description: String
    let established: String?
    let acres: Int?
    let visitors: String?
    let highlights: [String]?
    let activities: [String]?
    let bestTime: [String]?
    let coordinates: ParkCoordinates?
    let websiteUrl: String?
    let wikipediaUrl: String?
    let phone: String?
    let address: String?
    let terrain: [String]?
    let difficulty: String?
    let crowdLevel: String?
    let nearestCity: String?
    let location: String?
    let photos: [String]?
    let wildlife: [String]?
    let features: [String]?
    let managingForest: String?
}

struct ForestFacility: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let category: String
    let icon: String
    let available: Bool
    let locations: [String]?
    let details: String?
    let seasonalInfo: String?
    let wheelchairAccessible: Bool?
}

struct ForestFacilitiesData: Codable, Hashable {
    struct Campgrounds: Codable, Hashable {
        let developed: Int
        let dispersed: Bool
        let totalSites: Int?
        let electric: Bool
        let reservable: Bool
    }

    struct Trails: Codable, Hashable {
        let hiking: Int
        let biking: Int
        let motorized: Int
        let horseback: Int
        let accessible: [String]
    }

    struct WaterActivities: Codable, Hashable {
        let fishing: Bool
        let boating: Bool
        let swimming: Bool
        let lakesCount: Int
        let boatRamps: Int
        let beaches: Int
        let rivers: [String]
    }

    struct WinterActivities: Codable, Hashable {
        let skiing: Bool
        let snowmobiling: Bool
        let snowshoeing: Bool
        let groomedTrails: Bool
    }

    struct Services: Codable, Hashable {
        let wifi: Bool
        let cellService: String
        let firewood: Bool
        let gasStation: Bool
        let groceryStore: Bool
    }

    struct Accessibility: Codable, Hashable {
        let accessibleCampsites: Int
        let accessibleRestrooms: Int
        let accessibleTrails: [String]
        let accessibleFishing: Bool
    }

    let forestId: String
    let type: String
    let facilities: [ForestFacility]
    let campgrounds: Campgrounds?
    let trails: Trails?
    let waterActivities: WaterActivities?
    let winterActivities: WinterActivities?
    let services: Services?
    let accessibility: Accessibility?
}

/// Waterfront | Alpine | Leisure | Default — drives Quick Service Tags (Data Engineer contract)
enum NRAScenario: String, Codable, CaseIterable {
    case waterfront = "Waterfront"
    case alpine = "Alpine"
    case leisure = "Leisure"
    case defaultScenario = "Default"
}

// 与 national-recreation-data.ts 对应
struct NationalRecreationArea: Codable, Identifiable, Hashable {
    let id: Int
    let category: String
    let categoryName: String
    let name: String
    let photo: String?
    let photoUrl: String?
    let location: RecreationLocation
    let agency: String
    let dateEstablished: String
    let areaAcres: Int
    let areaKm2: Double
    let visitors: Int?
    let description: String
    /// Optional from nra_processed; when nil use derived or Default
    let activeScenario: String?
    /// When true: show Ferry/Access Info, hide Car Rental
    let requiresAlternativeAccess: Bool?

    enum CodingKeys: String, CodingKey {
        case id, category, categoryName, name, photo, photoUrl, location, agency
        case dateEstablished, areaAcres, areaKm2, visitors, description
        case activeScenario, requiresAlternativeAccess
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        category = try c.decode(String.self, forKey: .category)
        categoryName = try c.decode(String.self, forKey: .categoryName)
        name = try c.decode(String.self, forKey: .name)
        photo = try c.decodeIfPresent(String.self, forKey: .photo)
        photoUrl = try c.decodeIfPresent(String.self, forKey: .photoUrl)
        location = try c.decode(RecreationLocation.self, forKey: .location)
        agency = try c.decode(String.self, forKey: .agency)
        dateEstablished = try c.decode(String.self, forKey: .dateEstablished)
        areaAcres = try c.decode(Int.self, forKey: .areaAcres)
        areaKm2 = try c.decode(Double.self, forKey: .areaKm2)
        visitors = try c.decodeIfPresent(Int.self, forKey: .visitors)
        description = try c.decode(String.self, forKey: .description)
        activeScenario = try c.decodeIfPresent(String.self, forKey: .activeScenario)
        requiresAlternativeAccess = try c.decodeIfPresent(Bool.self, forKey: .requiresAlternativeAccess)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(category, forKey: .category)
        try c.encode(categoryName, forKey: .categoryName)
        try c.encode(name, forKey: .name)
        try c.encodeIfPresent(photo, forKey: .photo)
        try c.encodeIfPresent(photoUrl, forKey: .photoUrl)
        try c.encode(location, forKey: .location)
        try c.encode(agency, forKey: .agency)
        try c.encode(dateEstablished, forKey: .dateEstablished)
        try c.encode(areaAcres, forKey: .areaAcres)
        try c.encode(areaKm2, forKey: .areaKm2)
        try c.encodeIfPresent(visitors, forKey: .visitors)
        try c.encode(description, forKey: .description)
        try c.encodeIfPresent(activeScenario, forKey: .activeScenario)
        try c.encodeIfPresent(requiresAlternativeAccess, forKey: .requiresAlternativeAccess)
    }
}

struct RecreationLocation: Codable, Hashable {
    let states: [String]
    let coordinates: ParkCoordinates
}

// 与 alabama-regions.ts 对应（区域配置）
struct RegionConfig: Codable, Hashable {
    let name: String
    let color: String
    let bounds: [[Double]]
    let mapPosition: MapPosition
}

struct MapPosition: Codable, Hashable {
    let top: String
    let left: String
}
