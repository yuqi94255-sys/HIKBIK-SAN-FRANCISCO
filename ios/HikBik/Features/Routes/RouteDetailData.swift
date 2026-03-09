// MARK: - HIKBIK Route Detail — Data-Driven Schema (JSON-equivalent)
import Foundation
import SwiftUI
import CoreLocation

// MARK: - 海拔座標對（與 RouteDetailData 同 target，避免 Cannot find type 'ElevationPoint'）
/// 專業路段海拔數據點：橫軸里程 (mi)、縱軸海拔 (ft)
struct ElevationPoint: Identifiable, Codable, Equatable {
    let mile: Double
    let elevation: Double
    var id: String { "\(mile)_\(elevation)" }
}

// MARK: - Official Track 數據模型
/// 評論數據（驅動底部的評論列表）
struct OfficialTrackReview: Identifiable {
    let id = UUID()
    var author: String?
    var rating: Int
    var comment: String
    var date: Date
}

/// Single official track (no Day / multi-day). Path from pathPoints only.
struct OfficialDetailedTrack: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let headerImage: String
    let themeColor: Color
    let difficulty: String
    let distance: String
    let elevationGain: String
    let estimatedTime: String
    let safetyRating: Double
    let trackQuality: String
    let isOfficial: Bool
    var reviews: [OfficialTrackReview]
    let elevationData: [ElevationPoint]?
    let totalGain: String?
    let totalLoss: String?
    /// Dense path points for map polyline (non-linear, terrain-following). No Day data.
    let pathPoints: [CLLocationCoordinate2D]?
}

extension OfficialDetailedTrack {
    static let moabSlickrock = OfficialDetailedTrack(
        title: "Moab Slickrock Trail",
        location: "Moab, Utah",
        headerImage: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200",
        themeColor: Color.purple,
        difficulty: "Technical",
        distance: "12.3 mi",
        elevationGain: "1,200 ft",
        estimatedTime: "6-8 hrs",
        safetyRating: 4.5,
        trackQuality: "Excellent",
        isOfficial: true,
        reviews: [
            OfficialTrackReview(author: "Chief_Explorer", rating: 5, comment: "The elevation mapping on this official route is pinpoint accurate. The tactical dashboard helped me manage my pace perfectly.", date: Date()),
            OfficialTrackReview(author: "SummitSeeker", rating: 4, comment: "Incredible views. Technical specs were helpful—be prepared for steep inclines.", date: Date().addingTimeInterval(-86400)),
        ],
        elevationData: nil,
        totalGain: nil,
        totalLoss: nil,
        pathPoints: nil
    )

    /// Yosemite Half Dome Cables (Sub Dome → Summit). Dense pathPoints for smooth polyline.
    static let yosemiteCables = OfficialDetailedTrack(
        title: "Half Dome Cables Section",
        location: "Yosemite National Park, CA",
        headerImage: "https://images.unsplash.com/photo-1569969236549-b13c2d13796f?w=1200",
        themeColor: Color(hex: "A855F7"),
        difficulty: "Technical",
        distance: "0.5 mi",
        elevationGain: "+400 ft",
        estimatedTime: "1-2 hrs",
        safetyRating: 4.5,
        trackQuality: "Excellent",
        isOfficial: true,
        reviews: [],
        elevationData: [
            ElevationPoint(mile: 0.00, elevation: 8442),
            ElevationPoint(mile: 0.05, elevation: 8480),
            ElevationPoint(mile: 0.10, elevation: 8535),
            ElevationPoint(mile: 0.15, elevation: 8590),
            ElevationPoint(mile: 0.20, elevation: 8660),
            ElevationPoint(mile: 0.25, elevation: 8710),
            ElevationPoint(mile: 0.30, elevation: 8755),
            ElevationPoint(mile: 0.35, elevation: 8795),
            ElevationPoint(mile: 0.40, elevation: 8820),
            ElevationPoint(mile: 0.45, elevation: 8835),
            ElevationPoint(mile: 0.50, elevation: 8842),
        ],
        totalGain: "+400 ft",
        totalLoss: "0 ft",
        pathPoints: Self.yosemiteCablesPathPoints
    )

