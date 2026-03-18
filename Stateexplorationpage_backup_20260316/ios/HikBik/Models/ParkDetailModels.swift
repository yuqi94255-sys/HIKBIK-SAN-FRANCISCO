// MARK: - HikBik 公園詳情頁 — 完整數據結構（對齊產品藍圖）
// 模組化 struct，供 BasicInfo / LiveStatus / Campgrounds / Fees / MapData 等子結構使用

import Foundation

// MARK: - 頂層

struct ParkDetail: Codable {
    var basicInfo: BasicInfo
    var liveStatus: LiveStatus?
    var weather: WeatherInfo?
    var activities: ActivitiesInfo?
    var campgrounds: [CampgroundItem]
    var feesAndPermits: FeesAndPermits?
    var mapData: MapData?
    var facilities: FacilitiesInfo?
    var safety: SafetyInfo?
    var seasons: SeasonsInfo?
    var terrain: TerrainInfo?
    var access: AccessInfo?
}

// MARK: - 1. BasicInfo（必須）

struct BasicInfo: Codable {
    var parkId: String
    var parkName: String
    var parkType: String?           // national park / forest / grassland / state park / recreation area
    var coverImage: String?
    var galleryImages: [String]
    var description: String?
    var shortDescription: String?
    var state: String?
    var province: String?
    var country: String?
    var latitude: Double?
    var longitude: Double?
    var areaSize: String?           // acre / km²
    var elevationRange: String?
    var timezone: String?
    var weatherSummary: String?   // NPS weatherInfo 或簡短天氣描述
    var officialWebsite: String?
    var contactPhone: String?
    var address: String?
}

// MARK: - 2. LiveStatus（實時狀態）

struct LiveStatus: Codable {
    var openStatus: String?         // open / closed / partial
    var seasonalClosureInfo: String?
    var alertNotices: [AlertNotice]
    var fireRestrictions: String?
    var roadClosures: [String]
    var airQuality: String?
}

struct AlertNotice: Codable {
    var id: String?
    var title: String?
    var description: String?
    var category: String?
    var url: String?
}

// MARK: - 3. WeatherInfo（天氣）

struct WeatherInfo: Codable {
    var currentWeather: String?
    var sevenDayForecast: [DayForecast]?
    var temperatureRange: String?
    var windSpeed: String?
    var precipitation: String?
    var snowDepth: String?
    var sunrise: String?
    var sunset: String?
    var bestVisitMonths: [String]?
}

struct DayForecast: Codable {
    var date: String?
    var high: String?
    var low: String?
    var condition: String?
}

// MARK: - 4. ActivitiesInfo（活動適配）

struct ActivitiesInfo: Codable {
    var activitiesSupported: [String]?   // hiking, biking, camping, ...
    var difficultyLevelOverall: String?
    var recommendedExperienceLevel: String?
    var familyFriendly: Bool?
    var dogAllowed: Bool?
    var permitRequiredActivities: [String]?
}

// MARK: - 5. Campgrounds（營地）— 藍圖第五項，對接 Recreation.gov / RIDB

/// 單一營地：基礎 / 決策 / 設施 / 預約連結，供詳情頁「Campgrounds」區塊與預約入口使用。
struct CampgroundItem: Codable {
    var id: String?
    var name: String?
    var location: String?
    /// RV / Tent / Backcountry
    var type: String?
    /// 是否可預約（Recreation.gov）；否則為 First-come, first-served
    var reservable: Bool?
    var priceRange: String?
    var capacity: String?
    var amenities: [String]?
    /// 預約連結，指向 Recreation.gov
    var bookingUrl: String?
    // MARK: Amenities（設施圖標）
    var waterAccess: Bool?
    var electricity: Bool?
    var restroom: Bool?
    var shower: Bool?
    var fireRing: Bool?
    /// 開放季節（決策用）
    var season: String?

    var stableId: String { id ?? name ?? UUID().uuidString }
}

// MARK: - 6. FeesAndPermits

// MARK: - 6. FeesAndPermits（藍圖第六項：費用 / 預約 / Permit）
/// 門票、車輛／摩托車／人頭／商業導覽費、年票、定時入園，供導航前決策。NPS API 的 entranceFees 依 title 區分類型。
struct FeesAndPermits: Codable {
    var entryFee: String?
    /// 按車算，通常 $30–$35
    var vehicleFee: String?
    /// 按摩托車算（NPS API entranceFees 中 title 含 motorcycle）
    var motorcycleFee: String?
    /// 按人頭算，騎腳踏車或走路入園（NPS title 含 person / individual / pedestrian / bicycle）
    var individualFee: String?
    /// 商業導覽（NPS title 含 commercial）
    var commercialTourFee: String?
    var annualPassAccepted: Bool?
    var permitRequired: Bool?
    var reservationRequired: Bool?
    /// 是否需定時預約入園（北美大公園熱點，如 Acadia / Rocky Mountain）
    var timedEntryRequired: Bool?
    var permitLinks: [String]?
}

