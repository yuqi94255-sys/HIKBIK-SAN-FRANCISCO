// MARK: - Route Detail ViewModel — map, route, weather, camera logic; View only renders.
import SwiftUI
import MapKit
import CoreLocation

/// Detail sheet engine: state and map/route/weather logic; View renders only.
final class RouteDetailViewModel: ObservableObject {
    let journey: ManualJourney

    @Published var routeSegments: [[CLLocationCoordinate2D]] = []
    @Published var isLoadingRoutes = false
    @Published var mapPosition: MapCameraPosition = .automatic
    @Published var showSheet = true
    @Published var isFavorite = false
    @Published var sheetDetent: PresentationDetent = .fraction(0.4)
    @Published var selectedViewPointIndex: Int? = nil
    @Published var weatherSnapshot: WeatherSnapshot? = nil

    /// Delay between segment requests (seconds) to avoid Apple rate limit.
    private let requestSpacingSeconds: TimeInterval = 0.18
    private let minSegmentDistanceMeters: Double = 5

    init(journey: ManualJourney) {
        self.journey = journey
    }

    var effectiveRouteID: String { journey.effectiveRouteID }
    var theme: LandManagementTheme { LandManagementTheme.from(journey.category) }
    var accentColor: Color { theme.accentColor }
    var isSheetFullyExpanded: Bool { sheetDetent == .large }

    var routeCoordinates: [CLLocationCoordinate2D] {
        journey.viewPointNodes.compactMap { node in
            guard let lat = node.latitude, let lon = node.longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }

    /// 路線總距離（米），用於詳情頁 Distance 展示
    var totalDistanceMeters: Double {
        let coords = routeSegments.isEmpty ? routeCoordinates : routeSegments.flatMap { $0 }
        guard coords.count >= 2 else { return 0 }
        var meters: Double = 0
        for i in 0..<(coords.count - 1) {
            let a = coords[i], b = coords[i + 1]
            meters += CLLocation(latitude: a.latitude, longitude: a.longitude).distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
        }
        return meters
    }

    /// 格式化距離（英里），Hiking 優化
    var totalDistanceFormatted: String {
        let miles = totalDistanceMeters / 1609.34
        if miles < 0.01 { return "0 mi" }
        if miles < 0.1 { return String(format: "%.2f mi", miles) }
        if miles < 1 { return String(format: "%.1f mi", miles) }
        return String(format: "%.1f mi", miles)
    }

    var viewPointCount: Int { journey.viewPointNodes.count }

    private var directionsTransportType: MKDirectionsTransportType {
        let hasOverlanding = journey.viewPointNodes.contains { $0.activityType == .overlanding }
        return hasOverlanding ? .automobile : .walking
    }

    /// 段 i 是否為水上活動（paddling/boating/fishing），此段不請求 MKDirections，用直線
    private func isWaterSegment(from nodeIndex: Int) -> Bool {
        guard nodeIndex < journey.viewPointNodes.count else { return false }
        let activity = journey.viewPointNodes[nodeIndex].activityType
        switch activity {
        case .paddling, .boating, .fishing: return true
        default: return false
        }
    }

    // MARK: - Lifecycle（由 View onAppear / onChange 呼叫）
    func onAppear() {
        let coords = routeCoordinates
        if !coords.isEmpty {
            let region = regionForCoordinates(coords)
            let heading = headingFromPath(coords)
            let camera = cameraForRegion(region, heading: heading)
            DispatchQueue.main.async { [weak self] in
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.mapPosition = .camera(camera)
                }
                self?.calculateRouteLines()
            }
        }
        refreshWeather(forViewPointIndex: nil)
        showSheet = true
        // Like 狀態優先與 CurrentUser 同步（SocialDataManager 保留兼容）
        isFavorite = SocialDataManager.shared.isFavorite(routeID: effectiveRouteID)
    }

