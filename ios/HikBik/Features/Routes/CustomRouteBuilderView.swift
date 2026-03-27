// Custom Route Builder – Multi-step form, Dark Forest Green theme, Orange active states
import SwiftUI
import PhotosUI
import MapKit
import CoreLocation
import ImageIO
import UIKit

// MARK: - Live Track Draft (from Record Live Track → Save as Draft)
struct LiveTrackDraft {
    var waypoints: [(latitude: Double, longitude: Double, elevation: Double, timestamp: Date)]

    private static let savedDraftKey = "LiveTrackLastSavedDraft"

    func saveToUserDefaults() {
        let arr = waypoints.map { ["lat": $0.latitude, "lon": $0.longitude, "elevation": $0.elevation, "timestamp": $0.timestamp.timeIntervalSince1970] }
        UserDefaults.standard.set(arr, forKey: Self.savedDraftKey)
    }

    static func loadFromUserDefaults() -> LiveTrackDraft? {
        guard let arr = UserDefaults.standard.array(forKey: savedDraftKey) as? [[String: Any]] else { return nil }
        let waypoints: [(Double, Double, Double, Date)] = arr.compactMap { w in
            guard let lat = w["lat"] as? Double, let lon = w["lon"] as? Double,
                  let elev = w["elevation"] as? Double, let ts = w["timestamp"] as? Double else { return nil }
            return (lat, lon, elev, Date(timeIntervalSince1970: ts))
        }
        guard !waypoints.isEmpty else { return nil }
        return LiveTrackDraft(waypoints: waypoints)
    }

    static func from(draftItem: DraftItem) -> LiveTrackDraft {
        let waypoints = draftItem.waypoints.map { ($0.latitude, $0.longitude, $0.elevation, $0.timestamp) }
        return LiveTrackDraft(waypoints: waypoints)
    }
}

// MARK: - Theme (Dark Forest Green #0B121F, Active Orange #FF8C42)
private enum CRBColors {
    static let background = Color(hex: "0B121F")
    static let cardBg = Color(hex: "2A3540")
    static let cardNested = Color(hex: "1A2332")
    static let searchBg = Color(hex: "1A2332")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "9CA3AF")
    static let activeOrange = Color(hex: "FF8C42")
    static let inactivePill = Color(hex: "2A3540")
    static let borderMuted = Color(hex: "374151")
    static let dropdownBorder = Color(hex: "3A4D39")
    static let dropdownSolidBg = Color(hex: "1A2419")
    static let infoBorder = Color(hex: "FF8C42").opacity(0.6)
    static let infoBg = Color(hex: "FF8C42").opacity(0.12)
    /// Slightly darker than cardNested so Micro Track block is distinct inside Day Card
    static let microTrackNested = Color(hex: "151C28")
    /// Signal selector: 1–2 bars = poor (orange), 3–4 = good (yellow-green), 5 = excellent (bright green). Solid fill only.
    static let signalPoor = Color(hex: "FF8C42")
    static let signalGood = Color(hex: "A3E635")
    static let signalExcellent = Color(hex: "4ADE80")
}

// MARK: - Planning Style
private enum PlanningStyle: String, CaseIterable {
    case macroJourney = "Macro Journey"
    case microTrack = "Micro Track"
    var subtitle: String {
        switch self {
        case .macroJourney: return "Perfect for multi-day road trips"
        case .microTrack: return "Professional-grade trail/hiking guide"
        }
    }
}

// MARK: - Preferences
private enum DurationOption: String, CaseIterable {
    case oneDay = "1 Day"
    case twoThree = "2-3 Days"
    case fourFive = "4-5 Days"
    case sixSeven = "6-7 Days"
    case weekPlus = "Week+"
}

private enum VehicleOption: String, CaseIterable {
    case suv = "SUV"
    case fourByFour = "4x4"
    case rv = "RV"
    case van = "Van"
    case motorcycle = "Motorcycle"
}

private enum PaceOption: String, CaseIterable {
    case chill = "Chill"
    case moderate = "Moderate"
    case hardcore = "Hardcore"
}

// MARK: - US States (name + abbreviation for Macro Journey State Selector)
private let usStatesWithAbbr: [(name: String, abbr: String)] = [
    ("Alabama", "AL"), ("Alaska", "AK"), ("Arizona", "AZ"), ("Arkansas", "AR"), ("California", "CA"),
    ("Colorado", "CO"), ("Connecticut", "CT"), ("Delaware", "DE"), ("Florida", "FL"), ("Georgia", "GA"),
    ("Hawaii", "HI"), ("Idaho", "ID"), ("Illinois", "IL"), ("Indiana", "IN"), ("Iowa", "IA"),
    ("Kansas", "KS"), ("Kentucky", "KY"), ("Louisiana", "LA"), ("Maine", "ME"), ("Maryland", "MD"),
    ("Massachusetts", "MA"), ("Michigan", "MI"), ("Minnesota", "MN"), ("Mississippi", "MS"), ("Missouri", "MO"),
    ("Montana", "MT"), ("Nebraska", "NE"), ("Nevada", "NV"), ("New Hampshire", "NH"), ("New Jersey", "NJ"),
    ("New Mexico", "NM"), ("New York", "NY"), ("North Carolina", "NC"), ("North Dakota", "ND"), ("Ohio", "OH"),
    ("Oklahoma", "OK"), ("Oregon", "OR"), ("Pennsylvania", "PA"), ("Rhode Island", "RI"), ("South Carolina", "SC"),
    ("South Dakota", "SD"), ("Tennessee", "TN"), ("Texas", "TX"), ("Utah", "UT"), ("Vermont", "VT"),
    ("Virginia", "VA"), ("Washington", "WA"), ("West Virginia", "WV"), ("Wisconsin", "WI"), ("Wyoming", "WY")
]
private func stateAbbr(for name: String) -> String {
    usStatesWithAbbr.first { $0.name == name }?.abbr ?? name
}

// MARK: - Land Management Category (Location Selector)
private enum LandManagementCategory: String, CaseIterable, Hashable {
    case nationalPark = "National Park"
    case nationalForest = "National Forest"
    case statePark = "State Park"
    case stateForest = "State Forest"
    case nationalGrassland = "National Grassland"
    case nra = "NRA"
}

// MARK: - Activity Type (Micro Track)
private enum MicroActivityType: String, CaseIterable {
    case hiking = "Hiking"
    case mtb = "MTB"
    case overlanding = "Overlanding"
    case backcountry = "Backcountry"
    var icon: String {
        switch self {
        case .hiking: return "figure.walk"
        case .mtb: return "bicycle"
        case .overlanding: return "car"
        case .backcountry: return "location.north"
        }
    }
}

// MARK: - Waypoint (Micro Track: single track = list of waypoints, no days)
private struct Waypoint: Identifiable {
    let id = UUID()
    var name: String
    var activityType: MicroActivityType
    var briefNote: String
    var photo: UIImage?
    var latitude: String
    var longitude: String
    var arrivalTime: String
    var elevation: String
    var hasWater: Bool
    var hasFuel: Bool
    /// Cellular signal strength selector: 0 = none, 1...5 = selected level (bars 1..=N light up)
    var signalStrength: Int
    /// Filled after Drop Pin when not the first point (from MKDirections or API)
    var distanceFromPrevious: String
    var durationFromPrevious: String
    /// Curved path from previous waypoint to this one (route.polyline from MKDirections)
    var routePolylineFromPrevious: [CLLocationCoordinate2D]
    /// true when lat/lon were set from photo EXIF (show "來自照片數據")
    var coordinatesFromPhoto: Bool
    var recommendedStay: String
    init(name: String = "", activityType: MicroActivityType = .hiking, briefNote: String = "", photo: UIImage? = nil, latitude: String = "", longitude: String = "", arrivalTime: String = "", elevation: String = "", hasWater: Bool = false, hasFuel: Bool = false, signalStrength: Int = 0, distanceFromPrevious: String = "", durationFromPrevious: String = "", routePolylineFromPrevious: [CLLocationCoordinate2D] = [], coordinatesFromPhoto: Bool = false, recommendedStay: String = "") {
        self.name = name
        self.activityType = activityType
        self.briefNote = briefNote
        self.photo = photo
        self.latitude = latitude
        self.longitude = longitude
        self.arrivalTime = arrivalTime
        self.elevation = elevation
        self.hasWater = hasWater
        self.hasFuel = hasFuel
        self.signalStrength = min(5, max(0, signalStrength))
        self.distanceFromPrevious = distanceFromPrevious
        self.durationFromPrevious = durationFromPrevious
        self.routePolylineFromPrevious = routePolylineFromPrevious
        self.coordinatesFromPhoto = coordinatesFromPhoto
        self.recommendedStay = recommendedStay
    }
}

// MARK: - Route Location (name + coordinates for Day location picker)
struct RouteLocation: Equatable {
    var name: String
    var latitude: Double
    var longitude: Double
}

// MARK: - Journey Stop Model (Day); Micro Track: each stop has nested microTracks。photos 支持多圖輪播，photo 兼容單圖。
private struct JourneyStop: Identifiable {
    let id = UUID()
    var cityOrPark: String
    var date: Date
    var dateWasPicked: Bool
    var vehicleType: String
    var briefNote: String
    var recommendedStay: String
    var photo: UIImage?
    /// 當日多張照片（輪播）；為空時使用 photo 單圖
    var photos: [UIImage] = []
    var microTracks: [Waypoint]
    var selectedLocation: RouteLocation?
    /// 推薦標題（如 "Book on Airbnb"），與 recommendationLink 一併寫入 JSON。
    var recommendationTitle: String
    /// 推薦連結（如 Airbnb URL），詳情頁渲染為可點擊卡片。
    var recommendationLink: String
    init(cityOrPark: String = "", date: Date = Date(), dateWasPicked: Bool = false, vehicleType: String = "SUV", briefNote: String = "", recommendedStay: String = "", photo: UIImage? = nil, photos: [UIImage] = [], microTracks: [Waypoint] = [Waypoint()], selectedLocation: RouteLocation? = nil, recommendationTitle: String = "", recommendationLink: String = "") {
        self.cityOrPark = cityOrPark
        self.date = date
        self.dateWasPicked = dateWasPicked
        self.vehicleType = vehicleType
        self.briefNote = briefNote
        self.recommendedStay = recommendedStay
        self.photo = photo
        self.photos = photos.isEmpty && photo != nil ? [photo!] : photos
        self.microTracks = microTracks
        self.selectedLocation = selectedLocation
        self.recommendationTitle = recommendationTitle
        self.recommendationLink = recommendationLink
    }
}

// MARK: - EXIF from photo (GPS, DateTimeOriginal, Altitude) for waypoint sync
private struct EXIFWaypointData {
    var latitude: Double?
    var longitude: Double?
    var altitude: Double?
    var dateTimeOriginal: Date?
    static func extract(from imageData: Data) -> EXIFWaypointData? {
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil),
              let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else { return nil }
        var result = EXIFWaypointData()
        if let gps = props[kCGImagePropertyGPSDictionary as String] as? [String: Any] {
            result.latitude = Self.parseGPSRational(gps[kCGImagePropertyGPSLatitude as String], ref: gps[kCGImagePropertyGPSLatitudeRef as String] as? String)
            result.longitude = Self.parseGPSRational(gps[kCGImagePropertyGPSLongitude as String], ref: gps[kCGImagePropertyGPSLongitudeRef as String] as? String)
            if let alt = gps[kCGImagePropertyGPSAltitude as String] as? Double { result.altitude = alt }
            else if let altNum = gps[kCGImagePropertyGPSAltitude as String] as? Int { result.altitude = Double(altNum) }
        }
        if let exif = props[kCGImagePropertyExifDictionary as String] as? [String: Any],
           let dt = exif[kCGImagePropertyExifDateTimeOriginal as String] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            result.dateTimeOriginal = formatter.date(from: dt)
        }
        return result
    }
    private static func parseGPSRational(_ value: Any?, ref: String?) -> Double? {
        guard let v = value else { return nil }
        var deg: Double = 0
        if let arr = v as? [Any], arr.count >= 3 {
            let d = (arr[0] as? Double) ?? Double(arr[0] as? Int ?? 0)
            let m = (arr[1] as? Double) ?? Double(arr[1] as? Int ?? 0)
            let s = (arr[2] as? Double) ?? Double(arr[2] as? Int ?? 0)
            deg = d + m / 60 + s / 3600
        } else if let n = v as? Double { deg = n }
        else if let n = v as? Int { deg = Double(n) }
        else { return nil }
        if ref == "S" || ref == "W" { deg = -deg }
        return deg
    }
}


// MARK: - Pending route update (distance, duration, curved polyline from MKDirections)
private struct PendingRouteUpdate {
    let dayIndex: Int
    let waypointIndex: Int
    let distance: String
    let duration: String
    let polyline: [CLLocationCoordinate2D]
}

