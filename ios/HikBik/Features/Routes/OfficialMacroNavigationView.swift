// MARK: - 官方宏觀導航：全屏 2D 地圖、頂部指令、底部 Sheet 儀表盤
import SwiftUI
import MapKit
import CoreLocation
import UIKit

// MARK: - 官方推薦路徑（MKDirections：沿道路駕駛軌跡，禁止兩點直線）
private enum RouteDirections {
    /// 兩點間駕駛路線，貼馬路彎曲軌跡
    static func fetchDrivingRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) async -> [CLLocationCoordinate2D]? {
        await withCheckedContinuation { continuation in
            let req = MKDirections.Request()
            req.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
            req.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
            req.transportType = .automobile
            let dir = MKDirections(request: req)
            dir.calculate { response, _ in
                guard let route = response?.routes.first else {
                    continuation.resume(returning: nil)
                    return
                }
                let points = polylineToCoordinates(route.polyline)
                continuation.resume(returning: points.isEmpty ? nil : points)
            }
        }
    }

    static func polylineToCoordinates(_ polyline: MKPolyline) -> [CLLocationCoordinate2D] {
        let count = polyline.pointCount
        guard count > 0 else { return [] }
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: count)
        polyline.getCoordinates(&coords, range: NSRange(location: 0, length: count))
        return coords
    }

    /// 若某段點數過少（折線感），則用 Directions 取得沿路路徑
    static func resolveRoadSegments(daySegments: [[CLLocationCoordinate2D]], minPointsForUseAsIs: Int = 8) async -> [[CLLocationCoordinate2D]] {
        var result: [[CLLocationCoordinate2D]] = []
        for coords in daySegments {
            guard let first = coords.first, let last = coords.last else { result.append(coords); continue }
            if coords.count >= minPointsForUseAsIs {
                result.append(coords)
                continue
            }
            if let road = await fetchDrivingRoute(from: first, to: last), !road.isEmpty {
                result.append(road)
            } else {
                result.append(coords)
            }
        }
        return result
    }

    /// 官方真實導航路徑：單日 MKDirections automobile 路線（起終點來自 JSON/座標）
    static func fetchOfficialRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) async -> [CLLocationCoordinate2D]? {
        await fetchDrivingRoute(from: start, to: end)
    }
}

// MARK: - 導航狀態機
private enum MacroNavState {
    case onRoute
    case offRoute(meters: Double)
}

// MARK: - 定位管理（用於 userLocation 與偏航檢測）
private final class MacroNavLocationManager: NSObject, ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        authorizationStatus = manager.authorizationStatus
    }

    func requestAndStart() {
        manager.requestWhenInUseAuthorization()
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func stop() {
        manager.stopUpdatingLocation()
    }
}

extension MacroNavLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

// MARK: - 主視圖（多天數：頂部 Day 標籤、地圖分段、底部按 Day 分組里程碑）
struct OfficialMacroNavigationView: View {
    let route: OfficialMacroRoute
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = MacroNavLocationManager()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var followUser: Bool = true
    @State private var selectedMilestoneId: String?
    /// 經 MKDirections 解析後的沿路路徑（貼馬路），nil 時用 payload 的 pathCoordinates
    @State private var roadSegments: [[CLLocationCoordinate2D]]? = nil
    @State private var directionsLoading: Bool = false
    /// 用於 onChange：CLLocationCoordinate2D 不支援 Equatable，改觀察版本號
    @State private var roadSegmentsVersion: Int = 0
    /// 選中的天數：nil = 全局預覽 + GlobalMiniSheet，非 nil = 分段聚焦 + DayDetailSheet
    @State private var selectedDayIndex: Int? = nil
    /// 選中天的 DayRoute.id，用於顏色綁定（選中段亮白/亮紫，其餘 0.3 透明度）
    @State private var selectedDayId: String? = nil
    /// 底部 Sheet 常駐顯示；false 僅在離開頁面時由調用方控制
    @State private var isShowingBottomSheet: Bool = true
    /// Sheet 當前高度：.height(100) = 摺疊，.medium = 半屏（50%），禁止 .large
    @State private var sheetDetent: PresentationDetent = .height(100)
    /// 初始狀態 Sheet 的 detent（100pt 迷你 / 50% 展開），與 sheetDetent 分開以便無縫切到單日
    @State private var globalSheetDetent: PresentationDetent = .height(100)

