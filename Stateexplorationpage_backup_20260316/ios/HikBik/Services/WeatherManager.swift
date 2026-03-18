// MARK: - Weather Manager — 實時天氣 API 預留（可接入 Apple WeatherKit / OpenWeather）
import Foundation
import CoreLocation

/// 單次天氣快照，結構完整以備接入真實 API；前端僅依賴此結構，接入時無需改動 UI。
struct WeatherSnapshot: Sendable {
    var temperatureFahrenheit: Double
    var conditionDescription: String
    var conditionSymbol: String
    var windSpeedMph: Double
    var windDirection: String?
    var precipitationChance: Int
    /// National Recreation Area 專用：水溫 °F，未接入時為 nil
    var waterTempFahrenheit: Double?

    var temperatureDisplay: String { "\(Int(temperatureFahrenheit))°F" }
    var windDisplay: String {
        if let dir = windDirection, !dir.isEmpty {
            return "\(Int(windSpeedMph)) mph \(dir)"
        }
        return "\(Int(windSpeedMph)) mph"
    }
    var precipitationDisplay: String { "\(precipitationChance)%" }
    var waterTempDisplay: String? {
        guard let w = waterTempFahrenheit else { return nil }
        return "\(Int(w))°F"
    }

    /// 加載中或無數據時佔位；結構與真實 API 一致，避免接入時改動前端。
    static let placeholder: WeatherSnapshot = WeatherSnapshot(
        temperatureFahrenheit: 72,
        conditionDescription: "Clear Sky",
        conditionSymbol: "sun.max.fill",
        windSpeedMph: 8,
        windDirection: "NW",
        precipitationChance: 10,
        waterTempFahrenheit: nil
    )
}

/// 天氣數據獲取：目前為 Mock，接口預留便於接入 Apple WeatherKit 或 OpenWeather。
/// 頁面初始化時傳入 itinerary.first 座標；用戶點擊不同 View Point 時傳該點座標即可更新天氣。
final class WeatherManager: @unchecked Sendable {
    static let shared = WeatherManager()

    private init() {}

    /// 依座標獲取天氣。目前返回 Mock；接入時替換為 WeatherService.weather(for:) 等，無需改動調用方。
    func fetchWeather(for coordinate: CLLocationCoordinate2D) async -> WeatherSnapshot {
        try? await Task.sleep(nanoseconds: 300_000_000)
        return mockSnapshot(for: coordinate)
    }

    /// 同步便捷方法（主線程回調）
    func fetchWeather(for coordinate: CLLocationCoordinate2D, completion: @escaping (WeatherSnapshot) -> Void) {
        Task {
            let snapshot = await fetchWeather(for: coordinate)
            await MainActor.run { completion(snapshot) }
        }
    }

    private func mockSnapshot(for coordinate: CLLocationCoordinate2D) -> WeatherSnapshot {
        let seed = coordinate.latitude * 1000 + coordinate.longitude
        let temp = 68.0 + (seed.truncatingRemainder(dividingBy: 12)) - 4
        let wind = 8.0 + (seed.truncatingRemainder(dividingBy: 10))
        let precip = Int(seed.truncatingRemainder(dividingBy: 30))
        // National Recreation Area 會顯示 Water Temp；Mock 始終提供水溫，接入時由 API 填寫。
        let water = 64.0 + (seed.truncatingRemainder(dividingBy: 10))
        return WeatherSnapshot(
            temperatureFahrenheit: temp,
            conditionDescription: "Clear Sky",
            conditionSymbol: "sun.max.fill",
            windSpeedMph: wind,
            windDirection: "NW",
            precipitationChance: precip,
            waterTempFahrenheit: water
        )
    }
}