// MARK: - Custom Route Builder View
struct CustomRouteBuilderView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var pendingLiveTrackDraft: LiveTrackDraft?
    @State private var planningStyle: PlanningStyle = .microTrack
    @State private var journeyName: String = ""
    /// 宏觀：全線概覽簡介（寫入 `MacroJourneyPost.overallDescription`，與單日 briefNote 分離）。
    @State private var macroOverallDescription: String = ""
    @State private var duration: DurationOption = .twoThree
    @State private var vehicle: VehicleOption = .suv
    @State private var pace: PaceOption = .moderate
    @State private var stops: [JourneyStop] = [JourneyStop()]
    @State private var selectedLandCategory: LandManagementCategory?
    @State private var showPlanningInfo = true
    @State private var coverImage: UIImage?
    @State private var coverImages: [UIImage] = []
    @State private var datePickerStopIndex: Int?
    @State private var coverPhotoItem: PhotosPickerItem?
    @State private var coverPhotoItems: [PhotosPickerItem] = []
    @State private var stopPhotoPickerItems: [PhotosPickerItem?] = [nil]
    /// 每日多圖選擇，載入到 stop.photos
    @State private var stopPhotoPickerArrays: [[PhotosPickerItem]] = [[]]
    @State private var deleteConfirmDayIndex: Int?
    @State private var openVehicleDropdownForStopIndex: Int?
    @State private var dropPinContext: (dayIndex: Int, waypointIndex: Int)?
    @State private var loadingRouteInfoFor: (dayIndex: Int, waypointIndex: Int)?
    @State private var pendingRouteUpdate: PendingRouteUpdate?
    @State private var routeUpdateApplyTrigger = 0
    @State private var pendingReverseGeocodeName: (dayIndex: Int, waypointIndex: Int, name: String)?
    @State private var reverseGeocodeApplyTrigger = 0
    @State private var waypointPhotoPickerItems: [String: PhotosPickerItem?] = [:]
    @State private var loadingEXIFForWaypoint: (dayIndex: Int, waypointIndex: Int)?
    @State private var locationPickerDayIndex: Int?
    // Detailed Track Builder: single source of truth (physical isolation from Macro)
    @State private var detailedTrack: DetailedTrackPost = DetailedTrackPost(
        routeName: "",
        totalDurationMinutes: 30,
        viewPointNodes: [ViewPointNode(), ViewPointNode()]
    )
    @State private var viewPointPhotos: [UUID: [UIImage]] = [:]
    @State private var mapSelectionViewPointIndex: Int?
    @State private var viewPointPhotoPickerItems: [Int: PhotosPickerItem?] = [:]
    @State private var hasPrintedDetailedTrackSample = false
    /// Macro Journey only: selected state names (multi-select). Synced to MacroJourneyPost.selectedStates when saving.
    @State private var selectedMacroStates: Set<String> = []
    /// 範本 Tag 規格：逗號分隔自訂標籤（城市/主題等），寫入 macro JSON.tags
    @State private var macroTripTags: String = ""
    /// 發布成功後顯示 overlay；2 秒後自動 dismiss。
    @State private var showingSuccessOverlay = false
    /// 點擊 Publish 後顯示旋轉圖標；實際直到 Render API 成功才寫入本地。
    @State private var isPublishing = false
    /// 雲端發布失敗（未寫入發布箱）
    @State private var publishError: String?
    /// 成功 overlay 綠勾動畫：從 0.5 放大到 1。
    @State private var successCheckmarkScale: CGFloat = 0.5
    /// Cancel 時若有路徑數據則彈確認：保存草稿 / 放棄 / 繼續編輯
    @State private var showCancelConfirm = false
    @EnvironmentObject private var communityViewModel: CommunityViewModel
    /// 微觀路線：點擊「當前位置」時記錄要填入的 waypoint，收到 GPS 後寫入並清空
    @State private var currentLocationTarget: (dayIndex: Int, waypointIndex: Int)?
    @StateObject private var waypointCurrentLocationManager = DropPinLocationManager()

    /// 當前是否已有繪製點或路徑數據（用於 Cancel 攔截）
    private var hasPathData: Bool {
        if planningStyle == .macroJourney {
            return stops.count > 1
                || stops.contains { $0.selectedLocation != nil }
                || !journeyName.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return detailedTrack.viewPointNodes.count > 2
            || detailedTrack.viewPointNodes.contains { ($0.latitude ?? 0) != 0 || ($0.longitude ?? 0) != 0 }
    }

    init(liveTrackDraft: LiveTrackDraft? = nil) {
        _pendingLiveTrackDraft = State(initialValue: liveTrackDraft)
    }

    private var summaryText: String {
        if planningStyle == .macroJourney {
            let total = stops.reduce(0) { $0 + $1.microTracks.count }
            return "\(stops.count) days • \(total) waypoints • Macro Journey"
        }
        let count = detailedTrack.viewPointNodes.count
        let activityStr = detailedTrack.viewPointNodes.first?.activityType.rawValue ?? "Hiking"
        let milesStr = microTrackEstimatedMilesString
        return "\(count) View Points · \(activityStr) · \(milesStr)"
    }

    /// Micro Track 底部摘要：依 viewPointNodes 座標估算總里程（英里）
    private var microTrackEstimatedMilesString: String {
        let nodes = detailedTrack.viewPointNodes
        guard nodes.count >= 2 else { return "— mi" }
        let coords = nodes.compactMap { n -> CLLocationCoordinate2D? in
            guard let lat = n.latitude, let lon = n.longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        guard coords.count >= 2 else { return "— mi" }
        var meters: Double = 0
        for i in 0..<(coords.count - 1) {
            let a = coords[i], b = coords[i + 1]
            let locA = CLLocation(latitude: a.latitude, longitude: a.longitude)
            let locB = CLLocation(latitude: b.latitude, longitude: b.longitude)
            meters += locA.distance(from: locB)
        }
        let miles = meters / 1609.34
        if miles < 0.1 { return "< 0.1 mi" }
        if miles < 1 { return String(format: "%.1f mi", miles) }
        return String(format: "%.0f mi", miles)
    }

    private var canPublish: Bool {
        if planningStyle == .macroJourney {
            return macroJourneyIsReadyToPublish
        }
        return detailedTrack.isReadyToPublish
    }

    /// Macro: days.count >= 1, journeyName non-empty, every day has mainLocation (selectedLocation).
    private var macroJourneyIsReadyToPublish: Bool {
        guard !journeyName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !stops.isEmpty else { return false }
        return stops.allSatisfy { $0.selectedLocation != nil }
    }

    /// Call when Publish is disabled: prints which fields are missing so you can fix (e.g. Acadia trip).
    private func printMacroPublishValidation() {
        print("========== Macro Publish Validation ==========")
        let nameOk = !journeyName.trimmingCharacters(in: .whitespaces).isEmpty
        print("journeyName: \(nameOk ? "✓" : "✗ MISSING (fill Journey Name)")")
        print("stops.count: \(stops.count) \(stops.isEmpty ? "✗ need at least 1 day" : "✓")")
        for (index, stop) in stops.enumerated() {
            let locOk = stop.selectedLocation != nil
            let locStr = locOk ? "✓ \(stop.selectedLocation!.name)" : "✗ MISSING (tap Add Location for Day \(index + 1))"
            print("  Day \(index + 1) selectedLocation: \(locStr)")
        }
        print("canPublish: \(macroJourneyIsReadyToPublish ? "YES" : "NO")")
        print("===============================================")
    }

    /// Cancel 攔截：保存草稿並退出。依規劃模式存為宏觀(.imported)或微觀(.manualPlan)，草稿箱打開時會先進 PostEditorView。無路徑數據時僅關閉頁面。
    private func saveDraftAndExit() {
        if let item = buildDraftItemFromCurrentState() {
            UnifiedDraftStore.append(item)
        }
        showCancelConfirm = false
        dismiss()
    }

    /// 從當前路徑數據組裝 DraftItem：宏微均為 .manualBuilder，含 polylineCoordinates（macro）+ waypoints（micro），供發布與草稿箱。
    private func buildDraftItemFromCurrentState() -> DraftItem? {
        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateStyle = .medium
            return f
        }()
        if planningStyle == .macroJourney {
            var waypoints: [DraftItem.DraftWaypoint] = stops.compactMap { stop in
                guard let loc = stop.selectedLocation else { return nil }
                return DraftItem.DraftWaypoint(latitude: loc.latitude, longitude: loc.longitude, elevation: 0, timestamp: Date())
            }
            if waypoints.isEmpty {
                waypoints = [DraftItem.DraftWaypoint(latitude: 0, longitude: 0, elevation: 0, timestamp: Date())]
            }
            let coords = waypoints.map { DraftItem.DraftCoordinate(latitude: $0.latitude, longitude: $0.longitude) }
            let title = journeyName.trimmingCharacters(in: .whitespaces).isEmpty
                ? "Macro \(dateFormatter.string(from: Date()))"
                : journeyName
            let macroJSON: String? = {
                guard macroJourneyIsReadyToPublish, let post = buildMacroJourneyPost(),
                      let data = try? JSONEncoder().encode(post) else { return nil }
                return String(data: data, encoding: .utf8)
            }()
            return DraftItem(
                id: UUID(),
                source: .manualBuilder,
                title: title,
                createdAt: Date(),
                waypoints: waypoints,
                polylineCoordinates: coords,
                durationSeconds: nil,
                coverImageData: coverImage?.jpegData(compressionQuality: 0.85),
                macroJourneyJSON: macroJSON
            )
        }
        let nodes = detailedTrack.viewPointNodes
        let waypoints: [DraftItem.DraftWaypoint] = nodes.compactMap { node in
            guard let lat = node.latitude, let lon = node.longitude else { return nil }
            let elev = Double(node.elevation ?? "0") ?? 0
            return DraftItem.DraftWaypoint(latitude: lat, longitude: lon, elevation: elev, timestamp: Date())
        }
        guard waypoints.count >= 2 else { return nil }
        let coords = waypoints.map { DraftItem.DraftCoordinate(latitude: $0.latitude, longitude: $0.longitude) }
        let title = detailedTrack.routeName.trimmingCharacters(in: .whitespaces).isEmpty
            ? "Micro Track \(dateFormatter.string(from: Date()))"
            : detailedTrack.routeName
        let detailedJSON = exportDetailedTrackToJSON()
        return DraftItem(
            id: UUID(),
            source: .manualBuilder,
            title: title,
            createdAt: Date(),
            waypoints: waypoints,
            polylineCoordinates: coords,
            durationSeconds: nil,
            coverImageData: coverImage?.jpegData(compressionQuality: 0.85),
            detailedTrackJSON: detailedJSON
        )
    }

    /// 從當前 UI 狀態建構 MacroJourneyPost（確保 latitude/longitude、dayPhotos、description、recommendations 正確）。僅在 macroJourneyIsReadyToPublish 時有效。
    private func buildMacroJourneyPost() -> MacroJourneyPost? {
        guard macroJourneyIsReadyToPublish else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let days: [JourneyDay] = stops.enumerated().map { index, stop in
            let loc = stop.selectedLocation.map { GeoLocation(latitude: $0.latitude, longitude: $0.longitude) }
            let dateStr = stop.dateWasPicked ? formatter.string(from: stop.date) : nil
            let dayImages = stop.photos.isEmpty ? [stop.photo].compactMap { $0 } : stop.photos
            let photoURLs = dayImages.compactMap { Self.saveDayPhotoToTempURL($0) }
            let imagesArr: [String]? = photoURLs.isEmpty ? nil : photoURLs
            let descriptionText = stop.briefNote.trimmingCharacters(in: .whitespaces).isEmpty ? nil : stop.briefNote
            let recTitle = stop.recommendationTitle.trimmingCharacters(in: .whitespaces)
            let recLink = stop.recommendationLink.trimmingCharacters(in: .whitespaces)
            let airbnb = recLink.isEmpty ? nil : recLink
            let recommendations: [JourneyRecommendation]? = (recTitle.isEmpty && recLink.isEmpty) ? nil : [JourneyRecommendation(title: recTitle.isEmpty ? nil : recTitle, link: recLink.isEmpty ? nil : recLink)]
            return JourneyDay(
                id: stop.id,
                dayNumber: index + 1,
                location: loc,
                locationName: stop.selectedLocation?.name ?? (stop.cityOrPark.isEmpty ? nil : stop.cityOrPark),
                dateString: dateStr,
                notes: descriptionText,
                images: imagesArr,
                text: descriptionText,
                airbnbLink: airbnb,
                dayPhotos: imagesArr,
                description: descriptionText,
                recommendations: recommendations,
                recommendedStay: stop.recommendedStay.trimmingCharacters(in: .whitespaces).isEmpty ? nil : stop.recommendedStay
            )
        }
        /// 州選擇器 → 模型 state（多州 "A · B"，單州即全名）
        let stateDisplay = selectedMacroStates.sorted().joined(separator: " · ")
        var tagList: [String] = []
        if !stateDisplay.isEmpty { tagList.append(stateDisplay) }
        tagList.append(duration.rawValue)
        tagList.append(vehicle.rawValue)
        tagList.append(pace.rawValue)
        tagList.append("Difficulty · \(pace.rawValue)")
        for part in macroTripTags.split(separator: ",") {
            let s = part.trimmingCharacters(in: .whitespaces)
            if !s.isEmpty, !tagList.contains(s) { tagList.append(s) }
        }
        let overviewTrimmed = macroOverallDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        return MacroJourneyPost(
            journeyName: journeyName,
            days: days,
            selectedStates: Array(selectedMacroStates),
            duration: duration.rawValue,
            vehicle: vehicle.rawValue,
            pace: pace.rawValue,
            difficulty: pace.rawValue,
            tags: tagList,
            state: stateDisplay,
            overallDescription: overviewTrimmed.isEmpty ? nil : overviewTrimmed
        )
    }

    /// 路線標題下方：全線概覽（選填），與標題區用邊框與高度區隔。
    private var macroOverallDescriptionEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            labelWithIcon("Trip overview (optional)", icon: "text.alignleft")
            ZStack(alignment: .topLeading) {
                if macroOverallDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Share an exciting overview of this trip... (optional)")
                        .font(.system(size: 15))
                        .foregroundStyle(CRBColors.textMuted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $macroOverallDescription)
                    .scrollContentBackground(.hidden)
                    .font(.system(size: 15))
                    .foregroundStyle(CRBColors.textPrimary)
                    .frame(minHeight: 108)
                    .padding(8)
            }
            .background(CRBColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
        }
    }

    /// 將單張當日照片寫入臨時檔並回傳 file URL 字串，供 JSON dayPhotos 使用。
    private static func saveDayPhotoToTempURL(_ image: UIImage) -> String? {
        let maxW: CGFloat = 1200
        let quality: CGFloat = 0.85
        guard let resized = image.resized(maxWidth: maxW),
              let data = resized.jpegData(compressionQuality: quality) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("day_photo_\(UUID().uuidString).jpg")
        try? data.write(to: url)
        return url.absoluteString
    }

    /// 將 MacroJourneyPost 轉成 JSON 並 print（確保 lat/lon 正確）。
    private func exportMacroJourneyToJSON() -> String? {
        guard let post = buildMacroJourneyPost() else { return nil }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(post) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// 模擬上傳 Macro Journey：收集封面+各日圖片 → 寫入 PostMediaStore → 加入 publishedTracks → 封裝 CommunityJourney(imageUrls) → prepend。接後端時替換為 API 調用。
    private func publishMacroJourney(json: String) {
        guard let post = buildMacroJourneyPost(), let draft = buildDraftItemFromCurrentState(), planningStyle == .macroJourney else { return }
        isPublishing = true
        print("[Publish] Macro Journey JSON（latitude/longitude 已包含）:")
        print(json)
        let author = CommunityAuthor(id: "guest_user_001", displayName: "Guest", avatarURL: nil)
        var allImageData: [Data] = []
        let coverSources = coverImages.isEmpty && coverImage != nil ? [coverImage!] : coverImages
        for img in coverSources {
            if let data = img.jpegData(compressionQuality: 0.85) { allImageData.append(data) }
        }
        for stop in stops {
            let imgs = stop.photos.isEmpty ? [stop.photo].compactMap { $0 } : stop.photos
            for img in imgs {
                if let data = img.jpegData(compressionQuality: 0.85) { allImageData.append(data) }
            }
        }
        let postId = "published_0"
        let savedUrls = allImageData.isEmpty ? [] : savePostMediaToDocuments(postId: postId, imageData: allImageData)
        if !savedUrls.isEmpty { PostMediaStore.shared.setImageUrls(id: postId, urls: savedUrls) }  // 與 addPublished 後列表 id published_0 一致
        TrackDataManager.shared.addPublished(draft)
        let coverURL: String? = coverImage.flatMap { Self.processCoverImageForGrandJourney(image: $0)?.absoluteString }
        let communityPost = CommunityJourney.from(post, author: author, likeCount: 0, commentCount: 0, coverImageURL: coverURL, imageUrls: savedUrls.isEmpty ? nil : savedUrls)
        communityViewModel.prepend(communityPost)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            isPublishing = false
            showingSuccessOverlay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { dismiss() }
        }
    }

    /// 封面預處理：16:10 裁剪、最大寬 1920、JPEG 85%，寫入臨時檔（與 ImageUploadService 邏輯一致，避免跨模組依賴）
    private static func processCoverImageForGrandJourney(image: UIImage) -> URL? {
        let ratio: CGFloat = 16.0 / 10.0
        let maxW: CGFloat = 1920
        let quality: CGFloat = 0.85
        guard let cropped = image.croppedToAspectRatio(ratio, smartCrop: true),
              let resized = cropped.resized(maxWidth: maxW),
              let data = resized.jpegData(compressionQuality: quality) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("grand_cover_\(UUID().uuidString).jpg")
        try? data.write(to: url)
        return url
    }

    /// 模擬上傳 Detailed Track：印出 JSON 後延遲觸發成功 overlay。
    private func publishDetailedTrack(json: String) {
        print("[Publish] Detailed Track JSON 將上傳（模擬）:")
        print(json)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showingSuccessOverlay = true
        }
    }

    // MARK: - Render API → 成功後才 publishDraft（與 PostEditorView 一致）

    private func collectMacroJPEGDataForCloudUpload() -> [Data] {
        var allImageData: [Data] = []
        let coverSources = coverImages.isEmpty && coverImage != nil ? [coverImage!] : coverImages
        for img in coverSources {
            if let data = img.jpegData(compressionQuality: 0.85) { allImageData.append(data) }
        }
        for stop in stops {
            let imgs = stop.photos.isEmpty ? [stop.photo].compactMap { $0 } : stop.photos
            for img in imgs {
                if let data = img.jpegData(compressionQuality: 0.85) { allImageData.append(data) }
            }
        }
        return allImageData
    }

    private func collectMicroJPEGDataAndCountsForUpload(draft: DraftItem, basePost: DetailedTrackPost) -> (data: [Data], nodeCounts: [Int], hasCover: Bool) {
        var data: [Data] = []
        var nodeCounts: [Int] = []
        var hasCover = false
        if let coverData = draft.coverImageData ?? coverImage?.jpegData(compressionQuality: 0.85), !coverData.isEmpty {
            data.append(coverData)
            hasCover = true
        }
        for node in basePost.viewPointNodes {
            let images = viewPointPhotos[node.id] ?? []
            let ds = images.compactMap { $0.jpegData(compressionQuality: 0.85) }
            nodeCounts.append(ds.count)
            data.append(contentsOf: ds)
        }
        return (data, nodeCounts, hasCover)
    }

    private func mergeMicroJourneyWithCloudURLs(base: DetailedTrackPost, cloudURLs: [String], nodeCounts: [Int], hasCover: Bool) -> DetailedTrackPost {
        var post = base
        guard !cloudURLs.isEmpty else { return post }
        var idx = 0
        if hasCover {
            post.heroImage = cloudURLs[idx]
            post.heroImages = [cloudURLs[idx]]
            idx += 1
        }
        var nodes = post.viewPointNodes
        for i in nodes.indices {
            let n = i < nodeCounts.count ? nodeCounts[i] : 0
            let end = min(idx + n, cloudURLs.count)
            guard idx < cloudURLs.count else { break }
            let slice = Array(cloudURLs[idx..<end])
            idx = end
            nodes[i].imageUrls = slice.isEmpty ? nil : slice
            nodes[i].photoCount = max(nodes[i].photoCount, slice.count)
        }
        post.viewPointNodes = nodes
        if post.heroImage == nil, let first = cloudURLs.first {
            post.heroImage = first
            post.heroImages = cloudURLs
        }
        return post
    }

    /// 僅在 `SocialPublishService.publish` 成功（HTTP 201）後呼叫。
    private func finishPublishDraftToLocal(draft: DraftItem, with journey: DetailedTrackPost, category: PostCategory, cloudURLs: [String], isMacro: Bool) {
        TrackDataManager.shared.publishDraft(draft, with: journey, category: category)
        if isMacro {
            if !cloudURLs.isEmpty {
                let postId = PostMediaStore.publishId(publishedIndex: 0, trackRouteID: nil)
                PostMediaStore.shared.setImageUrls(id: postId, urls: cloudURLs)
            }
        } else {
            let mainId = "track_\(draft.routeID)"
            if let hero = journey.heroImage {
                PostMediaStore.shared.setImageUrls(id: mainId, urls: [hero])
            }
            for (index, node) in journey.viewPointNodes.enumerated() {
                let vpId = "track_\(draft.routeID)_vp_\(index)"
                if let urls = node.imageUrls, !urls.isEmpty {
                    PostMediaStore.shared.setImageUrls(id: vpId, urls: urls)
                }
            }
        }
        isPublishing = false
        showingSuccessOverlay = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { dismiss() }
    }

    /// Export Detailed Track to JSON string (View Points only, no Days). Only valid when isReadyToPublish. Syncs photoCount from viewPointPhotos.
    private func exportDetailedTrackToJSON() -> String? {
        guard detailedTrack.isReadyToPublish else { return nil }
        var copy = detailedTrack
        for i in copy.viewPointNodes.indices {
            let id = copy.viewPointNodes[i].id
            copy.viewPointNodes[i].photoCount = viewPointPhotos[id]?.count ?? 0
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(copy) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Print a sample DetailedTrack JSON so you can confirm it contains only View Points (viewPointNodes), no Days.
    private func printDetailedTrackJSONSample() {
        let sample = DetailedTrackPost(
            category: .nationalForest,
            routeName: "Sample Route",
            totalDurationMinutes: 90,
            viewPointNodes: [
                ViewPointNode(title: "Trailhead", activityType: .hiking, latitude: 37.73, longitude: -119.55, photoCount: 1),
                ViewPointNode(title: "Summit", activityType: .hiking, latitude: 37.75, longitude: -119.52, photoCount: 1)
            ]
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(sample), let str = String(data: data, encoding: .utf8) else { return }
        print("========== Detailed Track JSON 範例 (僅 View Points，無 Days) ==========")
        print(str)
        print("========== end ==========")
    }

    /// Base date: Day 1 only. Day 2+ = startDate + index (days).
    private func computedDate(forStopIndex index: Int) -> Date? {
        guard !stops.isEmpty, index >= 0 else { return nil }
        if index == 0 { return stops[0].date }
        return Calendar.current.date(byAdding: .day, value: index, to: stops[0].date)
    }

    /// Formatted label for Day 2+ (e.g. "Monday, March 3"). "Pending Day 1" when Day 1 not set.
    private func computedDateLabel(forStopIndex index: Int) -> String {
        guard index > 0 else { return "" }
        guard stops[0].dateWasPicked, let date = computedDate(forStopIndex: index) else {
            return "Pending Day 1"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }

    var body: some View {
        crbMainContent
            .navigationBarBackButtonHidden(true)
            .confirmationDialog("Save your work?", isPresented: $showCancelConfirm, titleVisibility: .visible) {
                Button("Save to Draft & Exit") {
                    saveDraftAndExit()
                }
                Button("Discard", role: .destructive) {
                    showCancelConfirm = false
                    dismiss()
                }
                Button("Continue Editing", role: .cancel) {
                    showCancelConfirm = false
                }
            } message: {
                Text("You have path data. Save to Draft Box to edit and publish later, or discard and exit.")
            }
            .alert("發布失敗", isPresented: Binding(
                get: { publishError != nil },
                set: { if !$0 { publishError = nil } }
            )) {
                Button("OK", role: .cancel) { publishError = nil }
            } message: {
                Text(publishError ?? "")
            }
            .onAppear {
                applyLiveTrackDraftIfNeeded()
                if planningStyle == .microTrack && !hasPrintedDetailedTrackSample {
                    hasPrintedDetailedTrackSample = true
                    printDetailedTrackJSONSample()
                }
            }
            .onChange(of: planningStyle) { _, new in
                if new == .microTrack && !hasPrintedDetailedTrackSample {
                    hasPrintedDetailedTrackSample = true
                    printDetailedTrackJSONSample()
                }
            }
            .sheet(isPresented: Binding(
                get: { datePickerStopIndex != nil },
                set: { if !$0 { datePickerStopIndex = nil } }
            )) {
                if datePickerStopIndex == 0, !stops.isEmpty {
                    DatePickerSheet(
                        date: binding(for: 0).date,
                        onDismiss: { cleared in
                            if cleared { stops[0].dateWasPicked = false }
                            else { stops[0].dateWasPicked = true }
                            datePickerStopIndex = nil
                        }
                    )
                }
            }
            .sheet(isPresented: Binding(
                get: { locationPickerDayIndex != nil },
                set: { if !$0 { locationPickerDayIndex = nil } }
            )) {
                if let dayIndex = locationPickerDayIndex, dayIndex >= 0, dayIndex < stops.count {
                    MapLocationPickerView(
                        selectedLocation: bindingLocation(for: dayIndex),
                        onDismiss: { locationPickerDayIndex = nil }
                    )
                }
            }
            .onChange(of: reverseGeocodeApplyTrigger) { _, _ in
                guard let p = pendingReverseGeocodeName else { return }
                defer { pendingReverseGeocodeName = nil }
                guard p.dayIndex >= 0, p.dayIndex < stops.count,
                      p.waypointIndex >= 0, p.waypointIndex < stops[p.dayIndex].microTracks.count else { return }
                if stops[p.dayIndex].microTracks[p.waypointIndex].name.trimmingCharacters(in: .whitespaces).isEmpty {
                    stops[p.dayIndex].microTracks[p.waypointIndex].name = p.name
                }
            }
            .onChange(of: routeUpdateApplyTrigger) { _, _ in
                guard let p = pendingRouteUpdate else { return }
                defer { pendingRouteUpdate = nil }
                guard p.dayIndex >= 0, p.dayIndex < stops.count,
                      p.waypointIndex >= 0, p.waypointIndex < stops[p.dayIndex].microTracks.count else { return }
                stops[p.dayIndex].microTracks[p.waypointIndex].distanceFromPrevious = p.distance
                stops[p.dayIndex].microTracks[p.waypointIndex].durationFromPrevious = p.duration
                stops[p.dayIndex].microTracks[p.waypointIndex].routePolylineFromPrevious = p.polyline
            }
            .onChange(of: waypointCurrentLocationManager.location) { _, new in
                guard let target = currentLocationTarget, let loc = new else { return }
                defer { currentLocationTarget = nil }
                guard target.dayIndex >= 0, target.dayIndex < stops.count,
                      target.waypointIndex >= 0, target.waypointIndex < stops[target.dayIndex].microTracks.count else { return }
                let coord = loc.coordinate
                stops[target.dayIndex].microTracks[target.waypointIndex].latitude = String(coord.latitude)
                stops[target.dayIndex].microTracks[target.waypointIndex].longitude = String(coord.longitude)
                stops[target.dayIndex].microTracks[target.waypointIndex].coordinatesFromPhoto = false
                reverseGeocodeAndFillPointName(dayIndex: target.dayIndex, waypointIndex: target.waypointIndex, lat: coord.latitude, lon: coord.longitude)
            }
            .fullScreenCover(isPresented: Binding(
                get: { dropPinContext != nil },
                set: { if !$0 { dropPinContext = nil } }
            )) {
                if let ctx = dropPinContext, ctx.dayIndex < stops.count, ctx.waypointIndex < stops[ctx.dayIndex].microTracks.count {
                    let wp = stops[ctx.dayIndex].microTracks[ctx.waypointIndex]
                    DropPinMapSheetView(
                        initialLat: Double(wp.latitude) ?? 0,
                        initialLon: Double(wp.longitude) ?? 0,
                        fallbackCenter: previousWaypointCoordinate(dayIndex: ctx.dayIndex, waypointIndex: ctx.waypointIndex),
                        onConfirm: { coord in
                            stops[ctx.dayIndex].microTracks[ctx.waypointIndex].latitude = String(coord.latitude)
                            stops[ctx.dayIndex].microTracks[ctx.waypointIndex].longitude = String(coord.longitude)
                            stops[ctx.dayIndex].microTracks[ctx.waypointIndex].coordinatesFromPhoto = false
                            dropPinContext = nil
                            if ctx.dayIndex != 0 || ctx.waypointIndex != 0 {
                                fetchRouteInfo(dayIndex: ctx.dayIndex, waypointIndex: ctx.waypointIndex)
                            }
                            reverseGeocodeAndFillPointName(dayIndex: ctx.dayIndex, waypointIndex: ctx.waypointIndex, lat: coord.latitude, lon: coord.longitude)
                        },
                        onCancel: { dropPinContext = nil }
                    )
                }
            }
            .fullScreenCover(isPresented: Binding(
                get: { mapSelectionViewPointIndex != nil },
                set: { if !$0 { mapSelectionViewPointIndex = nil } }
            )) {
                if let idx = mapSelectionViewPointIndex, idx >= 0, idx < detailedTrack.viewPointNodes.count {
                    let vp = detailedTrack.viewPointNodes[idx]
                    LocationPickerView(
                        initialLat: vp.latitude ?? 37.73,
                        initialLon: vp.longitude ?? -119.55,
                        onConfirm: { coord in
                            detailedTrack.viewPointNodes[idx].latitude = coord.latitude
                            detailedTrack.viewPointNodes[idx].longitude = coord.longitude
                            mapSelectionViewPointIndex = nil
                        },
                        onCancel: { mapSelectionViewPointIndex = nil }
                    )
                }
            }
            .confirmationDialog("Remove Day?", isPresented: Binding(
                get: { deleteConfirmDayIndex != nil },
                set: { if !$0 { deleteConfirmDayIndex = nil } }
            ), titleVisibility: .visible) {
                if let idx = deleteConfirmDayIndex, idx >= 0, idx < stops.count {
                    Button("Delete Day \(idx + 1)", role: .destructive) {
                        removeDay(at: idx)
                    }
                    Button("Cancel", role: .cancel) {
                        deleteConfirmDayIndex = nil
                    }
                }
            } message: {
                if let idx = deleteConfirmDayIndex {
                    Text("Are you sure you want to delete Day \(idx + 1)?")
                }
            }
            .overlay {
                if showingSuccessOverlay {
                    publishSuccessOverlay
                }
            }
    }

    /// 發布成功：滿屏綠色勾勾動畫 + "Your Journey is Live!"，2 秒後自動 dismiss（在 publishMacroJourney 內已排程）。
    private var publishSuccessOverlay: some View {
        ZStack {
            Color(hex: "0B121F")
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color(hex: "22C55E"))
                    .scaleEffect(successCheckmarkScale)
                Text("Your Journey is Live!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                Text("Taking you back to Community…")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: "9CA3AF"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) { successCheckmarkScale = 1.0 }
            }
        }
    }

    private var crbMainContent: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    planningStyleSection
                    if planningStyle == .microTrack {
                        detailedTrackRequiredSection
                    }
                    basicInfoSection
                    if planningStyle == .microTrack {
                        viewPointsSection
                    } else {
                        preferencesSection
                    }
                    if planningStyle == .macroJourney {
                        stateMultiSelectorSection
                        journeyTimelineSection
                        addStopButton
                    }
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CRBColors.background)
            .preferredColorScheme(.dark)
            stickyBottomBar
        }
    }

    private func removeDay(at index: Int) {
        guard index >= 0, index < stops.count else { return }
        withAnimation(.easeOut(duration: 0.3)) {
            stops.remove(at: index)
            if index < stopPhotoPickerItems.count { stopPhotoPickerItems.remove(at: index) }
            if index < stopPhotoPickerArrays.count { stopPhotoPickerArrays.remove(at: index) }
        }
        deleteConfirmDayIndex = nil
    }

    private func applyLiveTrackDraftIfNeeded() {
        guard let d = pendingLiveTrackDraft, !d.waypoints.isEmpty else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let waypoints = d.waypoints.map { pt in
            Waypoint(
                latitude: String(pt.latitude),
                longitude: String(pt.longitude),
                arrivalTime: formatter.string(from: pt.timestamp),
                elevation: pt.elevation > 0 ? String(Int(pt.elevation)) : ""
            )
        }
        stops = [JourneyStop(microTracks: waypoints)]
        planningStyle = .macroJourney
        pendingLiveTrackDraft = nil
    }

    /// First point = Day 1, first waypoint: no previous → skip distance calculation and just save coordinates.
    private func previousWaypointCoordinate(dayIndex: Int, waypointIndex: Int) -> CLLocationCoordinate2D? {
        var lastValid: CLLocationCoordinate2D?
        for d in 0..<stops.count {
            for w in 0..<stops[d].microTracks.count {
                if d == dayIndex && w == waypointIndex { return lastValid }
                let wp = stops[d].microTracks[w]
                if let lat = Double(wp.latitude), let lon = Double(wp.longitude), lat != 0 || lon != 0 {
                    lastValid = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                }
            }
        }
        return lastValid
    }

    /// Reverse geocode lat/lon and fill "Point Name" (Trailhead / Point of Interest) if currently empty.
    private func reverseGeocodeAndFillPointName(dayIndex: Int, waypointIndex: Int, lat: Double, lon: Double) {
        guard dayIndex >= 0, dayIndex < stops.count, waypointIndex >= 0, waypointIndex < stops[dayIndex].microTracks.count else { return }
        let location = CLLocation(latitude: lat, longitude: lon)
        let dIndex = dayIndex, wIndex = waypointIndex
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            guard let pm = placemarks?.first else { return }
            let name = Self.formatPlacemarkForPointName(pm)
            guard !name.isEmpty else { return }
            DispatchQueue.main.async {
                pendingReverseGeocodeName = (dIndex, wIndex, name)
                reverseGeocodeApplyTrigger += 1
            }
        }
    }

    private func bindingWaypointPhotoItem(dayIndex: Int, waypointIndex: Int) -> Binding<PhotosPickerItem?> {
        let key = "\(dayIndex)-\(waypointIndex)"
        return Binding(
            get: { waypointPhotoPickerItems[key] ?? nil },
            set: { new in
                waypointPhotoPickerItems[key] = new
                if new != nil {
                    loadWaypointPhotoAndApplyEXIF(dayIndex: dayIndex, waypointIndex: waypointIndex, item: new!)
                }
            }
        )
    }

    private func loadWaypointPhotoAndApplyEXIF(dayIndex: Int, waypointIndex: Int, item: PhotosPickerItem) {
        guard dayIndex >= 0, dayIndex < stops.count, waypointIndex >= 0, waypointIndex < stops[dayIndex].microTracks.count else { return }
        loadingEXIFForWaypoint = (dayIndex, waypointIndex)
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self) else {
                await MainActor.run { loadingEXIFForWaypoint = nil }
                return
            }
            let image = UIImage(data: data)
            let exif = EXIFWaypointData.extract(from: data)
            await MainActor.run {
                loadingEXIFForWaypoint = nil
                waypointPhotoPickerItems["\(dayIndex)-\(waypointIndex)"] = nil
                guard dayIndex < stops.count, waypointIndex < stops[dayIndex].microTracks.count else { return }
                var wp = stops[dayIndex].microTracks[waypointIndex]
                let exifHasCoords = exif?.latitude != nil && exif?.longitude != nil
                wp.photo = image
                if let ex = exif {
                    if let lat = ex.latitude { wp.latitude = String(lat); wp.coordinatesFromPhoto = true }
                    if let lon = ex.longitude { wp.longitude = String(lon) }
                    if let alt = ex.altitude {
                        let ft = alt * 3.28084
                        wp.elevation = String(format: "%.0f ft", ft)
                    }
                    if let dt = ex.dateTimeOriginal {
                        let f = DateFormatter()
                        f.dateFormat = "h:mm a"
                        wp.arrivalTime = f.string(from: dt)
                    }
                }
                if exifHasCoords {
                    withAnimation(.easeInOut(duration: 0.4)) { stops[dayIndex].microTracks[waypointIndex] = wp }
                } else {
                    stops[dayIndex].microTracks[waypointIndex] = wp
                }
                if exifHasCoords, (dayIndex != 0 || waypointIndex != 0) {
                    fetchRouteInfo(dayIndex: dayIndex, waypointIndex: waypointIndex)
                }
            }
        }
    }

    private static func formatPlacemarkForPointName(_ pm: CLPlacemark) -> String {
        if let n = pm.name, !n.isEmpty { return n }
        let street = [pm.subThoroughfare, pm.thoroughfare].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " ")
        if !street.isEmpty { return street }
        if let area = pm.areasOfInterest?.first, !area.isEmpty { return area }
        if let locality = pm.locality, !locality.isEmpty { return locality }
        if let admin = pm.administrativeArea, !admin.isEmpty { return admin }
        return ""
    }

    private static func extractPolylineCoordinates(from polyline: MKPolyline) -> [CLLocationCoordinate2D] {
        let count = polyline.pointCount
        guard count > 0 else { return [] }
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: count)
        polyline.getCoordinates(&coords, range: NSRange(location: 0, length: count))
        return coords
    }

    private func fetchRouteInfo(dayIndex: Int, waypointIndex: Int) {
        guard dayIndex < stops.count, waypointIndex < stops[dayIndex].microTracks.count else { return }
        guard let prev = previousWaypointCoordinate(dayIndex: dayIndex, waypointIndex: waypointIndex) else { return }
        let wp = stops[dayIndex].microTracks[waypointIndex]
        guard let lat = Double(wp.latitude), let lon = Double(wp.longitude) else { return }
        let dest = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        loadingRouteInfoFor = (dayIndex, waypointIndex)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: prev))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: dest))
        request.transportType = .automobile
        let dir = MKDirections(request: request)
        let dIndex = dayIndex, wIndex = waypointIndex
        dir.calculate { response, _ in
            DispatchQueue.main.async {
                loadingRouteInfoFor = nil
                if let route = response?.routes.first {
                    let distKm = route.distance / 1000
                    let dur = route.expectedTravelTime
                    let distStr = distKm < 1.6 ? String(format: "%.1f mi", distKm / 1.609) : String(format: "%.1f km", distKm)
                    let hours = Int(dur) / 3600
                    let mins = Int(dur) / 60 % 60
                    let timeStr = hours > 0 ? "\(hours)h \(mins)m" : "\(mins)m"
                    let polylinePoints = Self.extractPolylineCoordinates(from: route.polyline)
                    pendingRouteUpdate = PendingRouteUpdate(dayIndex: dIndex, waypointIndex: wIndex, distance: distStr, duration: timeStr, polyline: polylinePoints)
                    routeUpdateApplyTrigger += 1
                }
            }
        }
    }

    private func routeInfoRow(dayIndex: Int, waypointIndex: Int, waypoint: Binding<Waypoint>) -> some View {
        let isLoading = loadingRouteInfoFor?.dayIndex == dayIndex && loadingRouteInfoFor?.waypointIndex == waypointIndex
        return HStack(spacing: 8) {
            Text("From previous")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(CRBColors.textMuted)
            if isLoading {
                HStack(spacing: 6) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(CRBColors.textMuted)
                    Text("Calculating…")
                        .font(.system(size: 13))
                        .foregroundStyle(CRBColors.textMuted)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                let dist = waypoint.wrappedValue.distanceFromPrevious
                let dur = waypoint.wrappedValue.durationFromPrevious
                Text([dist, dur].filter { !$0.isEmpty }.joined(separator: " • "))
                    .font(.system(size: 13))
                    .foregroundStyle(CRBColors.textPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(CRBColors.searchBg)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack {
            Button {
                showCancelConfirm = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundStyle(CRBColors.textPrimary)
            }
            Spacer()
            VStack(spacing: 2) {
                Text("Custom Route Builder")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(CRBColors.textPrimary)
                if planningStyle == .microTrack {
                    Text("HIGH-PRECISION TRAIL MODE")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(CRBColors.activeOrange)
                }
            }
            Spacer()
            Button { } label: {
                HStack(spacing: 6) {
                    Image(systemName: "doc")
                        .font(.system(size: 14))
                    Text("Save Draft")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(CRBColors.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    // MARK: - Planning Style Picker
    private var planningStyleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if showPlanningInfo {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(CRBColors.activeOrange)
                    Text("Choose your planning style: Use **Macro Journey** to plan stops across states (cities, national parks), or **Micro Track** to document a specific off-road trail or hiking path with precision GPS data.")
                        .font(.system(size: 13))
                        .foregroundStyle(CRBColors.textPrimary)
                    Button { showPlanningInfo = false } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(CRBColors.textMuted)
                    }
                }
                .padding(12)
                .background(CRBColors.infoBg)
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.infoBorder, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            HStack(spacing: 12) {
                ForEach([PlanningStyle.macroJourney, PlanningStyle.microTrack], id: \.self) { style in
                    planningStyleCard(style)
                }
            }
        }
    }

    private func planningStyleCard(_ style: PlanningStyle) -> some View {
        let isSelected = planningStyle == style
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) { planningStyle = style }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: style == .macroJourney ? "mappin.circle" : "map")
                    .font(.system(size: 22))
                    .foregroundStyle(CRBColors.textPrimary)
                Text(style.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(CRBColors.textPrimary)
                Text(style.subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(CRBColors.textMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(isSelected ? CRBColors.activeOrange : CRBColors.inactivePill)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Macro Journey only: State Multi-Selector (collapsible, top of macro content)
    private var stateMultiSelectorSection: some View {
        StateMultiSelectorView(
            selectedStates: Binding(
                get: { selectedMacroStates },
                set: { selectedMacroStates = $0 }
            ),
            stateList: usStatesWithAbbr,
            accentColor: CRBColors.activeOrange,
            backgroundColor: CRBColors.cardNested,
            textPrimary: CRBColors.textPrimary,
            textMuted: CRBColors.textMuted,
            borderMuted: CRBColors.borderMuted
        )
    }

    // MARK: - Location Selector (Micro Track: Land Management Category)
    private var locationSelectorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(CRBColors.activeOrange)
                Text("Location Selector")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(CRBColors.textPrimary)
            }
            Text("Land Management Category")
                .font(.system(size: 13))
                .foregroundStyle(CRBColors.textMuted)
            FlowLayout(spacing: 8) {
                ForEach(LandManagementCategory.allCases, id: \.self) { category in
                    let isSelected = selectedLandCategory == category
                    Button {
                        selectedLandCategory = isSelected ? nil : category
                    } label: {
                        Text(category.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(isSelected ? .white : CRBColors.textMuted)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(isSelected ? CRBColors.activeOrange : CRBColors.inactivePill)
                            .clipShape(Capsule())
                            .overlay(Capsule().strokeBorder(CRBColors.borderMuted, lineWidth: isSelected ? 0 : 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(CRBColors.cardNested)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
        .padding(.horizontal, 20)
    }

    private func subCategoryPicker(title: String, options: [String], selected: Binding<String?>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(CRBColors.textMuted)
            Picker(title, selection: selected) {
                Text("Select").tag(nil as String?)
                ForEach(options, id: \.self) { opt in
                    Text(opt).tag(opt as String?)
                }
            }
            .pickerStyle(.menu)
            .tint(CRBColors.textPrimary)
            .padding(12)
            .background(CRBColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(selected.wrappedValue != nil ? CRBColors.activeOrange : CRBColors.borderMuted, lineWidth: 1))
        }
    }

    // MARK: - Detailed Track required: 第一層 Nature/Urban + 第二層 Sub-category，Route Name，Total Duration
    private var detailedTrackRequiredSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                labelWithIcon("Category (Required)", icon: "tag")
                Picker("", selection: Binding(
                    get: { detailedTrack.trackTier ?? .nature },
                    set: { new in
                        var c = detailedTrack
                        c.trackTier = new
                        c.subCategoryDisplay = nil
                        c.category = nil
                        detailedTrack = c
                    }
                )) {
                    Text(MicroTrackTier.nature.label).tag(MicroTrackTier.nature)
                    Text(MicroTrackTier.urban.label).tag(MicroTrackTier.urban)
                }
                .pickerStyle(.segmented)
                .tint(CRBColors.activeOrange)
                if detailedTrack.trackTier == .nature {
                    subCategoryPicker(
                        title: "Land Manager (Nature)",
                        options: DetailedTrackCategory.allCases.map(\.rawValue),
                        selected: Binding(
                            get: { detailedTrack.subCategoryDisplay },
                            set: { var c = detailedTrack; c.subCategoryDisplay = $0; detailedTrack = c }
                        )
                    )
                } else {
                    subCategoryPicker(
                        title: "Sub-category (Urban)",
                        options: UrbanSubCategory.allCases.map(\.rawValue),
                        selected: Binding(
                            get: { detailedTrack.subCategoryDisplay },
                            set: { var c = detailedTrack; c.subCategoryDisplay = $0; detailedTrack = c }
                        )
                    )
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                labelWithIcon("Total Duration (Required)", icon: "clock")
                HStack(spacing: 12) {
                    Picker("Hours", selection: Binding(
                        get: { detailedTrack.totalDurationMinutes / 60 },
                        set: { newH in var c = detailedTrack; c.totalDurationMinutes = newH * 60 + (c.totalDurationMinutes % 60); detailedTrack = c }
                    )) {
                        ForEach(0..<25, id: \.self) { Text("\($0) h").tag($0) }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                    Picker("Minutes", selection: Binding(
                        get: { detailedTrack.totalDurationMinutes % 60 },
                        set: { newM in var c = detailedTrack; c.totalDurationMinutes = (c.totalDurationMinutes / 60) * 60 + newM; detailedTrack = c }
                    )) {
                        ForEach([0, 15, 30, 45], id: \.self) { Text("\($0) min").tag($0) }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                }
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            }
            VStack(alignment: .leading, spacing: 8) {
                labelWithIcon("Activity Type", icon: "figure.walk")
                Picker("Activity Type", selection: Binding(
                    get: { detailedTrack.primaryActivityType ?? .hiking },
                    set: { var c = detailedTrack; c.primaryActivityType = $0; detailedTrack = c }
                )) {
                    ForEach(ViewPointActivityType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .tint(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            }
        }
    }

    // MARK: - Basic Info (Cover Photo, Journey Name)
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            coverPhotoZone
            journeyNameField
            if planningStyle == .macroJourney {
                macroOverallDescriptionEditor
            }
            if planningStyle == .macroJourney {
                VStack(alignment: .leading, spacing: 8) {
                    labelWithIcon("Trip tags (shown on detail hero)", icon: "tag.fill")
                    TextField("e.g. Utah, Desert, Family — comma separated", text: $macroTripTags)
                        .textFieldStyle(.plain)
                        .font(.system(size: 15))
                        .foregroundStyle(CRBColors.textPrimary)
                        .padding(14)
                        .background(CRBColors.searchBg)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                    Text("States + Duration + Vehicle + Pace are always saved as tags. Add extra here.")
                        .font(.system(size: 11))
                        .foregroundStyle(CRBColors.textMuted)
                }
            }
        }
    }

    private var coverPhotoZone: some View {
        PhotosPicker(selection: $coverPhotoItems, maxSelectionCount: 5, matching: .images) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                    .foregroundStyle(CRBColors.borderMuted)
                if let img = coverImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 44))
                            .foregroundStyle(CRBColors.textMuted)
                        Text("Add Route Cover Photo")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(CRBColors.textPrimary)
                        Text("Drag & drop or click to browse (up to 5)")
                            .font(.system(size: 13))
                            .foregroundStyle(CRBColors.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(CRBColors.cardNested)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .onChange(of: coverPhotoItems) { _, new in
            Task {
                var loaded: [UIImage] = []
                for item in new {
                    if let data = try? await item.loadTransferable(type: Data.self), let ui = UIImage(data: data) {
                        loaded.append(ui)
                    }
                }
                await MainActor.run {
                    coverImages = loaded
                    coverImage = loaded.first
                }
            }
        }
    }

    private var journeyNameField: some View {
        let (label, placeholder, binding) = planningStyle == .macroJourney
            ? ("Journey Name", "e.g., Pacific Coast Road Trip", $journeyName)
            : ("Route Name (Required)", "e.g., Angel's Landing Trail - Zion", Binding(get: { detailedTrack.routeName }, set: { var c = detailedTrack; c.routeName = $0; detailedTrack = c }))
        return VStack(alignment: .leading, spacing: 8) {
            labelWithIcon(label, icon: "link")
            TextField(placeholder, text: binding)
                .textFieldStyle(.plain)
                .font(.system(size: 16))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(14)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
        }
    }

    // MARK: - Preferences (Duration, Vehicle, Pace)
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            pillRow(title: "Duration", icon: "clock") {
                ForEach(DurationOption.allCases, id: \.self) { opt in
                    pillButton(opt.rawValue, selected: duration == opt) { duration = opt }
                }
            }
            pillRow(title: "Vehicle", icon: "car") {
                ForEach(VehicleOption.allCases, id: \.self) { opt in
                    pillButton(opt.rawValue, selected: vehicle == opt) { vehicle = opt }
                }
            }
            pillRow(title: "Pace", icon: "waveform") {
                ForEach(PaceOption.allCases, id: \.self) { opt in
                    pillButton(opt.rawValue, selected: pace == opt) { pace = opt }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(16)
        .background(CRBColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }

    private func pillRow<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            labelWithIcon(title, icon: icon)
            FlowLayout(spacing: 8) { content() }
        }
    }

    private func pillButton(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selected ? CRBColors.activeOrange : CRBColors.inactivePill)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - View Points (min 2; each: Title, Activity, Location from map, at least one Photo)
    private var viewPointsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(CRBColors.activeOrange)
                Text("View Points")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(CRBColors.textPrimary)
            }
            HStack(alignment: .top, spacing: 0) {
                timelineDashedLine(count: detailedTrack.viewPointNodes.count)
                VStack(spacing: 12) {
                    ForEach(Array(detailedTrack.viewPointNodes.enumerated()), id: \.element.id) { index, _ in
                        viewPointCard(displayIndex: index + 1, arrayIndex: index)
                    }
                    Button {
                        var c = detailedTrack
                        c.viewPointNodes.append(ViewPointNode())
                        detailedTrack = c
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(CRBColors.activeOrange)
                            Text("Add View Point")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(CRBColors.activeOrange)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, 12)
            }
        }
    }

    private static let arrivalTimeRefDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))!
    private static let arrivalTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.defaultDate = arrivalTimeRefDate
        return f
    }()

    private func arrivalTimeBinding(for arrayIndex: Int) -> Binding<Date> {
        Binding(
            get: {
                guard arrayIndex < detailedTrack.viewPointNodes.count else { return Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Self.arrivalTimeRefDate) ?? Self.arrivalTimeRefDate }
                let raw = detailedTrack.viewPointNodes[arrayIndex].arrivalTime ?? ""
                let trimmed = raw.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty, let parsed = Self.arrivalTimeFormatter.date(from: trimmed) else {
                    return Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Self.arrivalTimeRefDate) ?? Self.arrivalTimeRefDate
                }
                let comps = Calendar.current.dateComponents([.hour, .minute], from: parsed)
                return Calendar.current.date(bySettingHour: comps.hour ?? 9, minute: comps.minute ?? 0, second: 0, of: Self.arrivalTimeRefDate) ?? Self.arrivalTimeRefDate
            },
            set: { newDate in
                guard arrayIndex < detailedTrack.viewPointNodes.count else { return }
                var c = detailedTrack
                c.viewPointNodes[arrayIndex].arrivalTime = Self.arrivalTimeFormatter.string(from: newDate)
                detailedTrack = c
            }
        )
    }

    /// 宏觀路線 Waypoint 的到達時間：AM/PM 滾輪 → 寫回 waypoint.arrivalTime 字串
    private func arrivalTimeBindingForWaypoint(waypoint: Binding<Waypoint>) -> Binding<Date> {
        Binding(
            get: {
                let raw = (waypoint.wrappedValue.arrivalTime).trimmingCharacters(in: .whitespaces)
                guard !raw.isEmpty, let d = Self.arrivalTimeFormatter.date(from: raw) else {
                    return Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Self.arrivalTimeRefDate) ?? Self.arrivalTimeRefDate
                }
                let comps = Calendar.current.dateComponents([.hour, .minute], from: d)
                return Calendar.current.date(bySettingHour: comps.hour ?? 9, minute: comps.minute ?? 0, second: 0, of: Self.arrivalTimeRefDate) ?? Self.arrivalTimeRefDate
            },
            set: { newDate in
                var w = waypoint.wrappedValue
                w.arrivalTime = Self.arrivalTimeFormatter.string(from: newDate)
                waypoint.wrappedValue = w
            }
        )
    }

    private func viewPointCard(displayIndex: Int, arrayIndex: Int) -> some View {
        let vp = detailedTrack.viewPointNodes[arrayIndex]
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("View Point \(displayIndex)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(CRBColors.activeOrange)
                    .clipShape(Capsule())
                Spacer()
                if detailedTrack.viewPointNodes.count > 2 {
                    Button {
                        var c = detailedTrack
                        c.viewPointNodes.remove(at: arrayIndex)
                        detailedTrack = c
                        let id = vp.id
                        viewPointPhotos.removeValue(forKey: id)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundStyle(CRBColors.textMuted)
                    }
                    .buttonStyle(.plain)
                }
            }
            TextField("Title (Required)", text: Binding(
                get: { detailedTrack.viewPointNodes[arrayIndex].title },
                set: { new in var c = detailedTrack; c.viewPointNodes[arrayIndex].title = new; detailedTrack = c }
            ))
            .textFieldStyle(.plain)
            .font(.system(size: 15))
            .foregroundStyle(CRBColors.textPrimary)
            .padding(12)
            .background(CRBColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))

            VStack(alignment: .leading, spacing: 8) {
                labelWithIcon("Activity Type", icon: "figure.walk")
                Picker("Activity", selection: Binding(
                    get: { detailedTrack.viewPointNodes[arrayIndex].activityType },
                    set: { new in var c = detailedTrack; c.viewPointNodes[arrayIndex].activityType = new; detailedTrack = c }
                )) {
                    ForEach(ViewPointActivityType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .tint(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            }

            // MARK: - PROFESSIONAL DATA
            VStack(alignment: .leading, spacing: 12) {
                Text("PROFESSIONAL DATA")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(CRBColors.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(CRBColors.activeOrange)
                    .clipShape(Capsule())

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(CRBColors.textMuted)
                        Text("Precise GPS Coordinates")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(CRBColors.textPrimary)
                    }
                    HStack(spacing: 10) {
                        TextField("Latitude", text: Binding(
                            get: { vp.latitude.map { String($0) } ?? "" },
                            set: { var c = detailedTrack; c.viewPointNodes[arrayIndex].latitude = $0.isEmpty ? nil : Double($0); detailedTrack = c }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(CRBColors.textPrimary)
                        .padding(10)
                        .background(CRBColors.searchBg)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        TextField("Longitude", text: Binding(
                            get: { vp.longitude.map { String($0) } ?? "" },
                            set: { var c = detailedTrack; c.viewPointNodes[arrayIndex].longitude = $0.isEmpty ? nil : Double($0); detailedTrack = c }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(CRBColors.textPrimary)
                        .padding(10)
                        .background(CRBColors.searchBg)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(
                                (vp.latitude != nil && vp.longitude != nil) ? Color.clear : Color.red.opacity(0.75),
                                lineWidth: (vp.latitude != nil && vp.longitude != nil) ? 0 : 2
                            )
                            .padding(-2)
                    )
                    Text("If the photo has no coordinates or no photo is uploaded, tap Drop Pin below to set the location.")
                        .font(.system(size: 12))
                        .foregroundStyle(CRBColors.textMuted)
                    Button {
                        mapSelectionViewPointIndex = arrayIndex
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "scope")
                                .font(.system(size: 16))
                            Text("Drop Pin on Map")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundStyle(CRBColors.activeOrange)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(CRBColors.searchBg)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }

                VStack(alignment: .leading, spacing: 8) {
                    labelWithIcon("Arrival Time", icon: "clock")
                    DatePicker("", selection: arrivalTimeBinding(for: arrayIndex), displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .frame(maxWidth: 260)
                        .padding(8)
                        .background(CRBColors.searchBg)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                }

                VStack(alignment: .leading, spacing: 8) {
                    labelWithIcon("Elevation", icon: "mountain.2.fill")
                    TextField("e.g. 4,035 ft", text: Binding(
                        get: { detailedTrack.viewPointNodes[arrayIndex].elevation ?? "" },
                        set: { var c = detailedTrack; c.viewPointNodes[arrayIndex].elevation = $0.isEmpty ? nil : $0; detailedTrack = c }
                    ))
                    .textFieldStyle(.plain)
                    .font(.system(size: 15))
                    .foregroundStyle(CRBColors.textPrimary)
                    .padding(12)
                    .background(CRBColors.searchBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Survival & Amenities")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(CRBColors.textPrimary)
                    HStack(spacing: 10) {
                        Button {
                            var c = detailedTrack
                            c.viewPointNodes[arrayIndex].hasWater.toggle()
                            detailedTrack = c
                        } label: {
                            AmenityCapsule(icon: "drop.fill", label: "Water", color: Color(hex: "1E3A5F"), borderColor: Color(hex: "3B82F6").opacity(0.6), isSelected: detailedTrack.viewPointNodes[arrayIndex].hasWater)
                        }
                        .buttonStyle(.plain)
                        Button {
                            var c = detailedTrack
                            c.viewPointNodes[arrayIndex].hasFuel.toggle()
                            detailedTrack = c
                        } label: {
                            AmenityCapsule(icon: "fuelpump.fill", label: "Fuel", color: Color(hex: "78350F"), borderColor: Color(hex: "F59E0B").opacity(0.6), isSelected: detailedTrack.viewPointNodes[arrayIndex].hasFuel)
                        }
                        .buttonStyle(.plain)
                        HStack(spacing: 4) {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 14))
                                .foregroundStyle(CRBColors.textMuted)
                            SignalStrengthBar(strength: Binding(
                                get: { detailedTrack.viewPointNodes[arrayIndex].signalStrength },
                                set: { var c = detailedTrack; c.viewPointNodes[arrayIndex].signalStrength = min(5, max(0, $0)); detailedTrack = c }
                            ))
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    labelWithIcon("Recommended Stay (Optional)", icon: "house.fill")
                    TextField("Add accommodation recommendation...", text: Binding(
                        get: { detailedTrack.viewPointNodes[arrayIndex].recommendedStay ?? "" },
                        set: { var c = detailedTrack; c.viewPointNodes[arrayIndex].recommendedStay = $0.isEmpty ? nil : $0; detailedTrack = c }
                    ))
                    .textFieldStyle(.plain)
                    .font(.system(size: 15))
                    .foregroundStyle(CRBColors.textPrimary)
                    .padding(12)
                    .background(CRBColors.searchBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                }
            }
            .padding(14)
            .background(CRBColors.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))

            viewPointPhotoRow(arrayIndex: arrayIndex)
        }
        .padding(16)
        .background(CRBColors.cardNested)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
    }

    private func viewPointPhotoRow(arrayIndex: Int) -> some View {
        let nodeId = detailedTrack.viewPointNodes[arrayIndex].id
        let photos = viewPointPhotos[nodeId] ?? []
        return VStack(alignment: .leading, spacing: 8) {
            labelWithIcon("Photo (Required, at least one)", icon: "photo")
            if !photos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(photos.enumerated()), id: \.offset) { i, img in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                Button {
                                    viewPointPhotos[nodeId]?.remove(at: i)
                                    if (viewPointPhotos[nodeId]?.isEmpty ?? true) { viewPointPhotos[nodeId] = nil }
                                    var c = detailedTrack
                                    if let idx = c.viewPointNodes.firstIndex(where: { $0.id == nodeId }) {
                                        c.viewPointNodes[idx].photoCount = max(0, (viewPointPhotos[nodeId]?.count ?? 0))
                                    }
                                    detailedTrack = c
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(.white)
                                        .shadow(radius: 2)
                                }
                                .offset(x: 4, y: -4)
                            }
                        }
                        addPhotoButton(arrayIndex: arrayIndex)
                    }
                }
            } else {
                addPhotoButton(arrayIndex: arrayIndex)
            }
        }
    }

    private func addPhotoButton(arrayIndex: Int) -> some View {
        let nodeId = arrayIndex < detailedTrack.viewPointNodes.count ? detailedTrack.viewPointNodes[arrayIndex].id : UUID()
        return PhotosPicker(selection: Binding(
            get: { viewPointPhotoPickerItems[arrayIndex] ?? nil },
            set: { new in
                viewPointPhotoPickerItems[arrayIndex] = new
                guard let item = new else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
                        await MainActor.run {
                            if arrayIndex < detailedTrack.viewPointNodes.count {
                                viewPointPhotos[nodeId, default: []].append(img)
                                viewPointPhotoPickerItems[arrayIndex] = nil
                                var c = detailedTrack
                                if let idx = c.viewPointNodes.firstIndex(where: { $0.id == nodeId }) {
                                    c.viewPointNodes[idx].photoCount = viewPointPhotos[nodeId]?.count ?? 0
                                }
                                detailedTrack = c
                            }
                        }
                    }
                }
            }
        ), matching: .images) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundStyle(CRBColors.borderMuted)
                    .frame(width: 80, height: 80)
                VStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(CRBColors.activeOrange)
                    Text("Add")
                        .font(.system(size: 12))
                        .foregroundStyle(CRBColors.textMuted)
                }
            }
        }
        .buttonStyle(.plain)
    }

    /// All waypoint coordinates in order (Day1[0], Day1[1], …) for pins. Map overlay updates when new pin is dropped.
    private var waypointCoordinates: [CLLocationCoordinate2D] {
        var coords: [CLLocationCoordinate2D] = []
        for stop in stops {
            for wp in stop.microTracks {
                if let lat = Double(wp.latitude), let lon = Double(wp.longitude), (lat != 0 || lon != 0) {
                    coords.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                }
            }
        }
        return coords
    }

    /// Coordinates + optional photo for map markers (thumbnail when photo exists).
    private var waypointCoordinatesWithPhotos: [(CLLocationCoordinate2D, UIImage?)] {
        var list: [(CLLocationCoordinate2D, UIImage?)] = []
        for stop in stops {
            for wp in stop.microTracks {
                if let lat = Double(wp.latitude), let lon = Double(wp.longitude), (lat != 0 || lon != 0) {
                    list.append((CLLocationCoordinate2D(latitude: lat, longitude: lon), wp.photo))
                }
            }
        }
        return list
    }

    /// Full path for map: waypoints + curved segments from MKDirections (route.polyline) when available.
    private var fullRoutePolylineCoordinates: [CLLocationCoordinate2D] {
        var path: [CLLocationCoordinate2D] = []
        var index = 0
        for stop in stops {
            for wp in stop.microTracks {
                guard let lat = Double(wp.latitude), let lon = Double(wp.longitude), (lat != 0 || lon != 0) else { continue }
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                if index == 0 {
                    path.append(coord)
                } else if !wp.routePolylineFromPrevious.isEmpty {
                    path.append(contentsOf: wp.routePolylineFromPrevious.dropFirst())
                } else {
                    path.append(coord)
                }
                index += 1
            }
        }
        return path
    }

    private var routeMapOverlay: some View {
        let coords = waypointCoordinates
        let pathCoords = fullRoutePolylineCoordinates
        let region: MKCoordinateRegion = {
            guard !coords.isEmpty else {
                return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
            }
            let lats = coords.map(\.latitude)
            let lons = coords.map(\.longitude)
            let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
            let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
            let span = MKCoordinateSpan(latitudeDelta: max(0.02, (maxLat - minLat) * 1.4 + 0.01), longitudeDelta: max(0.02, (maxLon - minLon) * 1.4 + 0.01))
            return MKCoordinateRegion(center: center, span: span)
        }()
        return Group {
            if !coords.isEmpty {
                Map(initialPosition: .region(region)) {
                    ForEach(Array(waypointCoordinatesWithPhotos.enumerated()), id: \.offset) { idx, item in
                        let (c, photo) = item
                        Annotation("\(idx + 1)", coordinate: c) {
                            if let img = photo {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
                                    .overlay(Circle().strokeBorder(CRBColors.activeOrange, lineWidth: 2))
                            } else {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(CRBColors.activeOrange)
                            }
                        }
                    }
                    if pathCoords.count >= 2 {
                        MapPolyline(coordinates: pathCoords)
                            .stroke(CRBColors.activeOrange, lineWidth: 3)
                    }
                }
                .mapStyle(.standard)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Journey Timeline (Macro Journey only: Day cards, Location Picker)
    private var journeyTimelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "location.north.circle.fill")
                    .foregroundStyle(CRBColors.activeOrange)
                Text("The Journey")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(CRBColors.textPrimary)
            }
            .padding(.horizontal, 20)

            HStack(alignment: .top, spacing: 0) {
                timelineDashedLine(count: stops.count)
                VStack(spacing: 12) {
                    ForEach(Array(stops.enumerated()), id: \.element.id) { index, stop in
                        Group {
                            dayCard(displayIndex: index + 1, arrayIndex: index, stop: binding(for: index))
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity.combined(with: .move(edge: .top))
                        ))
                    }
                    .animation(.easeOut(duration: 0.3), value: stops.map(\.id))
                }
                .padding(.leading, 12)
                .padding(.trailing, 20)
            }
        }
    }

    private func microTrackBinding(dayIndex: Int, waypointIndex: Int) -> Binding<Waypoint> {
        Binding(
            get: {
                guard dayIndex >= 0, dayIndex < stops.count,
                      waypointIndex >= 0, waypointIndex < stops[dayIndex].microTracks.count
                else { return Waypoint() }
                return stops[dayIndex].microTracks[waypointIndex]
            },
            set: { new in
                guard dayIndex >= 0, dayIndex < stops.count,
                      waypointIndex >= 0, waypointIndex < stops[dayIndex].microTracks.count
                else { return }
                stops[dayIndex].microTracks[waypointIndex] = new
            }
        )
    }

    /// Micro Track is NESTED inside each Day Card. Day 1's microTracks and Day 2's are fully isolated.
    private func microTrackDayCard(displayIndex: Int, arrayIndex: Int, stop: Binding<JourneyStop>) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Day \(displayIndex)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(CRBColors.activeOrange)
                    .clipShape(Capsule())
                Spacer()
                HStack(spacing: 12) {
                    if displayIndex == 1 {
                        Image(systemName: "flag.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(CRBColors.textMuted)
                    } else if stops.count > 1 {
                        Button {
                            deleteConfirmDayIndex = arrayIndex
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundStyle(CRBColors.textMuted)
                        }
                        .buttonStyle(DeleteButtonStyle())
                    }
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundStyle(CRBColors.textMuted)
                }
            }
            ForEach(Array(stop.wrappedValue.microTracks.enumerated()), id: \.element.id) { wpIndex, _ in
                nestedMicroTrackBlock(displayIndex: wpIndex + 1, dayIndex: arrayIndex, waypointIndex: wpIndex, waypoint: microTrackBinding(dayIndex: arrayIndex, waypointIndex: wpIndex))
            }
            Button {
                withAnimation(.easeOut(duration: 0.25)) {
                    guard arrayIndex >= 0, arrayIndex < stops.count else { return }
                    stops[arrayIndex].microTracks.append(Waypoint())
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Add Stop")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(CRBColors.activeOrange)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(CRBColors.cardBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(CRBColors.cardNested)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
    }

    /// Single Micro Track block INSIDE a Day Card. Photo-first: Add Photo primary, then EXIF sync, Drop Pin as fallback.
    private func nestedMicroTrackBlock(displayIndex: Int, dayIndex: Int, waypointIndex: Int, waypoint: Binding<Waypoint>) -> some View {
        let isLoadingEXIF = loadingEXIFForWaypoint?.dayIndex == dayIndex && loadingEXIFForWaypoint?.waypointIndex == waypointIndex
        let hasPhoto = waypoint.wrappedValue.photo != nil
        let hasCoords = waypoint.wrappedValue.latitude.isEmpty == false || waypoint.wrappedValue.longitude.isEmpty == false
        let showDropPinFallback = !hasCoords || !hasPhoto
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("#\(displayIndex)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(CRBColors.activeOrange)
                    .clipShape(Capsule())
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: 14))
                    .foregroundStyle(CRBColors.textMuted)
            }
            Text("Add Photo")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(CRBColors.textPrimary)
            PhotosPicker(selection: bindingWaypointPhotoItem(dayIndex: dayIndex, waypointIndex: waypointIndex), matching: .images) {
                Group {
                    if let img = waypoint.wrappedValue.photo {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(CRBColors.activeOrange)
                            Text("Add photo")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(CRBColors.textMuted)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            }
            .buttonStyle(.plain)
            if isLoadingEXIF {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(CRBColors.activeOrange)
                    Text("Extracting coordinates from photo...")
                        .font(.system(size: 13))
                        .foregroundStyle(CRBColors.textMuted)
                }
                .padding(.vertical, 6)
            }
            TextField("Trailhead / Point of Interest", text: waypoint.name)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            HStack(spacing: 8) {
                Text("Activity Type")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(CRBColors.textMuted)
                Text("*")
                    .foregroundStyle(CRBColors.activeOrange)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(MicroActivityType.allCases, id: \.self) { type in
                        let isSelected = waypoint.wrappedValue.activityType == type
                        Button {
                            var w = waypoint.wrappedValue
                            w.activityType = type
                            waypoint.wrappedValue = w
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: type.icon)
                                    .font(.system(size: 12))
                                Text(type.rawValue)
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundStyle(isSelected ? .white : CRBColors.textMuted)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(isSelected ? CRBColors.activeOrange : Color.clear)
                            .clipShape(Capsule())
                            .overlay(Capsule().strokeBorder(CRBColors.borderMuted, lineWidth: isSelected ? 0 : 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
            .frame(height: 40)
            Text("Brief Note")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(CRBColors.textMuted)
            TextField("Add notes about this waypoint...", text: waypoint.briefNote, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .lineLimit(2...4)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            Text("PROFESSIONAL DATA")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(CRBColors.activeOrange)
                .clipShape(Capsule())
            HStack(alignment: .center, spacing: 8) {
                labelWithIcon("Precise GPS Coordinates", icon: "location.circle")
                if waypoint.wrappedValue.coordinatesFromPhoto {
                    Text("From photo data")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(CRBColors.activeOrange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(CRBColors.activeOrange.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            HStack(spacing: 10) {
                TextField("Latitude", text: waypoint.latitude)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .foregroundStyle(CRBColors.textPrimary)
                    .keyboardType(.decimalPad)
                    .padding(12)
                    .background(CRBColors.searchBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Longitude", text: waypoint.longitude)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .foregroundStyle(CRBColors.textPrimary)
                    .keyboardType(.decimalPad)
                    .padding(12)
                    .background(CRBColors.searchBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            if showDropPinFallback {
                Text("If the photo has no coordinates or no photo is uploaded, tap Drop Pin below to set the location.")
                    .font(.system(size: 12))
                    .foregroundStyle(CRBColors.textMuted)
            }
            HStack(spacing: 10) {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    currentLocationTarget = (dayIndex: dayIndex, waypointIndex: waypointIndex)
                    waypointCurrentLocationManager.requestLocation()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                        Text("Current Location")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(CRBColors.textPrimary)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(CRBColors.searchBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                }
                .buttonStyle(.plain)
                Button {
                    dropPinContext = (dayIndex: dayIndex, waypointIndex: waypointIndex)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "scope")
                        Text("Drop Pin on Map")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(showDropPinFallback ? CRBColors.textPrimary : CRBColors.textMuted)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(showDropPinFallback ? CRBColors.searchBg : CRBColors.searchBg.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            if dayIndex > 0 || waypointIndex > 0 {
                routeInfoRow(dayIndex: dayIndex, waypointIndex: waypointIndex, waypoint: waypoint)
            }
            labelWithIcon("Arrival Time", icon: "clock")
            DatePicker("", selection: arrivalTimeBindingForWaypoint(waypoint: waypoint), displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.wheel)
                .padding(8)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            labelWithIcon("Elevation", icon: "mountain.2")
            TextField("e.g. 4,035 ft", text: waypoint.elevation)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            Text("Survival & Amenities")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(CRBColors.textMuted)
            HStack(alignment: .center, spacing: 10) {
                Button {
                    var w = waypoint.wrappedValue
                    w.hasWater.toggle()
                    waypoint.wrappedValue = w
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 12))
                        Text("Water")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(waypoint.wrappedValue.hasWater ? .white : CRBColors.textMuted)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(waypoint.wrappedValue.hasWater ? Color(hex: "3B82F6") : CRBColors.searchBg)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                Button {
                    var w = waypoint.wrappedValue
                    w.hasFuel.toggle()
                    waypoint.wrappedValue = w
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "fuelpump.fill")
                            .font(.system(size: 12))
                        Text("Fuel")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(waypoint.wrappedValue.hasFuel ? .white : CRBColors.textMuted)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(waypoint.wrappedValue.hasFuel ? CRBColors.activeOrange : CRBColors.searchBg)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                cellularSignalStrengthSelector(waypoint: waypoint)
            }
            labelWithIcon("Recommended Stay (Optional)", icon: "house")
            TextField("Add accommodation recommendation", text: waypoint.recommendedStay)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
        }
        .padding(12)
        .background(CRBColors.microTrackNested)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
    }

    /// Signal strength segmented control: tap bar N lights 1…N with solid fill. 1–2 = orange, 3–4 = yellow-green, 5 = bright green.
    private func signalFillColor(forSelected selected: Int) -> Color {
        if selected <= 0 { return CRBColors.searchBg }
        if selected <= 2 { return CRBColors.signalPoor }
        if selected <= 4 { return CRBColors.signalGood }
        return CRBColors.signalExcellent
    }

    private func cellularSignalStrengthSelector(waypoint: Binding<Waypoint>) -> some View {
        let selected = waypoint.wrappedValue.signalStrength
        let barHeights: [CGFloat] = [6, 10, 14, 18, 22]
        let barWidth: CGFloat = 5
        let gap: CGFloat = 4
        let activeColor = signalFillColor(forSelected: selected)
        return HStack(alignment: .bottom, spacing: 4) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(selected > 0 ? activeColor : CRBColors.textMuted)
            HStack(alignment: .bottom, spacing: gap) {
                ForEach(1...5, id: \.self) { level in
                    Button {
                        var w = waypoint.wrappedValue
                        w.signalStrength = level
                        waypoint.wrappedValue = w
                    } label: {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(level <= selected ? activeColor : CRBColors.searchBg)
                            .frame(width: barWidth, height: barHeights[level - 1])
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
    }

    private func timelineDashedLine(count: Int) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(CRBColors.activeOrange)
                    .frame(width: 10, height: 10)
                if i < count - 1 {
                    Path { p in
                        p.move(to: CGPoint(x: 1, y: 0))
                        p.addLine(to: CGPoint(x: 1, y: 28))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
                    .foregroundStyle(CRBColors.activeOrange)
                    .frame(width: 2, height: 28)
                }
            }
        }
        .padding(.leading, 20)
        .padding(.top, 24)
    }

    private func binding(for index: Int) -> Binding<JourneyStop> {
        Binding(
            get: { stops[index] },
            set: { stops[index] = $0 }
        )
    }

    /// 雙向綁定該 Day 的 selectedLocation，供 MapLocationPicker 即時寫回，發布驗證器可即時偵測 ✓。
    private func bindingLocation(for dayIndex: Int) -> Binding<RouteLocation?> {
        Binding(
            get: { dayIndex >= 0 && dayIndex < stops.count ? stops[dayIndex].selectedLocation : nil },
            set: { new in
                guard dayIndex >= 0, dayIndex < stops.count else { return }
                stops[dayIndex].selectedLocation = new
                stops[dayIndex].cityOrPark = new?.name ?? ""
            }
        )
    }

    private func dayCard(displayIndex: Int, arrayIndex: Int, stop: Binding<JourneyStop>) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Day \(displayIndex)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(CRBColors.activeOrange)
                    .clipShape(Capsule())
                Spacer()
                HStack(spacing: 12) {
                    if displayIndex == 1 {
                        Image(systemName: "flag.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(CRBColors.textMuted)
                    } else if stops.count > 1 {
                        Button {
                            deleteConfirmDayIndex = arrayIndex
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundStyle(CRBColors.textMuted)
                        }
                        .buttonStyle(DeleteButtonStyle())
                    }
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundStyle(CRBColors.textMuted)
                }
            }
            TextField("City or National Park", text: stop.cityOrPark)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))

            locationPickerRow(arrayIndex: arrayIndex, stop: stop)
            dateField(displayIndex: displayIndex, arrayIndex: arrayIndex, date: stop.date, dateWasPicked: stop.dateWasPicked)
            photoUploadZone(stopIndex: arrayIndex, stop: stop)
            TextField("What makes this stop special?", text: stop.briefNote, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .lineLimit(3...6)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            labelWithIcon("Recommended Stay (Optional)", icon: "house")
            TextField("Add accommodation recommendation", text: stop.recommendedStay)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            labelWithIcon("Recommendation link (e.g. Airbnb)", icon: "link")
            TextField("Button title (e.g. Book on Airbnb)", text: stop.recommendationTitle)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            TextField("URL (e.g. https://www.airbnb.com/...)", text: stop.recommendationLink)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
        }
        .padding(16)
        .background(CRBColors.cardNested)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
    }

    @ViewBuilder
    private func locationPickerRow(arrayIndex: Int, stop: Binding<JourneyStop>) -> some View {
        if let loc = stop.selectedLocation.wrappedValue {
            HStack(spacing: 8) {
                Text(loc.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(CRBColors.textPrimary)
                    .lineLimit(1)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(CRBColors.searchBg)
                    .clipShape(Capsule())
                Button {
                    stop.selectedLocation.wrappedValue = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(CRBColors.textMuted)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        } else {
            Button {
                locationPickerDayIndex = arrayIndex
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(CRBColors.activeOrange)
                    Text("Add Location")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(CRBColors.activeOrange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(CRBColors.searchBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func dateField(displayIndex: Int, arrayIndex: Int, date: Binding<Date>, dateWasPicked: Binding<Bool>) -> some View {
        if arrayIndex == 0 {
            day1DateField(date: date, dateWasPicked: dateWasPicked)
        } else {
            computedDateLabelView(label: computedDateLabel(forStopIndex: arrayIndex))
        }
    }

    private func day1DateField(date: Binding<Date>, dateWasPicked: Binding<Bool>) -> some View {
        let showPlaceholder = !dateWasPicked.wrappedValue
        return Button { datePickerStopIndex = 0 } label: {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(CRBColors.textMuted)
                if showPlaceholder {
                    Text("Select Date")
                        .font(.system(size: 15))
                        .foregroundStyle(CRBColors.textMuted)
                } else {
                    Text(date.wrappedValue, style: .date)
                        .font(.system(size: 15))
                        .foregroundStyle(CRBColors.textPrimary)
                }
                Spacer()
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(CRBColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func computedDateLabelView(label: String) -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundStyle(CRBColors.textMuted.opacity(0.8))
            Text(label)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textMuted)
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(CRBColors.searchBg.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .animation(.easeInOut(duration: 0.25), value: label)
    }

    private static let vehicleTypeOptions: [String] = VehicleOption.allCases.map(\.rawValue)

    private func vehicleTypeField(stopIndex: Int, value: Binding<String>) -> some View {
        let isOpen = openVehicleDropdownForStopIndex == stopIndex
        return Button {
            withAnimation(.easeOut(duration: 0.2)) {
                openVehicleDropdownForStopIndex = isOpen ? nil : stopIndex
            }
        } label: {
            HStack {
                Text(value.wrappedValue.isEmpty ? "Vehicle" : value.wrappedValue)
                    .font(.system(size: 15))
                    .foregroundStyle(value.wrappedValue.isEmpty ? CRBColors.textMuted : CRBColors.textPrimary)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(CRBColors.textMuted)
                    .rotationEffect(.degrees(isOpen ? 180 : 0))
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(CRBColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .zIndex(isOpen ? 99999 : 0)
        .overlay(alignment: .topLeading) {
            if isOpen {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                    vehicleTypeDropdownMenu(selected: value) {
                        withAnimation(.easeOut(duration: 0.2)) { openVehicleDropdownForStopIndex = nil }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .zIndex(99999)
            }
        }
        .animation(.easeOut(duration: 0.2), value: isOpen)
    }

    private func vehicleTypeDropdownMenu(selected: Binding<String>, onClose: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Self.vehicleTypeOptions, id: \.self) { option in
                Button {
                    selected.wrappedValue = option
                    onClose()
                } label: {
                    HStack(alignment: .center) {
                        Text(option)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(CRBColors.textPrimary)
                        Spacer(minLength: 8)
                        if selected.wrappedValue == option {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(CRBColors.activeOrange)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(VehicleOptionButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CRBColors.dropdownSolidBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.dropdownBorder, lineWidth: 1))
        .shadow(color: .black.opacity(0.8), radius: 30, x: 0, y: 10)
    }

    private func photoUploadZone(stopIndex: Int, stop: Binding<JourneyStop>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "camera")
                    .foregroundStyle(CRBColors.textMuted)
                Text("Photo")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(CRBColors.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            PhotosPicker(selection: bindingForStopPhotoItems(stopIndex), maxSelectionCount: 5, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                        .foregroundStyle(CRBColors.activeOrange.opacity(0.7))
                    if let img = stop.wrappedValue.photo ?? stop.wrappedValue.photos.first {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 100)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 32))
                                .foregroundStyle(CRBColors.textMuted)
                            Text("Add photos (up to 5)")
                                .font(.system(size: 14))
                                .foregroundStyle(CRBColors.textMuted)
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(CRBColors.searchBg.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .onChange(of: stopPhotoPickerArrays) { _, new in
                guard stopIndex < new.count, stopIndex < stops.count else { return }
                Task {
                    var loaded: [UIImage] = []
                    for item in new[stopIndex] {
                        if let data = try? await item.loadTransferable(type: Data.self), let ui = UIImage(data: data) {
                            loaded.append(ui)
                        }
                    }
                    await MainActor.run {
                        if stopIndex < stops.count {
                            stops[stopIndex].photos = loaded
                            stops[stopIndex].photo = loaded.first
                        }
                    }
                }
            }
        }
    }

    private func bindingForStopPhotoItem(_ index: Int) -> Binding<PhotosPickerItem?> {
        Binding(
            get: { index < stopPhotoPickerItems.count ? stopPhotoPickerItems[index] : nil },
            set: { new in
                if index >= stopPhotoPickerItems.count {
                    stopPhotoPickerItems.append(contentsOf: repeatElement(nil, count: index + 1 - stopPhotoPickerItems.count))
                }
                stopPhotoPickerItems[index] = new
            }
        )
    }

    private func bindingForStopPhotoItems(_ index: Int) -> Binding<[PhotosPickerItem]> {
        Binding(
            get: { index < stopPhotoPickerArrays.count ? stopPhotoPickerArrays[index] : [] },
            set: { new in
                while index >= stopPhotoPickerArrays.count { stopPhotoPickerArrays.append([]) }
                stopPhotoPickerArrays[index] = new
            }
        )
    }

    private var addStopButton: some View {
        Button {
    withAnimation(.easeOut(duration: 0.3)) {
                let startDate = stops.first?.date ?? Date()
                let nextDate = Calendar.current.date(byAdding: .day, value: stops.count, to: startDate) ?? startDate
                var newStop = JourneyStop()
                newStop.date = nextDate
                stops.append(newStop)
                while stopPhotoPickerItems.count < stops.count { stopPhotoPickerItems.append(nil) }
                while stopPhotoPickerArrays.count < stops.count { stopPhotoPickerArrays.append([]) }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                Text("Add Stop to Journey")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(CRBColors.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(CRBColors.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }

    // MARK: - Sticky Bottom Bar（overflow: hidden 摘要 + white-space: nowrap 按鈕，絕不重疊）
    private var stickyBottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .background(CRBColors.borderMuted)
            HStack(alignment: .center, spacing: 10) {
                // Left: summary — overflow: hidden, text-overflow: ellipsis, never overlap
                Text(summaryText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(CRBColors.textMuted)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.6)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(0)
                    .clipped()
                // Right: buttons — white-space: nowrap, flex-shrink: 0, never wrap
                HStack(alignment: .center, spacing: 8) {
                    Button { } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "eye")
                                .font(.system(size: 13))
                            Text("Preview")
                                .font(.system(size: 13, weight: .medium))
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundStyle(CRBColors.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        print("🚀 Publish Button Pressed!")
                        guard canPublish, let draft = buildDraftItemFromCurrentState() else {
                            if !canPublish { printMacroPublishValidation() }
                            return
                        }
                        let category: PostCategory = planningStyle == .macroJourney ? .grandJourney : .detailedTrack
                        let baseJourney: DetailedTrackPost = planningStyle == .macroJourney
                            ? draft.toManualJourney()
                            : {
                                var post = detailedTrack
                                post.routeID = draft.routeID
                                return post
                            }()
                        isPublishing = true
                        publishError = nil
                        Task {
                            do {
                                if category == .grandJourney {
                                    let macroImageData = collectMacroJPEGDataForCloudUpload()
                                    let cloudURLs = macroImageData.isEmpty ? [] : (try await SocialPublishService.shared.uploadAllJPEGData(macroImageData))
                                    var draftMut = draft
                                    let titleForMacro = journeyName.trimmingCharacters(in: .whitespaces).isEmpty ? draftMut.title : journeyName
                                    let day1Note = stops.first?.briefNote.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                    let coverSources = coverImages.isEmpty && coverImage != nil ? [coverImage!] : coverImages
                                    let coverCount = coverSources.count
                                    let photosPerDay = stops.map { stop in
                                        let imgs = stop.photos.isEmpty ? [stop.photo].compactMap { $0 } : stop.photos
                                        return imgs.count
                                    }
                                    let macro = SocialPublishService.shared.buildMacroForPublish(
                                        draft: draftMut,
                                        title: titleForMacro,
                                        description: day1Note,
                                        cloudURLs: cloudURLs,
                                        coverImageCount: coverCount,
                                        dayPhotoSlotCounts: photosPerDay
                                    )
                                    try await SocialPublishService.shared.publish(category: .communityMacro, macro: macro, micro: nil)
                                    if let macroData = try? JSONEncoder().encode(macro), let str = String(data: macroData, encoding: .utf8) {
                                        draftMut.macroJourneyJSON = str
                                    }
                                    let journeyLocal = draftMut.toManualJourney()
                                    await MainActor.run {
                                        finishPublishDraftToLocal(draft: draftMut, with: journeyLocal, category: category, cloudURLs: cloudURLs, isMacro: true)
                                    }
                                } else {
                                    let (microData, nodeCounts, hasCover) = collectMicroJPEGDataAndCountsForUpload(draft: draft, basePost: baseJourney)
                                    let cloudURLs = microData.isEmpty ? [] : (try await SocialPublishService.shared.uploadAllJPEGData(microData))
                                    let mergedJourney = mergeMicroJourneyWithCloudURLs(base: baseJourney, cloudURLs: cloudURLs, nodeCounts: nodeCounts, hasCover: hasCover)
                                    var draftToPublish = draft
                                    if let data = try? JSONEncoder().encode(mergedJourney), let str = String(data: data, encoding: .utf8) {
                                        draftToPublish.detailedTrackJSON = str
                                    }
                                    try await SocialPublishService.shared.publish(category: .communityMicro, macro: nil, micro: mergedJourney)
                                    await MainActor.run {
                                        finishPublishDraftToLocal(draft: draftToPublish, with: mergedJourney, category: category, cloudURLs: cloudURLs, isMacro: false)
                                    }
                                }
                            } catch {
                                await MainActor.run {
                                    publishError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                                    isPublishing = false
                                }
                            }
                        }
                    } label: {
                        Group {
                            if isPublishing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: CRBColors.textPrimary))
                                    .scaleEffect(0.9)
                            } else {
                                Text("Publish")
                                    .font(.system(size: 13, weight: .semibold))
                                    .lineLimit(1)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .foregroundStyle(canPublish ? CRBColors.textPrimary : CRBColors.textMuted)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(canPublish && !isPublishing ? CRBColors.activeOrange : CRBColors.inactivePill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(!canPublish || isPublishing)
                    .fixedSize(horizontal: true, vertical: false)
                    Button { } label: {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 16))
                            .foregroundStyle(CRBColors.textMuted)
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)
                }
                .fixedSize(horizontal: true, vertical: false)
                .layoutPriority(1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(CRBColors.background)
        }
        .zIndex(1000)
    }

    private func labelWithIcon(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(CRBColors.textMuted)
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(CRBColors.textPrimary)
        }
    }

}

// MARK: - State Multi-Selector (Macro Journey only: collapsible, multi-select, summary with abbreviations)
private struct StateMultiSelectorView: View {
    @Binding var selectedStates: Set<String>
    let stateList: [(name: String, abbr: String)]
    let accentColor: Color
    let backgroundColor: Color
    let textPrimary: Color
    let textMuted: Color
    let borderMuted: Color
    @State private var isExpanded: Bool = false

    private var summaryText: String {
        let abbrs = stateList
            .filter { selectedStates.contains($0.name) }
            .map(\.abbr)
        if abbrs.isEmpty { return "No states selected" }
        if abbrs.count <= 2 { return abbrs.joined(separator: ", ") }
        return abbrs.prefix(2).joined(separator: ", ") + " +\(abbrs.count - 2) more"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DisclosureGroup(isExpanded: $isExpanded) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 140), spacing: 10),
                    GridItem(.adaptive(minimum: 140), spacing: 10)
                ], spacing: 10) {
                    ForEach(stateList, id: \.name) { item in
                        let isSelected = selectedStates.contains(item.name)
                        Button {
                            if isSelected {
                                selectedStates.remove(item.name)
                            } else {
                                selectedStates.insert(item.name)
                            }
                        } label: {
                            Text(item.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(isSelected ? .white : textMuted)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(isSelected ? accentColor : Color(hex: "1A2332"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(isSelected ? accentColor.opacity(0.6) : borderMuted, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 12)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(accentColor)
                    Text("Select States")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(textPrimary)
                    Spacer()
                    if !isExpanded {
                        Text(summaryText)
                            .font(.system(size: 13))
                            .foregroundStyle(textMuted)
                            .lineLimit(1)
                    }
                }
                .padding(.vertical, 4)
            }
            .tint(accentColor)
        }
        .padding(16)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(borderMuted, lineWidth: 1))
    }
}

// MARK: - AmenityCapsule (Water / Fuel): 膠囊內顯示圖示+文字，選中時藍/橙底+白字，未選中灰底+灰字
private struct AmenityCapsule: View {
    let icon: String
    let label: String
    let color: Color
    let borderColor: Color
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .foregroundStyle(isSelected ? Color.white : CRBColors.textMuted)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? color : CRBColors.searchBg)
        .overlay(Capsule().strokeBorder(isSelected ? borderColor : CRBColors.borderMuted, lineWidth: 1))
        .clipShape(Capsule())
    }
}

private extension Color {
    func contrastWithWhite() -> Color {
        self
    }
}

// MARK: - SignalStrengthBar: 5 格，前 signalStrength 格橘色，其餘灰
private struct SignalStrengthBar: View {
    @Binding var strength: Int
    private let totalBars = 5
    private let activeColor = Color(hex: "FF8C42")
    private let inactiveColor = Color(hex: "374151")

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<totalBars, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index < strength ? activeColor : inactiveColor)
                    .frame(width: 14, height: 10)
                    .onTapGesture { strength = index + 1 }
            }
        }
    }
}

// MARK: - Vehicle Option Row（按下時淺色高亮）
private struct VehicleOptionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? CRBColors.searchBg : Color.clear)
    }
}

// MARK: - Location Manager (user GPS for map fallback)
private final class DropPinLocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    private let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
}
extension DropPinLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // keep existing fallback
    }
}

// MARK: - Location Picker View (Drop Pin 彈窗：用戶位置起點、自由縮放/移動、MapReader + onTapGesture 插旗)
struct LocationPickerView: View {
    var initialLat: Double
    var initialLon: Double
    var onConfirm: (CLLocationCoordinate2D) -> Void
    var onCancel: () -> Void

    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var cameraPosition: MapCameraPosition

    private let accentOrange = Color(hex: "FF8C42")

    init(initialLat: Double, initialLon: Double, onConfirm: @escaping (CLLocationCoordinate2D) -> Void, onCancel: @escaping () -> Void) {
        self.initialLat = initialLat
        self.initialLon = initialLon
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        _cameraPosition = State(initialValue: .userLocation(followsHeading: false, fallback: .automatic))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Drop Pin on Map")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(CRBColors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
            Text("Starts at your location. Pinch to zoom, drag to pan. Tap to place the pin, then Confirm Location.")
                .font(.system(size: 13))
                .foregroundStyle(CRBColors.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 4)
            MapReader { proxy in
                Map(position: $cameraPosition, interactionModes: .all) {
                    if let coord = selectedCoordinate {
                        Marker("View Point", coordinate: coord)
                            .tint(accentOrange)
                    }
                }
                .mapStyle(.standard)
                .onTapGesture(count: 1, coordinateSpace: .local) { screenPoint in
                    if let coord = proxy.convert(screenPoint, from: .local) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            selectedCoordinate = coord
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack(spacing: 16) {
                Button("Cancel") {
                    onCancel()
                }
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(CRBColors.textMuted)
                .frame(maxWidth: .infinity)

                Button("Confirm Location") {
                    guard let coord = selectedCoordinate else { return }
                    onConfirm(coord)
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(selectedCoordinate != nil ? .white : CRBColors.textMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(selectedCoordinate != nil ? accentOrange : Color(hex: "2A3540"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(selectedCoordinate == nil)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(CRBColors.background)
        }
        .background(CRBColors.background)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Drop Pin Map Sheet (full-screen map; init: waypoint coords → user GPS → previous waypoint; never 0,0)
private struct DropPinMapSheetView: View {
    var initialLat: Double
    var initialLon: Double
    var fallbackCenter: CLLocationCoordinate2D?
    var onConfirm: (CLLocationCoordinate2D) -> Void
    var onCancel: () -> Void
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @StateObject private var locationManager = DropPinLocationManager()
    @State private var mapCenter: CLLocationCoordinate2D
    private static let defaultCenter = CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5)
    init(initialLat: Double, initialLon: Double, fallbackCenter: CLLocationCoordinate2D?, onConfirm: @escaping (CLLocationCoordinate2D) -> Void, onCancel: @escaping () -> Void) {
        self.initialLat = initialLat
        self.initialLon = initialLon
        self.fallbackCenter = fallbackCenter
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        let hasValidInitial = (initialLat != 0 || initialLon != 0)
        _mapCenter = State(initialValue: hasValidInitial ? CLLocationCoordinate2D(latitude: initialLat, longitude: initialLon) : (fallbackCenter ?? Self.defaultCenter))
    }
    private var displayCoordinate: CLLocationCoordinate2D {
        selectedCoordinate ?? CLLocationCoordinate2D(latitude: initialLat, longitude: initialLon)
    }

    var body: some View {
        NavigationStack {
            dropPinMapReader
                .onAppear {
                    if initialLat == 0 && initialLon == 0 {
                        locationManager.requestLocation()
                    }
                }
                .onChange(of: locationManager.location) { _, new in
                    if initialLat == 0 && initialLon == 0, let c = new?.coordinate {
                        withAnimation(.easeOut(duration: 0.35)) { mapCenter = c }
                    }
                }
                .ignoresSafeArea(.container)
                .navigationTitle("Drop Pin")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(CRBColors.background, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar { dropPinToolbarContent }
                .preferredColorScheme(.dark)
        }
    }

    private var dropPinMapReader: some View {
        MapReader { proxy in
            dropPinMapStack(proxy: proxy)
        }
    }

    private func dropPinMapStack(proxy: MapProxy) -> some View {
        ZStack(alignment: .bottomTrailing) {
            dropPinMapWithAnnotation
            MapUserLocationButton()
                .padding(.trailing, 16)
                .padding(.bottom, 24)
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .named("dropPinMap"))
                        .onEnded { value in
                            let pt = value.startLocation
                            if let coord = proxy.convert(pt, from: .named("dropPinMap")) {
                                selectedCoordinate = coord
                            }
                        }
                )
        }
        .coordinateSpace(name: "dropPinMap")
    }

    private var dropPinMapWithAnnotation: some View {
        Map(initialPosition: .region(MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))), interactionModes: .all) {
            Annotation("", coordinate: displayCoordinate) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(CRBColors.activeOrange)
            }
        }
        .mapStyle(.standard)
    }

    @ToolbarContentBuilder
    private var dropPinToolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { onCancel() }
                .foregroundStyle(CRBColors.textMuted)
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Confirm") {
                onConfirm(selectedCoordinate ?? CLLocationCoordinate2D(latitude: initialLat, longitude: initialLon))
            }
            .foregroundStyle(CRBColors.activeOrange)
        }
    }
}

// MARK: - Delete Button Style（預設灰，按下變紅）
private struct DeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? Color(hex: "EF4444") : CRBColors.textMuted)
    }
}

// MARK: - Date Picker Sheet（深色 + 橙色選中，僅 Day 1，支援 Clear）
private struct DatePickerSheet: View {
    @Binding var date: Date
    var onDismiss: (Bool) -> Void
    var body: some View {
        NavigationStack {
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(CRBColors.activeOrange)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(CRBColors.background)
                .foregroundStyle(CRBColors.textPrimary)
            .navigationTitle("Day 1 – Start Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        date = Date()
                        onDismiss(true)
                    }
                    .foregroundStyle(CRBColors.textMuted)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { onDismiss(false) }
                        .foregroundStyle(CRBColors.activeOrange)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - 編輯頁彈出用數據（item 有值才彈出，避免黑屏）
private struct PostEditorSheetItem: Identifiable {
    let id = UUID()
    let draft: LiveTrackDraft
    let distanceMeters: Double
    let elevationMeters: Double
    let durationSeconds: TimeInterval
    let defaultTitle: String
}

// MARK: - Live Track Recording View (Record Live Track → Save as Draft)
struct LiveTrackRecordingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var tracker = LiveTrackLocationTracker()
    @State private var showResumeAlert = false
    @State private var showSavedDraftAlert = false
    @State private var showDraftBox = false
    @State private var mapPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))
    @State private var hasInitialFocus = false
    @State private var editorSheetItem: PostEditorSheetItem?
    @State private var finishedJourney: ManualJourney?
    @State private var navigateToDetail = false
    @State private var showCancelConfirm = false

    var body: some View {
        ZStack(alignment: .top) {
            liveTrackMap
            liveTrackStatsOverlay
            liveTrackFloatingControls
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CRBColors.background)
        .navigationBarBackButtonHidden(true)
        .onChange(of: tracker.breadcrumbPointCount) { _, newCount in
            if !hasInitialFocus && newCount >= 1 {
                hasInitialFocus = true
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    mapPosition = .userLocation(followsHeading: false, fallback: .automatic)
                }
            }
        }
        .confirmationDialog("Exit recording?", isPresented: $showCancelConfirm, titleVisibility: .visible) {
            Button("Save to Draft") {
                saveRecordingToDraftAndExit()
            }
            Button("Discard", role: .destructive) {
                tracker.stopRecording()
                showCancelConfirm = false
                dismiss()
            }
            Button("Resume", role: .cancel) {
                showCancelConfirm = false
            }
        } message: {
            Text("Save your current track to Draft Box (Live Recorded) to edit later, or discard and exit.")
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { showCancelConfirm = true }
                    .foregroundStyle(CRBColors.textMuted)
            }
            if tracker.hasRecordedTrack, !tracker.isRecording {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Stop & Edit") {
                        tracker.stopRecording()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            let draft = tracker.buildDraft()
                            let distance = tracker.totalDistanceMeters
                            let elevation = tracker.currentElevation
                            let duration = tracker.elapsedSeconds
                            Task {
                                let title = await geocodeDefaultTitle(draft: draft)
                                await MainActor.run {
                                    editorSheetItem = PostEditorSheetItem(
                                        draft: draft,
                                        distanceMeters: distance,
                                        elevationMeters: elevation,
                                        durationSeconds: duration,
                                        defaultTitle: title
                                    )
                                }
                            }
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(CRBColors.activeOrange)
                }
            }
        }
        .onAppear {
            tracker.requestAuthorization()
            if tracker.hasRecoveryData {
                showResumeAlert = true
            }
        }
        .alert("Resume Recording?", isPresented: $showResumeAlert) {
            Button("Resume") {
                tracker.resumeFromRecovery()
                showResumeAlert = false
            }
            Button("Start New", role: .destructive) {
                tracker.clearRecovery()
                showResumeAlert = false
            }
            Button("Cancel", role: .cancel) {
                showResumeAlert = false
            }
        } message: {
            Text("A previous recording was saved. Resume or start a new one?")
        }
        .alert("Saved to Drafts", isPresented: $showSavedDraftAlert) {
            Button("View Drafts") {
                showSavedDraftAlert = false
                showDraftBox = true
            }
            Button("Back to Home") {
                showSavedDraftAlert = false
                dismiss()
            }
        } message: {
            Text("Your recording has been saved. You can view it later in your Drafts folder.")
        }
        .fullScreenCover(isPresented: $showDraftBox) {
            UnifiedDraftBoxView()
                .environmentObject(TrackDataManager.shared)
                .onDisappear { showDraftBox = false }
        }
        .fullScreenCover(item: $editorSheetItem) { item in
            PostEditorView(
                draft: item.draft,
                distanceMeters: item.distanceMeters,
                elevationMeters: item.elevationMeters,
                durationSeconds: item.durationSeconds,
                sportType: .hiking,
                initialTitle: item.defaultTitle.isEmpty ? nil : item.defaultTitle,
                onSaveToDrafts: { title in
                    item.draft.saveToUserDefaults()
                    let draftItem = DraftItem.fromLiveTrack(waypoints: item.draft.waypoints, polyline: tracker.fullBreadcrumbPolyline, durationSeconds: item.durationSeconds, title: title.isEmpty ? nil : title)
                    TrackDataManager.shared.addDraft(draftItem)
                    AchievementStore.onRecordStopped(waypoints: item.draft.waypoints)
                    editorSheetItem = nil
                    showSavedDraftAlert = true
                },
                onPublish: { _ in },
                onPublishComplete: { editorSheetItem = nil }
            )
        }
        .preferredColorScheme(.dark)
    }

    private func geocodeDefaultTitle(draft: LiveTrackDraft) async -> String {
        guard let lastPoint = draft.waypoints.last else {
            return "\(dateString) · Hiking"
        }
        let loc = CLLocation(latitude: lastPoint.latitude, longitude: lastPoint.longitude)
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(loc)
            let name = placemarks.first?.locality ?? placemarks.first?.administrativeArea ?? placemarks.first?.name
            if let n = name, !n.isEmpty {
                return "\(n) · \(dateString) · Hiking"
            }
        } catch {}
        return "\(dateString) · Hiking"
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: Date())
    }

    private var defaultManualJourney: ManualJourney {
        DetailedTrackPost(routeName: "", totalDurationMinutes: 0, viewPointNodes: [])
    }

    /// Cancel dialog "Save to Draft": add to DataManager.draftTracks, then dismiss (Draft Box reads draftTracks).
    private func saveRecordingToDraftAndExit() {
        let draft = tracker.buildDraft()
        let item = DraftItem.fromLiveTrack(
            waypoints: draft.waypoints,
            polyline: tracker.fullBreadcrumbPolyline,
            durationSeconds: tracker.elapsedSeconds
        )
        tracker.stopRecording()
        TrackDataManager.shared.addDraft(item)
        showCancelConfirm = false
        dismiss()
    }

    private var liveTrackMap: some View {
        Map(position: $mapPosition, interactionModes: .all) {
            UserAnnotation()
            ForEach(Array(tracker.breadcrumbSegmentsForMap.enumerated()), id: \.offset) { _, item in
                MapPolyline(coordinates: item.coords)
                    .stroke(item.color, lineWidth: 4)
            }
            ForEach(Array(tracker.waypoints.enumerated()), id: \.offset) { idx, pt in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: pt.latitude, longitude: pt.longitude)) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(idx == 0 ? Color(hex: "10B981") : CRBColors.activeOrange)
                }
            }
        }
        .mapStyle(.standard)
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    mapPosition = .userLocation(followsHeading: false, fallback: .automatic)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.95))
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                    Circle()
                        .stroke(Color(hex: "10B981").opacity(0.4), lineWidth: 1)
                        .frame(width: 52, height: 52)
                    Image(systemName: "location.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color(hex: "10B981"))
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
            .padding(.bottom, 130)
        }
        .onAppear { mapPosition = .region(tracker.mapRegion) }
        .onReceive(tracker.$mapRegion) { mapPosition = .region($0) }
        .ignoresSafeArea(.container)
    }

    private var liveTrackStatsOverlay: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                statCard(icon: "clock.fill", value: tracker.elapsedTimeFormatted, label: "Elapsed")
                statCard(icon: "arrow.triangle.swap", value: tracker.distanceFormatted, label: "Distance")
                statCard(icon: "arrow.up.right", value: tracker.elevationFormatted, label: "Elevation")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top, 16)
            .padding(.horizontal, 20)
            if tracker.elevationProfileLast1km.count >= 2 {
                LiveTrackElevationProfileView(points: tracker.elevationProfileLast1km)
                    .frame(height: 28)
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
            }
            Spacer()
        }
    }

    private func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "10B981"))
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(CRBColors.textPrimary)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(CRBColors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private var liveTrackFloatingControls: some View {
        VStack {
            Spacer()
            Button {
                if tracker.isRecording {
                    tracker.stopRecording()
                } else {
                    tracker.startRecording()
                }
            } label: {
                Image(systemName: tracker.isRecording ? "pause.fill" : "play.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .background(
                        (tracker.isRecording ? Color(hex: "EF4444") : Color(hex: "10B981"))
                            .opacity(0.92),
                        in: Circle()
                    )
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.4), lineWidth: 1))
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 44)
        }
    }
}