    private let tacticalPurple = Color(hex: "A855F7")
    /// 選中模式：被選中段高亮色（強發光紫）
    private let selectedSegmentHighlight = Color(hex: "CF9FFF")
    private let offRouteThresholdMeters: Double = 200
    private let walkingSpeedMetersPerSecond: Double = 0.5

    /// 多天數導航用：優先從 JSON days[].pathCoordinates 載入官方路徑，否則由 route 切分
    private var payload: MacroJourneyNavigationPayload {
        if route.id == "arizona-trip-itinerary",
           let json = MacroJourneyJSON.load(filename: "arizona-trip-itinerary") {
            return json.toNavigationPayload()
        }
        return route.toNavigationPayload()
    }

    /// 實際用於地圖與距離計算的每日路徑（已用 Directions 替換稀疏折線時為沿路駕駛軌跡）
    private var effectiveDaySegments: [[CLLocationCoordinate2D]] {
        roadSegments ?? payload.daySegmentCoordinates
    }

    /// 根據當前位置判定所在 Day 段落（與該段路徑最近則視為該天）
    private var currentDayIndex: Int {
        guard let loc = locationManager.userLocation else { return 0 }
        let segs = effectiveDaySegments
        guard !segs.isEmpty else { return 0 }
        var best = 0
        var bestD = Double.greatestFiniteMagnitude
        for (i, coords) in segs.enumerated() {
            guard coords.count >= 2 else { continue }
            let d = Self.distanceFrom(point: loc.coordinate, toPolyline: coords)
            if d < bestD { bestD = d; best = i }
        }
        return min(best, payload.dayRoutes.count - 1)
    }

    private var currentDayRoute: DayRoute {
        let idx = currentDayIndex
        guard idx >= 0, idx < payload.dayRoutes.count else {
            return payload.dayRoutes.first ?? DayRoute(id: "d1", day: 1, from: "", to: "", duration: "", distance: "")
        }
        return payload.dayRoutes[idx]
    }

    /// 導航用完整路徑（與地圖渲染一致：沿路 pathCoordinates 或 Directions 結果，禁止直線）
    private var fullPathCoordinates: [CLLocationCoordinate2D] {
        effectiveDaySegments.flatMap { $0 }
    }

    /// 沿路行駛總里程（mi），用於 UI 顯示，非兩點直線距離
    private var totalRouteDistanceMiles: Double {
        totalRouteLengthMeters() / 1609.34
    }

    /// 整趟 Journey 總標題（頂部 HUD 顯示，非單一地點）
    private var journeyTitle: String {
        payload.name.isEmpty ? route.name : payload.name
    }

    private var distanceToPathMeters: Double {
        guard let loc = locationManager.userLocation else { return 0 }
        return Self.distanceFrom(point: loc.coordinate, toPolyline: fullPathCoordinates)
    }

    private var navState: MacroNavState {
        let d = distanceToPathMeters
        if d > offRouteThresholdMeters { return .offRoute(meters: d) }
        return .onRoute
    }

    private var nextMilestone: MacroStation? {
        guard let loc = locationManager.userLocation else { return route.milestones.first }
        let progress = progressAlongPath(from: loc.coordinate)
        return route.milestones.first { $0.distanceFromStart > progress }
    }

