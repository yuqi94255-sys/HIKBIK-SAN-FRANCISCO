// MARK: - 官方宏觀導航：路徑與里程碑模型
import Foundation
import CoreLocation
import MapKit

// MARK: - JSON 行程（days[].pathCoordinates = 官方路徑，禁止直線連接）
/// 單日 JSON：pathCoordinates 為該日官方路徑點陣，地圖用 MapPolyline 繪製
struct JourneyDayJSON: Codable {
    let day: Int
    let from: String
    let to: String
    let duration: String
    let distance: String
    /// 該日官方路徑座標 [[lat, lng], ...]，地圖必須用此渲染，禁止兩點直線
    let pathCoordinates: [[Double]]
    /// 景點/亮點標籤（時間軸列表用）
    let highlights: [String]?
    /// 當日摘要（時間軸列表用）
    let summary: String?
    /// 沿路海拔採樣（米），用於繪製海拔曲線裝飾
    let elevation: [Double]?
}

struct MacroJourneyJSON: Codable {
    let id: String
    let name: String
    let days: [JourneyDayJSON]
}

extension MacroJourneyJSON {
    /// Mock 推薦位：按天輪換類型，標題與風景佔位圖，保證 Sheet 視覺飽滿
    static func mockPromoSlotForDay(day: Int, from: String, to: String) -> PromotionSlot {
        let types: [SuggestionType] = [.hotel, .campsite, .ad]
        let type = types[day % types.count]
        let title: String
        let priceRange: String?
        let rating: Double?
        let perks: [String]
        switch type {
        case .hotel:
            title = "Stay near \(from)"
            priceRange = "$120–220"
            rating = 4.5
            perks = ["Free breakfast", "Near scenic area", "Parking"]
        case .campsite:
            title = "Camp along the route"
            priceRange = "$35–80"
            rating = 4.8
            perks = ["Fire pit", "Restrooms", "Trail access"]
        case .ad:
            title = "Partner offer · Day \(day)"
            priceRange = "From $99"
            rating = 4.2
            perks = ["Exclusive rate", "Flexible cancel"]
        }
        let placeholderImages = [
            "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400",
            "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400",
            "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400",
        ]
        return PromotionSlot(
            suggestionType: type,
            title: title,
            link: nil,
            imageURL: placeholderImages[day % placeholderImages.count],
            priceRange: priceRange,
            rating: rating,
            perks: perks,
            promoCode: day % 2 == 0 ? "ROUTE\(day)10" : nil
        )
    }

    /// 從 Bundle 載入 JSON（檔名不含副檔名），失敗回傳 nil
    static func load(bundle: Bundle = .main, filename: String) -> MacroJourneyJSON? {
        guard let url = bundle.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(MacroJourneyJSON.self, from: data) else { return nil }
        return decoded
    }

    /// 轉為導航頁 Payload：分段路徑來自 JSON pathCoordinates；無 promo 時為每日注入 Mock 推薦位
    func toNavigationPayload() -> MacroJourneyNavigationPayload {
        let dayRoutes: [DayRoute] = days.enumerated().map { index, d in
            DayRoute(
                id: "d\(d.day)",
                day: d.day,
                from: d.from,
                to: d.to,
                duration: d.duration,
                distance: d.distance,
                highlights: d.highlights ?? [],
                summary: d.summary ?? "",
                elevationPoints: d.elevation,
                promoSlot: Self.mockPromoSlotForDay(day: index + 1, from: d.from, to: d.to)
            )
        }
        let daySegmentCoordinates: [[CLLocationCoordinate2D]] = days.map { day in
            day.pathCoordinates.compactMap { pair -> CLLocationCoordinate2D? in
                guard pair.count >= 2 else { return nil }
                return CLLocationCoordinate2D(latitude: pair[0], longitude: pair[1])
            }
        }
        var milestonesByDay: [[MacroStation]] = []
        for (i, day) in days.enumerated() {
            let coords = daySegmentCoordinates[i]
            guard !coords.isEmpty else { milestonesByDay.append([]); continue }
            let start = coords.first!
            let end = coords.last!
            let stations: [MacroStation] = [
                MacroStation(id: "day\(day.day)-from", title: day.from, coordinate: start, description: "Day \(day.day) start", distanceFromStart: 0),
                MacroStation(id: "day\(day.day)-to", title: day.to, coordinate: end, description: "Day \(day.day) end", distanceFromStart: 100)
            ]
            milestonesByDay.append(stations)
        }
        return MacroJourneyNavigationPayload(
            id: id,
            name: name,
            dayRoutes: dayRoutes,
            daySegmentCoordinates: daySegmentCoordinates,
            milestonesByDay: milestonesByDay
        )
    }
}

