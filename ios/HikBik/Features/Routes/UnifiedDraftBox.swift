// Unified Draft Box – 三種卡片模式（Live / Manual Micro / Macro），統一進 PostEditorView
import SwiftUI
import MapKit
import CoreLocation
import UIKit

/// Template A: 社區 / Live Activity 用同一份數據，渲染為豪華卡片（大圖、儀表盤、地點、天氣）。
typealias CommunityCardModel = DraftItem
/// Template B: 個人中心用同一份數據，渲染為精簡卡片（縮略圖、標題、里程、日期）。統一路由：routeID → ManualJourneyDetailView。
typealias ProfilePostModel = DraftItem

private let cardBg = Color(hex: "2A3540")
private let draftBg = Color(hex: "0B121F")
private let textMuted = Color(hex: "9CA3AF")
private let liveRed = Color(hex: "EF4444")
private let accentGreen = Color(hex: "10B981")
private let accentOrange = Color(hex: "FF8C42")

// MARK: - Post Category (社區三大板塊：投遞到對應 Tab)
enum PostCategory: String, Codable, CaseIterable {
    case grandJourney   // 宏觀路線 (From Custom Route Builder) → Grand Journeys
    case detailedTrack  // 微觀足跡 (From Normal Track Record) → Detailed Tracks
    case livelyActivity // 實時活動 (Live Recording / Quick Post) → Live Activity

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        let raw = try c.decode(String.self)
        if let v = PostCategory(rawValue: raw) {
            self = v
        } else {
            self = .detailedTrack
        }
    }
}

// MARK: - Draft Source (visual + routing)
enum DraftSource: String, Codable, CaseIterable {
    case photoSync = "photoSync"
    case manualPlan = "manualPlan"
    case liveRecorded = "liveRecorded"
    case imported = "imported"
    /// 創作來源：Custom Route Builder 產出的宏觀/微觀路線（與 .liveRecorded 錄製來源區分）
    case manualBuilder = "manualBuilder"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if raw == "synced" {
            self = .imported
        } else if let value = DraftSource(rawValue: raw) {
            self = value
        } else {
            self = .imported
        }
    }

    var tagLabel: String {
        switch self {
        case .photoSync: return "📷 Photo Sync"
        case .manualPlan: return "✍️ Manual Plan"
        case .liveRecorded: return "🔴 Live Recorded"
        case .imported: return "📥 Imported"
        case .manualBuilder: return "🛤️ Route Builder"
        }
    }

    var tagColor: Color {
        switch self {
        case .photoSync: return Color(hex: "10B981")
        case .manualPlan: return Color(hex: "FF8C42")
        case .liveRecorded: return Color(hex: "EF4444")
        case .imported: return Color(hex: "9CA3AF")
        case .manualBuilder: return Color(hex: "FF8C42")
        }
    }

    var listIcon: String {
        switch self {
        case .photoSync: return "camera.fill"
        case .manualPlan: return "map.fill"
        case .liveRecorded: return "figure.run"
        case .imported: return "square.and.arrow.down.fill"
        case .manualBuilder: return "map.fill"
        }
    }
}

// MARK: - Two-Tier JSON Templates (Template A = Card/Live Activity, Template B = Detail)

/// Template A: lightweight payload for community list and Live Island.
struct TrackCardPayload: Codable {
    var routeName: String
    var coverImageBase64: String?
    var distanceMeters: Double
    var durationSeconds: Double
    var locationName: String?
}

/// Template B: full payload for detail/deep link (form + raw path + system context).
struct TrackDetailPayload: Codable {
    var card: TrackCardPayload
    var formDescription: String?
    var rawWaypoints: [RawWaypointPayload]
    var currentWeather: String?
    var nearbyFacilities: [String]?
}

struct RawWaypointPayload: Codable {
    var latitude: Double
    var longitude: Double
    var elevation: Double
    var timestamp: Date
}

/// Call on Publish: prints Template 1 (Card) and Template 2 (Detail) JSON to console.
func printPublishPayloadsToConsole(_ item: DraftItem) {
    let card = item.toCardPayload()
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.dateEncodingStrategy = .iso8601
    if let cardData = try? encoder.encode(card), let cardStr = String(data: cardData, encoding: .utf8) {
        print("[Publish] Template 1 (Card) — community list / Live Island:\n\(cardStr)")
    }
    let detail = item.toDetailPayload(
        weather: item.currentWeather ?? "Sunny, 72°F (22°C), Wind 5 mph NE",
        facilities: item.nearbyFacilities ?? ["Restroom", "Parking", "Visitor Center", "Water Refill"]
    )
    if let detailData = try? encoder.encode(detail), let detailStr = String(data: detailData, encoding: .utf8) {
        print("[Publish] Template 2 (Detail) — full GPS + form + weather/facilities:\n\(detailStr)")
    }
}