    private var etaToNextMilestoneSeconds: Double? {
        guard let next = nextMilestone, let loc = locationManager.userLocation else { return nil }
        let toMilestone = CLLocation(latitude: next.coordinate.latitude, longitude: next.coordinate.longitude)
        let meters = loc.distance(from: toMilestone)
        return meters / walkingSpeedMetersPerSecond
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            macroMap
            backButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0A0C10"))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            locationManager.requestAndStart()
            centerMapOnRoute()
            fetchRoadSegmentsIfNeeded()
        }
        .onChange(of: roadSegmentsVersion) { _, _ in
            centerMapOnRoute()
        }
        .onChange(of: selectedDayIndex) { _, new in
            if let idx = new {
                withAnimation(.spring()) {
                    zoomToSegment(idx)
                    sheetDetent = .medium
                }
            } else {
                withAnimation(.spring()) {
                    centerMapOnRoute()
                    sheetDetent = .height(100)
                }
            }
        }
        .onChange(of: sheetDetent) { _, new in
            if new == .height(100) {
                selectedDayId = nil
                selectedDayIndex = nil
            }
        }
        .sheet(isPresented: $isShowingBottomSheet) {
            Group {
                if selectedDayId == nil {
                    GlobalMiniSheet(
                        tripName: journeyTitle,
                        totalMiles: totalRouteDistanceMiles,
                        progressText: "Day \(currentDayIndex + 1) of \(payload.dayRoutes.count)",
                        dayCount: payload.dayRoutes.count,
                        accentColor: tacticalPurple,
                        dayRoutes: payload.dayRoutes,
                        sheetDetent: globalSheetDetent,
                        selectedDayIndex: selectedDayIndex,
                        onSelectDay: { index in
                            withAnimation(.spring()) {
                                selectedDayIndex = index
                                selectedDayId = payload.dayRoutes[index].id
                                sheetDetent = .medium
                            }
                        }
                    )
                    .presentationDetents([.height(100), .medium], selection: $globalSheetDetent)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.ultraThinMaterial)
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled(true)
                } else if let idx = selectedDayIndex, idx < payload.dayRoutes.count {
                    let daySeg = effectiveDaySegments.indices.contains(idx) ? effectiveDaySegments[idx] : []
                    let searchCenter = segmentCenter(daySeg) ?? daySeg.first ?? CLLocationCoordinate2D(latitude: 34, longitude: -112)
                    DayDetailSheet(
                        dayRoute: payload.dayRoutes[idx],
                        milestones: payload.milestonesByDay[idx],
                        searchCenter: searchCenter,
                        accentColor: tacticalPurple,
                        sheetDetent: $sheetDetent,
                        onBackToGlobal: {
                            withAnimation(.spring()) {
                                selectedDayId = nil
                                selectedDayIndex = nil
                                sheetDetent = .height(100)
                                globalSheetDetent = .height(100)
                            }
                        },
                        onStartNavigation: { dismiss() }
                    )
                    .presentationDetents([.height(100), .medium], selection: $sheetDetent)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.ultraThinMaterial)
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled(true)
                }
            }
        }
        .onDisappear {
            locationManager.stop()
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - 全屏 2D 地圖（selectedDay 為空 = 全局紫龍；選中 = 聚焦該段 + 其餘淡出）
    private var macroMap: some View {
        Map(position: $cameraPosition, interactionModes: [.zoom]) {
            // 1. 路線：全局 = 全紫；選中模式 = 選中段亮紫/白、其餘官方紫 opacity 0.3
            if selectedDayId == nil {
                if fullPathCoordinates.count >= 2 {
                    MapPolyline(coordinates: fullPathCoordinates)
                        .stroke(tacticalPurple, lineWidth: 5)
                }
            } else {
                ForEach(Array(effectiveDaySegments.enumerated()), id: \.offset) { index, coords in
                    if coords.count >= 2, index < payload.dayRoutes.count {
                        let dayRoute = payload.dayRoutes[index]
                        let isSelected = dayRoute.id == selectedDayId
                        MapPolyline(coordinates: coords)
                            .stroke(
                                isSelected ? selectedSegmentHighlight : tacticalPurple.opacity(0.3),
                                lineWidth: isSelected ? 6 : 3
                            )
                    }
                }
            }
            // 2. Day 標籤：預設極簡小圓點+數字；點擊後展開長條 + 高亮 + Sheet
            ForEach(Array(effectiveDaySegments.enumerated()), id: \.offset) { index, coords in
                if index < payload.dayRoutes.count, let centerCoord = segmentCenter(coords) {
                    let dayRoute = payload.dayRoutes[index]
                    let isExpanded = dayRoute.id == selectedDayId
                    Annotation("Day \(index + 1)", coordinate: centerCoord) {
                        Button {
                            withAnimation(.spring()) {
                                selectedDayIndex = index
                                selectedDayId = payload.dayRoutes[index].id
                            }
                        } label: {
                            if isExpanded {
                                Text("\(dayRoute.from) - \(dayRoute.to) | \(dayRoute.duration)")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(tacticalPurple.opacity(0.5), lineWidth: 1)
                                    )
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(tacticalPurple.opacity(0.92))
                                        .frame(width: 28, height: 28)
                                    Text("\(index + 1)")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            ForEach(route.milestones) { m in
                Annotation(m.title, coordinate: m.coordinate) {
                    ZStack {
                        Circle()
                            .fill(tacticalPurple.opacity(0.9))
                            .frame(width: 24, height: 24)
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                }
            }
            if let coord = locationManager.userLocation?.coordinate {
                Annotation("You", coordinate: coord) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .onMapCameraChange { context in
            if followUser, let coord = locationManager.userLocation?.coordinate {
                let center = context.region.center
                if abs(center.latitude - coord.latitude) > 0.0001 || abs(center.longitude - coord.longitude) > 0.0001 {
                    followUser = false
                }
            }
        }
        .ignoresSafeArea(.container)
    }

    // MARK: - 左上角 Back 按鈕（極簡、無文字）
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
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

    /// 每段路徑中點（沿路距離的一半），標籤精確釘在推薦路線中段
    private func segmentCenter(_ coords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        guard coords.count >= 2 else { return coords.first }
        var cumulative: [Double] = [0]
        for i in 1..<coords.count {
            let a = coords[i - 1], b = coords[i]
            let d = CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
            cumulative.append((cumulative.last ?? 0) + d)
        }
        let total = cumulative.last ?? 0
        guard total > 0 else { return coords[coords.count / 2] }
        let half = total / 2
        for i in 0..<(cumulative.count - 1) {
            if cumulative[i + 1] >= half {
                let t = (half - cumulative[i]) / (cumulative[i + 1] - cumulative[i] + 1e-10)
                let a = coords[i], b = coords[i + 1]
                return CLLocationCoordinate2D(
                    latitude: a.latitude + t * (b.latitude - a.latitude),
                    longitude: a.longitude + t * (b.longitude - a.longitude)
                )
            }
        }
        return coords[coords.count / 2]
    }

    /// 導航啟動時一次性加載 Day 1～Day N 所有真實道路路徑（MKDirections automobile）
    private func fetchRoadSegmentsIfNeeded() {
        guard route.id == "arizona-trip-itinerary" else { return }
        let segs = payload.daySegmentCoordinates
        directionsLoading = true
        Task {
            // 遍歷所有天數，每段調用 fetchOfficialRoute(from:to:) 取得貼公路路線
            let resolved = await RouteDirections.resolveRoadSegments(daySegments: segs, minPointsForUseAsIs: 15)
            await MainActor.run {
                roadSegments = resolved
                roadSegmentsVersion += 1
                directionsLoading = false
            }
        }
    }

    /// 全景初始化：顯示 Day 1～Day N 完整路徑邊界
    private func centerMapOnRoute() {
        let coords = fullPathCoordinates
        guard !coords.isEmpty else { return }
        var rect = MKMapRect.null
        for coord in coords {
            let point = MKMapPoint(coord)
            let ptRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            rect = rect.isNull ? ptRect : rect.union(ptRect)
        }
        guard !rect.isNull else { return }
        let padding = 0.25
        rect = rect.insetBy(dx: -rect.size.width * padding, dy: -rect.size.height * padding)
        cameraPosition = .rect(rect)
    }

    /// 分段聚焦：縮放到該段 polyline 範圍
    private func zoomToSegment(_ index: Int) {
        let segs = effectiveDaySegments
        guard index >= 0, index < segs.count else { return }
        let coords = segs[index]
        guard !coords.isEmpty else { return }
        var rect = MKMapRect.null
        for coord in coords {
            let point = MKMapPoint(coord)
            let ptRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            rect = rect.isNull ? ptRect : rect.union(ptRect)
        }
        guard !rect.isNull else { return }
        let padding = 0.3
        rect = rect.insetBy(dx: -rect.size.width * padding, dy: -rect.size.height * padding)
        cameraPosition = .rect(rect)
    }

    private func formatETA(_ seconds: Double) -> String {
        let m = Int(seconds / 60)
        if m < 60 { return "\(m) min" }
        let h = m / 60
        let rem = m % 60
        return rem == 0 ? "\(h) hr" : "\(h) hr \(rem) min"
    }

    /// 當前位置沿路徑的進度（起點到最近點的累計里程，mi），使用與地圖一致的 fullPathCoordinates
    private func progressAlongPath(from coordinate: CLLocationCoordinate2D) -> Double {
        let coords = fullPathCoordinates
        guard coords.count >= 2 else { return 0 }
        var minDist = Double.greatestFiniteMagnitude
        var progressMeters: Double = 0
        let n = coords.count
        var cumulative: [Double] = [0]
        for i in 1..<n {
            let a = coords[i - 1], b = coords[i]
            let d = CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
            cumulative.append((cumulative.last ?? 0) + d)
        }
        for i in 0..<(n - 1) {
            let a = coords[i], b = coords[i + 1]
            let segLen = CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
            let (dist, t) = Self.closestPoint(onSegment: (a, b), from: coordinate)
            if dist < minDist {
                minDist = dist
                progressMeters = cumulative[i] + t * segLen
            }
        }
        return progressMeters / 1609.34
    }

    private func totalRouteLengthMeters() -> Double {
        let coords = fullPathCoordinates
        guard coords.count >= 2 else { return 0 }
        var sum: Double = 0
        for i in 1..<coords.count {
            let a = coords[i - 1], b = coords[i]
            sum += CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
        }
        return sum
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

    private static func closestPoint(onSegment segment: (CLLocationCoordinate2D, CLLocationCoordinate2D), from point: CLLocationCoordinate2D) -> (Double, Double) {
        let (a, b) = segment
        let dx = b.longitude - a.longitude, dy = b.latitude - a.latitude
        let t = max(0, min(1, (dx * (point.longitude - a.longitude) + dy * (point.latitude - a.latitude)) / (dx * dx + dy * dy + 1e-20)))
        let px = a.latitude + t * (b.latitude - a.latitude), py = a.longitude + t * (b.longitude - a.longitude)
        let dist = CLLocation(latitude: point.latitude, longitude: point.longitude)
            .distance(from: CLLocation(latitude: px, longitude: py))
        return (dist, t)
    }
}

// MARK: - 全局總覽 Sheet（雙段式：100pt 迷你 / 50% 展開，禁止 .large）
private struct GlobalMiniSheet: View {
    let tripName: String
    let totalMiles: Double
    let progressText: String
    let dayCount: Int
    let accentColor: Color
    let dayRoutes: [DayRoute]
    let sheetDetent: PresentationDetent
    let selectedDayIndex: Int?
    let onSelectDay: (Int) -> Void

    private var isExpanded: Bool {
        if case .medium = sheetDetent { return true }
        return false
    }

    private var safeAreaBottom: CGFloat {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom) ?? 24
    }

    var body: some View {
        Group {
            if isExpanded {
                expandedContent
            } else {
                miniContent
            }
        }
        .padding(.bottom, safeAreaBottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// 100pt：總里程、總天數、微小「查看完整行程」提示
    private var miniContent: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(format: "%.0f mi total", totalMiles))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Text("\(dayCount) days")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(accentColor)
            }
            Spacer(minLength: 8)
            Label("View full itinerary", systemImage: "chevron.up")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    /// 50%：垂直時間軸列表（左側線條 + 天數/路線/里程/景點標籤，點擊切換到單日詳情）
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                Text(tripName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                Text(String(format: "%.0f mi · %@", totalMiles, progressText))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(accentColor)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)

            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(dayRoutes.enumerated()), id: \.offset) { index, dayRoute in
                        DayTimelineRow(
                            dayRoute: dayRoute,
                            index: index,
                            isSelected: selectedDayIndex == index,
                            accentColor: accentColor
                        ) {
                            onSelectDay(index)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
            .frame(maxHeight: .infinity)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - 時間軸單行（左側豎線 + 天數/路線/里程時間/景點標籤，可選海拔曲線背景）
private struct DayTimelineRow: View {
    let dayRoute: DayRoute
    let index: Int
    let isSelected: Bool
    let accentColor: Color
    let onTap: () -> Void

    private var safeAreaBottom: CGFloat {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom) ?? 24
    }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                timelineLine
                contentColumn
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    if let points = dayRoute.elevationPoints, !points.isEmpty {
                        elevationCurvePath(points: points)
                            .fill(accentColor.opacity(0.08))
                            .ignoresSafeArea(edges: .all)
                    }
                }
            )
            .background(.ultraThinMaterial)
        }
        .buttonStyle(.plain)
    }

    private var timelineLine: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(isSelected ? accentColor : Color.white.opacity(0.5))
                .frame(width: 12, height: 12)
            Rectangle()
                .fill(accentColor.opacity(0.4))
                .frame(width: 2, height: 44)
        }
        .frame(width: 12, alignment: .center)
    }

    private var contentColumn: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 8) {
                Text("Day \(dayRoute.day)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(isSelected ? accentColor : .white)
                Text(dayRoute.from + " → " + dayRoute.to)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            HStack(spacing: 12) {
                Label(dayRoute.distance, systemImage: "road.lanes")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                Label(dayRoute.duration, systemImage: "clock")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
            }
            if !dayRoute.highlights.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(dayRoute.highlights, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(accentColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(accentColor.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func elevationCurvePath(points: [Double]) -> Path {
        guard points.count >= 2 else { return Path() }
        let minE = points.min() ?? 0
        let maxE = points.max() ?? 1
        let range = max(maxE - minE, 1)
        return Path { path in
            let w: CGFloat = 300
            let h: CGFloat = 44
            let step = w / CGFloat(points.count - 1)
            for (i, e) in points.enumerated() {
                let x = CGFloat(i) * step
                let y = h - CGFloat((e - minE) / range) * h * 0.6
                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
        }
    }
}

// MARK: - 單日小卡片（橫向 DaySelector 用，緊湊以適應 100pt 高）
private struct DaySelectorCard: View {
    let dayIndex: Int
    let from: String
    let to: String
    let isSelected: Bool
    let accentColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 1) {
                Text("Day \(dayIndex)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.9))
                Text("\(from)→\(to)")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(isSelected ? accentColor : .white.opacity(0.6))
                    .lineLimit(1)
            }
            .frame(width: 88, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(isSelected ? accentColor.opacity(0.35) : Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isSelected ? accentColor : Color.white.opacity(0.15), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 單日詳情 Sheet（點擊 Day 標籤後彈起 50%；Back 關閉此 Sheet 回到全局）
private struct DayDetailSheet: View {
    let dayRoute: DayRoute
    let milestones: [MacroStation]
    /// 加油站搜尋中心（當日路線中點或用戶位置）
    let searchCenter: CLLocationCoordinate2D
    let accentColor: Color
    @Binding var sheetDetent: PresentationDetent
    var onBackToGlobal: () -> Void
    var onStartNavigation: () -> Void

    @State private var gasStations: [MKMapItem] = []
    @State private var gasSearchLoading: Bool = false
    /// 補給模塊用琥珀色，與路線紫區分
    private let supplyAccent = Color(red: 0.91, green: 0.64, blue: 0.09) // 柔和琥珀

    /// 是否處於 100pt 迷你狀態（僅顯示 Day N + 上拉提示）
    private var isMiniState: Bool {
        if case .height(100) = sheetDetent { return true }
        return false
    }

    var body: some View {
        Group {
            if isMiniState {
                miniStateView
            } else {
                fullContentView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// 100pt 時：左「Day N: In progress」、右 chevron.up 提示上拉
    private var miniStateView: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("Day \(dayRoute.day): In progress")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
            Spacer(minLength: 8)
            Image(systemName: "chevron.up")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(accentColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .padding(.bottom, safeAreaBottom)
    }

    /// 50% 固定高度 + 內部垂直雜誌滾動（標題→景點→加油站→推薦位→Start）
    private var fullContentView: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.white.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            HStack(alignment: .center, spacing: 12) {
                Button { onBackToGlobal() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                Text("Day \(dayRoute.day) Plan")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)

            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 20) {
                    section1CoreData
                    section2Stops
                    section3GasStations
                    section4PartnerSuggestions
                    startButtonInScroll
                    scrollBottomHint
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, safeAreaBottom + 24)
            }
            .frame(maxHeight: .infinity)
        }
        .overlay(alignment: .bottom) {
            scrollGradientOverlay
        }
        .onAppear { fetchGasStations() }
    }

    /// [Section 1] 核心數據：里程、時間
    private var section1CoreData: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(dayRoute.from) → \(dayRoute.to)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            HStack(spacing: 16) {
                Label(dayRoute.duration, systemImage: "clock")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
                Label(dayRoute.distance, systemImage: "road.lanes")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
    }

    /// [Section 2] 景點鏈條：橫向小卡片流
    private var section2Stops: some View {
        Group {
            if !milestones.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Stops")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(milestones) { m in
                                HStack(spacing: 8) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(accentColor)
                                    Text(m.title)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .frame(height: 48)
                }
            }
        }
    }

    /// [Section 3] 補給雷達：加油站垂直列表，更易閱讀
    private var section3GasStations: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "fuelpump.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(supplyAccent)
                Text("Gas Stations")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            if gasSearchLoading {
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: supplyAccent))
                        .scaleEffect(0.9)
                    Text("Searching nearby…")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
            } else if gasStations.isEmpty {
                Text("No gas stations found within 10 km")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(gasStations.prefix(8).enumerated()), id: \.offset) { _, item in
                        GasStationCard(
                            mapItem: item,
                            fromCoordinate: searchCenter,
                            accentColor: supplyAccent
                        )
                    }
                }
            }
        }
    }

    /// [Section 4] 商業推薦：2–3 張垂直大卡片（數據 + 佔位）
    private var section4PartnerSuggestions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Partner Suggestions")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
            if let slot = dayRoute.promoSlot {
                PromotionView(slot: slot, accentColor: accentColor)
            }
            PartnerSuggestionPlaceholder(index: 2)
            PartnerSuggestionPlaceholder(index: 3)
        }
    }

    private var startButtonInScroll: some View {
        Button {
            onStartNavigation()
        } label: {
            Label("Start Day \(dayRoute.day) Navigation", systemImage: "location.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }

    /// 滾動暗示：淡淡漸層 + 露出下一張邊緣感
    private var scrollBottomHint: some View {
        HStack(spacing: 6) {
            Image(systemName: "chevron.down")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
            Text("Scroll for more")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    /// 底部漸層遮罩，提示「下面還有更多」
    private var scrollGradientOverlay: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 32)
            .allowsHitTesting(false)
            Spacer()
        }
    }

    /// MKLocalSearch：以 searchCenter 為圓心 10km 搜尋 "Gas Station"
    private func fetchGasStations() {
        gasSearchLoading = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Gas Station"
        request.region = MKCoordinateRegion(
            center: searchCenter,
            latitudinalMeters: 20_000,
            longitudinalMeters: 20_000
        )
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            let items = response?.mapItems ?? []
            Task { @MainActor in
                gasSearchLoading = false
                gasStations = items
            }
        }
    }

    /// 底部安全區高度，避免被 Home Indicator 遮擋
    private var safeAreaBottom: CGFloat {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom) ?? 24
    }
}