// MARK: - 商業化推薦位（酒店/營地/廣告，動態開關、類型驅動視覺）
enum SuggestionType: String, Codable, CaseIterable {
    case hotel
    case campsite
    case ad
}

/// 單日「推薦位」：類型、標題、連結預留；70% 展開時展示深度數據
struct PromotionSlot: Codable, Equatable {
    let suggestionType: SuggestionType
    let title: String
    let link: String?
    let imageURL: String?
    let priceRange: String?
    let rating: Double?
    let perks: [String]?
    let promoCode: String?

    init(suggestionType: SuggestionType, title: String, link: String? = nil, imageURL: String? = nil,
         priceRange: String? = nil, rating: Double? = nil, perks: [String]? = nil, promoCode: String? = nil) {
        self.suggestionType = suggestionType
        self.title = title
        self.link = link
        self.imageURL = imageURL
        self.priceRange = priceRange
        self.rating = rating
        self.perks = perks
        self.promoCode = promoCode
    }

    enum CodingKeys: String, CodingKey {
        case suggestionType, title, link, imageURL, priceRange, rating, perks, promoCode
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        suggestionType = try c.decode(SuggestionType.self, forKey: .suggestionType)
        title = try c.decode(String.self, forKey: .title)
        link = try c.decodeIfPresent(String.self, forKey: .link)
        imageURL = try c.decodeIfPresent(String.self, forKey: .imageURL)
        priceRange = try c.decodeIfPresent(String.self, forKey: .priceRange)
        rating = try c.decodeIfPresent(Double.self, forKey: .rating)
        perks = try c.decodeIfPresent([String].self, forKey: .perks)
        promoCode = try c.decodeIfPresent(String.self, forKey: .promoCode)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(suggestionType, forKey: .suggestionType)
        try c.encode(title, forKey: .title)
        try c.encodeIfPresent(link, forKey: .link)
        try c.encodeIfPresent(imageURL, forKey: .imageURL)
        try c.encodeIfPresent(priceRange, forKey: .priceRange)
        try c.encodeIfPresent(rating, forKey: .rating)
        try c.encodeIfPresent(perks, forKey: .perks)
        try c.encodeIfPresent(promoCode, forKey: .promoCode)
    }
}

// MARK: - 官方行程模板（JSON 驅動，多 Day 行程鏈）
/// 單日路段：供 MacroJourneyTemplate 解析 JSON，驅動 Day 列表渲染
struct DayRoute: Identifiable, Codable, Equatable {
    let id: String
    let day: Int
    let from: String
    let to: String
    let duration: String
    let distance: String
    /// 景點/亮點標籤（時間軸列表用）
    let highlights: [String]
    /// 當日摘要（時間軸列表用）
    let summary: String
    /// 沿路海拔採樣（米），用於繪製海拔曲線裝飾
    let elevationPoints: [Double]?
    /// 商業化推薦位（nil = 無合作，不顯示；有值則自動長出卡片）
    let promoSlot: PromotionSlot?

    enum CodingKeys: String, CodingKey {
        case id, day, from, to, duration, distance, highlights, summary, elevationPoints, promoSlot
    }

    init(id: String, day: Int, from: String, to: String, duration: String, distance: String,
         highlights: [String] = [], summary: String = "", elevationPoints: [Double]? = nil, promoSlot: PromotionSlot? = nil) {
        self.id = id
        self.day = day
        self.from = from
        self.to = to
        self.duration = duration
        self.distance = distance
        self.highlights = highlights
        self.summary = summary
        self.elevationPoints = elevationPoints
        self.promoSlot = promoSlot
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        day = try c.decode(Int.self, forKey: .day)
        from = try c.decode(String.self, forKey: .from)
        to = try c.decode(String.self, forKey: .to)
        duration = try c.decode(String.self, forKey: .duration)
        distance = try c.decode(String.self, forKey: .distance)
        highlights = try c.decodeIfPresent([String].self, forKey: .highlights) ?? []
        summary = try c.decodeIfPresent(String.self, forKey: .summary) ?? ""
        elevationPoints = try c.decodeIfPresent([Double].self, forKey: .elevationPoints)
        promoSlot = try c.decodeIfPresent(PromotionSlot.self, forKey: .promoSlot)
    }
}