// MARK: - Draft Item (unified model for Draft Box)
struct DraftItem: Identifiable, Codable, Hashable {
    let id: UUID
    var source: DraftSource
    /// 社區板塊歸類：發布後按此投遞到 Grand Journeys / Detailed Tracks / Live Activity。.grandJourney 以 waypoints + polylineCoordinates 承載行程單（Itinerary）；.detailedTrack 以 waypoints + coverImageData 承載精確經緯度與單點圖片。
    var category: PostCategory
    var title: String
    var createdAt: Date
    var waypoints: [DraftWaypoint]
    var polylineCoordinates: [DraftCoordinate]?
    /// Total elapsed time of the recording in seconds (e.g. 6312 = 01:45:12). Used for Live Recorded; nil for other types.
    var durationSeconds: Double?
    /// Cover image for Template A (Card/Live Activity). Optional.
    var coverImageData: Data?
    /// User-written description; used in Template B (Detail).
    var formDescription: String?
    /// Resolved location name (e.g. from geocode); used in Template A.
    var locationName: String?
    /// Injected for detail page (from start point); Model B / detail.
    var currentWeather: String?
    /// Injected for detail page; Model B / detail.
    var nearbyFacilities: [String]?
    /// 宏觀路線發布時寫入的完整 MacroJourneyPost JSON（含每日照片、描述、Airbnb 連結）。Profile / 詳情頁解碼用。
    var macroJourneyJSON: String?
    /// 微觀 Detailed Track 發布時寫入的完整 DetailedTrackPost JSON（含 viewPointNodes：arrivalTime、amenities、elevation 等）。Community 卡片與詳情頁解碼用。
    var detailedTrackJSON: String?
    /// 發布時綁定 MongoDB 用戶 id；Profile Posts 僅顯示與當前帳號一致者。
    var ownerUserId: String?

    enum CodingKeys: String, CodingKey {
        case id, source, category, title, createdAt, waypoints, polylineCoordinates, durationSeconds, coverImageData, formDescription, locationName, currentWeather, nearbyFacilities
        case macroJourneyJSON, detailedTrackJSON, ownerUserId
    }

    /// 從 source 推斷默認 category：Builder→Grand Journeys，Live Recording→Lively Activity，Micro/Detailed→Detailed Tracks。
    static func category(from source: DraftSource) -> PostCategory {
        switch source {
        case .manualBuilder: return .grandJourney
        case .liveRecorded: return .livelyActivity
        case .manualPlan, .photoSync, .imported: return .detailedTrack
        }
    }

    init(id: UUID, source: DraftSource, category: PostCategory? = nil, title: String, createdAt: Date, waypoints: [DraftWaypoint], polylineCoordinates: [DraftCoordinate]?, durationSeconds: Double?, coverImageData: Data? = nil, formDescription: String? = nil, locationName: String? = nil, currentWeather: String? = nil, nearbyFacilities: [String]? = nil, macroJourneyJSON: String? = nil, detailedTrackJSON: String? = nil, ownerUserId: String? = nil) {
        self.id = id
        self.source = source
        self.category = category ?? Self.category(from: source)
        self.title = title
        self.createdAt = createdAt
        self.waypoints = waypoints
        self.polylineCoordinates = polylineCoordinates
        self.durationSeconds = durationSeconds
        self.coverImageData = coverImageData
        self.formDescription = formDescription
        self.locationName = locationName
        self.currentWeather = currentWeather
        self.nearbyFacilities = nearbyFacilities
        self.macroJourneyJSON = macroJourneyJSON
        self.detailedTrackJSON = detailedTrackJSON
        self.ownerUserId = ownerUserId
    }

    struct DraftWaypoint: Codable, Hashable {
        var latitude: Double
        var longitude: Double
        var elevation: Double
        var timestamp: Date
    }
    struct DraftCoordinate: Codable, Hashable {
        var latitude: Double
        var longitude: Double
    }

