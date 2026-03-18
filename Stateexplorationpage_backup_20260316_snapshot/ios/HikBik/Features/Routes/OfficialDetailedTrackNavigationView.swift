// MARK: - OfficialDetailedTrackNavigationView — GPX-driven or pathPoints fallback. No Day / Macro. English only.
import SwiftUI
import MapKit
import CoreLocation

struct OfficialDetailedTrackNavigationView: View {
    let track: OfficialDetailedTrack
    /// Fallback path when no GPX. When gpxData is set, path is taken from GPX.
    var pathCoordinates: [CLLocationCoordinate2D]
    /// When set, route is driven by GPX (curved polyline, elevations, turn instructions).
    var gpxData: Data? = nil
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = DetailedTrackLocationManager()
    @StateObject private var navigationEngine = NavigationEngine()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var gpxResult: GPXParseResult?
    /// Mode B: walking route from MKDirections (curved along trails). Set when no GPX or GPX has ≤2 points.
    @State private var directionsRouteCoordinates: [CLLocationCoordinate2D]? = nil
    /// When true, user dot is pinned to first GPX point (Happy Isles Trailhead) for preview without real GPS.
    @State private var isSimulated: Bool = true
    @State private var isOffCourse: Bool = false
    @State private var distanceToNextTurnMeters: Double = 0
    @State private var turnIcon: String = "⬆️"
    @State private var progressAlongPathMeters: Double = 0
    @State private var showBottomSheet: Bool = true

    private let offCourseThresholdMeters: Double = 20
    private let tacticalPurple = Color(hex: "A855F7")

    /// Mode A: GPX with >2 points → full parser array, fit to bounds.
    private var useGPXMode: Bool {
        guard let r = gpxResult, r.coordinates.count > 2 else { return false }
        return true
    }
    private var useGPX: Bool { gpxResult != nil }
    /// Display path: snapped route when available; else waypoints (for length/engine). Map uses polylineCoordinates only.
    private var displayCoordinates: [CLLocationCoordinate2D] {
        directionsRouteCoordinates ?? waypointsForSnap
    }
    private var displayProgressMeters: Double { useGPX ? navigationEngine.progressDistanceMeters : progressAlongPathMeters }
    private var displayTotalMeters: Double { useGPX ? navigationEngine.totalDistanceMeters : pathLengthMeters() }
    private var displayTurnIcon: String { useGPX ? (navigationEngine.currentInstruction?.icon ?? "⬆️") : turnIcon }
    private var displayTurnText: String { useGPX ? (navigationEngine.currentInstruction?.text ?? "Straight") : turnInstructionText }
    private var displayDistanceToTurn: Double { useGPX ? (navigationEngine.currentInstruction?.distanceToTurnMeters ?? 0) : distanceToNextTurnMeters }
    private var displayIsOffCourse: Bool { useGPX ? navigationEngine.isOffRoute : isOffCourse }
    /// User pin only. Mode A simulated = first GPX point; Mode B simulated = first of display path; else real/snapped location.
    private var displayUserPin: CLLocationCoordinate2D? {
        if useGPXMode, isSimulated, let first = gpxResult?.coordinates.first { return first }
        if useGPXMode { return navigationEngine.snappedCoordinate }
        if isSimulated, let first = displayCoordinates.first { return first }
        return locationManager.userLocation?.coordinate
    }