/// 宏觀詳情頁模板：可解析含多個 DayRoute 的 JSON，用於靜態地圖 + Day 列表鏈
struct MacroJourneyTemplate: Identifiable {
    let id: String
    let name: String
    /// 全路徑座標（靜態頭圖地圖繪製用）
    let coordinates: [CLLocationCoordinate2D]
    /// 按日路段，ForEach 生成行程區塊
    let routes: [DayRoute]
}

/// 多天數導航頁專用：按 Day 分段路徑 + 按 Day 分組里程碑（頂部 HUD、地圖分段、底部卡片分組）
struct MacroJourneyNavigationPayload: Identifiable {
    let id: String
    let name: String
    let dayRoutes: [DayRoute]
    /// 每一天的路徑座標，用於地圖分段渲染（當天實線、其餘虛線）
    let daySegmentCoordinates: [[CLLocationCoordinate2D]]
    /// 按天分組的里程碑，底部卡片流「Day N Milestones」用
    let milestonesByDay: [[MacroStation]]
}

/// 官方定義的宏觀路線（全屏 2D 地圖導航用）
struct OfficialMacroRoute: Identifiable {
    let id: String
    let name: String
    /// 官方路徑座標（順序繪製紫色折線）
    let coordinates: [CLLocationCoordinate2D]
    /// 官方推薦站點（底部橫向卡片數據源）
    let milestones: [MacroStation]
}

/// 官方推薦站點：為什麼推薦、里程位置
struct MacroStation: Identifiable {
    let id: String
    let title: String
    let coordinate: CLLocationCoordinate2D
    let description: String
    /// 從起點算起的里程（mi）
    let distanceFromStart: Double
}

// MARK: - 示例數據（Yosemite Half Dome 區域，用於宏觀導航）
extension OfficialMacroRoute {
    /// 約 0.5 mi 的 Cables 段示意路徑（Sub Dome → Summit）
    static let yosemiteHalfDomeCables = OfficialMacroRoute(
        id: "yosemite-cables-macro",
        name: "Half Dome Cables Section",
        coordinates: [
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
        ],
        milestones: [
            MacroStation(
                id: "sub-dome",
                title: "Sub Dome",
                coordinate: CLLocationCoordinate2D(latitude: 37.732_00, longitude: -119.533_20),
                description: "Official start of the cables; secure footing before the climb.",
                distanceFromStart: 0.0
            ),
            MacroStation(
                id: "cables-mid",
                title: "Mid Cables",
                coordinate: CLLocationCoordinate2D(latitude: 37.732_95, longitude: -119.532_50),
                description: "Halfway point; recommended rest and checkpoint.",
                distanceFromStart: 0.25
            ),
            MacroStation(
                id: "summit",
                title: "Summit",
                coordinate: CLLocationCoordinate2D(latitude: 37.733_95, longitude: -119.531_75),
                description: "Summit of Half Dome; official end of cables section.",
                distanceFromStart: 0.5
            ),
        ]
    )

