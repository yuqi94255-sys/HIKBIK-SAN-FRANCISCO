// MARK: - Macro Journey Builder — 範本即規格：Tags + 每日 images/text/airbnbLink 與地圖欄位並存
import Foundation
import CoreLocation

/// 單條推薦（如 Airbnb）。與 airbnbLink 並存，詳情頁優先 airbnbLink。
struct JourneyRecommendation: Codable {
    var title: String?
    var link: String?
}

/// 單日行程（範本對位）：地圖用 location + 展示用 images / text / airbnbLink。
struct JourneyDay: Identifiable, Codable {
    var id: UUID
    var dayNumber: Int
    var location: GeoLocation?
    var locationName: String?
    var dateString: String?
    var notes: String?
    var fromPlace: String?
    var toPlace: String?
    /// 規格欄位：當日照片牆（URL 或本地路徑），與 dayPhotos 同步寫入 JSON。
    var images: [String]?
    /// 規格欄位：當日介紹正文，與 description / notes 同步。
    var text: String?
    /// 規格欄位：Airbnb 等住宿連結，單一主連結。
    var airbnbLink: String?
    /// 舊鍵兼容：等同 images。
    var dayPhotos: [String]?
    var description: String?
    var recommendations: [JourneyRecommendation]?
    var recommendedStay: String?

    enum CodingKeys: String, CodingKey {
        case id, dayNumber, location, locationName, dateString, notes, fromPlace, toPlace
        case images, text, airbnbLink
        case dayPhotos, description, recommendations, recommendedStay
    }

    init(
        id: UUID = UUID(),
        dayNumber: Int = 1,
        location: GeoLocation? = nil,
        locationName: String? = nil,
        dateString: String? = nil,
        notes: String? = nil,
        fromPlace: String? = nil,
        toPlace: String? = nil,
        images: [String]? = nil,
        text: String? = nil,
        airbnbLink: String? = nil,
        dayPhotos: [String]? = nil,
        description: String? = nil,
        recommendations: [JourneyRecommendation]? = nil,
        recommendedStay: String? = nil
    ) {
        self.id = id
        self.dayNumber = dayNumber
        self.location = location
        self.locationName = locationName
        self.dateString = dateString
        self.notes = notes
        self.fromPlace = fromPlace
        self.toPlace = toPlace
        let imgs = images ?? dayPhotos
        self.images = imgs
        self.text = text ?? description ?? notes
        self.airbnbLink = airbnbLink
        self.dayPhotos = imgs
        self.description = text ?? description ?? notes
        self.recommendations = recommendations
        self.recommendedStay = recommendedStay
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        dayNumber = try c.decode(Int.self, forKey: .dayNumber)
        location = try c.decodeIfPresent(GeoLocation.self, forKey: .location)
        locationName = try c.decodeIfPresent(String.self, forKey: .locationName)
        dateString = try c.decodeIfPresent(String.self, forKey: .dateString)
        notes = try c.decodeIfPresent(String.self, forKey: .notes)
        fromPlace = try c.decodeIfPresent(String.self, forKey: .fromPlace)
        toPlace = try c.decodeIfPresent(String.self, forKey: .toPlace)
        let decodedImages = try c.decodeIfPresent([String].self, forKey: .images)
        let decodedDayPhotos = try c.decodeIfPresent([String].self, forKey: .dayPhotos)
        images = decodedImages ?? decodedDayPhotos
        dayPhotos = images
        let decodedText = try c.decodeIfPresent(String.self, forKey: .text)
        let decodedDesc = try c.decodeIfPresent(String.self, forKey: .description)
        text = decodedText ?? decodedDesc ?? notes
        description = text
        airbnbLink = try c.decodeIfPresent(String.self, forKey: .airbnbLink)
        recommendations = try c.decodeIfPresent([JourneyRecommendation].self, forKey: .recommendations)
        if airbnbLink == nil, let first = recommendations?.first?.link, !(first.isEmpty) { airbnbLink = first }
        recommendedStay = try c.decodeIfPresent(String.self, forKey: .recommendedStay)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(dayNumber, forKey: .dayNumber)
        try c.encodeIfPresent(location, forKey: .location)
        try c.encodeIfPresent(locationName, forKey: .locationName)
        try c.encodeIfPresent(dateString, forKey: .dateString)
        try c.encodeIfPresent(notes, forKey: .notes)
        try c.encodeIfPresent(fromPlace, forKey: .fromPlace)
        try c.encodeIfPresent(toPlace, forKey: .toPlace)
        let imgs = images ?? dayPhotos
        try c.encodeIfPresent(imgs, forKey: .images)
        try c.encodeIfPresent(imgs, forKey: .dayPhotos)
        let body = text ?? description ?? notes
        try c.encodeIfPresent(body, forKey: .text)
        try c.encodeIfPresent(body, forKey: .description)
        try c.encodeIfPresent(airbnbLink, forKey: .airbnbLink)
        try c.encodeIfPresent(recommendations, forKey: .recommendations)
        try c.encodeIfPresent(recommendedStay, forKey: .recommendedStay)
    }