    /// Dense polyline for Half Dome Cables (smooth, non-linear). ~100+ points.
    private static var yosemiteCablesPathPoints: [CLLocationCoordinate2D] {
        let seed: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.732_00, longitude: -119.533_20),
            CLLocationCoordinate2D(latitude: 37.732_15, longitude: -119.533_10),
            CLLocationCoordinate2D(latitude: 37.732_35, longitude: -119.532_95),
            CLLocationCoordinate2D(latitude: 37.732_55, longitude: -119.532_80),
            CLLocationCoordinate2D(latitude: 37.732_75, longitude: -119.532_65),
            CLLocationCoordinate2D(latitude: 37.732_95, longitude: -119.532_50),
            CLLocationCoordinate2D(latitude: 37.733_15, longitude: -119.532_35),
            CLLocationCoordinate2D(latitude: 37.733_35, longitude: -119.532_20),
            CLLocationCoordinate2D(latitude: 37.733_55, longitude: -119.532_05),
            CLLocationCoordinate2D(latitude: 37.733_75, longitude: -119.531_90),
            CLLocationCoordinate2D(latitude: 37.733_95, longitude: -119.531_75),
        ]
        return interpolatePolyline(seed, pointsPerSegment: 12)
    }
}

private func interpolatePolyline(_ coords: [CLLocationCoordinate2D], pointsPerSegment: Int) -> [CLLocationCoordinate2D] {
    guard coords.count >= 2 else { return coords }
    var out: [CLLocationCoordinate2D] = [coords[0]]
    for i in 1..<coords.count {
        let a = coords[i - 1], b = coords[i]
        for j in 1...pointsPerSegment {
            let t = Double(j) / Double(pointsPerSegment)
            out.append(CLLocationCoordinate2D(
                latitude: a.latitude + t * (b.latitude - a.latitude),
                longitude: a.longitude + t * (b.longitude - a.longitude)
            ))
        }
    }
    return out
}

// MARK: - Step 2: 數據協議 (RouteData Protocol)
// 所有組件僅透過此協議的數據渲染，無硬編碼文本。
protocol RouteDataProtocol {
    var routeName: String { get }
    var routeId: String { get }
    var location: String? { get }
    var heroImage: String { get }
    var stats: RouteDetailStats { get }
    var itinerary: [RouteDetailItineraryItem] { get }
    var techSpecs: RouteDetailTechSpecs { get }
    var gear: [RouteDetailGearItem] { get }
    var heroRating: String? { get }
    var heroReviewCount: String? { get }
    var heroAuthorHandle: String? { get }
    var heroAuthorInitials: String? { get }
    var heroShortDescription: String? { get }
    var heroTagLabels: [String] { get }
    var trailReports: [TrailReport] { get }
    var reviews: [RouteReview] { get }
    /// 可選主題色（Official Track 用；nil 時 UI 用預設色）
    var themeColor: Color? { get }
    /// View Points 路線座標（Detailed Track 詳情頁頂部 Map 紫線）
    var pathPoints: [CLLocationCoordinate2D]? { get }
}

extension RouteDataProtocol {
    var themeColor: Color? { nil }
    var pathPoints: [CLLocationCoordinate2D]? { nil }
}

// MARK: - Root（遵循協議）
struct RouteDetailData: RouteDataProtocol {
    var routeName: String
    var routeId: String
    var location: String?
    var heroImage: String
    var stats: RouteDetailStats
    var itinerary: [RouteDetailItineraryItem]
    var techSpecs: RouteDetailTechSpecs
    var gear: [RouteDetailGearItem]
    var heroRating: String?
    var heroReviewCount: String?
    var heroAuthorHandle: String?
    var heroAuthorInitials: String?
    var heroShortDescription: String?
    var heroTagLabels: [String]
    var trailReports: [TrailReport]
    var reviews: [RouteReview]
    var themeColor: Color?

    init(
        routeName: String,
        routeId: String,
        location: String?,
        heroImage: String,
        stats: RouteDetailStats,
        itinerary: [RouteDetailItineraryItem],
        techSpecs: RouteDetailTechSpecs,
        gear: [RouteDetailGearItem],
        heroRating: String? = nil,
        heroReviewCount: String? = nil,
        heroAuthorHandle: String? = nil,
        heroAuthorInitials: String? = nil,
        heroShortDescription: String? = nil,
        heroTagLabels: [String] = [],
        trailReports: [TrailReport] = [],
        reviews: [RouteReview] = [],
        themeColor: Color? = nil
    ) {
        self.routeName = routeName
        self.routeId = routeId
        self.location = location
        self.heroImage = heroImage
        self.stats = stats
        self.itinerary = itinerary
        self.techSpecs = techSpecs
        self.gear = gear
        self.heroRating = heroRating
        self.heroReviewCount = heroReviewCount
        self.heroAuthorHandle = heroAuthorHandle
        self.heroAuthorInitials = heroAuthorInitials
        self.heroShortDescription = heroShortDescription
        self.heroTagLabels = heroTagLabels
        self.trailReports = trailReports
        self.reviews = reviews
        self.themeColor = themeColor
    }