    /// Arizona Desert Explorer 宏觀路線（Sonoran Desert 多日環線：Apache Junction → Roosevelt → Saguaro → 回起點）
    static let arizonaDesertExplorer = OfficialMacroRoute(
        id: "arizona-desert-explorer",
        name: "Arizona Desert Explorer",
        coordinates: [
            CLLocationCoordinate2D(latitude: 33.415_20, longitude: -111.549_50),
            CLLocationCoordinate2D(latitude: 33.452_00, longitude: -111.480_00),
            CLLocationCoordinate2D(latitude: 33.512_00, longitude: -111.280_00),
            CLLocationCoordinate2D(latitude: 33.620_00, longitude: -111.100_00),
            CLLocationCoordinate2D(latitude: 32.950_00, longitude: -110.750_00),
            CLLocationCoordinate2D(latitude: 32.420_00, longitude: -110.720_00),
            CLLocationCoordinate2D(latitude: 33.350_00, longitude: -111.520_00),
            CLLocationCoordinate2D(latitude: 33.415_20, longitude: -111.549_50),
        ],
        milestones: [
            MacroStation(id: "start", title: "Apache Junction", coordinate: CLLocationCoordinate2D(latitude: 33.415_20, longitude: -111.549_50), description: "Trailhead; Lost Dutchman area.", distanceFromStart: 0),
            MacroStation(id: "roosevelt", title: "Roosevelt Lake", coordinate: CLLocationCoordinate2D(latitude: 33.512_00, longitude: -111.280_00), description: "Desert lake; recommended rest stop.", distanceFromStart: 42),
            MacroStation(id: "saguaro", title: "Saguaro East", coordinate: CLLocationCoordinate2D(latitude: 32.420_00, longitude: -110.720_00), description: "Cactus forest; scenic overlook.", distanceFromStart: 88),
            MacroStation(id: "end", title: "Return to Start", coordinate: CLLocationCoordinate2D(latitude: 33.415_20, longitude: -111.549_50), description: "End of official loop.", distanceFromStart: 118),
        ]
    )

    /// 亞利桑那行程路線（Trip Itinerary / JSON 對應）：Phoenix → Sedona → Grand Canyon South Rim → North Rim
    static let arizonaTripItinerary = OfficialMacroRoute(
        id: "arizona-trip-itinerary",
        name: "Trip Itinerary",
        coordinates: [
            CLLocationCoordinate2D(latitude: 33.4484, longitude: -112.0740),
            CLLocationCoordinate2D(latitude: 33.65, longitude: -111.95),
            CLLocationCoordinate2D(latitude: 34.00, longitude: -111.85),
            CLLocationCoordinate2D(latitude: 34.8697, longitude: -111.7610),
            CLLocationCoordinate2D(latitude: 35.20, longitude: -111.90),
            CLLocationCoordinate2D(latitude: 35.65, longitude: -112.00),
            CLLocationCoordinate2D(latitude: 36.0544, longitude: -112.1401),
            CLLocationCoordinate2D(latitude: 36.07, longitude: -112.14),
            CLLocationCoordinate2D(latitude: 36.21, longitude: -112.06),
            CLLocationCoordinate2D(latitude: 36.2133, longitude: -112.0604),
        ],
        milestones: [
            MacroStation(id: "phoenix", title: "Phoenix", coordinate: CLLocationCoordinate2D(latitude: 33.4484, longitude: -112.0740), description: "Start; Phoenix area.", distanceFromStart: 0),
            MacroStation(id: "sedona", title: "Sedona", coordinate: CLLocationCoordinate2D(latitude: 34.8697, longitude: -111.7610), description: "Red rocks, Oak Creek Canyon, Cathedral Rock.", distanceFromStart: 120),
            MacroStation(id: "south-rim", title: "Grand Canyon South Rim", coordinate: CLLocationCoordinate2D(latitude: 36.0544, longitude: -112.1401), description: "South Rim entrance, Desert View, Hermit Road, Hopi Point.", distanceFromStart: 230),
            MacroStation(id: "north-rim", title: "North Rim", coordinate: CLLocationCoordinate2D(latitude: 36.2133, longitude: -112.0604), description: "Jacob Lake, North Rim viewpoints.", distanceFromStart: 482),
        ]
    )
}