    var hasMainLocation: Bool {
        location != nil && location?.latitude != nil && location?.longitude != nil
    }
}

struct GeoLocation: Codable {
    var latitude: Double
    var longitude: Double
}

/// 完整宏觀帖子：頂部標籤組 + 每日 images/text/airbnbLink（範本規格）。
struct MacroJourneyPost: Codable {
    var journeyName: String
    var days: [JourneyDay]
    var selectedStates: [String]
    var duration: String?
    var vehicle: String?
    var pace: String?
    /// 難度/節奏標籤（與 pace 可同義，單獨列出供範本「難度」膠囊）。
    var difficulty: String?
    /// 範本頂部與 Tag Cloud 唯一真相源：城市/天數/載具/難度等；發布時由 Builder 填滿。
    var tags: [String]?
    /// 州選擇器硬規格：與 UI 首位標籤 1:1（多州時為 "Utah · California"）。
    var state: String
    /// 全線概覽簡介（與單日筆記分離；詳情頁頂部展示，不寫入 Day 1 正文字段）。
    var overallDescription: String?

    init(
        journeyName: String = "",
        days: [JourneyDay] = [],
        selectedStates: [String] = [],
        duration: String? = nil,
        vehicle: String? = nil,
        pace: String? = nil,
        difficulty: String? = nil,
        tags: [String]? = nil,
        state: String = "",
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
        self.overallDescription = overallDescription
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        journeyName = try c.decode(String.self, forKey: .journeyName)
        days = try c.decode([JourneyDay].self, forKey: .days)
        selectedStates = (try? c.decode([String].self, forKey: .selectedStates)) ?? []
        duration = try c.decodeIfPresent(String.self, forKey: .duration)
        vehicle = try c.decodeIfPresent(String.self, forKey: .vehicle)
        pace = try c.decodeIfPresent(String.self, forKey: .pace)
        difficulty = try c.decodeIfPresent(String.self, forKey: .difficulty)
        tags = try c.decodeIfPresent([String].self, forKey: .tags)
        state = (try? c.decode(String.self, forKey: .state)) ?? ""
        if state.isEmpty, let first = selectedStates.sorted().first { state = first }
        overallDescription = try c.decodeIfPresent(String.self, forKey: .overallDescription)
    }

    enum CodingKeys: String, CodingKey {
        case journeyName, days, selectedStates, duration, vehicle, pace, difficulty, tags, state
        case overallDescription
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(journeyName, forKey: .journeyName)
        try c.encode(days, forKey: .days)
        try c.encode(selectedStates, forKey: .selectedStates)
        try c.encodeIfPresent(duration, forKey: .duration)
        try c.encodeIfPresent(vehicle, forKey: .vehicle)
        try c.encodeIfPresent(pace, forKey: .pace)
        try c.encodeIfPresent(difficulty, forKey: .difficulty)
        try c.encodeIfPresent(tags, forKey: .tags)
        try c.encode(state, forKey: .state)
        try c.encodeIfPresent(overallDescription, forKey: .overallDescription)
    }

    var isReadyToPublish: Bool {
        guard !journeyName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !days.isEmpty else { return false }
        return days.allSatisfy(\.hasMainLocation)
    }
}
