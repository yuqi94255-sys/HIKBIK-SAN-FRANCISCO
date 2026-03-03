// Custom Route Builder – Multi-step form, Dark Forest Green theme, Orange active states
import SwiftUI
import PhotosUI
import MapKit
import CoreLocation
import ImageIO

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

// MARK: - Journey Stop Model (Day); Micro Track: each stop has nested microTracks
private struct JourneyStop: Identifiable {
    let id = UUID()
    var cityOrPark: String
    var date: Date
    var dateWasPicked: Bool
    var vehicleType: String
    var briefNote: String
    var recommendedStay: String
    var photo: UIImage?
    var microTracks: [Waypoint]
    init(cityOrPark: String = "", date: Date = Date(), dateWasPicked: Bool = false, vehicleType: String = "SUV", briefNote: String = "", recommendedStay: String = "", photo: UIImage? = nil, microTracks: [Waypoint] = [Waypoint()]) {
        self.cityOrPark = cityOrPark
        self.date = date
        self.dateWasPicked = dateWasPicked
        self.vehicleType = vehicleType
        self.briefNote = briefNote
        self.recommendedStay = recommendedStay
        self.photo = photo
        self.microTracks = microTracks
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
    @State private var duration: DurationOption = .twoThree
    @State private var vehicle: VehicleOption = .suv
    @State private var pace: PaceOption = .moderate
    @State private var stops: [JourneyStop] = [JourneyStop()]
    @State private var selectedLandCategory: LandManagementCategory?
    @State private var showPlanningInfo = true
    @State private var coverImage: UIImage?
    @State private var datePickerStopIndex: Int?
    @State private var coverPhotoItem: PhotosPickerItem?
    @State private var stopPhotoPickerItems: [PhotosPickerItem?] = [nil]
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

    init(liveTrackDraft: LiveTrackDraft? = nil) {
        _pendingLiveTrackDraft = State(initialValue: liveTrackDraft)
    }

    private var summaryText: String {
        if planningStyle == .microTrack {
            let total = stops.reduce(0) { $0 + $1.microTracks.count }
            return "\(total) waypoints • Micro Track"
        }
        let durationStr = duration.rawValue
        let vehicleStr = vehicle.rawValue
        let paceStr = pace.rawValue
        let styleStr = planningStyle.rawValue
        return "\(stops.count) stops • \(durationStr) • \(vehicleStr) • \(paceStr) pace • \(styleStr)"
    }

    private var canPublish: Bool {
        if planningStyle == .microTrack {
            let hasValidWaypoint = stops.contains { stop in
                stop.microTracks.contains { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            }
            return !journeyName.trimmingCharacters(in: .whitespaces).isEmpty && hasValidWaypoint
        }
        return !journeyName.trimmingCharacters(in: .whitespaces).isEmpty
            && stops.contains { !$0.cityOrPark.trimmingCharacters(in: .whitespaces).isEmpty }
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
        .onAppear { applyLiveTrackDraftIfNeeded() }
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
    }

    private var crbMainContent: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    planningStyleSection
                    if planningStyle == .microTrack {
                        locationSelectorSection
                    }
                    basicInfoSection
                    if planningStyle == .macroJourney {
                        preferencesSection
                    }
                    journeyTimelineSection
                    addStopButton
                    Spacer(minLength: 120)
                }
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
            if index < stopPhotoPickerItems.count {
                stopPhotoPickerItems.remove(at: index)
            }
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
        planningStyle = .microTrack
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
            Button { dismiss() } label: {
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
        .padding(.horizontal, 20)
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
        .padding(.horizontal, 20)
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

    // MARK: - Basic Info (Cover Photo, Journey Name)
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            coverPhotoZone
            journeyNameField
        }
        .padding(.horizontal, 20)
    }