    func toggleFavorite() {
        let newValue = SocialDataManager.shared.toggleFavorite(routeID: effectiveRouteID)
        DispatchQueue.main.async { [weak self] in
            self?.isFavorite = newValue
        }
    }

    /// 從 CurrentUser 同步 Like 狀態（Profile 跳轉回來時收藏/點贊按鈕正確顯示）
    func setFavoriteFromCurrentUser(_ liked: Bool) {
        isFavorite = liked
    }

    /// 分享用純文本摘要（無網頁時）：路線名 + 座標簡述
    var shareMessage: String {
        let name = journey.routeName
        let cat = journey.category?.rawValue ?? "Route"
        let count = journey.viewPointNodes.count
        let duration = journey.calculatedRealDuration ?? "\(journey.totalDurationMinutes) min"
        let gain = journey.elevationGain ?? "—"
        var lines = ["\(name)", "\(cat) · \(count) stops · \(duration)", "Elevation gain: \(gain)"]
        if let first = journey.viewPointNodes.first, let lat = first.latitude, let lon = first.longitude {
            lines.append("Start: \(String(format: "%.4f", lat)), \(String(format: "%.4f", lon))")
        }
        lines.append("— Shared from HikBik")
        return lines.joined(separator: "\n")
    }

    func onSheetDetentChange() {
        updateMapPositionForSheet()
    }

    func onSelectedViewPointChange(index: Int?) {
        guard let idx = index else { return }
        flyToViewPoint(at: idx)
        refreshWeather(forViewPointIndex: idx)
    }

