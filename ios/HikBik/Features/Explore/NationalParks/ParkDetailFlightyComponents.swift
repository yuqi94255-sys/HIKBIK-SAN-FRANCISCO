// MARK: - 公園詳情頁 Flighty 儀表化組件（Skeleton）
// 地圖區域 / 狀態條 / 內容抽屜

import SwiftUI
import MapKit
import UIKit

private let detailSheetBackgroundColor = Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255)

/// 僅頂部兩角圓角的 Shape（兼容 iOS 15+）
private struct TopRoundedShape: Shape {
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = min(radius, rect.width / 2, rect.height / 2)
        path.move(to: CGPoint(x: rect.minX + r, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - r, y: rect.minY + r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        path.addArc(center: CGPoint(x: rect.minX + r, y: rect.minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.closeSubpath()
        return path
    }
}

// MARK: - 詳情頁地圖樣式（四類詳情頁共用：公園、森林、草原、休閒區）
enum DetailMapStyle: Int, CaseIterable {
    case standard
    case imagery
    case hybrid

    @available(iOS 17.0, *)
    var mapStyle: MapStyle {
        switch self {
        case .standard: return .standard(elevation: .flat)
        case .imagery: return .imagery(elevation: .flat)
        case .hybrid: return .hybrid(elevation: .flat)
        }
    }

    var next: DetailMapStyle {
        switch self {
        case .standard: return .imagery
        case .imagery: return .hybrid
        case .hybrid: return .standard
        }
    }
}

/// 獨立的「地圖 + 樣式按鈕」子視圖：僅此 View 持有 currentMapStyle，切換時只重繪地圖區。
/// 按鈕用 overlay 疊在地圖上，避免 Map 搶觸摸導致點擊無反應。
struct DetailMapWithStyleSwitcher: View {
    let center: CLLocationCoordinate2D
    let markerTitle: String
    var height: CGFloat = 180
    var span: (lat: Double, lon: Double) = (0.15, 0.15)
    @State private var currentMapStyle: DetailMapStyle = .standard

    var body: some View {
        Map(initialPosition: .region(MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: span.lat, longitudeDelta: span.lon)
        ))) {
            Marker(markerTitle, coordinate: center)
        }
        .mapStyle(currentMapStyle.mapStyle)
        .animation(nil, value: currentMapStyle)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(alignment: .topTrailing) {
            DetailMapStyleSwitcherButton(currentMapStyle: $currentMapStyle)
                .padding(.top, 64)
                .padding(.trailing, 12)
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - 地圖操作區按鈕統一樣式：40x40 圓形毛玻璃 + 微弱陰影
private struct MapActionButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 40, height: 40)
            .background(.ultraThinMaterial, in: Circle())
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

/// 通用收藏按鈕：依 SavedDestination 與 FavoritesManager 執行 save/remove，心形跳動 + 觸覺反饋
struct FavoriteButton: View {
    let id: String
    let name: String
    let category: DestinationType
    let agency: String
    let imageUrl: String?
    let latitude: Double
    let longitude: Double
    @Binding var isFavorite: Bool

    @State private var heartScale: CGFloat = 1.0

    var body: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            if isFavorite {
                FavoritesManager.shared.remove(id)
                isFavorite = false
            } else {
                let dest = SavedDestination(
                    id: id,
                    name: name,
                    category: category,
                    agency: agency,
                    imageUrl: imageUrl,
                    latitude: latitude,
                    longitude: longitude
                )
                FavoritesManager.shared.save(dest)
                isFavorite = true
            }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                heartScale = 1.25
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    heartScale = 1.0
                }
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isFavorite ? Color.red : .primary)
                .scaleEffect(heartScale)
        }
        .buttonStyle(FavoriteButtonStyle())
        .modifier(MapActionButtonStyle())
        .frame(minWidth: 44, minHeight: 44)
        .contentShape(Circle())
    }
}

/// 按壓時縮小，提供明確的點擊視覺反饋（模擬器無觸覺時也能看到反應）
private struct FavoriteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// 懸浮地圖樣式切換按鈕：40x40 Circle、.ultraThinMaterial；點擊僅更新 mapStyle。
struct DetailMapStyleSwitcherButton: View {
    @Binding var currentMapStyle: DetailMapStyle

    var body: some View {
        Button {
            var t = Transaction()
            t.disablesAnimations = true
            withTransaction(t) {
                currentMapStyle = currentMapStyle.next
            }
        } label: {
            Image(systemName: "square.2.layers.3d")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .modifier(MapActionButtonStyle())
        .padding(12)
        .contentShape(Rectangle())
    }
}

// MARK: - 1. 地圖區域 (MapHeaderView)
/// 高度固定 40% 屏；支援 Standard / Satellite / Hybrid 切換；右上角 VStack 可放收藏 + 樣式按鈕。
struct MapHeaderView: View {
    var coordinate: CLLocationCoordinate2D?
    var facilityAnnotation: FacilityLocation? = nil
    var viewpoints: [GeoPoint]? = nil
    var dangerZones: [GeoPoint]? = nil
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)
    var fixedHeight: CGFloat? = nil
    var recAreaStyle: Bool = false
    var isRecAreaMarkerSelected: Bool = false
    var onRecAreaMarkerTap: (() -> Void)? = nil
    /// 右上角按鈕組頂部（如收藏心形）；與樣式切換按鈕組成 VStack，預設為空
    var topRightContent: () -> AnyView = { AnyView(EmptyView()) }

