// 与 states-data.ts / state-data-loader.ts 对应
import Foundation

// MARK: - 州列表项（states-list.json）
struct StateListItem: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let code: String
    let parksCount: String
}

// MARK: - 露营信息（与 CampingInfo 对应）
struct CampingInfo: Codable, Hashable {
    let available: Bool
    let description: String?
    let campgrounds: [Campground]?
    let backcountry: Backcountry?
    let priceRange: String?
    let seasonalNotes: String?
    let officialUrl: String?
    let reservationSystem: String?
}

struct Campground: Codable, Hashable {
    let name: String
    let type: String
    let sites: Int?
    let amenities: [String]?
}

struct Backcountry: Codable, Hashable {
    let available: Bool
    let permitRequired: Bool?
    let notes: String?
}

// MARK: - 州公园（与 Park 对应）
struct Park: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let activities: [String]
    let latitude: Double
    let longitude: Double
    let popularity: Int?
    let hours: String?
    let entryFee: String?
    let phone: String?
    let region: String?
    let county: String?
    let type: String?
    let camping: CampingInfo?
    let websiteUrl: String?
}

// MARK: - 州完整数据（与 StateData 对应，states-parks.json 每州一条）
struct StateData: Codable {
    let name: String
    let code: String
    let images: [String]
    let parks: [Park]
    let bounds: [[Double]]?
    let description: String?
    let regions: [String]?
    let counties: [String]?
}