    private var coverPhotoZone: some View {
        PhotosPicker(selection: $coverPhotoItem, matching: .images) {
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
                        Text("Drag & drop or click to browse")
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
        .onChange(of: coverPhotoItem) { _, new in
            Task {
                if let data = try? await new?.loadTransferable(type: Data.self), let ui = UIImage(data: data) {
                    await MainActor.run { coverImage = ui }
                }
            }
        }
    }

    private var journeyNameField: some View {
        let (label, placeholder) = planningStyle == .microTrack
            ? ("Trail/Track Name", "e.g., Angel's Landing Trail - Zion")
            : ("Journey Name", "e.g., Pacific Coast Highway Adventure")
        return VStack(alignment: .leading, spacing: 8) {
            labelWithIcon(label, icon: "link")
            TextField(placeholder, text: $journeyName)
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

    // MARK: - Journey Timeline (Macro: days | Micro: single track = flat waypoints)
    private var journeyTimelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if planningStyle == .microTrack {
                routeMapOverlay
            }
            HStack(spacing: 8) {
                Image(systemName: planningStyle == .microTrack ? "paperplane.fill" : "location.north.circle.fill")
                    .foregroundStyle(CRBColors.activeOrange)
                Text(planningStyle == .microTrack ? "The Track" : "The Journey")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(CRBColors.textPrimary)
            }
            .padding(.horizontal, 20)

            HStack(alignment: .top, spacing: 0) {
                timelineDashedLine(count: stops.count)
                VStack(spacing: 12) {
                    ForEach(Array(stops.enumerated()), id: \.element.id) { index, stop in
                        Group {
                            if planningStyle == .microTrack {
                                microTrackDayCard(displayIndex: index + 1, arrayIndex: index, stop: binding(for: index))
                            } else {
                                dayCard(displayIndex: index + 1, arrayIndex: index, stop: binding(for: index))
                            }
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
            if dayIndex > 0 || waypointIndex > 0 {
                routeInfoRow(dayIndex: dayIndex, waypointIndex: waypointIndex, waypoint: waypoint)
            }
            labelWithIcon("Arrival Time", icon: "clock")
            TextField("e.g. 12:30 PM", text: waypoint.arrivalTime)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .foregroundStyle(CRBColors.textPrimary)
                .padding(12)
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
        }
        .padding(16)
        .background(CRBColors.cardNested)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(CRBColors.borderMuted, lineWidth: 1))
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
            PhotosPicker(selection: bindingForStopPhotoItem(stopIndex), matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                        .foregroundStyle(CRBColors.activeOrange.opacity(0.7))
                    if let img = stop.wrappedValue.photo {
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
                            Text("Add photo")
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
            .onChange(of: stopPhotoPickerItems) { _, new in
                guard stopIndex < new.count, let item = new[stopIndex], stopIndex < stops.count else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self), let ui = UIImage(data: data) {
                        await MainActor.run { if stopIndex < stops.count { stops[stopIndex].photo = ui } }
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

    private var addStopButton: some View {
        Button {
    withAnimation(.easeOut(duration: 0.3)) {
                let startDate = stops.first?.date ?? Date()
                let nextDate = Calendar.current.date(byAdding: .day, value: stops.count, to: startDate) ?? startDate
                var newStop = JourneyStop()
                newStop.date = nextDate
                stops.append(newStop)
                while stopPhotoPickerItems.count < stops.count { stopPhotoPickerItems.append(nil) }
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
                    Button { } label: {
                        Text("Publish")
                            .font(.system(size: 13, weight: .semibold))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .foregroundStyle(canPublish ? CRBColors.textPrimary : CRBColors.textMuted)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(canPublish ? CRBColors.activeOrange : CRBColors.inactivePill)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(!canPublish)
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
            .padding(.horizontal, 16)
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

// MARK: - Live Track Recording View (Record Live Track → Save as Draft)
struct LiveTrackRecordingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var tracker = LiveTrackLocationTracker()
    @State private var showResumeAlert = false
    @State private var showSavedDraftAlert = false
    @State private var showDraftBox = false

    var body: some View {
        ZStack(alignment: .top) {
            liveTrackMap
            liveTrackStatsOverlay
            liveTrackFloatingControls
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CRBColors.background)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
                    .foregroundStyle(CRBColors.textMuted)
            }
            if tracker.hasRecordedTrack, !tracker.isRecording {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Stop & Save Record") {
                        let draft = tracker.buildDraft()
                        draft.saveToUserDefaults()
                        let item = DraftItem.fromLiveTrack(waypoints: draft.waypoints, polyline: tracker.fullBreadcrumbPolyline, durationSeconds: tracker.elapsedSeconds)
                        UnifiedDraftStore.append(item)
                        AchievementStore.onRecordStopped(waypoints: draft.waypoints)
                        let totalMeters = UnifiedDraftStore.loadAll().reduce(0.0) { $0 + $1.totalDistanceMeters }
                        AchievementStore.updateFromDrafts(totalDistanceMeters: totalMeters)
                        showSavedDraftAlert = true
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
            NavigationStack {
                UnifiedDraftBoxView()
            }
            .onDisappear { showDraftBox = false }
        }
        .preferredColorScheme(.dark)
    }

    private var liveTrackMap: some View {
        Map(initialPosition: .region(tracker.mapRegion), interactionModes: .all) {
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
        locationManager.allowsBackgroundLocationUpdates = false
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startRecording() {
        guard !isRecording else { return }
        waypoints = []
        breadcrumbTrail = []
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

#Preview { NavigationStack { CustomRouteBuilderView() } }