    /// 相機跨度固定於 0.1–0.3，避免自動縮放到過細導致模糊
    private static let cameraSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)

    /// 延遲顯示地圖，先出佔位，減少首幀卡頓
    @State private var mapVisible = false
    /// 設施標註延遲顯示，確保地圖主視圖先載入再疊加，不阻塞衛星圖
    @State private var showFacilityAnnotation = false
    /// 地圖樣式：Standard / Satellite / Hybrid，一鍵切換
    @State private var currentMapStyle: DetailMapStyle = .imagery

    private var region: MKCoordinateRegion {
        let center = coordinate ?? CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5)
        return MKCoordinateRegion(center: center, span: Self.cameraSpan)
    }

    private var viewpointCoordinates: [MapGeoItem] {
        (viewpoints ?? []).compactMap { g -> MapGeoItem? in
            guard let lat = g.latitude, let lon = g.longitude else { return nil }
            return MapGeoItem(id: "vp-\(lat)-\(lon)", name: g.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
    }

    private var dangerZoneCoordinates: [MapGeoItem] {
        (dangerZones ?? []).compactMap { g -> MapGeoItem? in
            guard let lat = g.latitude, let lon = g.longitude else { return nil }
            return MapGeoItem(id: "dz-\(lat)-\(lon)", name: g.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
    }

    private let mapPlaceholder = Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255)

    var body: some View {
        ZStack {
            mapPlaceholder
            if #available(iOS 17.0, *) {
                let center = coordinate ?? CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5)
                Map(initialPosition: .region(region), interactionModes: .all) {
                    Annotation("", coordinate: center) {
                        Group {
                            if recAreaStyle {
                                Button {
                                    onRecAreaMarkerTap?()
                                } label: {
                                    RecAreaMapMarkerView(selected: isRecAreaMarkerSelected)
                                }
                                .buttonStyle(.plain)
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.9))
                                        .frame(width: 16, height: 16)
                                    Circle()
                                        .stroke(themeColor, lineWidth: 2)
                                        .frame(width: 16, height: 16)
                                }
                                .shadow(color: themeColor.opacity(0.6), radius: 6)
                            }
                        }
                    }
                    if showFacilityAnnotation, let fac = facilityAnnotation {
                        Annotation(fac.name, coordinate: CLLocationCoordinate2D(latitude: fac.latitude, longitude: fac.longitude)) {
                            FacilityAnnotationView(facilityName: fac.name, themeColor: themeColor)
                        }
                    }
                    ForEach(viewpointCoordinates, id: \.id) { item in
                        Annotation(item.name ?? "Viewpoint", coordinate: item.coordinate) {
                            MapPointView(color: Color.blue.opacity(0.9), size: 10)
                        }
                    }
                    ForEach(dangerZoneCoordinates, id: \.id) { item in
                        Annotation(item.name ?? "Caution", coordinate: item.coordinate) {
                            MapPointView(color: Color.red.opacity(0.9), size: 10)
                        }
                    }
                }
                .mapStyle(currentMapStyle.mapStyle)
                .animation(nil, value: currentMapStyle)
                .preferredColorScheme(.dark)
                .opacity(mapVisible ? 1 : 0)
            }
        }
        .frame(height: fixedHeight ?? UIScreen.main.bounds.height * 0.40)
        .clipped()
        .overlay(alignment: .topTrailing) {
            if #available(iOS 17.0, *) {
                VStack(alignment: .trailing, spacing: 12) {
                    topRightContent()
                    DetailMapStyleSwitcherButton(currentMapStyle: $currentMapStyle)
                }
                .padding(.top, 64)
                .padding(.trailing, 16)
                .zIndex(1)
                .allowsHitTesting(true)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.easeOut(duration: 0.25)) { mapVisible = true }
            }
        }
        .onChange(of: facilityAnnotation?.id) { _, newValue in
            showFacilityAnnotation = false
            guard newValue != nil else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                showFacilityAnnotation = true
            }
        }
        .onChange(of: mapVisible) { _, visible in
            guard visible, facilityAnnotation != nil else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showFacilityAnnotation = true
            }
        }
    }
}

/// RecArea 地圖標記：藍色圓圈 + 水域/山林圖標，選中時縮放
private struct RecAreaMapMarkerView: View {
    var selected: Bool
    private let size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.9))
                .frame(width: size, height: size)
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: size, height: size)
            Image(systemName: "water.waves")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
        }
        .shadow(color: Color.blue.opacity(0.5), radius: 6)
        .scaleEffect(selected ? 1.2 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selected)
    }
}

/// 地圖上用於 GeoPoint 的識別項
private struct MapGeoItem: Identifiable {
    let id: String
    let name: String?
    let coordinate: CLLocationCoordinate2D
}

/// 小圓點標註（viewpoints 藍、dangerZones 紅）
private struct MapPointView: View {
    var color: Color
    var size: CGFloat = 10

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .overlay(Circle().stroke(.white, lineWidth: 1.5))
    }
}

/// 設施標註視圖（獨立組件，便於異步渲染與重用）
private struct FacilityAnnotationView: View {
    let facilityName: String
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "building.2.fill")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(6)
                .background(themeColor, in: Circle())
            Text(facilityName)
                .font(.caption2)
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.horizontal, 4)
                .background(themeColor.opacity(0.9), in: Capsule())
        }
    }
}

// MARK: - 2. 狀態條 (FlightyStatusBar)
/// 可綁定 ParkDetail：Alt / Est.（成立年份）/ Crowd / Open（綠/紅），天氣改由下方天氣卡片展示
struct FlightyStatusBar: View {
    var alt: String? = nil
    var est: String? = nil           // 成立年份，取代原 Weather 格
    var crowd: String? = nil
    var openText: String? = nil
    var openIsOpen: Bool? = nil      // true=綠, false=紅

    var body: some View {
        HStack(spacing: 0) {
            FlightyStatusCell(icon: "mountain.2.fill", title: "Alt", value: alt ?? "—")
            FlightyStatusDivider()
            FlightyStatusCell(icon: "calendar", title: "Est.", value: est ?? "—")
            FlightyStatusDivider()
            FlightyStatusCell(icon: "person.3.fill", title: "Crowd", value: crowd ?? "—")
            FlightyStatusDivider()
            FlightyStatusCellOpen(value: openText ?? "—", isOpen: openIsOpen)
        }
        .frame(height: 70)
        .background(.ultraThinMaterial)
    }
}

private struct FlightyStatusCell: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct FlightyStatusCellOpen: View {
    let value: String
    let isOpen: Bool?

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "clock.fill")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
            Text("Open")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(openColor)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    private var openColor: Color {
        guard let open = isOpen else { return .primary }
        return open ? Color.green : Color.red
    }
}