    var body: some View {
        ZStack(alignment: .top) {
            precisionMapLayer
            // TEMP: Comment out to test map touch — if map works, header was blocking.
            // navigationCommandHeader
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0A0C10"))
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.leading, 16)
            .padding(.top, 12)
        }
        .sheet(isPresented: $showBottomSheet) {
            sheetContentWithMapUnlocked
        }
        .onAppear {
            locationManager.requestAndStart()
            // If line is missing: gpxData may be nil — check Bundle.main.url(forResource: "MistTrail", withExtension: "gpx")
            if let data = gpxData, let result = GPXParser().parse(data: data), !result.coordinates.isEmpty {
                gpxResult = result
                if result.coordinates.count > 2 {
                    navigationEngine.load(result: result)
                }
            }
            if waypointsForSnap.count >= 2 {
                Task { await fetchMultiSegmentWalkingDirections(waypoints: waypointsForSnap) }
            }
            if useGPXMode, isSimulated, let first = gpxResult?.coordinates.first {
                let mock = CLLocation(latitude: first.latitude, longitude: first.longitude)
                navigationEngine.update(userLocation: mock)
            } else if useGPXMode {
                navigationEngine.update(userLocation: locationManager.userLocation)
                updateCameraForGPX()
            } else {
                updateNavigationState()
            }
            if !displayCoordinates.isEmpty {
                cameraPosition = .region(routeBoundingRegion())
            } else if let first = waypointsForSnap.first {
                cameraPosition = .region(MKCoordinateRegion(center: first, span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)))
            }
        }
        .onChange(of: locationManager.userLocation) { _, _ in
            guard !isSimulated else {
                if useGPXMode, let first = gpxResult?.coordinates.first {
                    let mock = CLLocation(latitude: first.latitude, longitude: first.longitude)
                    navigationEngine.update(userLocation: mock)
                }
                return
            }
            if useGPXMode {
                navigationEngine.update(userLocation: locationManager.userLocation)
                updateCameraForGPX()
            } else {
                updateNavigationState()
            }
        }
        .onDisappear {
            locationManager.stop()
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header: REROUTING... or Next Turn. English only. Clean frosted glass.
    private var navigationCommandHeader: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(displayTurnIcon)
                .font(.system(size: 28, weight: .bold))
            VStack(alignment: .leading, spacing: 2) {
                Text(displayIsOffCourse ? "REROUTING..." : "Next Turn")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
                Text(displayIsOffCourse ? "Return to Path" : displayTurnText)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(displayIsOffCourse ? Color(hex: "EF4444") : .white)
            }
            Spacer()
            Text(displayIsOffCourse ? "—" : formatDistance(displayDistanceToTurn))
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(displayIsOffCourse ? Color(hex: "EF4444") : tacticalPurple)
            // displayDistanceToTurn is along path (curve), not straight-line
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(displayIsOffCourse ? Color(hex: "EF4444").opacity(0.5) : tacticalPurple.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }

    private var turnInstructionText: String {
        switch turnIcon {
        case "⬆️": return "Straight"
        case "↗️": return "Bear right"
        case "➡️": return "Turn right"
        case "⬇️": return "Turn around"
        case "⬅️": return "Turn left"
        case "↖️": return "Bear left"
        default: return "Straight"
        }
    }

    /// Waypoints for multi-segment snap (GPX or path). No direct [A,B,C,D] — map uses snapped route only.
    private var waypointsForSnap: [CLLocationCoordinate2D] {
        if let r = gpxResult, !r.coordinates.isEmpty { return r.coordinates }
        return pathCoordinates
    }

    /// MapPolyline uses only concatenated MKRoute.polyline points (multi-segment walking). Never raw waypoints.
    private var polylineCoordinates: [CLLocationCoordinate2D] {
        directionsRouteCoordinates ?? []
    }

    // MARK: - Map: MapPolyline = snapped route only (multi-segment directions). No direct segment lines.
    private var precisionMapLayer: some View {
        let course = locationManager.userLocation?.course ?? -1
        let heading: CLLocationDirection = (course >= 0) ? course : locationManager.userHeadingDegrees
        return DetailedTrackMapLayer(
            fullTrackCoordinates: polylineCoordinates,
            userLocation: displayUserPin,
            userHeading: heading,
            cameraPosition: $cameraPosition
        )
        .ignoresSafeArea(.container)
    }

    /// Sheet content. Must have presentationBackgroundInteraction on outer layer so map can receive touch.
    private var sheetContentWithMapUnlocked: some View {
        bottomSheetWithElevationBar
            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            .interactiveDismissDisabled(true)
    }

    // MARK: - Bottom sheet: Min 150pt. English only. No Day labels.
    private var bottomSheetWithElevationBar: some View {
        let totalM = displayTotalMeters
        let elevationPointsForChart = gpxElevationPoints ?? track.elevationData
        let estimatedMinutes = totalM > 0 ? Int(totalM / 1000 * 15) : 0
        return VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Elevation")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 28)
                    .padding(.top, 24)
                if let points = elevationPointsForChart, !points.isEmpty {
                    ElevationBarView(
                        elevationPoints: points,
                        progressMeters: displayProgressMeters,
                        pathLengthMeters: totalM
                    )
                    .frame(height: 56)
                    .padding(.horizontal, 28)
                    .padding(.top, 14)
                }
                HStack {
                    Text("Total Distance")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                    Text(String(format: "%.1f km", totalM / 1000))
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(tacticalPurple)
                }
                .padding(.horizontal, 28)
                .padding(.top, 8)
                HStack {
                    Text("Estimated Time")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                    Text(estimatedMinutes >= 60 ? String(format: "%d hr %d min", estimatedMinutes / 60, estimatedMinutes % 60) : String(format: "%d min", estimatedMinutes))
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(tacticalPurple)
                }
                .padding(.horizontal, 28)
                .padding(.top, 4)
                HStack {
                    Text("Current Progress")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                    Text(String(format: "%.1f km / %.1f km", displayProgressMeters / 1000, totalM / 1000))
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(tacticalPurple)
                }
                .padding(.horizontal, 28)
                .padding(.top, 8)
                .padding(.bottom, 18)
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Next waypoint")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    Text(track.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                    Divider().background(.white.opacity(0.2))
                    HStack(spacing: 8) {
                        Label("Surface", systemImage: "circle.grid.2x2.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(tacticalPurple)
                        Text(track.trackQuality)
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    HStack(spacing: 8) {
                        Label("Conditions", systemImage: "cloud.sun.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(tacticalPurple)
                        Text("Check weather before departure")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 14)
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .presentationDetents([.height(150), .medium])
        .presentationDragIndicator(.visible)
    }

    /// Elevation points from GPX (distances → miles, elevations) for chart binding.
    private var gpxElevationPoints: [ElevationPoint]? {
        guard let r = gpxResult, !r.distances.isEmpty, r.distances.count == r.elevations.count else { return nil }
        return r.distances.enumerated().map { index, distance in
            ElevationPoint(mile: distance / 1609.34, elevation: r.elevations[index])
        }
    }

    private func formatDistance(_ meters: Double) -> String {
        if meters >= 1000 { return String(format: "%.1f km", meters / 1000) }
        return String(format: "%.0f m", max(0, meters))
    }

    private func pathLengthMeters() -> Double {
        let path = displayCoordinates
        guard path.count >= 2 else { return 0 }
        var sum: Double = 0
        for i in 1..<path.count {
            let a = path[i - 1], b = path[i]
            sum += CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
        }
        return sum
    }

    static func kmMarkerCoordinates(path: [CLLocationCoordinate2D], pathLengthMeters: Double) -> [(km: Int, coordinate: CLLocationCoordinate2D)] {
        guard path.count >= 2, pathLengthMeters > 0 else { return [] }
        var cumulative: [Double] = [0]
        for i in 1..<path.count {
            let a = path[i - 1], b = path[i]
            let d = CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
            cumulative.append((cumulative.last ?? 0) + d)
        }
        var result: [(Int, CLLocationCoordinate2D)] = []
        let totalKm = Int(pathLengthMeters / 1000)
        for km in 1...max(1, totalKm) {
            let d = Double(km) * 1000
            guard d < pathLengthMeters else { break }
            var seg = 0
            while seg + 1 < cumulative.count, cumulative[seg + 1] < d { seg += 1 }
            guard seg < path.count - 1 else { continue }
            let a = path[seg], b = path[seg + 1]
            let segStart = cumulative[seg], segEnd = cumulative[seg + 1]
            let t = segEnd > segStart ? (d - segStart) / (segEnd - segStart) : 0
            let lat = a.latitude + t * (b.latitude - a.latitude)
            let lon = a.longitude + t * (b.longitude - a.longitude)
            result.append((km, CLLocationCoordinate2D(latitude: lat, longitude: lon)))
        }
        return result
    }

    private func updateNavigationState() {
        guard let loc = locationManager.userLocation else { return }
        let coord = loc.coordinate
        let course = loc.course
        let effectiveCourse = (course >= 0) ? course : locationManager.userHeadingDegrees
        let path = displayCoordinates

        let distToPath = Self.distanceFrom(point: coord, toPolyline: path)
        isOffCourse = distToPath > offCourseThresholdMeters

        var progress: Double = 0
        var distToNext: Double = 0
        var nextTurnIcon: String = "⬆️"
        (progress, distToNext, nextTurnIcon) = Self.progressAndNextTurn(
            from: coord,
            path: path,
            userCourse: effectiveCourse
        )
        progressAlongPathMeters = progress
        distanceToNextTurnMeters = distToNext
        turnIcon = nextTurnIcon

        if !isOffCourse {
            let center = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            let heading = max(0, min(360, effectiveCourse))
            cameraPosition = .camera(
                MapCamera(centerCoordinate: center, distance: 400, heading: heading, pitch: 0)
            )
        }
    }

    private func updateCameraForGPX() {
        guard useGPXMode, !isSimulated else { return }
        if navigationEngine.isOffRoute, let loc = locationManager.userLocation {
            let c = loc.coordinate
            cameraPosition = .camera(MapCamera(centerCoordinate: c, distance: 400, heading: 0, pitch: 0))
            return
        }
        if let snapped = navigationEngine.snappedCoordinate, let loc = locationManager.userLocation {
            let heading = (loc.course >= 0) ? loc.course : locationManager.userHeadingDegrees
            cameraPosition = .camera(MapCamera(centerCoordinate: snapped, distance: 400, heading: heading, pitch: 0))
        }
    }

    /// Multi-point snap: request walking directions for each segment A→B, B→C, C→D… and concatenate all polyline points.
    private func fetchMultiSegmentWalkingDirections(waypoints: [CLLocationCoordinate2D]) async {
        guard waypoints.count >= 2 else { return }
        var allCoords: [CLLocationCoordinate2D] = []
        for i in 0..<(waypoints.count - 1) {
            let start = waypoints[i], end = waypoints[i + 1]
            let startItem = MKMapItem(placemark: MKPlacemark(coordinate: start))
            let endItem = MKMapItem(placemark: MKPlacemark(coordinate: end))
            let request = MKDirections.Request()
            request.source = startItem
            request.destination = endItem
            request.transportType = .walking
            request.requestsAlternateRoutes = false
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                guard let route = response.routes.first else { continue }
                let polyline = route.polyline
                let count = polyline.pointCount
                let points = polyline.points()
                if i == 0 {
                    for j in 0..<count { allCoords.append(points[j].coordinate) }
                } else {
                    for j in 1..<count { allCoords.append(points[j].coordinate) }
                }
            } catch {
                continue
            }
        }
        await MainActor.run {
            directionsRouteCoordinates = allCoords.isEmpty ? nil : allCoords
            if !allCoords.isEmpty {
                cameraPosition = .region(regionForCoordinates(allCoords))
            }
        }
    }

    private func regionForCoordinates(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.73, longitude: -119.55), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
        let lats = coords.map(\.latitude), lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
        let pad = 0.003
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) + pad, 0.008),
            longitudeDelta: max((maxLon - minLon) + pad, 0.008)
        )
        return MKCoordinateRegion(center: center, span: span)
    }

    /// Fit map to route bounding box (no focus on user location). Used for initial camera and preview.
    private func routeBoundingRegion() -> MKCoordinateRegion {
        let coords = displayCoordinates
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.73, longitude: -119.55), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
        let pad = 0.003
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) + pad, 0.008),
            longitudeDelta: max((maxLon - minLon) + pad, 0.008)
        )
        return MKCoordinateRegion(center: center, span: span)
    }

    static func distanceFrom(point: CLLocationCoordinate2D, toPolyline coords: [CLLocationCoordinate2D]) -> Double {
        guard coords.count >= 2 else { return 0 }
        var minD = Double.greatestFiniteMagnitude
        for i in 0..<(coords.count - 1) {
            let (dist, _) = closestPoint(onSegment: (coords[i], coords[i + 1]), from: point)
            if dist < minD { minD = dist }
        }
        return minD
    }

    static func closestPoint(onSegment segment: (CLLocationCoordinate2D, CLLocationCoordinate2D), from point: CLLocationCoordinate2D) -> (Double, Double) {
        let (a, b) = segment
        let dx = b.longitude - a.longitude, dy = b.latitude - a.latitude
        let t = max(0, min(1, (dx * (point.longitude - a.longitude) + dy * (point.latitude - a.latitude)) / (dx * dx + dy * dy + 1e-20)))
        let px = a.latitude + t * (b.latitude - a.latitude), py = a.longitude + t * (b.longitude - a.longitude)
        let dist = CLLocation(latitude: point.latitude, longitude: point.longitude)
            .distance(from: CLLocation(latitude: px, longitude: py))
        return (dist, t)
    }

    static func progressAndNextTurn(from point: CLLocationCoordinate2D, path: [CLLocationCoordinate2D], userCourse: Double) -> (progressMeters: Double, distanceToNextMeters: Double, turnIcon: String) {
        guard path.count >= 2 else { return (0, 0, "⬆️") }
        var cumulative: [Double] = [0]
        for i in 1..<path.count {
            let a = path[i - 1], b = path[i]
            let d = CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
            cumulative.append((cumulative.last ?? 0) + d)
        }
        let total = cumulative.last ?? 0
        var bestSegment = 0
        var bestT: Double = 0
        var bestDist = Double.greatestFiniteMagnitude
        for i in 0..<(path.count - 1) {
            let (dist, t) = closestPoint(onSegment: (path[i], path[i + 1]), from: point)
            if dist < bestDist {
                bestDist = dist
                bestSegment = i
                bestT = t
            }
        }
        let progressMeters = (cumulative[bestSegment] + bestT * (cumulative[bestSegment + 1] - cumulative[bestSegment]))
        var distanceToNext: Double = 0
        var turnIcon = "⬆️"
        if bestSegment + 1 < path.count {
            distanceToNext = total - progressMeters
            let nextPt = path[bestSegment + 1]
            let curPt = path[bestSegment]
            let bearing = atan2(nextPt.longitude - curPt.longitude, nextPt.latitude - curPt.latitude) * 180 / .pi
            let rel = (bearing - (userCourse * .pi / 180)).truncatingRemainder(dividingBy: 2 * .pi)
            let deg = rel * 180 / .pi
            if deg > -30 && deg <= 30 { turnIcon = "⬆️" }
            else if deg > 30 && deg <= 90 { turnIcon = "↗️" }
            else if deg > 90 && deg <= 150 { turnIcon = "➡️" }
            else if deg > 150 || deg <= -150 { turnIcon = "⬇️" }
            else if deg > -150 && deg <= -90 { turnIcon = "⬅️" }
            else { turnIcon = "↖️" }
        }
        return (progressMeters, max(0, distanceToNext), turnIcon)
    }
}