// MARK: - 商業化推薦位視圖：單一垂直雜誌卡（封面 + 標題 + 價格/評分 + 訂房）
private struct PromotionView: View {
    let slot: PromotionSlot
    let accentColor: Color

    private var typeIcon: String {
        switch slot.suggestionType {
        case .hotel: return "star.fill"
        case .campsite: return "tent.fill"
        case .ad: return "megaphone.fill"
        }
    }

    private var typeLabel: String {
        switch slot.suggestionType {
        case .hotel: return "Hotel"
        case .campsite: return "Campsite"
        case .ad: return "Partner"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                coverImage(height: 140)
                HStack(spacing: 6) {
                    Image(systemName: typeIcon).font(.system(size: 11)).foregroundStyle(.white)
                    Text(typeLabel).font(.system(size: 10, weight: .semibold)).foregroundStyle(.white)
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(8)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(slot.title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)

            HStack(alignment: .center, spacing: 12) {
                if let price = slot.priceRange {
                    Text(price).font(.system(size: 14, weight: .semibold)).foregroundStyle(accentColor)
                }
                if let r = slot.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").font(.system(size: 11)).foregroundStyle(Color(red: 0.91, green: 0.64, blue: 0.09))
                        Text(String(format: "%.1f", r)).font(.system(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.9))
                    }
                }
            }

            if let perks = slot.perks, !perks.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(perks.prefix(4), id: \.self) { p in
                        Text(p)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
            }

            Button {
                if let link = slot.link, let url = URL(string: link) { UIApplication.shared.open(url) }
            } label: {
                Text(slot.link != nil ? "Book / View offer" : "Coming soon")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(slot.link != nil ? accentColor : Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .disabled(slot.link == nil)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(accentColor.opacity(0.25), lineWidth: 1))
    }

    @ViewBuilder
    private func coverImage(height: CGFloat) -> some View {
        if let urlString = slot.imageURL, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                default: placeholderImage(height: height)
                }
            }
            .frame(height: height)
            .clipped()
        } else {
            placeholderImage(height: height)
        }
    }

    private func placeholderImage(height: CGFloat) -> some View {
        ZStack {
            LinearGradient(colors: [accentColor.opacity(0.4), accentColor.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: "photo.fill").font(.system(size: 28)).foregroundStyle(.white.opacity(0.5))
        }
        .frame(height: height)
    }
}