private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .opacity(0.5 + 0.5 * (0.5 + 0.5 * sin(Double(phase))))
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { phase = .pi * 2 }
            }
    }
}

// MARK: - 天氣儀表板卡片（磨砂玻璃，綁定 WeatherInfo + NPS weatherSummary）
struct WeatherDashboardCard: View {
    var weather: WeatherInfo?
    var weatherSummaryFromNPS: String?  // NPS weatherInfo 長文，放在底部 .caption

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(temperatureDisplay)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.primary)
                    if !conditionDisplay.isEmpty {
                        Text(conditionDisplay)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 8) {
                    WeatherMetaRow(icon: "sunrise.fill", label: "Sunrise/Sunset", value: sunriseSunsetDisplay)
                    WeatherMetaRow(icon: "wind", label: "Wind", value: weather?.windSpeed ?? "—")
                    WeatherMetaRow(icon: "drop.fill", label: "Precipitation", value: precipitationDisplay)
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
            }
            if let summary = weatherSummaryFromNPS, !summary.isEmpty {
                Text(summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(nil)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var temperatureDisplay: String {
        weather?.temperatureRange ?? weather?.currentWeather ?? "—"
    }

    private var conditionDisplay: String {
        guard let w = weather else { return "" }
        if let c = w.currentWeather, !c.isEmpty, c != temperatureDisplay { return c }
        return ""
    }

    private var sunriseSunsetDisplay: String {
        guard let w = weather else { return "—" }
        let a = [w.sunrise, w.sunset].compactMap { $0 }.filter { !$0.isEmpty }
        return a.isEmpty ? "—" : a.joined(separator: " / ")
    }

    private var precipitationDisplay: String {
        weather?.precipitation ?? "—"
    }
}

private struct WeatherMetaRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text("\(label): \(value)")
                .lineLimit(1)
        }
    }
}

// MARK: - 安全與風險儀表板（藍圖第九項：Safety Info）
/// 費用下方、描述上方；三張風險卡片 + 緊急撥號，有風險時卡片邊框紅/黃 + 脈動
struct SafetyDashboardView: View {
    var alertNotices: [AlertNotice]
    var safety: SafetyInfo?
    var elevationRange: String?
    var parkLat: Double?
    var parkLon: Double?
    var emergencyContact: String?
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    /// 從 LiveStatus.alertNotices 篩出含 Safety / Danger / Warning 的公告
    private var safetyRelatedAlerts: [AlertNotice] {
        let keywords = ["safety", "danger", "warning", "hazard", "caution"]
        return alertNotices.filter { notice in
            let title = (notice.title ?? "").lowercased()
            let desc = (notice.description ?? "").lowercased()
            let cat = (notice.category ?? "").lowercased()
            return keywords.contains { title.contains($0) || desc.contains($0) || cat.contains($0) }
        }
    }

    private var wildlifeText: String {
        if let w = safety?.wildlifeWarnings, !w.isEmpty { return w }
        return "No active wildlife alerts"
    }

    private var altitudeText: String {
        if let a = safety?.altitudeRisk, !a.isEmpty { return a }
        if let e = elevationRange, !e.isEmpty { return "Elevation \(e). Watch for altitude sickness at high elevation." }
        return "Check park info for elevation and altitude notes."
    }

    private var generalHazardText: String {
        if let first = safetyRelatedAlerts.first {
            return first.title ?? first.description ?? "Active safety notice"
        }
        return "No active hazard notices"
    }

    private var hasWildlifeRisk: Bool {
        (safety?.wildlifeWarnings?.isEmpty ?? true) == false
    }
    private var hasAltitudeRisk: Bool {
        (safety?.altitudeRisk?.isEmpty ?? false) || (elevationRange?.isEmpty == false)
    }
    private var hasGeneralHazard: Bool { !safetyRelatedAlerts.isEmpty }

    @State private var showEmergencyOptions = false
    @State private var showLocationCopied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Safety & Hazards")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    HazardCard(
                        icon: "bear.fill",
                        title: "Wildlife",
                        message: wildlifeText,
                        hasRisk: hasWildlifeRisk,
                        themeColor: themeColor
                    )
                    HazardCard(
                        icon: "mountain.2.fill",
                        title: "Altitude",
                        message: altitudeText,
                        hasRisk: hasAltitudeRisk,
                        themeColor: themeColor
                    )
                }
                HazardCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "General Hazard",
                    message: generalHazardText,
                    hasRisk: hasGeneralHazard,
                    themeColor: themeColor
                )
            }
            emergencyButton
        }
        .confirmationDialog("Emergency", isPresented: $showEmergencyOptions) {
            Button("Call 911") { openPhone(phoneNumber: "911") }
            if let num = emergencyContact?.filter({ $0.isNumber || $0 == "+" }), !num.isEmpty {
                Button("Call Park Ranger") { openPhone(phoneNumber: num) }
            } else {
                Button("Call Park Ranger") { openPhone(phoneNumber: "888-448-6777") }
            }
            Button("Copy location (lat, lon)") { copyParkLocation() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(locationMessage)
        }
        .alert("Location copied", isPresented: $showLocationCopied) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Coordinates copied. Share with 911 or ranger when calling.")
        }
    }

    private var locationMessage: String {
        if let lat = parkLat, let lon = parkLon {
            return String(format: "Park: %.5f, %.5f — Tell the operator this location.", lat, lon)
        }
        return "Open map to get your coordinates, or tell operator the park name."
    }

    private var emergencyButton: some View {
        Button {
            showEmergencyOptions = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 14))
                Text("911 / Park Ranger")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private func openPhone(phoneNumber: String) {
        let digits = phoneNumber.filter { $0.isNumber || $0 == "+" }
        guard let url = URL(string: "tel:\(digits)") else { return }
        UIApplication.shared.open(url)
    }

    private func copyParkLocation() {
        if let lat = parkLat, let lon = parkLon {
            UIPasteboard.general.string = String(format: "%.5f, %.5f", lat, lon)
            showLocationCopied = true
        }
    }
}