// MARK: - Map layer: MapPolyline = parsed GPX coordinates only. No 1km waypoints. “You” = separate Annotation.
struct DetailedTrackMapLayer: View {
    /// Parsed GPX full array (hundreds of points). This is the ONLY source for the purple line.
    let fullTrackCoordinates: [CLLocationCoordinate2D]
    let userLocation: CLLocationCoordinate2D?
    let userHeading: CLLocationDirection
    @Binding var cameraPosition: MapCameraPosition

    private let routeColor = Color(hex: "A855F7")

    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all) {
            if fullTrackCoordinates.count >= 2 {
                MapPolyline(coordinates: fullTrackCoordinates)
                    .stroke(routeColor, lineWidth: 5)
            }
            if let coord = userLocation {
                Annotation("You", coordinate: coord) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .mapControls {
            MapCompass()
            MapScaleView()
        }
    }
}

// MARK: - Elevation chart: padding so curve does not touch edges. Spacing from data text.
struct ElevationBarView: View {
    let elevationPoints: [ElevationPoint]
    let progressMeters: Double
    let pathLengthMeters: Double

    private let accentColor = Color(hex: "A855F7")
    private let chartInset: CGFloat = 16

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let rect = CGRect(x: chartInset, y: chartInset, width: max(0, w - 2 * chartInset), height: max(0, h - 2 * chartInset))
            ZStack(alignment: .leading) {
                elevationPath(in: rect)
                    .stroke(accentColor.opacity(0.5), lineWidth: 2)
                if pathLengthMeters > 0 {
                    let t = min(1, max(0, progressMeters / pathLengthMeters))
                    Circle()
                        .fill(accentColor)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                        .position(x: rect.minX + t * rect.width, y: yForProgress(t, in: rect.height) + rect.minY)
                }
            }
        }
    }

    private func yForProgress(_ t: Double, in height: CGFloat) -> CGFloat {
        guard !elevationPoints.isEmpty else { return height / 2 }
        let totalMile = elevationPoints.last?.mile ?? 1
        let mile = t * totalMile
        let pts = elevationPoints
        guard let i = pts.firstIndex(where: { $0.mile >= mile }) else {
            let e = pts.last?.elevation ?? 0
            return elevationToY(e, height: height)
        }
        if i == 0 { return elevationToY(pts[0].elevation, height: height) }
        let a = pts[i - 1], b = pts[i]
        let frac = (mile - a.mile) / max(b.mile - a.mile, 1e-6)
        let e = a.elevation + frac * (b.elevation - a.elevation)
        return elevationToY(e, height: height)
    }

    private func elevationToY(_ e: Double, height: CGFloat) -> CGFloat {
        let minE = elevationPoints.map(\.elevation).min() ?? 0
        let maxE = elevationPoints.map(\.elevation).max() ?? 1
        let range = max(maxE - minE, 1)
        return height - CGFloat((e - minE) / range) * height * 0.8
    }

    private func elevationPath(in rect: CGRect) -> Path {
        guard elevationPoints.count >= 2, rect.width > 0, rect.height > 0 else { return Path() }
        let minE = elevationPoints.map(\.elevation).min() ?? 0
        let maxE = elevationPoints.map(\.elevation).max() ?? 1
        let range = max(maxE - minE, 1)
        let totalMile = elevationPoints.last?.mile ?? 1
        return Path { path in
            for (i, pt) in elevationPoints.enumerated() {
                let x = totalMile > 0 ? rect.minX + rect.width * CGFloat(pt.mile / totalMile) : rect.minX
                let y = rect.maxY - CGFloat((pt.elevation - minE) / range) * rect.height * 0.8
                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
        }
    }
}

private final class DetailedTrackLocationManager: NSObject, ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var userHeadingDegrees: Double = 0

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 3
        manager.headingFilter = 5
    }

    func requestAndStart() {
        manager.requestWhenInUseAuthorization()
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
    }

    func stop() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
}

extension DetailedTrackLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading.trueHeading >= 0 else { return }
        userHeadingDegrees = newHeading.trueHeading
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