// MARK: - 7. MapData

struct MapData: Codable {
    var boundaryPolygon: [[Double]]?     // 簡化：經緯度陣列
    var entrances: [GeoPoint]?
    var visitorCenters: [GeoPoint]?
    var parkingLocations: [GeoPoint]?
    var viewpoints: [GeoPoint]?
    var campgroundLocations: [GeoPoint]?
    var waterSources: [GeoPoint]?
    var dangerZones: [GeoPoint]?
}

struct GeoPoint: Codable {
    var name: String?
    var latitude: Double?
    var longitude: Double?
}

// MARK: - 8. FacilitiesInfo（設施快覽 + 可選座標供地圖標註）

/// 單一設施位置，供地圖標註與「點擊跳轉地圖」使用
struct FacilityLocation: Codable, Identifiable {
    var id: String
    var name: String
    var latitude: Double
    var longitude: Double
    /// 如 "visitor_center", "restroom", "water"
    var facilityType: String?
}

struct FacilitiesInfo: Codable {
    var visitorCenters: [String]?
    /// 遊客中心座標，與 visitorCenters 對應或補充，供地圖標註
    var visitorCenterLocations: [FacilityLocation]?
    var restrooms: [String]?
    var waterStations: [String]?
    var foodServices: String?
    var lodging: String?
    var gasNearby: String?
    var wifiAvailable: Bool?
    var cellSignalStrength: String?
    var wheelchairAccessibility: String?
}

// MARK: - 9. SafetyInfo

struct SafetyInfo: Codable {
    var wildlifeWarnings: String?
    var weatherHazards: String?
    var altitudeRisk: String?
    var emergencyContact: String?
    var rescueInfo: String?
    var leaveNoTraceRules: String?
}

// MARK: - 10. SeasonsInfo（季節 + 月份熱力圖）

struct SeasonsInfo: Codable {
    var bestSeasons: [String]?
    var crowdLevelByMonth: [String: String]?   // "January": "Low" / "Medium" / "High" / "Closed"
    var peakMonths: [String]?
    var recommendedDuration: String?
    /// 每月細項：人潮、氣溫、亮點（供 SeasonalityGrid 詳情面板）
    var monthDetails: [MonthSeasonDetail]?
}

struct MonthSeasonDetail: Codable, Identifiable {
    var monthIndex: Int       // 1–12
    var crowdLevel: String?   // Low, Medium, High, Closed
    var tempLow: String?
    var tempHigh: String?
    var highlight: String?
    var id: Int { monthIndex }
}

// MARK: - 11. TerrainInfo（專業級）

struct TerrainInfo: Codable {
    var terrainType: String?        // desert / alpine / forest / coastal
    var elevationProfile: String?
    var geology: String?
    var vegetationTypes: [String]?
    var waterFeatures: [String]?
}

// MARK: - 12. AccessInfo（可達性）

struct AccessInfo: Codable {
    var nearestAirport: String?
    /// 最近機場代碼（如 FAT），用於與 regionalHubsWithin5hr 去重
    var nearestAirportCode: String?
    /// 5 小時車程內的大型樞紐機場，如 ATL/CLT/BNA（Great Smoky Mountains）、SFO/LAX（Yosemite）
    var regionalHubsWithin5hr: [String: String]?
    /// 相容舊版；現由 regionalHubsWithin5hr 取代
    var driveTimeFromMajorCities: [String: String]?
    var roadAccessibility: String?
    var winterAccess: String?
}

// MARK: - 13. ParkPortals（手動整理的門戶數據 — ParkPortalsData.json）

struct ParkPortalsItem: Codable {
    let portals: [PortalItem]
    let proTip: String?
}

struct PortalItem: Codable, Identifiable {
    let type: String       // Fastest, Major Hub, Primary Hub, Global Hub, Regional Hub, Exclusive Hub, Direct
    let airport: String
    let driveTime: String
    let entrance: String
    let tip: String
    var id: String { "\(airport)-\(entrance)" }
}

struct ParkPortalsData: Codable {
    let _meta: [String: String]?
    let parks: [String: ParkPortalsItem]
}