// MARK: - Live Track Elevation Profile (last 1 km)
private struct LiveTrackElevationProfileView: View {
    let points: [(distance: Double, elevation: Double)]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let distMax = points.last?.distance ?? 1
            let distRangeSafe = max(1, distMax)
            let elevMin = points.map(\.elevation).min() ?? 0
            let elevMax = points.map(\.elevation).max() ?? elevMin + 1
            let elevRange = max(1, elevMax - elevMin)
            Path { path in
                guard points.count >= 2 else { return }
                let first = points[0]
                path.move(to: CGPoint(x: w * CGFloat(first.distance / distRangeSafe), y: h - h * CGFloat((first.elevation - elevMin) / elevRange)))
                for pt in points.dropFirst() {
                    let x = w * CGFloat(pt.distance / distRangeSafe)
                    let y = h - h * CGFloat((pt.elevation - elevMin) / elevRange)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(
                LinearGradient(
                    colors: [Color(hex: "10B981").opacity(0.6), CRBColors.activeOrange.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 2
            )
        }
        .background(CRBColors.cardNested.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Breadcrumb segment for map (speed-based color)
private struct BreadcrumbSegmentForMap {
    let coords: [CLLocationCoordinate2D]
    let color: Color
}

// MARK: - Live Track Location Tracker
private final class LiveTrackLocationTracker: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var waypoints: [(latitude: Double, longitude: Double, elevation: Double, timestamp: Date)] = []
    @Published var totalDistanceMeters: Double = 0
    @Published var currentElevation: Double = 0
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    /// 軌跡點數量（用於進場自動對焦：收到 ≥1 點即對焦一次）
    @Published var breadcrumbPointCount: Int = 0

    private let locationManager = CLLocationManager()
    private var recordingStartDate: Date?
    private var lastLocation: CLLocation?
    private var lastWaypointLocation: CLLocation?
    private var lastWaypointTime: Date?
    private var timer: Timer?
    private var autoSaveTimer: Timer?
    private let autoWaypointDistanceMeters: Double = 500
    private let autoWaypointStopDurationSeconds: TimeInterval = 120

    /// Breadcrumb trail: every point with cumulative distance and speed (m/s) for dynamic trace
    private var breadcrumbTrail: [(latitude: Double, longitude: Double, elevation: Double, cumulativeDistance: Double, speed: Double)] = []
    /// Stationary filter: do not add distance when movement is likely GPS drift
    private let stationaryDistanceThreshold: Double = 3
    private let stationaryAccuracyThreshold: Double = 25
    private var stationarySince: Date?
    private let minMovementToResetStationary: Double = 5
    private static let recoveryKey = "LiveTrackRecovery"
    private let autoSaveInterval: TimeInterval = 30

    var elapsedTimeFormatted: String {
        let mins = Int(elapsedSeconds) / 60
        let secs = Int(elapsedSeconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }

    var distanceFormatted: String {
        if totalDistanceMeters < 1000 {
            return String(format: "%.0f m", totalDistanceMeters)
        }
        return String(format: "%.2f km", totalDistanceMeters / 1000)
    }

    var elevationFormatted: String {
        if currentElevation > 0 {
            return String(format: "%.0f m", currentElevation)
        }
        return "—"
    }

    /// Segments of the breadcrumb trail colored by speed (fast = green, slow = red)
    var breadcrumbSegmentsForMap: [BreadcrumbSegmentForMap] {
        guard breadcrumbTrail.count >= 2 else { return [] }
        var segments: [BreadcrumbSegmentForMap] = []
        var currentCoords: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: breadcrumbTrail[0].latitude, longitude: breadcrumbTrail[0].longitude)]
        var currentSpeed = breadcrumbTrail[0].speed
        func colorForSpeed(_ s: Double) -> Color {
            if s >= 1.2 { return Color(hex: "10B981") }
            if s >= 0.5 { return Color(hex: "EAB308") }
            return Color(hex: "EF4444")
        }
        for i in 1..<breadcrumbTrail.count {
            let pt = breadcrumbTrail[i]
            let speed = pt.speed
            if abs(speed - currentSpeed) < 0.2 && !currentCoords.isEmpty {
                currentCoords.append(CLLocationCoordinate2D(latitude: pt.latitude, longitude: pt.longitude))
            } else {
                if currentCoords.count >= 2 {
                    segments.append(BreadcrumbSegmentForMap(coords: currentCoords, color: colorForSpeed(currentSpeed)))
                }
                currentCoords = [CLLocationCoordinate2D(latitude: pt.latitude, longitude: pt.longitude)]
                currentSpeed = speed
            }
        }
        if currentCoords.count >= 2 {
            segments.append(BreadcrumbSegmentForMap(coords: currentCoords, color: colorForSpeed(currentSpeed)))
        }
        return segments
    }

    /// Last 1 km of trail for elevation profile: (distance from end of 1km window, elevation)
    var elevationProfileLast1km: [(distance: Double, elevation: Double)] {
        let oneKm = 1000.0
        guard let total = breadcrumbTrail.last?.cumulativeDistance, total > 0 else { return [] }
        let startDist = max(0, total - oneKm)
        let points = breadcrumbTrail.filter { $0.cumulativeDistance >= startDist }
        return points.map { ($0.cumulativeDistance - startDist, $0.elevation) }
    }

    var hasRecordedTrack: Bool { !waypoints.isEmpty }

    var hasRecoveryData: Bool {
        UserDefaults.standard.data(forKey: Self.recoveryKey) != nil
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    func startRecording() {
        guard !isRecording else { return }
        waypoints = []
        breadcrumbTrail = []
        breadcrumbPointCount = 0
        totalDistanceMeters = 0
        currentElevation = 0
        elapsedSeconds = 0
        lastLocation = nil
        lastWaypointLocation = nil
        lastWaypointTime = nil
        stationarySince = nil
        recordingStartDate = Date()
        isRecording = true
        locationManager.startUpdatingLocation()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.current.add(timer!, forMode: .common)
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: autoSaveInterval, repeats: true) { [weak self] _ in
            self?.performAutoSave()
        }
        RunLoop.current.add(autoSaveTimer!, forMode: .common)
    }

    func stopRecording() {
        guard isRecording else { return }
        isRecording = false
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        autoSaveTimer?.invalidate()
        autoSaveTimer = nil
        clearRecovery()
    }

    func clearRecovery() {
        UserDefaults.standard.removeObject(forKey: Self.recoveryKey)
    }

    func resumeFromRecovery() {
        guard let data = UserDefaults.standard.data(forKey: Self.recoveryKey),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let wpArray = dict["waypoints"] as? [[String: Any]],
              let totalDist = dict["totalDistanceMeters"] as? Double,
              let startStamp = dict["recordingStartDate"] as? Double else { return }
        waypoints = wpArray.compactMap { w in
            guard let lat = w["lat"] as? Double, let lon = w["lon"] as? Double,
                  let elev = w["elevation"] as? Double, let ts = w["timestamp"] as? Double else { return nil }
            return (latitude: lat, longitude: lon, elevation: elev, timestamp: Date(timeIntervalSince1970: ts))
        }
        if let trailData = dict["breadcrumbTrail"] as? [[String: Any]] {
            breadcrumbTrail = trailData.compactMap { t in
                guard let lat = t["lat"] as? Double, let lon = t["lon"] as? Double,
                      let elev = t["elevation"] as? Double,
                      let cum = t["cumulativeDistance"] as? Double, let sp = t["speed"] as? Double else { return nil }
                return (latitude: lat, longitude: lon, elevation: elev, cumulativeDistance: cum, speed: sp)
            }
            breadcrumbPointCount = breadcrumbTrail.count
        }
        totalDistanceMeters = totalDist
        recordingStartDate = Date(timeIntervalSince1970: startStamp)
        elapsedSeconds = Date().timeIntervalSince(recordingStartDate!)
        lastWaypointLocation = waypoints.last.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        lastLocation = lastWaypointLocation
        lastWaypointTime = waypoints.isEmpty ? nil : Date()
        isRecording = true
        locationManager.startUpdatingLocation()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in self?.tick() }
        RunLoop.current.add(timer!, forMode: .common)
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: autoSaveInterval, repeats: true) { [weak self] _ in self?.performAutoSave() }
        RunLoop.current.add(autoSaveTimer!, forMode: .common)
        updateMapRegion()
    }

    private func performAutoSave() {
        guard isRecording else { return }
        let dict: [String: Any] = [
            "recordingStartDate": recordingStartDate?.timeIntervalSince1970 ?? 0,
            "totalDistanceMeters": totalDistanceMeters,
            "waypoints": waypoints.map { ["lat": $0.latitude, "lon": $0.longitude, "elevation": $0.elevation, "timestamp": $0.timestamp.timeIntervalSince1970] },
            "breadcrumbTrail": breadcrumbTrail.map { ["lat": $0.latitude, "lon": $0.longitude, "elevation": $0.elevation, "cumulativeDistance": $0.cumulativeDistance, "speed": $0.speed] }
        ]
        if let data = try? JSONSerialization.data(withJSONObject: dict) {
            UserDefaults.standard.set(data, forKey: Self.recoveryKey)
        }
    }

    func buildDraft() -> LiveTrackDraft {
        LiveTrackDraft(waypoints: waypoints)
    }

    var fullBreadcrumbPolyline: [CLLocationCoordinate2D] {
        breadcrumbTrail.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private func tick() {
        guard let start = recordingStartDate else { return }
        elapsedSeconds = Date().timeIntervalSince(start)
    }

    private func addWaypoint(from location: CLLocation) {
        let pt = (
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            elevation: location.altitude,
            timestamp: Date()
        )
        waypoints.append(pt)
        lastWaypointLocation = location
        lastWaypointTime = Date()
        updateMapRegion()
    }

    private func addBreadcrumb(lat: Double, lon: Double, elevation: Double, cumulativeDistance: Double, speed: Double) {
        breadcrumbTrail.append((latitude: lat, longitude: lon, elevation: elevation, cumulativeDistance: cumulativeDistance, speed: speed))
        DispatchQueue.main.async { [weak self] in
            self?.breadcrumbPointCount = self?.breadcrumbTrail.count ?? 0
        }
    }

    private func updateMapRegion() {
        let allLats = breadcrumbTrail.map(\.latitude) + waypoints.map(\.latitude)
        let allLons = breadcrumbTrail.map(\.longitude) + waypoints.map(\.longitude)
        guard !allLats.isEmpty, !allLons.isEmpty else { return }
        let minLat = allLats.min() ?? 0
        let maxLat = allLats.max() ?? 0
        let minLon = allLons.min() ?? 0
        let maxLon = allLons.max() ?? 0
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.01, (maxLat - minLat) * 1.5 + 0.005),
            longitudeDelta: max(0.01, (maxLon - minLon) * 1.5 + 0.005)
        )
        mapRegion = MKCoordinateRegion(center: center, span: span)
    }