    /// 從 OfficialDetailedTrack 生成 routeData（單次路線，無多日 itinerary / Day）
    init(from track: OfficialDetailedTrack) {
        let reviewsAsRoute: [RouteReview] = track.reviews.map { r in
            RouteReview(rating: r.rating, comment: r.comment, author: r.author, date: r.date, selectedTags: [], photoData: [], userId: nil)
        }
        self = RouteDetailData(
            routeName: track.title,
            routeId: track.id.uuidString,
            location: track.location,
            heroImage: track.headerImage,
            stats: RouteDetailStats(
                days: 0,
                distance: track.distance,
                vehicle: track.difficulty,
                signal: track.trackQuality
            ),
            itinerary: [],
            techSpecs: RouteDetailTechSpecs(
                surfaceType: track.trackQuality,
                cellSignal: track.trackQuality,
                vehicleAccess: "Available",
                permitStatus: track.isOfficial ? "Official" : "Not Required"
            ),
            gear: [],
            heroRating: String(format: "%.1f", track.safetyRating),
            heroReviewCount: "\(track.reviews.count)",
            heroAuthorHandle: nil,
            heroAuthorInitials: nil,
            heroShortDescription: "\(track.difficulty) · \(track.estimatedTime) · \(track.elevationGain)",
            heroTagLabels: track.isOfficial ? ["OFFICIAL TRACK", track.difficulty] : [track.difficulty],
            trailReports: [],
            reviews: reviewsAsRoute,
            themeColor: track.themeColor
        )
    }

    /// 從列表項生成 routeData（行程/裝備/報告/評論沿用 mock，Beta 展示用；後續可改為 API）
    init(routeItem: RouteItem) {
        self = RouteDetailData(
            routeName: routeItem.title,
            routeId: routeItem.id,
            location: routeItem.location,
            heroImage: routeItem.imageUrl,
            stats: RouteDetailStats(days: 5, distance: routeItem.distance, vehicle: "AWD+", signal: "Limited"),
            itinerary: RouteDetailData.mockArizona.itinerary,
            techSpecs: RouteDetailData.mockArizona.techSpecs,
            gear: RouteDetailData.mockArizona.gear,
            heroRating: "4.7",
            heroReviewCount: "342",
            heroAuthorHandle: "@desert_wanderer",
            heroAuthorInitials: "DW",
            heroShortDescription: RouteDetailData.mockArizona.heroShortDescription,
            heroTagLabels: RouteDetailData.mockArizona.heroTagLabels,
            trailReports: [],
            reviews: RouteDetailData.mockArizona.reviews
        )
        // TODO: Fetch data from Firebase/Backend; replace mockArizona.reviews with API response
    }
}

// MARK: - Stats (Hero 下方四宮格)
struct RouteDetailStats {
    var days: Int
    var distance: String
    var vehicle: String
    var signal: String
}

// MARK: - Itinerary 單日（支持單圖 img 或多圖 images 橫滑；location 供天氣模塊地點切換）
struct RouteDetailItineraryItem: Identifiable {
    var id: Int { day }
    var day: Int
    var title: String
    var distance: String
    var desc: String
    var img: String
    /// 多圖時使用，橫向滑動；為空則用 img 作為單圖
    var images: [String]
    /// 該日地點名稱，供 WeatherModule 切換；為空時不參與地點列表
    var location: String?

    /// 用於展示的圖片列表：多圖用 images，否則用 [img]
    var displayImages: [String] {
        images.isEmpty ? [img] : images
    }
}

// MARK: - Tech Specs 2x2
struct RouteDetailTechSpecs {
    var surfaceType: String
    var cellSignal: String
    var vehicleAccess: String
    var permitStatus: String
}

// MARK: - Gear 單項
struct RouteDetailGearItem: Identifiable {
    var id: String { name }
    var name: String
    var icon: String
    var critical: Bool
}

// MARK: - 實時路況報告（雙軌制頂層：路況狀態 + 描述，無星級）
enum TrailReportStatus: String, Codable {
    case good
    case caution
}