// MARK: - Partner Suggestions 佔位卡（高品質風景圖 + 標籤）
private struct PartnerSuggestionPlaceholder: View {
    let index: Int
    private let accentColor = Color(hex: "A855F7")
    private static let placeholderURLs = [
        "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=400",
        "https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=400",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: Self.placeholderURLs[index % Self.placeholderURLs.count])) { phase in
                    switch phase {
                    case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                    default: placeholderBg
                    }
                }
                .frame(height: 120)
                .clipped()
                Text("Partner · Coming soon")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(8)
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Text("Suggestion #\(index)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(accentColor.opacity(0.2), lineWidth: 1))
    }

    private var placeholderBg: some View {
        ZStack {
            LinearGradient(colors: [accentColor.opacity(0.3), accentColor.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: "photo.fill").font(.system(size: 32)).foregroundStyle(.white.opacity(0.4))
        }
        .frame(height: 120)
    }
}

// MARK: - 智慧補給卡片：加油站品牌、距離、一鍵導航
private struct GasStationCard: View {
    let mapItem: MKMapItem
    let fromCoordinate: CLLocationCoordinate2D
    let accentColor: Color

    private var name: String {
        mapItem.placemark.name ?? mapItem.name ?? "Gas Station"
    }

    private var distanceMiles: Double {
        guard let loc = mapItem.placemark.location else { return 0 }
        let from = CLLocation(latitude: fromCoordinate.latitude, longitude: fromCoordinate.longitude)
        return loc.distance(from: from) / 1609.34
    }

    var body: some View {
        Button {
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "fuelpump.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(accentColor)
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(String(format: "%.1f mi", distanceMiles))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(accentColor)
                }
                Spacer(minLength: 4)
                Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(accentColor.opacity(0.9))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(minWidth: 160, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(accentColor.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 里程碑卡片（單擊居中、雙擊恢復追蹤）
private struct MacroMilestoneCard: View {
    let station: MacroStation
    let isSelected: Bool
    let accentColor: Color
    let onTap: () -> Void
    let onDoubleTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(station.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Text(station.description)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(2)
                Text(String(format: "%.2f mi", station.distanceFromStart))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(accentColor)
            }
            .frame(width: 160, alignment: .leading)
            .padding(12)
            .background(Color.white.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? accentColor : Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .onTapGesture(count: 2) {
            onDoubleTap()
        }
    }
}