    private func processLocation(_ location: CLLocation) {
        currentElevation = location.altitude
        let accuracy = location.horizontalAccuracy
        let speed = location.speed >= 0 ? location.speed : 0

        if waypoints.isEmpty {
            addWaypoint(from: location)
            lastLocation = location
            addBreadcrumb(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude,
                elevation: location.altitude,
                cumulativeDistance: 0,
                speed: speed
            )
            return
        }

        let distanceFromLast = lastLocation.map { location.distance(from: $0) } ?? 0
        let isLikelyDrift = distanceFromLast < stationaryDistanceThreshold && (accuracy < 0 || accuracy > stationaryAccuracyThreshold)
        let isMovingSlow = speed < 0.2

        if isLikelyDrift || (isMovingSlow && distanceFromLast < minMovementToResetStationary) {
            if stationarySince == nil { stationarySince = Date() }
            lastLocation = location
            addBreadcrumb(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude,
                elevation: location.altitude,
                cumulativeDistance: totalDistanceMeters,
                speed: speed
            )
            return
        }
        if distanceFromLast >= minMovementToResetStationary { stationarySince = nil }

        totalDistanceMeters += distanceFromLast
        lastLocation = location
        addBreadcrumb(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude,
            elevation: location.altitude,
            cumulativeDistance: totalDistanceMeters,
            speed: speed
        )

        if let lastWp = lastWaypointLocation {
            let distFromLastWp = location.distance(from: lastWp)
            if distFromLastWp >= autoWaypointDistanceMeters {
                addWaypoint(from: location)
                return
            }
        }

        if speed < 0.5 {
            if let lastTime = lastWaypointTime {
                if Date().timeIntervalSince(lastTime) >= autoWaypointStopDurationSeconds {
                    addWaypoint(from: location)
                }
            } else {
                lastWaypointTime = Date()
            }
        } else {
            lastWaypointTime = nil
        }
    }
}