struct TrailReport: Identifiable {
    var id: String
    var status: TrailReportStatus
    var segmentLabel: String
    var description: String
    /// 里程標記（英里），用於與海拔圖表聯動、高亮該里程附近的報告
    var mileMarker: Double
    /// 可選：發布者 handle（如 TrailRunner_88）
    var author: String?

    init(id: String = UUID().uuidString, status: TrailReportStatus, segmentLabel: String, description: String, mileMarker: Double = 0, author: String? = nil) {
        self.id = id
        self.status = status
        self.segmentLabel = segmentLabel
        self.description = description
        self.mileMarker = mileMarker
        self.author = author
    }
}

// MARK: - 整體路線評分（雙軌制底層：星級 + 評論；符合 Reviewable 協議）
struct RouteReview: Identifiable, Reviewable {
    var id: String
    var rating: Int       // 1–5
    var comment: String
    var author: String?
    var date: Date
    /// Quick Intel 標籤（用於精選權重）
    var selectedTags: [String]
    /// 附件照片數據（用於精選權重 +100，列表縮略圖）
    var photoData: [Data]
    /// 發布者 ID，用於權限判斷（僅本人評論顯示刪除按鈕）
    var userId: String?

    init(id: String = UUID().uuidString, rating: Int, comment: String, author: String? = nil, date: Date, selectedTags: [String] = [], photoData: [Data] = [], userId: String? = nil) {
        self.id = id
        self.rating = rating
        self.comment = comment
        self.author = author
        self.date = date
        self.selectedTags = selectedTags
        self.photoData = photoData
        self.userId = userId
    }

    /// 是否為當前登錄用戶的評論（用於顯示刪除菜單）
    static func isCurrentUser(_ review: RouteReview) -> Bool {
        guard let uid = review.userId, !uid.isEmpty else { return false }
        return uid == ReviewManager.currentUserId
    }

    /// 有實質內容（非空且非 "No comment."）才在列表中展示
    var hasMeaningfulComment: Bool {
        let t = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        return !t.isEmpty && t != "No comment."
    }

    /// 精選權重：基礎分 + 文字長度 + 標籤數 + 有照片 +100（排序與 TOP INTEL 用）
    var priorityScore: Double {
        let base = Double(rating) * 10
        let textScore = Double(comment.count) * 0.1
        let tagScore = Double(selectedTags.count) * 5
        let photoBonus: Double = photoData.isEmpty ? 0 : 100
        return base + textScore + tagScore + photoBonus
    }
}