// MARK: - OfficialMacroRoute → MacroJourneyTemplate（供官方宏觀詳情頁模板使用）
extension OfficialMacroRoute {
    func toMacroJourneyTemplate() -> MacroJourneyTemplate {
        if id == "arizona-trip-itinerary" {
            return MacroJourneyTemplate(id: id, name: name, coordinates: coordinates, routes: Self.dayRoutesForArizonaTripItinerary())
        }
        if milestones.isEmpty {
            return MacroJourneyTemplate(id: id, name: name, coordinates: coordinates, routes: Self.defaultDayRoutesForArizona())
        }
        let dayRoutes: [DayRoute] = milestones.enumerated().map { index, m in
            let from = index == 0 ? "Start" : milestones[index - 1].title
            let distMi = index == 0 ? m.distanceFromStart : (m.distanceFromStart - milestones[index - 1].distanceFromStart)
            let dur = index == 0 ? "—" : "\(max(1, Int(distMi * 0.4)))h"
            return DayRoute(
                id: m.id,
                day: index + 1,
                from: from,
                to: m.title,
                duration: dur,
                distance: String(format: "%.0f mi", distMi)
            )
        }
        return MacroJourneyTemplate(id: id, name: name, coordinates: coordinates, routes: dayRoutes)
    }

    private static func dayRoutesForArizonaTripItinerary() -> [DayRoute] {
        [
            DayRoute(id: "d1", day: 1, from: "Phoenix", to: "Sedona", duration: "2h 30m", distance: "120 mi"),
            DayRoute(id: "d2", day: 2, from: "Sedona", to: "Grand Canyon South Rim", duration: "2h 45m", distance: "110 mi"),
            DayRoute(id: "d3", day: 3, from: "Grand Canyon South Rim", to: "Grand Canyon Exploration", duration: "1h", distance: "40 mi"),
            DayRoute(id: "d4", day: 4, from: "South Rim", to: "North Rim", duration: "4h 30m", distance: "212 mi"),
        ]
    }

    private static func defaultDayRoutesForArizona() -> [DayRoute] {
        [
            DayRoute(id: "d1", day: 1, from: "Apache Junction", to: "Roosevelt Lake", duration: "2h 11m", distance: "42 mi"),
            DayRoute(id: "d2", day: 2, from: "Roosevelt Lake", to: "Saguaro East", duration: "3h 05m", distance: "46 mi"),
            DayRoute(id: "d3", day: 3, from: "Saguaro East", to: "Return to Start", duration: "2h 30m", distance: "30 mi"),
        ]
    }

    /// 導航頁多天數用：分段路徑 + 按天分組里程碑
    func toNavigationPayload() -> MacroJourneyNavigationPayload {
        let template = toMacroJourneyTemplate()
        let dayCount = template.routes.count
        guard dayCount > 0, !coordinates.isEmpty else {
            return MacroJourneyNavigationPayload(
                id: id,
                name: name,
                dayRoutes: template.routes,
                daySegmentCoordinates: [coordinates],
                milestonesByDay: [milestones]
            )
        }
        var segmentIndices: [Int] = [0]
        for m in milestones {
            var best = 0
            var bestD = Double.greatestFiniteMagnitude
            let mloc = CLLocation(latitude: m.coordinate.latitude, longitude: m.coordinate.longitude)
            for (i, c) in coordinates.enumerated() {
                let d = mloc.distance(from: CLLocation(latitude: c.latitude, longitude: c.longitude))
                if d < bestD { bestD = d; best = i }
            }
            if best > segmentIndices.last! { segmentIndices.append(best) }
        }
        segmentIndices.append(coordinates.count)
        var segs: [[CLLocationCoordinate2D]] = []
        for i in 0..<(segmentIndices.count - 1) {
            let a = segmentIndices[i], b = segmentIndices[i + 1]
            segs.append(Array(coordinates[a...min(b, coordinates.count - 1)]))
        }
        while segs.count < dayCount, !coordinates.isEmpty {
            segs.append(coordinates)
        }
        segs = Array(segs.prefix(dayCount))
        let byDay: [[MacroStation]]
        if milestones.isEmpty {
            byDay = (0..<dayCount).map { _ in [] }
        } else {
            let perDay = max(1, milestones.count / dayCount)
            var idx = 0
            byDay = (0..<dayCount).map { d in
                let end = d == dayCount - 1 ? milestones.count : min(idx + perDay, milestones.count)
                let slice = Array(milestones[idx..<end])
                idx = end
                return slice
            }
        }
        return MacroJourneyNavigationPayload(
            id: id,
            name: name,
            dayRoutes: template.routes,
            daySegmentCoordinates: segs.isEmpty ? [coordinates] : segs,
            milestonesByDay: byDay.isEmpty ? [milestones] : byDay
        )
    }
}