extension LiveTrackLocationTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isRecording, let location = locations.last, location.horizontalAccuracy >= 0 else { return }
        DispatchQueue.main.async { [weak self] in
            self?.processLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

// MARK: - Location Search Manager（防抖 0.3s、美國限定、過濾非美國結果）
private final class LocationSearchManager: NSObject, ObservableObject {
    private let completer = MKLocalSearchCompleter()
    private var debounceWorkItem: DispatchWorkItem?
    private let debounceInterval: TimeInterval = 0.3

    @Published private(set) var results: [MKLocalSearchCompletion] = []
    @Published private(set) var isSearching = false

    var queryFragment: String = "" {
        didSet {
            debounceWorkItem?.cancel()
            let query = queryFragment
            let item = DispatchWorkItem { [weak self] in
                self?.isSearching = true
                self?.completer.queryFragment = query
            }
            debounceWorkItem = item
            DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: item)
        }
    }

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.pointOfInterest, .query]
        let usCenter = CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5)
        completer.region = MKCoordinateRegion(center: usCenter, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    }

    func resolve(completion: MKLocalSearchCompletion, usOnly: Bool = true, completionHandler: @escaping ((name: String, coordinate: CLLocationCoordinate2D)?) -> Void) {
        let request = MKLocalSearch.Request(completion: completion)
        MKLocalSearch(request: request).start { response, _ in
            guard let mapItem = response?.mapItems.first else { DispatchQueue.main.async { completionHandler(nil) }; return }
            if usOnly, let code = mapItem.placemark.countryCode, code != "US" {
                DispatchQueue.main.async { completionHandler(nil) }; return
            }
            let name = mapItem.name ?? mapItem.placemark.name ?? completion.title
            let coord = mapItem.placemark.coordinate
            DispatchQueue.main.async { completionHandler((name, coord)) }
        }
    }
}