/// 單張風險維度卡片：無風險時 .secondary，有風險時邊框紅/黃 + 微弱脈動
private struct HazardCard: View {
    let icon: String
    let title: String
    let message: String
    let hasRisk: Bool
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    @State private var pulseOpacity: CGFloat = 0.5

    private var borderColor: Color {
        guard hasRisk else { return .clear }
        return title == "General Hazard" ? Color.orange : Color.red.opacity(0.8)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(hasRisk ? (title == "Wildlife" ? Color.orange : Color.red.opacity(0.9)) : .secondary)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(hasRisk ? .primary : .secondary)
            }
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor.opacity(hasRisk ? (0.5 + 0.5 * pulseOpacity) : 0), lineWidth: hasRisk ? 2 : 0)
        )
        .onAppear {
            guard hasRisk else { return }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { pulseOpacity = 1 }
        }
    }
}

// MARK: - 自然概覽 Landscape & Nature（藍圖第十二項 Terrain + 第十四項 Ecology）
/// 描述文字下方：地形數據條 + Key Species 水平滾動小圓圈，.ultraThinMaterial、.subheadline 科學雜誌風格
struct LandscapeNatureView: View {
    var terrain: TerrainInfo?
    var descriptionFallback: String?
    var parkId: String
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    /// 地貌標籤：優先 TerrainInfo，否則從描述關鍵詞提取
    private var terrainLabels: [String] {
        if let t = terrain?.terrainType, !t.isEmpty {
            return t.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
        if let veg = terrain?.vegetationTypes, !veg.isEmpty { return veg }
        guard let text = descriptionFallback?.lowercased() else { return [] }
        let pairs: [(String, String)] = [
            ("forest", "Forest"), ("alpine", "Alpine"), ("coast", "Coast"), ("coastal", "Coast"),
            ("desert", "Desert"), ("mountain", "Mountain"), ("canyon", "Canyon"), ("wetland", "Wetland"),
            ("tundra", "Tundra"), ("grassland", "Grassland"), ("glacier", "Glacier")
        ]
        var out: [String] = []
        for (kw, label) in pairs where text.contains(kw) && !out.contains(label) { out.append(label) }
        return out
    }

    private var keySpeciesList: [WildlifeAnimal] {
        let animals = DataLoader.loadNationalParksWildlife().first { $0.parkId == parkId }?.animals ?? []
        let preferred = animals.filter { $0.commonlySeen == true }
        let list = preferred.isEmpty ? Array(animals.prefix(12)) : Array(preferred.prefix(12))
        return list
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Landscape & Nature")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            if !terrainLabels.isEmpty {
                terrainBar
            }
            keySpeciesSection
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var terrainBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "mountain.2.fill")
                .font(.subheadline)
                .foregroundStyle(themeColor.opacity(0.9))
            Text(terrainLabels.joined(separator: " · "))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private var keySpeciesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Key Species to Watch")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(keySpeciesList) { animal in
                        SpeciesCircleView(name: animal.name, iconName: animal.icon, themeColor: themeColor)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

/// 物種小圓圈：圖標 + 名稱，科學雜誌感
private struct SpeciesCircleView: View {
    let name: String
    var iconName: String?
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    private var symbolName: String {
        if let icon = iconName, !icon.isEmpty { return icon }
        let lower = name.lowercased()
        if lower.contains("eagle") || lower.contains("bird") { return "bird.fill" }
        if lower.contains("bear") { return "bear.fill" }
        if lower.contains("elk") || lower.contains("deer") || lower.contains("caribou") || lower.contains("moose") { return "hare.fill" }
        if lower.contains("wolf") { return "pawprint.fill" }
        if lower.contains("fish") { return "fish.fill" }
        return "leaf.fill"
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(themeColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: symbolName)
                    .font(.system(size: 18))
                    .foregroundStyle(themeColor)
            }
            Text(name)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 64)
    }
}

// MARK: - 月份熱力圖 SeasonalityHeatmapView（藍圖第十項・4×3 北美四季矩陣）
private enum SeasonalityHeatLevel { case best, good, normal, challenging }

private enum SeasonRow: String, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
    var icon: String {
        switch self {
        case .spring: return "🌸"
        case .summer: return "☀️"
        case .fall: return "🍂"
        case .winter: return "❄️"
        }
    }
    var monthIndices: [Int] {
        switch self {
        case .spring: return [3, 4, 5]
        case .summer: return [6, 7, 8]
        case .fall: return [9, 10, 11]
        case .winter: return [12, 1, 2]
        }
    }
    static func season(forMonthIndex index: Int) -> SeasonRow {
        switch index {
        case 3, 4, 5: return .spring
        case 6, 7, 8: return .summer
        case 9, 10, 11: return .fall
        default: return .winter
        }
    }
}

/// 4 行 × 3 欄：Spring(MAR,APR,MAY)、Summer(JUN,JUL,AUG)、Fall(SEP,OCT,NOV)、Winter(DEC,JAN,FEB)；左側季節圖標、行色系、無邊框、當前月發光
struct SeasonalityGridView: View {
    var seasons: SeasonsInfo?
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    private static let monthAbbrevs = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    private static let monthNamesFull = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    @State private var selectedMonthIndex: Int = Calendar.current.component(.month, from: Date())
    @State private var isPressed = false

