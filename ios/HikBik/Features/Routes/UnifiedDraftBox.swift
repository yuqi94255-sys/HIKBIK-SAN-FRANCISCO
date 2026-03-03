// Unified Draft Box – Source tags, map thumbnails, routing by draft type
import SwiftUI
import MapKit
import CoreLocation

// MARK: - Draft Source (visual + routing)
enum DraftSource: String, Codable, CaseIterable {
    case photoSync = "photoSync"
    case manualPlan = "manualPlan"
    case liveRecorded = "liveRecorded"
    case imported = "imported"

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
        }
    }

    var tagColor: Color {
        switch self {
        case .photoSync: return Color(hex: "10B981")
        case .manualPlan: return Color(hex: "FF8C42")
        case .liveRecorded: return Color(hex: "EF4444")
        case .imported: return Color(hex: "9CA3AF")
        }
    }

    var listIcon: String {
        switch self {
        case .photoSync: return "camera.fill"
        case .manualPlan: return "map.fill"
        case .liveRecorded: return "figure.run"
        case .imported: return "square.and.arrow.down.fill"
        }
    }
}

// MARK: - Draft Item (unified model for Draft Box)
struct DraftItem: Identifiable, Codable, Hashable {
    let id: UUID
    var source: DraftSource
    var title: String
    var createdAt: Date
    var waypoints: [DraftWaypoint]
    var polylineCoordinates: [DraftCoordinate]?
    /// Total elapsed time of the recording in seconds (e.g. 6312 = 01:45:12). Used for Live Recorded; nil for other types.
    var durationSeconds: Double?

    enum CodingKeys: String, CodingKey {
        case id, source, title, createdAt, waypoints, polylineCoordinates, durationSeconds
    }

    init(id: UUID, source: DraftSource, title: String, createdAt: Date, waypoints: [DraftWaypoint], polylineCoordinates: [DraftCoordinate]?, durationSeconds: Double?) {
        self.id = id
        self.source = source
        self.title = title
        self.createdAt = createdAt
        self.waypoints = waypoints
        self.polylineCoordinates = polylineCoordinates
        self.durationSeconds = durationSeconds
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

    static func fromLiveTrack(waypoints: [(latitude: Double, longitude: Double, elevation: Double, timestamp: Date)], polyline: [CLLocationCoordinate2D]?, durationSeconds: Double? = nil) -> DraftItem {
        let wps = waypoints.map { DraftWaypoint(latitude: $0.latitude, longitude: $0.longitude, elevation: $0.elevation, timestamp: $0.timestamp) }
        let coords = polyline?.map { DraftCoordinate(latitude: $0.latitude, longitude: $0.longitude) }
        return DraftItem(
            id: UUID(),
            source: .liveRecorded,
            title: "Live Record \(dateFormatter.string(from: Date()))",
            createdAt: Date(),
            waypoints: wps,
            polylineCoordinates: coords,
            durationSeconds: durationSeconds
        )
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
        title = try c.decode(String.self, forKey: .title)
        createdAt = try c.decode(Date.self, forKey: .createdAt)
        waypoints = try c.decode([DraftWaypoint].self, forKey: .waypoints)
        polylineCoordinates = try c.decodeIfPresent([DraftCoordinate].self, forKey: .polylineCoordinates)
        durationSeconds = try c.decodeIfPresent(Double.self, forKey: .durationSeconds)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(source, forKey: .source)
        try c.encode(title, forKey: .title)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(waypoints, forKey: .waypoints)
        try c.encodeIfPresent(polylineCoordinates, forKey: .polylineCoordinates)
        try c.encodeIfPresent(durationSeconds, forKey: .durationSeconds)
    }
}

// MARK: - Unified Draft Store
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

    static func append(_ item: DraftItem) {
        var list = loadAll()
        list.insert(item, at: 0)
        saveAll(list)
    }

    static func remove(id: UUID) {
        var list = loadAll()
        list.removeAll { $0.id == id }
        saveAll(list)
    }
}

// MARK: - Unified Drafts View (Draft Box)
struct UnifiedDraftBoxView: View {
    @State private var drafts: [DraftItem] = UnifiedDraftStore.loadAll()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            ForEach(drafts) { draft in
                DraftCardRow(draft: draft)
                    .listRowBackground(Color(hex: "2A3540"))
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .onDelete(perform: deleteDrafts)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(hex: "0B121F"))
        .navigationTitle("Draft Box")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 17))
                    }
                    .foregroundStyle(Color(hex: "9CA3AF"))
                }
            }
        }
        .toolbarBackground(Color(hex: "0B121F"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(for: DraftItem.self) { draft in
            if draft.isEditable {
                CustomRouteBuilderView(liveTrackDraft: LiveTrackDraft.from(draftItem: draft))
            } else {
                LiveTrackDetailView(draft: draft)
            }
        }
        .onAppear { drafts = UnifiedDraftStore.loadAll() }
        .preferredColorScheme(.dark)
    }

    private func deleteDrafts(at offsets: IndexSet) {
        for i in offsets {
            UnifiedDraftStore.remove(id: drafts[i].id)
        }
        drafts = UnifiedDraftStore.loadAll()
    }
}

// MARK: - Draft Card Row (source tag + smart thumbnail + tap routing)
struct DraftCardRow: View {
    let draft: DraftItem

    var body: some View {
        NavigationLink(value: draft) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: draft.source.listIcon)
                        .font(.system(size: 16))
                        .foregroundStyle(draft.source.tagColor)
                    Text(draft.source.tagLabel)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(draft.source.tagColor)
                    Spacer()
                    if let elapsed = draft.elapsedTimeFormatted {
                        Text(elapsed)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color(hex: "9CA3AF"))
                    } else {
                        Text(draft.createdAt, style: .relative)
                            .font(.system(size: 11))
                            .foregroundStyle(Color(hex: "9CA3AF"))
                    }
                }
                Text(draft.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                DraftMapThumbnail(draft: draft)
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(12)
            .background(Color(hex: "2A3540"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Smart Map Thumbnail (Points vs Polyline by source)
struct DraftMapThumbnail: View {
    let draft: DraftItem

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
            latitudeDelta: max(0.01, (maxLat - minLat) * 1.8 + 0.005),
            longitudeDelta: max(0.01, (maxLon - minLon) * 1.8 + 0.005)
        )
        return MKCoordinateRegion(center: center, span: span)
    }
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
