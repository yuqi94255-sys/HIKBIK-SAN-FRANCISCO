// 与 Figma/Web 国家公园设计一致：设施、天气、图库、野生动物、统计
import Foundation

// MARK: - 设施（national-parks-facilities）
struct ParkFacilitiesData: Codable {
    let parkId: String
    let facilities: [ParkFacility]
    let generalInfo: String?
}

struct ParkFacility: Codable, Identifiable {
    let id: String
    let name: String
    let category: String?
    let icon: String?
    let available: Bool
    let locations: [String]?
    let details: String?
    let seasonalInfo: String?
}

// MARK: - 天气（national-parks-weather）
struct ParkWeather: Codable {
    let parkId: String
    let currentTemp: Int?
    let condition: String?
    let humidity: Int?
    let windSpeed: Int?
    let forecast: [DailyWeather]?
    let bestMonths: [String]?
    let seasonalInfo: [SeasonalInfo]?
}

struct DailyWeather: Codable {
    let day: String
    let icon: String?
    let high: Int
    let low: Int
    let condition: String?
}

struct SeasonalInfo: Codable {
    let season: String
    let description: String
}

// MARK: - 野生动物（national-parks-wildlife）
struct ParkWildlife: Codable {
    let parkId: String
    let animals: [WildlifeAnimal]?
    let bestViewingTimes: [String]?
    let safetyTips: [String]?
}

struct WildlifeAnimal: Codable, Identifiable {
    var id: String { name }
    let name: String
    let icon: String?
    let category: String?
    let commonlySeen: Bool?
}

// MARK: - 统计（national-parks-stats）
struct ParkStatisticsElevation: Codable {
    let highest: String?
    let highestFeet: Int?
    let lowest: String?
    let lowestFeet: Int?
}

struct ParkStatistics: Codable {
    let parkId: String
    let established: String?
    let area: String?
    let annualVisitors: String?
    let worldHeritageSite: Bool?
    let elevation: ParkStatisticsElevation?
}

// MARK: - 住宿（national-parks-lodging）
struct LodgingOption: Codable, Identifiable {
    let id: String
    let name: String
    let type: String?
    let description: String?
    let priceRange: String?
    let amenities: [String]?
    let highlights: [String]?
}

struct ParkLodging: Codable {
    let parkId: String
    let hasInParkLodging: Bool?
    let lodgingOptions: [LodgingOption]?
    let nearbyInfo: String?
    let generalNotes: [String]?
}