    /// Recorded/imported tracks are read-only and open Track Detail View; manual/photo drafts open the Route Editor.
    var isEditable: Bool {
        source == .manualPlan || source == .photoSync
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: DraftItem, r: DraftItem) -> Bool { l.id == r.id }

    static func fromLiveTrack(waypoints: [(latitude: Double, longitude: Double, elevation: Double, timestamp: Date)], polyline: [CLLocationCoordinate2D]?, durationSeconds: Double? = nil, title: String? = nil, coverImageData: Data? = nil, formDescription: String? = nil, locationName: String? = nil, currentWeather: String? = nil, nearbyFacilities: [String]? = nil) -> DraftItem {
        let wps = waypoints.map { DraftWaypoint(latitude: $0.latitude, longitude: $0.longitude, elevation: $0.elevation, timestamp: $0.timestamp) }
        let coords = polyline?.map { DraftCoordinate(latitude: $0.latitude, longitude: $0.longitude) }
        let resolvedTitle = title?.trimmingCharacters(in: .whitespaces).isEmpty == false
            ? title!
            : "Live Record \(dateFormatter.string(from: Date()))"
        return DraftItem(
            id: UUID(),
            source: .liveRecorded,
            title: resolvedTitle,
            createdAt: Date(),
            waypoints: wps,
            polylineCoordinates: coords,
            durationSeconds: durationSeconds,
            coverImageData: coverImageData,
            formDescription: formDescription,
            locationName: locationName,
            currentWeather: currentWeather,
            nearbyFacilities: nearbyFacilities
        )
    }

    /// Same routeID for Community card and Profile post; both open same ManualJourneyDetailView.
    var routeID: String { id.uuidString }

    /// Mock weather + facilities from start coordinate (for context injection on publish).
    static func injectContextForStart(latitude: Double, longitude: Double) -> (weather: String, facilities: [String]) {
        let weather = "Sunny, 72°F (22°C), Wind 5 mph NE"
        let facilities = ["Restroom", "Parking", "Visitor Center", "Water Refill", "Trailhead"]
        return (weather, facilities)
    }