    private var currentMonthIndex: Int { Calendar.current.component(.month, from: Date()) }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Seasonality")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            rightNowLabel
            VStack(alignment: .leading, spacing: 14) {
                ForEach(SeasonRow.allCases, id: \.self) { row in
                    SeasonRowView(
                        season: row,
                        monthIndices: row.monthIndices,
                        monthAbbrevs: Self.monthAbbrevs,
                        heatLevel: heatLevel(for:),
                        currentMonthIndex: currentMonthIndex,
                        selectedMonthIndex: selectedMonthIndex,
                        isPressed: isPressed
                    ) { index in
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation(.easeOut(duration: 0.15)) { isPressed = true }
                        withAnimation(.easeOut(duration: 0.2)) { selectedMonthIndex = index }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                            withAnimation(.easeOut(duration: 0.1)) { isPressed = false }
                        }
                    }
                }
            }
            .padding(.horizontal, 0)
            SeasonalityDetailPanel(
                monthIndex: selectedMonthIndex,
                monthName: Self.monthNamesFull[selectedMonthIndex - 1],
                seasonName: SeasonRow.season(forMonthIndex: selectedMonthIndex).rawValue,
                detail: monthDetail(for: selectedMonthIndex),
                crowdLevelByMonth: seasons?.crowdLevelByMonth,
                themeColor: themeColor
            )
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .onAppear { selectedMonthIndex = currentMonthIndex }
    }

    private var rightNowLabel: some View {
        Text(rightNowText)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    private var rightNowText: String {
        let name = Self.monthNamesFull[currentMonthIndex - 1]
        let level = heatLevel(for: currentMonthIndex)
        let phrase: String
        switch level {
        case .best: phrase = "Peak season for visiting."
        case .good: phrase = "Good time to visit."
        case .normal: phrase = "Off-peak; expect moderate crowds."
        case .challenging: phrase = "Off-peak season with limited access or heavy snow."
        }
        return "Currently in \(name): \(phrase)"
    }

    private func heatLevel(for monthIndex: Int) -> SeasonalityHeatLevel {
        let name = Self.monthNamesFull[monthIndex - 1]
        if let detail = seasons?.monthDetails?.first(where: { $0.monthIndex == monthIndex }),
           let crowd = detail.crowdLevel?.lowercased() {
            if crowd == "closed" { return .challenging }
            if crowd == "high" { return .normal }
            if crowd == "medium" { return .good }
            if crowd == "low" { return .best }
        }
        if let crowd = seasons?.crowdLevelByMonth?[name]?.lowercased() {
            if crowd == "closed" { return .challenging }
            if crowd == "high" { return .normal }
            if crowd == "medium" { return .good }
            if crowd == "low" { return .best }
        }
        let bestMonths: [Int] = (seasons?.bestSeasons ?? []).flatMap { season -> [Int] in
            switch season.lowercased() {
            case "spring": return [3, 4, 5]
            case "summer": return [6, 7, 8]
            case "fall", "autumn": return [9, 10, 11]
            case "winter": return [12, 1, 2]
            default: return []
            }
        }
        if bestMonths.contains(monthIndex) { return .best }
        let peakIndices: [Int] = (seasons?.peakMonths ?? []).compactMap { Self.monthNamesFull.firstIndex(of: $0).map { $0 + 1 } }
        if peakIndices.contains(monthIndex) { return .normal }
        if [12, 1, 2].contains(monthIndex) { return .challenging }
        return .normal
    }

    private func monthDetail(for monthIndex: Int) -> MonthSeasonDetail? {
        seasons?.monthDetails?.first { $0.monthIndex == monthIndex }
    }
}

private struct SeasonRowView: View {
    let season: SeasonRow
    let monthIndices: [Int]
    let monthAbbrevs: [String]
    let heatLevel: (Int) -> SeasonalityHeatLevel
    let currentMonthIndex: Int
    let selectedMonthIndex: Int
    var isPressed: Bool
    let onSelect: (Int) -> Void

    private var rowTint: Color {
        switch season {
        case .spring: return Color(red: 0.45, green: 0.72, blue: 0.48)
        case .summer: return Color(red: 0.95, green: 0.72, blue: 0.35)
        case .fall: return Color(red: 0.72, green: 0.52, blue: 0.32)
        case .winter: return Color(red: 0.55, green: 0.68, blue: 0.82)
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(season.icon)
                .font(.system(size: 20))
                .frame(width: 28, alignment: .center)
            HStack(spacing: 10) {
                ForEach(monthIndices, id: \.self) { index in
                    MonthCellView(
                        monthAbbrev: monthAbbrevs[index - 1],
                        monthIndex: index,
                        heatLevel: heatLevel(index),
                        seasonTint: rowTint,
                        isCurrentMonth: index == currentMonthIndex,
                        isPressed: index == selectedMonthIndex ? isPressed : false
                    ) { onSelect(index) }
                }
            }
        }
    }
}

private struct MonthCellView: View {
    let monthAbbrev: String
    let monthIndex: Int
    let heatLevel: SeasonalityHeatLevel
    let seasonTint: Color
    let isCurrentMonth: Bool
    var isPressed: Bool
    let onTap: () -> Void

    private var opacityForLevel: Double {
        switch heatLevel {
        case .best: return 0.88
        case .good: return 0.55
        case .normal: return 0.22
        case .challenging: return 0.12
        }
    }

    private var textColor: Color {
        switch heatLevel {
        case .best, .good: return .white
        case .normal, .challenging: return .primary
        }
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(seasonTint.opacity(opacityForLevel))
                if isCurrentMonth {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                }
            }
            .overlay(
                Text(monthAbbrev)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(textColor)
            )
            .shadow(color: isCurrentMonth ? Color.white.opacity(0.35) : .clear, radius: 8)
            .aspectRatio(1, contentMode: .fit)
            .scaleEffect(isPressed ? 0.94 : 1)
        }
        .buttonStyle(.plain)
    }
}

/// 人潮訊號條（音量錶風格，亮色 = 高峰）
private struct CrowdSignalBars: View {
    let level: Int
    var peakColor: Color = Color(red: 0.35, green: 0.65, blue: 0.4)
    var inactiveColor: Color = Color.primary.opacity(0.12)

    private let heights: [CGFloat] = [6, 10, 14, 18, 22]

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<5, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(i < level ? peakColor : inactiveColor)
                    .frame(width: 5, height: heights[i])
            }
        }
    }
}

private struct SeasonalityDetailPanel: View {
    let monthIndex: Int
    let monthName: String
    let seasonName: String
    let detail: MonthSeasonDetail?
    let crowdLevelByMonth: [String: String]?
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    private var crowdText: String {
        detail?.crowdLevel ?? crowdLevelByMonth?[monthName] ?? "—"
    }