    // MARK: - 地圖與相機
    func regionForCoordinates(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39, longitude: -98), span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
        }
        let lats = coords.map(\.latitude), lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let rawLatDelta = max(maxLat - minLat, 0.0001)
        let rawLonDelta = max(maxLon - minLon, 0.0001)
        let padding = 1.4
        let minLatMeters: Double = 1000
        let metersPerDegreeLat: Double = 111_320
        let minLatDelta = max(minLatMeters / metersPerDegreeLat, 0.01)
        let cosLat = max(0.01, cos(center.latitude * .pi / 180))
        let minLonDelta = minLatDelta / cosLat
        let span = MKCoordinateSpan(
            latitudeDelta: max(rawLatDelta * padding, minLatDelta),
            longitudeDelta: max(rawLonDelta * padding, minLonDelta)
        )
        return MKCoordinateRegion(center: center, span: span)
    }

    /// 使用首段有效方向計算 heading（環形步道 first/last 重合時改用 coords[0]–coords[1]，距離過近則往後找）
    func headingFromPath(_ coords: [CLLocationCoordinate2D]) -> Double {
        guard coords.count >= 2 else { return 0 }
        var i = 0
        while i + 1 < coords.count {
            let a = coords[i]
            let b = coords[i + 1]
            let dist = hypot((b.longitude - a.longitude) * 111_320 * cos(a.latitude * .pi / 180), (b.latitude - a.latitude) * 111_320)
            if dist >= minSegmentDistanceMeters {
                let φ1 = a.latitude * .pi / 180
                let φ2 = b.latitude * .pi / 180
                let Δλ = (b.longitude - a.longitude) * .pi / 180
                let y = sin(Δλ) * cos(φ2)
                let x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ)
                var deg = atan2(y, x) * 180 / .pi
                if deg < 0 { deg += 360 }
                return deg
            }
            i += 1
        }
        return 0
    }

    func cameraForRegion(_ region: MKCoordinateRegion, heading: Double) -> MapCamera {
        let metersPerDegree: Double = 111_320
        let cosLat = max(0.01, cos(region.center.latitude * .pi / 180))
        let latMeters = region.span.latitudeDelta * metersPerDegree
        let lonMeters = region.span.longitudeDelta * metersPerDegree * cosLat
        let spanMeters = max(latMeters, lonMeters)
        let distance = max(spanMeters * 2.2, 800)
        return MapCamera(centerCoordinate: region.center, distance: distance, heading: heading, pitch: 45)
    }

    func updateMapPositionForSheet() {
        let coords = routeSegments.isEmpty ? routeCoordinates : routeSegments.flatMap { $0 }
        guard !coords.isEmpty else { return }
        var region = regionForCoordinates(coords)
        if sheetDetent == .medium {
            let offset = region.span.latitudeDelta * 0.28
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: region.center.latitude - offset, longitude: region.center.longitude),
                span: region.span
            )
        }
        let heading = headingFromPath(coords)
        let camera = cameraForRegion(region, heading: heading)
        DispatchQueue.main.async { [weak self] in
            withAnimation(.easeInOut(duration: 0.35)) {
                self?.mapPosition = .camera(camera)
            }
        }
    }

    func flyToViewPoint(at index: Int) {
        let coords = routeSegments.isEmpty ? routeCoordinates : routeSegments.flatMap { $0 }
        guard index >= 0, index < journey.viewPointNodes.count else { return }
        guard let lat = journey.viewPointNodes[index].latitude, let lon = journey.viewPointNodes[index].longitude else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let distance: Double = 650
        let heading = coords.count >= 2 ? headingFromPath(coords) : 0
        let camera = MapCamera(centerCoordinate: center, distance: distance, heading: heading, pitch: 45)
        DispatchQueue.main.async { [weak self] in
            withAnimation(.easeInOut(duration: 0.55)) {
                self?.mapPosition = .camera(camera)
            }
        }
    }

    // MARK: - 路徑計算（Fallback 直線、水上跳過、請求間隔防 Rate Limit）
    func calculateRouteLines() {
        let coords = routeCoordinates
        guard coords.count >= 2, routeSegments.isEmpty else { return }
        isLoadingRoutes = true
        let count = coords.count - 1
        var segments: [[CLLocationCoordinate2D]?] = Array(repeating: nil, count: count)
        let lock = NSLock()
        let transport = directionsTransportType

        func setSegment(_ index: Int, _ value: [CLLocationCoordinate2D]) {
            lock.lock()
            segments[index] = value
            lock.unlock()
        }

        func straightLine(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
            [from, to]
        }

        let group = DispatchGroup()
        for i in 0..<count {
            let from = coords[i]
            let to = coords[i + 1]
            let useWaterStraight = isWaterSegment(from: i) || isWaterSegment(from: i + 1)

            if useWaterStraight {
                setSegment(i, straightLine(from: from, to: to))
                continue
            }

            group.enter()
            let delay = requestSpacingSeconds * Double(i)
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + delay) {
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
                request.transportType = transport
                request.requestsAlternateRoutes = false
                MKDirections(request: request).calculate { response, _ in
                    defer { group.leave() }
                    if let route = response?.routes.first, route.polyline.pointCount > 0 {
                        let polyline = route.polyline
                        let pts = polyline.points()
                        var segmentCoords: [CLLocationCoordinate2D] = []
                        for j in 0..<polyline.pointCount {
                            segmentCoords.append(pts[j].coordinate)
                        }
                        setSegment(i, segmentCoords)
                    } else {
                        setSegment(i, straightLine(from: from, to: to))
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.routeSegments = segments.compactMap { $0 }
            self.isLoadingRoutes = false
            if !self.routeSegments.isEmpty {
                self.updateMapPositionForSheet()
            }
        }
    }

    // MARK: - 天氣
    func refreshWeather(forViewPointIndex index: Int?) {
        let coord: CLLocationCoordinate2D?
        if let i = index, i >= 0, i < journey.viewPointNodes.count,
           let lat = journey.viewPointNodes[i].latitude, let lon = journey.viewPointNodes[i].longitude {
            coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            coord = routeCoordinates.first
        }
        guard let coordinate = coord else { return }
        WeatherManager.shared.fetchWeather(for: coordinate) { [weak self] snapshot in
            DispatchQueue.main.async {
                self?.weatherSnapshot = snapshot
            }
        }
    }
}