// MARK: - Mock Data（切換 routeName 即可驅動整頁）
extension RouteDetailData {
    /// Arizona 範例
    static let mockArizona = RouteDetailData(
        routeName: "Arizona Desert Explorer",
        routeId: "az_mock",
        location: "Arizona, USA",
        heroImage: "https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=1200",
        stats: RouteDetailStats(days: 5, distance: "580 mi", vehicle: "AWD+", signal: "Moderate"),
        itinerary: [
            RouteDetailItineraryItem(day: 1, title: "Phoenix to Sedona", distance: "120mi", desc: "Red rock formations, Oak Creek Canyon scenic drive, Cathedral Rock viewpoint.", img: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800", images: ["https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800", "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800"], location: "Phoenix"),
            RouteDetailItineraryItem(day: 2, title: "Sedona to Grand Canyon", distance: "110mi", desc: "South Rim entrance, Desert View Drive, multiple viewpoints along the rim.", img: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800", images: [], location: "Sedona"),
            RouteDetailItineraryItem(day: 3, title: "Grand Canyon Exploration", distance: "40mi", desc: "Hermit Road scenic drive, Rim Trail hiking, sunset at Hopi Point.", img: "https://images.unsplash.com/photo-1474044159687-1ee9f3a51722?w=800", images: [], location: "Grand Canyon"),
            RouteDetailItineraryItem(day: 4, title: "South Rim to North Rim", distance: "212mi", desc: "Full day drive across the canyon via US-89. Stops at Jacob Lake and North Rim viewpoints.", img: "https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=800", images: [], location: "North Rim"),
        ],
        techSpecs: RouteDetailTechSpecs(
            surfaceType: "Mixed",
            cellSignal: "Good",
            vehicleAccess: "Available",
            permitStatus: "Required"
        ),
        gear: [
            RouteDetailGearItem(name: "Water", icon: "drop.fill", critical: true),
            RouteDetailGearItem(name: "Hiking Boots", icon: "shoe.fill", critical: true),
            RouteDetailGearItem(name: "Map/GPS", icon: "map.fill", critical: true),
            RouteDetailGearItem(name: "First Aid", icon: "cross.case.fill", critical: true),
            RouteDetailGearItem(name: "Headlamp", icon: "flashlight.on.fill", critical: true),
            RouteDetailGearItem(name: "Food/Snacks", icon: "fork.knife", critical: true),
            RouteDetailGearItem(name: "Backpack", icon: "bag.fill", critical: false),
        ],
        heroRating: "4.7",
        heroReviewCount: "342",
        heroAuthorHandle: "@desert_wanderer",
        heroAuthorInitials: "DW",
        heroShortDescription: "A stunning 5-day road trip through Arizona's most iconic desert landscapes, from red rocks to canyons.",
        heroTagLabels: ["Preview", "GRAND JOURNEY", "User Shared"],
        trailReports: [],
        reviews: [
            RouteReview(rating: 5, comment: "The elevation mapping on this official route is pinpoint accurate. The tactical dashboard helped me manage my pace perfectly.", author: "Chief_Explorer", date: Date(), selectedTags: [], photoData: [], userId: "other_user"),
            RouteReview(rating: 4, comment: "Incredible views. The technical specs were helpful, but 'Moderate' feels like an understatement—be prepared for steep inclines.", author: "SummitSeeker", date: Date().addingTimeInterval(-86400), selectedTags: [], photoData: [], userId: "other_user"),
        ]
    )

    /// Arizona Desert Explorer 範例（僅改 routeData 即可全頁切換）
    static let mockArizonaDesertExplorer = RouteDetailData(
        routeName: "Arizona Desert Explorer",
        routeId: "az_desert_mock",
        location: "Sonoran Desert, Arizona",
        heroImage: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
        stats: RouteDetailStats(days: 4, distance: "118mi", vehicle: "4WD", signal: "Limited"),
        itinerary: [
            RouteDetailItineraryItem(day: 1, title: "Phoenix to Lost Dutchman", distance: "42mi", desc: "Desert foothills, Superstition Mountains, saguaro stands.", img: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800", images: [], location: "Apache Junction"),
            RouteDetailItineraryItem(day: 2, title: "Tonto to Roosevelt Lake", distance: "38mi", desc: "Tonto National Forest, desert lakes, riparian stops.", img: "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800", images: [], location: "Roosevelt"),
            RouteDetailItineraryItem(day: 3, title: "Desert View to Saguaro East", distance: "28mi", desc: "Cactus forests, desert wildlife, scenic overlooks.", img: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800", images: [], location: "Tucson"),
            RouteDetailItineraryItem(day: 4, title: "Catalina Foothills Return", distance: "10mi", desc: "Final stretch through Sonoran desert and back to trailhead.", img: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800", images: [], location: "Catalina"),
        ],
        techSpecs: RouteDetailTechSpecs(
            surfaceType: "Mixed",
            cellSignal: "Limited",
            vehicleAccess: "Available",
            permitStatus: "Not Required"
        ),
        gear: [
            RouteDetailGearItem(name: "Water", icon: "drop.fill", critical: true),
            RouteDetailGearItem(name: "Sun Protection", icon: "sun.max.fill", critical: true),
            RouteDetailGearItem(name: "Map/GPS", icon: "map.fill", critical: true),
            RouteDetailGearItem(name: "First Aid", icon: "cross.case.fill", critical: true),
            RouteDetailGearItem(name: "Layers", icon: "cloud.sun.fill", critical: true),
            RouteDetailGearItem(name: "Food/Snacks", icon: "fork.knife", critical: true),
            RouteDetailGearItem(name: "Backpack", icon: "bag.fill", critical: false),
        ],
        heroRating: "4.8",
        heroReviewCount: "234",
        heroAuthorHandle: "@arizona_desert_guide",
        heroAuthorInitials: "AD",
        heroShortDescription: "Multi-day loop through Sonoran Desert, saguaro forests, and desert lakes.",
        heroTagLabels: ["Preview", "OFFICIAL", "Pro Guide"],
        trailReports: [],
        reviews: []
    )
}

// MARK: - Official Track JSON Payload（與 RouteDetailData 同 target，供 RoutesView / OfficialDetailedTrackView 使用）
struct OfficialTrackPayload: Codable {
    let trackId: String
    let type: String?
    let theme: TrackPayloadTheme
    let header: TrackPayloadHeader
    let dashboard: TrackPayloadDashboard
    let elevationProfile: TrackPayloadElevationProfile
    let weather: TrackPayloadWeather
    let technicalSpecs: TrackPayloadTechnicalSpecs
    let waypoints: [TrackPayloadWaypoint]
    let essentialGear: [EssentialGearItem]
}

struct TrackPayloadTheme: Codable {
    let primaryColor: String
    let accentColor: String?
    var primarySwiftUIColor: Color { Color(hex: primaryColor.replacingOccurrences(of: "#", with: "")) }
}

struct TrackPayloadHeader: Codable {
    let badge: String
    let title: String
    let location: String
    let imageName: String
    let rating: String
    let reviewsCount: Int
}

struct TrackPayloadDashboard: Codable {
    let trackQuality: String
    let safetyRating: String
    let distance: String
    let duration: String
}

struct TrackPayloadElevationProfile: Codable {
    let totalGain: String
    let totalLoss: String
    let startAlt: String
    let maxAlt: String
    let endAlt: String
    let dataPoints: [Double]
}

struct TrackPayloadWeather: Codable {
    let location: String
    let forecast: [WeatherForecastItem]
}

struct WeatherForecastItem: Codable {
    let time: String
    let temp: String
    let condition: String
    let wind: String
}

struct TrackPayloadTechnicalSpecs: Codable {
    let surface: String
    let cellSignal: String
    let vehicleAccess: String
    let permit: String
}

struct TrackPayloadWaypoint: Codable, Identifiable {
    var id: String { name + distance }
    let name: String
    let distance: String
}

struct EssentialGearItem: Codable, Identifiable {
    var id: String { item }
    let item: String
    let isMandatory: Bool
    let icon: String
}

extension OfficialTrackPayload {
    static func loadYosemiteHalfDome() -> OfficialTrackPayload? {
        if let url = Bundle.main.url(forResource: "yosemite-half-dome-cables", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(OfficialTrackPayload.self, from: data) { return decoded }
        return nil
    }

    static let yosemiteHalfDome: OfficialTrackPayload? = {
        if let payload = loadYosemiteHalfDome() { return payload }
        let json = """
        {"trackId":"yosemite-half-dome-cables","type":"OFFICIAL_DETAILED_TRACK","theme":{"primaryColor":"#22C55E","accentColor":"#4ADE80"},"header":{"badge":"DETAILED TRACK","title":"Half Dome Cables Section","location":"Yosemite National Park, CA","imageName":"yosemite_half_dome_hero","rating":"4.9","reviewsCount":1284},"dashboard":{"trackQuality":"Excellent","safetyRating":"3.5/5","distance":"0.5 mi","duration":"1-2 hrs"},"elevationProfile":{"totalGain":"+400 ft","totalLoss":"0 ft","startAlt":"8,442 ft","maxAlt":"8,842 ft","endAlt":"8,842 ft","dataPoints":[8442,8500,8650,8750,8842]},"weather":{"location":"Yosemite Valley, CA","forecast":[{"time":"Now","temp":"68°F","condition":"Sunny","wind":"15 mph"},{"time":"1 PM","temp":"70°F","condition":"Sunny","wind":"18 mph"},{"time":"2 PM","temp":"71°F","condition":"Windy","wind":"22 mph"}]},"technicalSpecs":{"surface":"Granite Rock","cellSignal":"None","vehicleAccess":"No","permit":"REQUIRED"},"waypoints":[{"name":"Sub Dome Base","distance":"0.0 mi"},{"name":"Base of Cables","distance":"0.2 mi"},{"name":"Half Dome Summit","distance":"0.5 mi"}],"essentialGear":[{"item":"Leather Gloves","isMandatory":true,"icon":"hand.raised.fill"},{"item":"Climbing Harness","isMandatory":false,"icon":"figure.climbing"},{"item":"Grip Boots","isMandatory":true,"icon":"shoe.fill"}]}
        """
        guard let data = json.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(OfficialTrackPayload.self, from: data) else { return nil }
        return decoded
    }()

    var heroImageURL: URL? {
        switch trackId {
        case "yosemite-half-dome-cables":
            return URL(string: "https://images.unsplash.com/photo-1569969236549-b13c2d13796f?w=1200")
        default: return nil
        }
    }
}