extension LocationSearchManager: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async { [weak self] in
            self?.isSearching = false
            self?.results = completer.results
        }
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in self?.isSearching = false }
    }
}

// MARK: - Map Location Picker（極簡 UI：搜尋框 + 輸入時 List / 否則 Map，Binding 區域，Confirm 回傳）
struct MapLocationPickerView: View {
    @Binding var selectedLocation: RouteLocation?
    var onDismiss: () -> Void

    @StateObject private var searchManager = LocationSearchManager()
    @State private var searchText = ""
    @State private var pinCoordinate: CLLocationCoordinate2D?
    @State private var cameraPosition: MapCameraPosition
    @State private var pendingName: String?
    @State private var isResolving = false
    private let geocoder = CLGeocoder()
    private static let defaultCenter = CLLocationCoordinate2D(latitude: 44.35, longitude: -68.21)
    private static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)

    init(selectedLocation: Binding<RouteLocation?>, onDismiss: @escaping () -> Void) {
        _selectedLocation = selectedLocation
        self.onDismiss = onDismiss
        let initial = selectedLocation.wrappedValue.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) } ?? Self.defaultCenter
        _cameraPosition = State(initialValue: .region(MKCoordinateRegion(center: initial, span: Self.defaultSpan)))
    }

    private var effectiveCoordinate: CLLocationCoordinate2D {
        pinCoordinate ?? (selectedLocation.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) } ?? Self.defaultCenter)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchField
                if showSuggestions {
                    suggestionsList
                } else {
                    mapContent
                }
            }
            .background(CRBColors.background)
            .navigationTitle("Add Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { onDismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm Location") { confirmAndDismiss() }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(CRBColors.activeOrange)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: searchText) { _, newValue in
            searchManager.queryFragment = newValue
        }
    }

    private var showSuggestions: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var searchField: some View {
        TextField("Search city or place…", text: $searchText)
            .textFieldStyle(.plain)
            .font(.system(size: 16))
            .foregroundStyle(CRBColors.textPrimary)
            .padding(12)
            .background(CRBColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
    }

    private var suggestionsList: some View {
        Group {
            if searchManager.isSearching {
                HStack(spacing: 8) {
                    ProgressView().tint(CRBColors.activeOrange)
                    Text("Searching…").font(.system(size: 14)).foregroundStyle(CRBColors.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                List {
                    ForEach(Array(searchManager.results.enumerated()), id: \.offset) { _, completion in
                        Button {
                            selectCompletion(completion)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(completion.title).font(.system(size: 16, weight: .medium)).foregroundStyle(CRBColors.textPrimary)
                                if !completion.subtitle.isEmpty {
                                    Text(completion.subtitle).font(.system(size: 13)).foregroundStyle(CRBColors.textMuted)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(CRBColors.cardBg)
                    }
                    if searchManager.results.isEmpty {
                        Text("No US results").font(.system(size: 14)).foregroundStyle(CRBColors.textMuted)
                            .listRowBackground(CRBColors.cardBg)
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(maxHeight: 280)
    }

    private var mapContent: some View {
        VStack(spacing: 0) {
            MapReader { proxy in
                ZStack(alignment: .center) {
                    Map(position: $cameraPosition, interactionModes: .all) {
                        Annotation("", coordinate: effectiveCoordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(CRBColors.activeOrange)
                        }
                    }
                    .mapStyle(.standard)
                    Color.clear
                        .contentShape(Rectangle())
                        .coordinateSpace(name: "mapTap")
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("mapTap"))
                                .onEnded { value in
                                    guard hypot(value.translation.width, value.translation.height) < 15,
                                          let coord = proxy.convert(value.startLocation, from: .named("mapTap")) else { return }
                                    pendingName = nil
                                    pinCoordinate = coord
                                }
                        )
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.4)
                                .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .named("mapTap")))
                                .onEnded { value in
                                    if case .second(true, let drag?) = value,
                                       let coord = proxy.convert(drag.startLocation, from: .named("mapTap")) {
                                        pendingName = nil
                                        pinCoordinate = coord
                                    }
                                }
                        )
                }
            }
            .frame(minHeight: 280)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            if isResolving {
                HStack(spacing: 8) {
                    ProgressView().tint(CRBColors.activeOrange)
                    Text("Getting address…").font(.system(size: 14)).foregroundStyle(CRBColors.textMuted)
                }
                .padding(.bottom, 8)
            }
        }
    }

    private func selectCompletion(_ completion: MKLocalSearchCompletion) {
        searchManager.resolve(completion: completion, usOnly: true) { [self] result in
            guard let result = result else { return }
            pendingName = result.name
            pinCoordinate = result.coordinate
            searchText = ""
            withAnimation(.easeInOut(duration: 0.3)) {
                cameraPosition = .region(MKCoordinateRegion(center: result.coordinate, span: Self.defaultSpan))
            }
        }
    }

    private func confirmAndDismiss() {
        let coord = effectiveCoordinate
        if let name = pendingName {
            selectedLocation = RouteLocation(name: name, latitude: coord.latitude, longitude: coord.longitude)
            onDismiss()
            return
        }
        isResolving = true
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coord.latitude, longitude: coord.longitude)) { placemarks, _ in
            DispatchQueue.main.async {
                isResolving = false
                let name = placemarks?.first?.name
                    ?? placemarks?.first?.locality
                    ?? placemarks?.first?.administrativeArea
                    ?? String(format: "%.5f, %.5f", coord.latitude, coord.longitude)
                selectedLocation = RouteLocation(name: name, latitude: coord.latitude, longitude: coord.longitude)
                onDismiss()
            }
        }
    }
}

#Preview { NavigationStack { CustomRouteBuilderView().environmentObject(CommunityViewModel()) } }