    /// Start location name by reverse geocode (for contextual auto-fill on publish).
    static func geocodeStartLocation(latitude: Double, longitude: Double) async -> String? {
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(loc)
            return placemarks.first?.locality ?? placemarks.first?.administrativeArea ?? placemarks.first?.name
        } catch { return nil }
    }

    /// Formatted elapsed time (e.g. "01:45:12" or "45:12") for display in Draft Box; nil if not a timed recording.
    var elapsedTimeFormatted: String? {
        guard let sec = durationSeconds, sec >= 0 else { return nil }
        let total = Int(sec)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, HH:mm"
        return f
    }()

    var coordinate2DPoints: [CLLocationCoordinate2D] {
        waypoints.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
    var polyline2D: [CLLocationCoordinate2D]? {
        polylineCoordinates?.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    /// Total distance in meters (from polyline or waypoints). For feed cards.
    var totalDistanceMeters: Double {
        let coords = polyline2D ?? coordinate2DPoints
        guard coords.count >= 2 else { return 0 }
        var d: Double = 0
        for i in 1..<coords.count {
            d += CLLocation(latitude: coords[i].latitude, longitude: coords[i].longitude)
                .distance(from: CLLocation(latitude: coords[i-1].latitude, longitude: coords[i-1].longitude))
        }
        return d
    }

    /// Elevation gain in meters. For feed cards.
    var elevationGainMeters: Double {
        guard waypoints.count >= 2 else { return 0 }
        var gain: Double = 0
        for i in 1..<waypoints.count {
            let delta = waypoints[i].elevation - waypoints[i-1].elevation
            if delta > 0 { gain += delta }
        }
        return gain
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        source = try c.decode(DraftSource.self, forKey: .source)
        if let cat = try c.decodeIfPresent(PostCategory.self, forKey: .category) {
            category = cat
        } else {
            category = Self.category(from: source)
        }
        title = try c.decode(String.self, forKey: .title)
        createdAt = try c.decode(Date.self, forKey: .createdAt)
        waypoints = try c.decode([DraftWaypoint].self, forKey: .waypoints)
        polylineCoordinates = try c.decodeIfPresent([DraftCoordinate].self, forKey: .polylineCoordinates)
        durationSeconds = try c.decodeIfPresent(Double.self, forKey: .durationSeconds)
        coverImageData = try c.decodeIfPresent(Data.self, forKey: .coverImageData)
        formDescription = try c.decodeIfPresent(String.self, forKey: .formDescription)
        locationName = try c.decodeIfPresent(String.self, forKey: .locationName)
        currentWeather = try c.decodeIfPresent(String.self, forKey: .currentWeather)
        nearbyFacilities = try c.decodeIfPresent([String].self, forKey: .nearbyFacilities)
        macroJourneyJSON = try c.decodeIfPresent(String.self, forKey: .macroJourneyJSON)
        detailedTrackJSON = try c.decodeIfPresent(String.self, forKey: .detailedTrackJSON)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(source, forKey: .source)
        try c.encode(category, forKey: .category)
        try c.encode(title, forKey: .title)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(waypoints, forKey: .waypoints)
        try c.encodeIfPresent(polylineCoordinates, forKey: .polylineCoordinates)
        try c.encodeIfPresent(durationSeconds, forKey: .durationSeconds)
        try c.encodeIfPresent(coverImageData, forKey: .coverImageData)
        try c.encodeIfPresent(formDescription, forKey: .formDescription)
        try c.encodeIfPresent(locationName, forKey: .locationName)
        try c.encodeIfPresent(currentWeather, forKey: .currentWeather)
        try c.encodeIfPresent(nearbyFacilities, forKey: .nearbyFacilities)
        try c.encodeIfPresent(macroJourneyJSON, forKey: .macroJourneyJSON)
        try c.encodeIfPresent(detailedTrackJSON, forKey: .detailedTrackJSON)
    }

    /// 解碼為 DetailedTrackPost（僅當 detailedTrackJSON 存在且有效時）。用於 toManualJourney 與 resolved 顯示。
    private func decodedDetailedTrackPost() -> DetailedTrackPost? {
        guard let json = detailedTrackJSON, let data = json.data(using: .utf8),
              var post = try? JSONDecoder().decode(DetailedTrackPost.self, from: data) else { return nil }
        post.routeID = routeID
        return post
    }

    /// 卡片/詳情用：總時長顯示。優先從 Detailed Track JSON 取（calculatedRealDuration 或 totalDurationMinutes），否則用 durationSeconds。
    var resolvedDurationDisplay: String? {
        if let post = decodedDetailedTrackPost() {
            if let real = post.calculatedRealDuration { return real }
            let m = post.totalDurationMinutes
            if m < 60 { return "\(m) min" }
            let h = m / 60
            let r = m % 60
            return r > 0 ? "\(h)h \(r)min" : "\(h)h"
        }
        guard let sec = durationSeconds, sec >= 0 else { return nil }
        let total = Int(sec)
        let minutes = total / 60
        if minutes < 60 { return "\(minutes) min" }
        let h = minutes / 60
        let m = minutes % 60
        return m > 0 ? "\(h)h \(m)min" : "\(h)h"
    }

    /// 卡片用：總海拔顯示。優先從 Detailed Track JSON 取 elevationGain，否則用 elevationGainMeters 換算為 ft。
    var resolvedElevationGain: String? {
        if let post = decodedDetailedTrackPost(), let gain = post.elevationGain, !gain.isEmpty { return gain }
        let m = elevationGainMeters
        guard m > 0 else { return nil }
        return "\(Int(m * 3.28084)) ft"
    }

    /// 卡片 Badge 用：Detailed Track 主活動類型（primaryActivityType ?? 首個 viewPoint 的 activityType）。
    var detailedTrackPrimaryActivityType: ViewPointActivityType? {
        guard let post = decodedDetailedTrackPost() else { return nil }
        return post.primaryActivityType ?? post.viewPointNodes.first?.activityType
    }

    /// Community 卡片用：路線類別（二級體系 subCategoryDisplay 或 legacy category），即 Land Manager 名稱
    var detailedTrackCategoryDisplay: String? {
        decodedDetailedTrackPost()?.displayCategory
    }

    /// Community 卡片左上角標籤：NATURE · DETAILED / URBAN · DETAILED
    var detailedTrackTier: MicroTrackTier? {
        decodedDetailedTrackPost()?.trackTier
    }

    /// 微觀篩選用：時長（分鐘），優先 Detailed Track JSON 的 totalDurationMinutes，否則 durationSeconds 換算
    var durationMinutesForFilter: Int? {
        if let post = decodedDetailedTrackPost(), post.totalDurationMinutes > 0 { return post.totalDurationMinutes }
        guard let sec = durationSeconds, sec > 0 else { return nil }
        return max(1, Int(sec / 60))
    }

    /// 宏觀詳情：優先解碼 macroJourneyJSON（完整每日數據），否則由 waypoints 組最小 CommunityJourney。
    func communityJourneyForMacroDetail(author: CommunityAuthor? = nil) -> CommunityJourney {
        if let json = macroJourneyJSON, let data = json.data(using: .utf8),
           let post = try? JSONDecoder().decode(MacroJourneyPost.self, from: data) {
            return CommunityJourney.from(post, author: author ?? CommunityAuthor(id: "me", displayName: "Me", avatarURL: nil), likeCount: 0, commentCount: 0, coverImageURL: nil)
        }
        let days = waypoints.enumerated().map { index, w in
            CommunityJourneyDay(
                dayNumber: index + 1,
                location: CommunityGeoLocation(latitude: w.latitude, longitude: w.longitude),
                locationName: nil,
                dateString: nil,
                notes: formDescription,
                photoURL: nil,
                recommendedStay: nil,
                dayPhotos: nil,
                description: formDescription,
                recommendations: nil
            )
        }
        return CommunityJourney(
            journeyName: title.isEmpty ? "Journey" : title,
            days: days.isEmpty ? [CommunityJourneyDay(dayNumber: 1, location: nil, locationName: nil, notes: "No stops.")] : days,
            selectedStates: [],
            duration: nil,
            vehicle: nil,
            pace: nil,
            difficulty: nil,
            tags: ["Macro Journey"],
            state: "",
            author: author ?? CommunityAuthor(id: "me", displayName: "Me", avatarURL: nil),
            likeCount: 0,
            commentCount: 0,
            coverImageURL: nil,
            aspectRatio: 16.0 / 10.0
        )
    }

    // MARK: - Two-Tier JSON (Template A = Card/Live Activity, Template B = Detail/Deep Link)

    /// Template A: lightweight JSON for community list and Live Island (靈動島).
    func toCardPayload() -> TrackCardPayload {
        TrackCardPayload(
            routeName: title,
            coverImageBase64: coverImageData?.base64EncodedString(),
            distanceMeters: totalDistanceMeters,
            durationSeconds: durationSeconds ?? 0,
            locationName: locationName
        )
    }

    /// Template B: full JSON for detail/deep link (form content, raw path, weather/facilities).
    func toDetailPayload(weather: String? = nil, facilities: [String]? = nil) -> TrackDetailPayload {
        TrackDetailPayload(
            card: toCardPayload(),
            formDescription: formDescription,
            rawWaypoints: waypoints.map { RawWaypointPayload(latitude: $0.latitude, longitude: $0.longitude, elevation: $0.elevation, timestamp: $0.timestamp) },
            currentWeather: weather ?? currentWeather,
            nearbyFacilities: facilities ?? nearbyFacilities
        )
    }

    /// Convert to ManualJourney for ManualJourneyDetailView (route detail sheet). 優先解碼 detailedTrackJSON（Builder 完整 ViewPoint 數據），否則由 waypoints 組最小行程。
    func toManualJourney() -> ManualJourney {
        if let post = decodedDetailedTrackPost() { return post }
        let nodes = waypoints.enumerated().map { i, w in
            ViewPointNode(
                title: "Point \(i + 1)",
                activityType: .hiking,
                latitude: w.latitude,
                longitude: w.longitude,
                photoCount: 1,
                elevation: String(format: "%.0f m", w.elevation),
                hasWater: false,
                hasFuel: false,
                signalStrength: 0
            )
        }
        let durationMin = max(1, Int((durationSeconds ?? 0) / 60))
        let elevFt = Int(elevationGainMeters * 3.28084)
        return DetailedTrackPost(
            routeName: title.isEmpty ? "Recorded Route" : title,
            totalDurationMinutes: durationMin,
            viewPointNodes: nodes,
            elevationGain: "\(elevFt) ft",
            routeID: routeID
        )
    }
}

// MARK: - Unified Draft Store
extension Notification.Name {
    static let unifiedDraftsDidChange = Notification.Name("UnifiedDraftStore.draftsDidChange")
}

enum UnifiedDraftStore {
    private static let key = "UnifiedDraftBox"

    static func loadAll() -> [DraftItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([DraftItem].self, from: data) else { return [] }
        return decoded.sorted { $0.createdAt > $1.createdAt }
    }

    static func saveAll(_ items: [DraftItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    /// Append new post at index 0 (newest first). Posts notification so Home/Profile can refresh immediately.
    static func append(_ item: DraftItem) {
        var list = loadAll()
        list.insert(item, at: 0)
        saveAll(list)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .unifiedDraftsDidChange, object: nil)
        }
    }

    static func remove(id: UUID) {
        var list = loadAll()
        list.removeAll { $0.id == id }
        saveAll(list)
    }
}

// MARK: - Unified Drafts View (Draft Box) — reads only TrackDataManager.draftTracks; tap row → PostEditorView
struct UnifiedDraftBoxView: View {
    @EnvironmentObject private var trackDataManager: TrackDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDraft: DraftItem?
    @State private var showEditor = false

    private var drafts: [DraftItem] { trackDataManager.draftTracks }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if drafts.isEmpty {
                    Text("No Drafts Found").foregroundColor(.gray)
                } else {
                    List {
                        ForEach(drafts) { draft in
                            Button {
                                selectedDraft = draft
                                showEditor = true
                            } label: {
                                DraftCardRow(draft: draft)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteDrafts)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("My Drafts")
            .navigationDestination(isPresented: $showEditor) {
                if let draft = selectedDraft {
                    DraftEditorEntryView(draft: draft) {
                        trackDataManager.reloadFromStore()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") { dismiss() }
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
            }
            .toolbarBackground(Color(hex: "0B121F"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear { trackDataManager.reloadFromStore() }
        .preferredColorScheme(.dark)
    }

    private func deleteDrafts(at offsets: IndexSet) {
        let idsToRemove = offsets.map { drafts[$0].id }
        for id in idsToRemove {
            trackDataManager.removeDraft(id: id)
        }
    }
}

// MARK: - Draft Card Row (label for NavigationLink; must match navigationDestination(for: DraftItem.self))
private struct DraftCardRow: View {
    let draft: DraftItem

    var body: some View {
        Group {
            switch draft.source {
            case .liveRecorded:
                LiveRecordedCardView(draft: draft)
            case .photoSync, .manualPlan, .manualBuilder:
                ManualMicroCardView(draft: draft)
            case .imported:
                MacroExplorationCardView(draft: draft)
            }
        }
    }
}

// MARK: - 1. 實時紀錄卡片：紅點 + Live、地圖縮略圖、里程/耗時/海拔
private struct LiveRecordedCardView: View {
    let draft: DraftItem
    @State private var blink = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(liveRed)
                        .frame(width: 8, height: 8)
                        .opacity(blink ? 1 : 0.4)
                    Text("Live")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(liveRed)
                }
                Spacer()
                if let elapsed = draft.elapsedTimeFormatted {
                    Text(elapsed)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(textMuted)
                }
            }
            DraftMapThumbnail(draft: draft)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            HStack(spacing: 16) {
                dataPill(value: distanceFormatted, label: "Distance")
                dataPill(value: draft.elapsedTimeFormatted ?? "—", label: "Time")
                dataPill(value: elevationFormatted, label: "Elev.")
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) { blink = true }
        }
    }

    private var distanceFormatted: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "0 km" : String(format: "%.2f km", km)
    }
    private var elevationFormatted: String {
        let m = draft.elevationGainMeters
        return m < 1 ? "0 m" : String(format: "%.0f m", m)
    }
    private func dataPill(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 2. 手動/微觀紀錄卡片：照片拼貼風格、路線名、日期、點數
private struct ManualMicroCardView: View {
    let draft: DraftItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                photoCollagePlaceholder
                VStack(alignment: .leading, spacing: 4) {
                    Text(draft.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text(draft.createdAt, style: .date)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(textMuted)
                    Text("\(draft.waypoints.count) points")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(accentGreen)
                }
                Spacer()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var photoCollagePlaceholder: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(cardBg.opacity(0.8))
                .frame(width: 72, height: 72)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(textMuted.opacity(0.3), lineWidth: 1))
            RoundedRectangle(cornerRadius: 10)
                .fill(cardBg.opacity(0.9))
                .frame(width: 72, height: 72)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(textMuted.opacity(0.3), lineWidth: 1))
                .offset(x: 6, y: 6)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "1A2332"))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "photo.stack.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(accentGreen.opacity(0.8))
                )
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(textMuted.opacity(0.3), lineWidth: 1))
                .offset(x: 12, y: 12)
        }
        .frame(width: 96, height: 96)
    }
}