    private var crowdBars: Int {
        let c = crowdText.lowercased()
        if c == "low" { return 1 }
        if c == "medium" { return 3 }
        if c == "high" { return 5 }
        if c == "closed" { return 0 }
        return 2
    }

    private var tempRange: String {
        guard let d = detail else { return "—" }
        let low = d.tempLow ?? "—"
        let high = d.tempHigh ?? "—"
        if low == "—", high == "—" { return "—" }
        return "\(low) – \(high)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text(monthName)
                    .font(.subheadline.weight(.semibold))
                Text("•")
                    .foregroundStyle(.secondary)
                Text(seasonName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 10) {
                Text("Crowd")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                CrowdSignalBars(level: crowdBars)
                if crowdText != "—" {
                    Text(crowdText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            HStack(spacing: 8) {
                Image(systemName: "thermometer.medium")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Avg: \(tempRange)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let highlight = detail?.highlight, !highlight.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundStyle(themeColor)
                    Text(highlight)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .animation(.easeOut(duration: 0.25), value: monthIndex)
    }
}

// MARK: - 費用與許可證（藍圖第六項，導航前必看）
struct FeeStatusView: View {
    var fees: FeesAndPermits?
    /// 來自本地 JSON 的門票描述（NPS API 未回傳或未載入時使用，避免總是顯示 Check website）
    var fallbackEntranceText: String?
    var officialWebsite: String?
    var permitLinks: [String]?
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    private var hasAnyFee: Bool {
        guard let f = fees else { return false }
        let list = [f.entryFee, f.vehicleFee, f.motorcycleFee, f.individualFee, f.commercialTourFee]
        return list.contains { $0.map { !$0.isEmpty } ?? false }
    }

    /// 優先用本地 JSON 的 entrance；API 有資料時可展開四類（Vehicle / Motorcycle / Individual / Commercial）
    private var feeDisplayString: String {
        if let s = fallbackEntranceText, !s.isEmpty { return s }
        if hasAnyFee {
            var parts: [String] = []
            if let v = fees?.vehicleFee, !v.isEmpty { parts.append((v.hasPrefix("$") ? v : "$\(v)") + "/Vehicle") }
            if let m = fees?.motorcycleFee, !m.isEmpty { parts.append((m.hasPrefix("$") ? m : "$\(m)") + "/Motorcycle") }
            if let i = fees?.individualFee, !i.isEmpty { parts.append((i.hasPrefix("$") ? i : "$\(i)") + "/Person") }
            if let c = fees?.commercialTourFee, !c.isEmpty { parts.append((c.hasPrefix("$") ? c : "$\(c)") + "/Commercial") }
            if parts.isEmpty, let e = fees?.entryFee, !e.isEmpty { parts.append(e.hasPrefix("$") ? e : "$\(e)") }
            return parts.isEmpty ? "—" : parts.joined(separator: " · ")
        }
        return ""
    }

    private var showFeeLine: Bool { hasAnyFee || (fallbackEntranceText?.isEmpty == false) }

    /// 僅在無 fallback、且 NPS 有回傳四類費用時顯示分行明細
    private var hasApiFeeBreakdown: Bool {
        guard fallbackEntranceText?.isEmpty != false, let f = fees else { return false }
        return [f.vehicleFee, f.motorcycleFee, f.individualFee, f.commercialTourFee].contains { $0.map { !$0.isEmpty } ?? false }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if showFeeLine {
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "ticket.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(themeColor)
                        Text(feeDisplayString)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary)
                    }
                    if fees?.annualPassAccepted == true {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.green)
                            Text("Annual Pass Accepted")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Color.green)
                        }
                    }
                }
                if hasApiFeeBreakdown {
                    VStack(alignment: .leading, spacing: 4) {
                        if let v = fees?.vehicleFee, !v.isEmpty { feeRow("Vehicle", v) }
                        if let m = fees?.motorcycleFee, !m.isEmpty { feeRow("Motorcycle", m) }
                        if let i = fees?.individualFee, !i.isEmpty { feeRow("Individual (walk/bike)", i) }
                        if let c = fees?.commercialTourFee, !c.isEmpty { feeRow("Commercial Tour", c) }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                if !hasAnyFee, fallbackEntranceText?.isEmpty == false, let urlString = officialWebsite, let url = URL(string: urlString) {
                    Link(destination: url) {
                        Text("Verify on official site")
                            .font(.caption)
                            .foregroundStyle(themeColor)
                    }
                }
                if fees?.timedEntryRequired == true {
                    HStack(spacing: 8) {
                        Text("Timed Entry Required")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(themeColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(themeColor.opacity(0.2), in: Capsule())
                        if let url = (permitLinks?.first ?? officialWebsite).flatMap({ URL(string: $0) }) {
                            Button {
                                AuthGuard.run(message: AuthGuardMessages.parkReservation) {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Text("Book Entry")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(themeColor, in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            } else {
                fallbackView
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func feeRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label + ":")
            Text(value.hasPrefix("$") ? value : "$\(value)")
        }
    }

    private var fallbackView: some View {
        Group {
            if let urlString = officialWebsite, let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack(spacing: 6) {
                        Image(systemName: "link.circle.fill")
                            .font(.system(size: 14))
                        Text("Check official site for latest fees")
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundStyle(themeColor)
                }
            } else {
                Text("Check official site for latest fees")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - 設施快覽 Park Amenities（藍圖第八項：營地下方，圖標矩陣 + 點擊可標註地圖）
struct ParkAmenitiesView: View {
    var facilities: FacilitiesInfo?
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)
    /// 點擊具座標的設施（如 Visitor Center）時呼叫，供地圖標註
    var onFacilityTap: ((FacilityLocation?) -> Void)?

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var hasRestrooms: Bool { (facilities?.restrooms?.isEmpty ?? true) == false }
    private var hasWater: Bool { (facilities?.waterStations?.isEmpty ?? true) == false }
    private var hasVisitorCenters: Bool { (facilities?.visitorCenters?.isEmpty ?? true) == false }
    private var cellSignalText: String? { facilities?.cellSignalStrength }
    private var hasAccessibility: Bool { (facilities?.wheelchairAccessibility?.isEmpty ?? true) == false }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Park Amenities")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            LazyVGrid(columns: columns, spacing: 16) {
                amenityCell(icon: "toilet", label: "Restrooms", available: hasRestrooms, location: nil)
                amenityCell(icon: "drop.fill", label: "Water", available: hasWater, location: nil)
                visitorCenterCell
                cellSignalCell
                amenityCell(icon: "figure.roll", label: "Accessibility", available: hasAccessibility, location: nil)
            }
        }
    }

    private var visitorCenterCell: some View {
        let available = hasVisitorCenters
        let firstLocation = facilities?.visitorCenterLocations?.first
        return amenityCell(icon: "building.2.fill", label: "Visitor Centers", available: available, location: firstLocation)
    }

    private var cellSignalCell: some View {
        let available = cellSignalText != nil
        let text = cellSignalText ?? "—"
        return Button {
            // 無座標可跳轉，僅顯示狀態
        } label: {
            amenityIconLabel(icon: "antenna.radiowaves.left.and.right", label: "Cell Signal", available: available, sublabel: available ? text : nil)
        }
        .buttonStyle(.plain)
    }

    private func amenityCell(icon: String, label: String, available: Bool, location: FacilityLocation?) -> some View {
        Button {
            if let loc = location {
                onFacilityTap?(loc)
            }
        } label: {
            amenityIconLabel(icon: icon, label: label, available: available, sublabel: nil)
        }
        .buttonStyle(.plain)
        .disabled(location == nil && !available)
    }

    private func amenityIconLabel(icon: String, label: String, available: Bool, sublabel: String?) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(available ? themeColor : Color.primary.opacity(0.35))
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(available ? .primary : .secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            if let sub = sublabel, !sub.isEmpty {
                Text(sub)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(available ? themeColor.opacity(0.12) : Color.clear, in: RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Campgrounds 區塊（天氣卡片下方，橫向卡片 + 預約標籤）
struct CampgroundsSectionView: View {
    let campgrounds: [CampgroundItem]
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    var body: some View {
        if campgrounds.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Campgrounds")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("\(campgrounds.count)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(campgrounds, id: \.stableId) { item in
                            CampgroundCardView(item: item, themeColor: themeColor)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

private struct CampgroundCardView: View {
    let item: CampgroundItem
    var themeColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                Text(item.name ?? "—")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                reservableTag
            }
            amenitiesRow
            if let price = item.priceRange, !price.isEmpty {
                Text(price)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(width: 180, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private var reservableTag: some View {
        Group {
            if item.reservable == true {
                Text("Reservable")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green, in: Capsule())
            } else {
                Text("First-come, first-served")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.08), in: Capsule())
            }
        }
    }

    private var amenitiesRow: some View {
        HStack(spacing: 8) {
            if item.waterAccess == true {
                Image(systemName: "drop.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            if item.electricity == true {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            if item.restroom == true {
                Image(systemName: "toilet")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            if item.shower == true {
                Image(systemName: "shower.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            if item.fireRing == true {
                Image(systemName: "flame.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

/// 實時警告橫幅：深橙底、exclamationmark.triangle.fill、最新 Alert 標題
struct ParkAlertBanner: View {
    let title: String

    private static let alertOrange = Color(red: 0.8, green: 0.35, blue: 0.1)

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 18))
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(ParkAlertBanner.alertOrange.opacity(0.92))
    }
}

private struct FlightyStatusDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.15))
            .frame(width: 0.5)
    }
}

// MARK: - 3. 內容抽屜 (DetailContentSheet) — 固定高度版，供無需拖拽處使用
struct DetailContentSheet<Content: View>: View {
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            FlightyStatusBar()
            ScrollView {
                content()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(detailSheetBackgroundColor)
        .clipShape(TopRoundedShape(radius: 32))
        .overlay(TopRoundedShape(radius: 32).stroke(themeColor.opacity(0.4), lineWidth: 1))
    }
}

// MARK: - 4. 可拖拽抽屜（三段：最下 50% / 中間 85% / 頂 100%）
/// 類比 Flighty：初始在最下面（50%），可拉到中間 85%、可拉到頂全屏。拖拽條+標題區可拉。
struct DraggableDetailSheet<Content: View>: View {
    @Binding var detentFraction: CGFloat
    var maxHeight: CGFloat
    var parkName: String
    var themeColor: Color
    @ViewBuilder var content: () -> Content

    private let detentFractions: [CGFloat] = [0.50, 0.85, 1.0]
    @State private var dragOffset: CGFloat = 0

    private var currentHeight: CGFloat {
        let base = detentFraction * maxHeight
        let total = base + dragOffset
        return min(maxHeight, max(detentFractions[0] * maxHeight, total))
    }

    private func nearestFraction(to height: CGFloat) -> CGFloat {
        detentFractions.min(by: { abs($0 * maxHeight - height) < abs($1 * maxHeight - height) }) ?? detentFractions[0]
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    dragHandle
                    sheetHeader
                    FlightyStatusBar()
                    ScrollView {
                        content()
                            .frame(minHeight: max(0, currentHeight - 180))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                    }
                    .scrollContentBackground(.hidden)
                    .background(detailSheetBackgroundColor)
                }
                Color.clear
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                dragOffset = -value.translation.height
                            }
                            .onEnded { _ in
                                let targetFraction = nearestFraction(to: currentHeight)
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    detentFraction = targetFraction
                                    dragOffset = 0
                                }
                            }
                    )
            }
        }
        .frame(height: currentHeight)
        .frame(maxWidth: .infinity)
        .background(detailSheetBackgroundColor)
        .clipShape(TopRoundedShape(radius: 32))
        .overlay(TopRoundedShape(radius: 32).stroke(themeColor.opacity(0.4), lineWidth: 1))
    }

    private var dragHandle: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.primary.opacity(0.25))
            .frame(width: 36, height: 5)
            .padding(.top, 10)
            .padding(.bottom, 4)
    }

    private var sheetHeader: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(parkName)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

// MARK: - 5. 系統 Sheet 內容（三段式：200pt / 60% / large，綁定 ParkDetail）
/// 頂部留白 20–24pt、公園名 → 實時警告條（若有）→ 數據條 → 可滾動：按鈕、Gallery、shortDescription
struct ParkDetailSheetContent: View {
    let park: NationalPark
    var parkDetail: ParkDetail?
    @Binding var selectedFacilityForMap: FacilityLocation?
    @Binding var isFavorite: Bool
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    private var displayName: String { parkDetail?.basicInfo.parkName ?? park.name }
    private var alertNotices: [AlertNotice] { parkDetail?.liveStatus?.alertNotices ?? [] }
    private var latestAlertTitle: String? { alertNotices.first?.title }
    private var elevationRange: String? { parkDetail?.basicInfo.elevationRange }
    private var established: String? { park.established ?? nil }
    private var openStatus: String? { parkDetail?.liveStatus?.openStatus }
    private var openDisplay: (text: String, isOpen: Bool?) {
        guard let s = openStatus else { return ("—", nil) }
        let lower = s.lowercased()
        if lower.contains("open") { return ("Open", true) }
        if lower.contains("closed") { return ("Closed", false) }
        return (s, nil)
    }
    private var galleryImages: [String] { parkDetail?.basicInfo.galleryImages ?? [] }
    private var shortDescription: String? { parkDetail?.basicInfo.shortDescription ?? park.description }
    private var parkBackup: ParkBackupData { DataLoader.loadParkBackup() }
    /// 營地：優先 API/Mock 注入的 parkDetail.campgrounds，Denali 可先用 Mock 撐起 UI
    private var displayedCampgrounds: [CampgroundItem] {
        if let list = parkDetail?.campgrounds, !list.isEmpty { return list }
        if park.parkCode == "dena" { return MockCampgrounds.denali }
        return []
    }
    /// 用於 AccessLogisticsView 導航：優先 park.coordinates，缺則用備援
    private var effectiveParkCoordinate: CLLocationCoordinate2D? {
        let c = park.coordinates ?? parkBackup[park.id]?.coordinates
        guard let c = c else { return nil }
        return CLLocationCoordinate2D(latitude: c.latitude, longitude: c.longitude)
    }

    var body: some View {
        VStack(spacing: 0) {
            // 頂部留白 20–24pt + 手動拉條
            Capsule()
                .fill(Color.primary.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 40)
                .padding(.bottom, 24)
            sheetHeader
            if let title = latestAlertTitle, !title.isEmpty {
                ParkAlertBanner(title: title)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            FlightyStatusBar(
                alt: elevationRange,
                est: established,
                crowd: nil,
                openText: openDisplay.text,
                openIsOpen: openDisplay.isOpen
            )
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FeeStatusView(
                        fees: parkDetail?.feesAndPermits,
                        fallbackEntranceText: park.entrance ?? parkBackup[park.id]?.entrance,
                        officialWebsite: parkDetail?.basicInfo.officialWebsite ?? park.websiteUrl,
                        permitLinks: parkDetail?.feesAndPermits?.permitLinks,
                        themeColor: themeColor
                    )
                    if !galleryImages.isEmpty {
                        gallerySection
                    }
                    if let desc = shortDescription, !desc.isEmpty {
                        Text(desc)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineLimit(nil)
                    }
                    AccessLogisticsView(
                        parkId: park.id,
                        portalsFromBackup: parkBackup[park.id]?.portals,
                        accessFromBackup: parkDetail?.access ?? parkBackup[park.id]?.access,
                        proTipFromBackup: parkBackup[park.id]?.proTip,
                        cellSignalStrength: parkDetail?.facilities?.cellSignalStrength,
                        permitRequired: parkDetail?.feesAndPermits?.permitRequired,
                        parkCoordinate: effectiveParkCoordinate,
                        themeColor: themeColor
                    )
                    SafetyDashboardView(
                        alertNotices: alertNotices,
                        safety: parkDetail?.safety,
                        elevationRange: parkDetail?.basicInfo.elevationRange,
                        parkLat: parkDetail?.basicInfo.latitude ?? park.coordinates?.latitude,
                        parkLon: parkDetail?.basicInfo.longitude ?? park.coordinates?.longitude,
                        emergencyContact: parkDetail?.safety?.emergencyContact,
                        themeColor: themeColor
                    )
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Weather")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.primary)
                        WeatherDashboardCard(
                            weather: parkDetail?.weather,
                            weatherSummaryFromNPS: parkDetail?.basicInfo.weatherSummary
                        )
                    }
                    if !displayedCampgrounds.isEmpty {
                        CampgroundsSectionView(
                            campgrounds: displayedCampgrounds,
                            themeColor: themeColor
                        )
                    }
                    ParkAmenitiesView(
                        facilities: parkDetail?.facilities,
                        themeColor: themeColor,
                        onFacilityTap: { selectedFacilityForMap = $0 }
                    )
                    LandscapeNatureView(
                        terrain: parkDetail?.terrain,
                        descriptionFallback: parkDetail?.basicInfo.description ?? park.description,
                        parkId: park.id,
                        themeColor: themeColor
                    )
                    SeasonalityGridView(seasons: parkDetail?.seasons, themeColor: themeColor)
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(detailSheetBackgroundColor)
        .overlay(alignment: .topTrailing) {
            FavoriteButton(
                id: "nationalPark:\(park.id)",
                name: park.name,
                category: .park,
                agency: "National Park Service",
                imageUrl: galleryImages.first ?? DataLoader.loadNationalParksGallery()[park.id]?.first,
                latitude: effectiveParkCoordinate?.latitude ?? 0,
                longitude: effectiveParkCoordinate?.longitude ?? 0,
                isFavorite: $isFavorite
            )
            .padding(.top, 52)
            .padding(.trailing, 20)
        }
    }

    private var sheetHeader: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(displayName)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var gallerySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(galleryImages.enumerated()), id: \.offset) { _, urlString in
                    if let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            default: Color.primary.opacity(0.15)
                            }
                        }
                        .frame(width: 160, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
