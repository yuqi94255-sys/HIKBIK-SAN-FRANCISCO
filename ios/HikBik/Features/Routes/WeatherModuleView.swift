// MARK: - WeatherModuleView — Figma 實裝：磨砂玻璃、地點切換、24h 趨勢、Current Location
import SwiftUI
import CoreLocation

// MARK: - 地點提取（從 itinerary 自動去重，無硬編碼）
private extension RouteDataProtocol {
    /// 遍歷 itinerary 提取所有 location，去重後有序列表；用於地點切換 Menu
    var itineraryLocations: [String] {
        var seen = Set<String>()
        return itinerary.compactMap(\.location).filter { seen.insert($0).inserted }
    }

    /// 默認顯示地點：itinerary[0].location ?? route.location ?? "Current Location"
    var defaultWeatherLocation: String {
        itinerary.first?.location ?? location ?? "Current Location"
    }
}

// MARK: - 定位管理（Current Location 授權與狀態）
private final class RouteLocationManager: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var isUpdating = false

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = manager.authorizationStatus
    }

    func requestWhenInUse() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        guard manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways else { return }
        isUpdating = true
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
        isUpdating = false
    }
}

extension RouteLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoordinate = locations.last?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

// MARK: - WeatherModuleView
struct WeatherModuleView: View {
    let data: RouteDataProtocol

    @State private var selectedLocation: String
    @State private var showLocationDeniedAlert = false
    @StateObject private var locationManager = RouteLocationManager()

    private static let weatherCardCornerRadius: CGFloat = 24
    private static let weatherBorderOpacity: Double = 0.1
    private static let nowHighlightBorderOpacity: Double = 0.35

    init(data: RouteDataProtocol) {
        self.data = data
        _selectedLocation = State(initialValue: data.defaultWeatherLocation)
    }

    /// Menu 選項：📍 Current Location + itinerary 提取的地點
    private var menuOptions: [String] {
        ["Current Location"] + data.itineraryLocations
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            locationSwitcher
            hourlyTrendScroll
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: Self.weatherCardCornerRadius)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1A1F2B"), Color(hex: "0F1116")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: Self.weatherCardCornerRadius)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Self.weatherCardCornerRadius))
        .padding(.bottom, HIKBIKTheme.sectionSpacing)
        .alert("需要定位權限", isPresented: $showLocationDeniedAlert) {
            Button("打開設定", role: .none) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("若要查看「當前位置」天氣，請在設定中允許 HIKBIK 使用定位服務。")
        }
        .onChange(of: selectedLocation) { _, newValue in
            if newValue == "Current Location" {
                switch locationManager.authorizationStatus {
                case .notDetermined:
                    locationManager.requestWhenInUse()
                    locationManager.startUpdatingLocation()
                case .denied, .restricted:
                    showLocationDeniedAlert = true
                case .authorizedWhenInUse, .authorizedAlways:
                    locationManager.startUpdatingLocation()
                @unknown default:
                    break
                }
            } else {
                locationManager.stopUpdatingLocation()
            }
        }
        .onChange(of: locationManager.authorizationStatus) { _, status in
            if selectedLocation == "Current Location", status == .denied || status == .restricted {
                showLocationDeniedAlert = true
            }
        }
    }

    // MARK: - 地點切換器（Caption 級別、調淡色，戰術高級感）
    private var locationSwitcher: some View {
        Menu {
            ForEach(menuOptions, id: \.self) { option in
                Button {
                    selectedLocation = option
                } label: {
                    if option == "Current Location" {
                        Label(option, systemImage: "location.fill")
                    } else {
                        Text(option)
                    }
                }
            }
        } label: {
            HStack(spacing: 18) {
                Text(selectedLocation)
                    .font(.caption)
                    .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.9))
                Image(systemName: "chevron.down")
                    .font(.caption2.weight(.regular))
                    .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .menuStyle(.borderlessButton)
    }

    // MARK: - 24h 趨勢橫向滾動
    private var hourlyTrendScroll: some View {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let hours: [Int] = (0..<24).map { (currentHour + $0) % 24 }

        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(hours.enumerated()), id: \.offset) { index, hour in
                    let isNow = index == 0
                    HourCell(hour: hour, isNow: isNow)
                }
            }
            .padding(.vertical, 6)
        }
    }
}

// MARK: - 單小時單元（像素級：vertical 12 呼吸、Now 深綠 0.1+螢光綠邊 12px、溫度 rounded 24、戰術 10pt Secondary、圖標縮 15%+微光）
private struct HourCell: View {
    let hour: Int
    let isNow: Bool

    private static let cellWidth: CGFloat = 72
    private static let cellCornerRadius: CGFloat = 12
    private static let contentInsetH: CGFloat = 12

    var body: some View {
        VStack(spacing: 0) {
            Text(isNow ? "Now" : hourLabel)
                .font(.system(size: isNow ? 13 : 12, weight: .regular))
                .foregroundStyle(isNow ? HIKBIKTheme.textPrimary : HIKBIKTheme.textMuted)
            Spacer(minLength: 8)
            weatherIcon
            Spacer(minLength: 10)
            Text("68°")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(HIKBIKTheme.textPrimary)
            Spacer(minLength: 8)
            tacticalParams
        }
        .padding(.horizontal, Self.contentInsetH)
        .padding(.vertical, 12)
        .frame(width: Self.cellWidth, height: 108)
        .background(nowCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Self.cellCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Self.cellCornerRadius)
                .strokeBorder(nowCardBorder, lineWidth: isNow ? 1 : 0)
        )
    }

    /// 圖標縮小 15% + 微弱陰影/發光（鑲嵌玻璃儀表感）
    private var weatherIcon: some View {
        let (iconName, gradient) = iconAndGradient
        return Image(systemName: iconName)
            .font(.system(size: 24, weight: .medium))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(
                LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 1)
            .shadow(color: gradient.first?.opacity(0.3) ?? Color.clear, radius: 4, x: 0, y: 0)
    }

    private var iconAndGradient: (String, [Color]) {
        if hour >= 6 && hour < 18 {
            return ("sun.max.fill", [Color(hex: "F59E0B"), Color(hex: "EAB308")])
        }
        if hour >= 18 || hour < 6 {
            return ("moon.stars.fill", [Color(hex: "94A3B8"), Color(hex: "64748B")])
        }
        return ("cloud.sun.fill", [Color(hex: "F59E0B"), Color(hex: "94A3B8")])
    }

    /// 下方數據：10pt、Secondary 灰
    private var tacticalParams: some View {
        Text("8mph  5%")
            .font(.system(size: 10, weight: .regular))
            .foregroundStyle(HIKBIKTheme.textMuted)
    }

    @ViewBuilder
    private var nowCardBackground: some View {
        if isNow {
            RoundedRectangle(cornerRadius: Self.cellCornerRadius)
                .fill(Color.green.opacity(0.1))
        } else {
            RoundedRectangle(cornerRadius: Self.cellCornerRadius)
                .fill(Color.white.opacity(0.05))
        }
    }

    private var nowCardBorder: Color {
        isNow ? Color.green.opacity(0.5) : .clear
    }

    private var hourLabel: String {
        if hour == 0 { return "12 AM" }
        if hour == 12 { return "12 PM" }
        return hour < 12 ? "\(hour) AM" : "\(hour - 12) PM"
    }
}