// MARK: - 3. 宏觀探索卡片：較廣地圖、大跨度里程、地理感
private struct MacroExplorationCardView: View {
    let draft: DraftItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "map.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(textMuted)
                Text("Macro")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(textMuted)
                Spacer()
                Text(draft.createdAt, style: .date)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(textMuted)
            }
            DraftMapThumbnail(draft: draft, spanScale: 2.2)
                .frame(height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(draft.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
            HStack(spacing: 12) {
                Text(distanceFormatted)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundStyle(accentOrange)
                Text("•")
                    .foregroundStyle(textMuted)
                Text("\(draft.waypoints.count) waypoints")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(textMuted)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var distanceFormatted: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "0 km" : String(format: "%.1f km", km)
    }
}

// MARK: - 進入編輯預覽（統一先進 PostEditorView；發布時必須 removeDraft 並 addPublished，單向不可退回草稿）
struct DraftEditorEntryView: View {
    let draft: DraftItem
    var onDismiss: () -> Void = {}

    @Environment(\.dismiss) private var envDismiss
    @EnvironmentObject private var trackDataManager: TrackDataManager

    var body: some View {
        PostEditorView(
            draft: LiveTrackDraft.from(draftItem: draft),
            distanceMeters: draft.totalDistanceMeters,
            elevationMeters: draft.elevationGainMeters,
            durationSeconds: draft.durationSeconds ?? 0,
            sportType: .hiking,
            initialTitle: draft.title.isEmpty ? nil : draft.title,
            sourceDraftId: draft.id,
            sourceDraftItem: draft,
            onSaveToDrafts: { title in
                let updated = DraftItem(
                    id: draft.id,
                    source: draft.source,
                    category: draft.category,
                    title: title.isEmpty ? draft.title : title,
                    createdAt: draft.createdAt,
                    waypoints: draft.waypoints,
                    polylineCoordinates: draft.polylineCoordinates,
                    durationSeconds: draft.durationSeconds,
                    coverImageData: draft.coverImageData,
                    formDescription: draft.formDescription,
                    locationName: draft.locationName,
                    currentWeather: draft.currentWeather,
                    nearbyFacilities: draft.nearbyFacilities
                )
                trackDataManager.removeDraft(id: draft.id)
                trackDataManager.addDraft(updated)
                envDismiss()
                onDismiss()
            },
            onPublish: { _ in
                // 數據已由 PostEditorView 硬連線寫入單例，此處只負責 Live Activity
                TrackRecordingLiveActivityManager.startPublishedActivity(
                    distanceMeters: draft.totalDistanceMeters,
                    durationSeconds: draft.durationSeconds ?? 0,
                    elevationMeters: draft.elevationGainMeters
                )
            },
            onPublishComplete: {
                envDismiss()
                onDismiss()
                DispatchQueue.main.async {
                    TabSelectionManager.shared.switchToCommunity()
                }
            }
        )
    }
}

// MARK: - Smart Map Thumbnail (Points vs Polyline by source)
struct DraftMapThumbnail: View {
    let draft: DraftItem
    /// 宏觀卡片可傳 2.0+ 讓地圖範圍更廣
    var spanScale: CGFloat = 1.8

    var body: some View {
        Map(initialPosition: .region(region), interactionModes: []) {
            if draft.source == .liveRecorded || draft.source == .imported, let poly = draft.polyline2D, poly.count >= 2 {
                MapPolyline(coordinates: poly)
                    .stroke(draft.source == .liveRecorded ? Color(hex: "EF4444") : Color(hex: "9CA3AF"), lineWidth: 3)
            } else {
                MapPolyline(coordinates: draft.coordinate2DPoints)
                    .stroke(Color(hex: "10B981"), lineWidth: 2)
            }
            ForEach(Array(draft.coordinate2DPoints.enumerated()), id: \.offset) { idx, coord in
                Annotation("", coordinate: coord) {
                    Circle()
                        .fill(idx == 0 ? Color(hex: "10B981") : Color(hex: "FF8C42"))
                        .frame(width: draft.source == .manualPlan || draft.source == .photoSync ? 8 : 6, height: 8)
                }
            }
        }
        .mapStyle(.standard)
        .allowsHitTesting(false)
    }

    private var region: MKCoordinateRegion {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 0
        let maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0
        let maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.01, (maxLat - minLat) * spanScale + 0.005),
            longitudeDelta: max(0.01, (maxLon - minLon) * spanScale + 0.005)
        )
        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - Activity Detail（紀錄 Lively）— 與微觀 ManualJourneyDetailView 分離
struct ActivityDetailView: View {
    let draft: DraftItem
    var body: some View { LiveTrackDetailView(draft: draft) }
}

// MARK: - Track Detail View (read-only for Live Recorded; no editor)
struct LiveTrackDetailView: View {
    let draft: DraftItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(draft.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                HStack(spacing: 8) {
                    Image(systemName: draft.source.listIcon)
                        .foregroundStyle(draft.source.tagColor)
                    Text(draft.source.tagLabel)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(draft.source.tagColor)
                }
                trackMapSection
                elevationProfileSection
                statsSection
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0B121F"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Back") { dismiss() }
                    .foregroundStyle(Color(hex: "9CA3AF"))
            }
        }
        .toolbarBackground(Color(hex: "0B121F"), for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    private var trackMapSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Full Track")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            Map(initialPosition: .region(detailRegion), interactionModes: .all) {
                if let poly = draft.polyline2D, poly.count >= 2 {
                    MapPolyline(coordinates: poly)
                        .stroke(draft.source.tagColor, lineWidth: 5)
                } else {
                    MapPolyline(coordinates: draft.coordinate2DPoints)
                        .stroke(draft.source.tagColor, lineWidth: 5)
                }
                ForEach(Array(draft.coordinate2DPoints.enumerated()), id: \.offset) { idx, coord in
                    Annotation("", coordinate: coord) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: idx == 0 ? 24 : 18))
                            .foregroundStyle(idx == 0 ? Color(hex: "10B981") : Color(hex: "FF8C42"))
                    }
                }
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var elevationProfileSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Elevation Profile")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            if draft.waypoints.count >= 2 {
                ElevationProfileChart(waypoints: draft.waypoints)
                    .frame(height: 80)
                    .padding(12)
                    .background(Color(hex: "2A3540"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var statsSection: some View {
        HStack(spacing: 16) {
            statBlock(value: "\(draft.waypoints.count)", label: "Waypoints")
            if let first = draft.waypoints.first?.timestamp, let last = draft.waypoints.last?.timestamp {
                let mins = Int(last.timeIntervalSince(first) / 60)
                statBlock(value: "\(mins) min", label: "Duration")
            }
            if let elevGain = elevationGain {
                statBlock(value: String(format: "%.0f m", elevGain), label: "Elev. Gain")
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "2A3540"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func statBlock(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Color(hex: "9CA3AF"))
        }
        .frame(maxWidth: .infinity)
    }

    private var elevationGain: Double? {
        guard draft.waypoints.count >= 2 else { return nil }
        var gain: Double = 0
        for i in 1..<draft.waypoints.count {
            let diff = draft.waypoints[i].elevation - draft.waypoints[i-1].elevation
            if diff > 0 { gain += diff }
        }
        return gain
    }

    private var detailRegion: MKCoordinateRegion {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let center = CLLocationCoordinate2D(latitude: (lats.min()! + lats.max()!) / 2, longitude: (lons.min()! + lons.max()!) / 2)
        let span = MKCoordinateSpan(latitudeDelta: max(0.02, (lats.max()! - lats.min()!) * 1.5), longitudeDelta: max(0.02, (lons.max()! - lons.min()!) * 1.5))
        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - Elevation Profile Chart (read-only)
private struct ElevationProfileChart: View {
    let waypoints: [DraftItem.DraftWaypoint]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let elevs = waypoints.map(\.elevation)
            let minE = elevs.min() ?? 0
            let maxE = elevs.max() ?? minE + 1
            let range = max(1, maxE - minE)
            Path { path in
                guard waypoints.count >= 2 else { return }
                for (i, wp) in waypoints.enumerated() {
                    let x = w * CGFloat(i) / CGFloat(max(1, waypoints.count - 1))
                    let y = h - h * CGFloat((wp.elevation - minE) / range)
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(
                LinearGradient(colors: [Color(hex: "10B981"), Color(hex: "EF4444")], startPoint: .leading, endPoint: .trailing),
                lineWidth: 2
            )
        }
    }
}
