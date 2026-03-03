// MARK: - NPS API 請求服務（需有效 API key）
// 使用 developer.nps.gov 的 key，在 NPSAPIConfig / NPSSecrets 中設定
// 同步請求 /parks、/alerts；營地需另接 Recreation.gov

import Foundation

enum NPSAPIServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case noParkFound
}

enum NPSAPIService {

    private static func ensureAPIKey() throws {
        guard !NPSAPIConfig.apiKey.isEmpty else {
            #if DEBUG
            print("[NPSAPIService] API key 未設定，請在 NPSSecrets.apiKey 填入 key")
            #endif
            throw NPSAPIServiceError.noData
        }
    }

    /// 依 parkCode 取得單一公園（如 dena = Denali）
    static func fetchPark(
        parkCode: String,
        fields: String? = "images,elevation,operatingHours,addresses,entranceFees"
    ) async throws -> NationalPark {
        try ensureAPIKey()
        var components = URLComponents(string: NPSAPIConfig.baseURL + "/parks")!
        components.queryItems = [
            URLQueryItem(name: "parkCode", value: parkCode),
            URLQueryItem(name: "api_key", value: NPSAPIConfig.apiKey)
        ]
        if let f = fields, !f.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "fields", value: f))
        }
        guard let url = components.url else { throw NPSAPIServiceError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NPSParksResponse.self, from: data)
        guard let item = response.data.first else { throw NPSAPIServiceError.noParkFound }
        return item.toNationalPark()
    }

    /// 依 parkCode 取得該公園的 alerts（實時狀態）
    static func fetchAlerts(parkCode: String) async throws -> [NPSAlertItem] {
        try ensureAPIKey()
        var components = URLComponents(string: NPSAPIConfig.baseURL + "/alerts")!
        components.queryItems = [
            URLQueryItem(name: "parkCode", value: parkCode),
            URLQueryItem(name: "api_key", value: NPSAPIConfig.apiKey)
        ]
        guard let url = components.url else { throw NPSAPIServiceError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NPSAlertsResponse.self, from: data)
        return response.data ?? []
    }

    /// 依 parkCode 取得營地列表。數據源為 Recreation.gov (RIDB) 或 NPS /campgrounds；目前為預留，可先以 Mock 注入。
    static func fetchCampgrounds(parkCode: String) async throws -> [CampgroundItem] {
        // TODO: 對接 Recreation.gov RIDB API 或 NPS /campgrounds
        _ = parkCode
        return []
    }

    /// 依 parkCode 取得該公園的遊客中心列表（名稱 + 座標），供設施快覽與地圖標註
    static func fetchVisitorCenters(parkCode: String) async throws -> (names: [String], locations: [FacilityLocation]) {
        try ensureAPIKey()
        var components = URLComponents(string: NPSAPIConfig.baseURL + "/visitorcenters")!
        components.queryItems = [
            URLQueryItem(name: "parkCode", value: parkCode),
            URLQueryItem(name: "api_key", value: NPSAPIConfig.apiKey)
        ]
        guard let url = components.url else { throw NPSAPIServiceError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NPSVisitorCentersResponse.self, from: data)
        let items = response.data ?? []
        var names: [String] = []
        var locations: [FacilityLocation] = []
        for item in items {
            let name = item.name ?? "Visitor Center"
            if let lat = item.latitude.flatMap(Double.init), let lon = item.longitude.flatMap(Double.init) {
                locations.append(FacilityLocation(
                    id: item.id ?? UUID().uuidString,
                    name: name,
                    latitude: lat,
                    longitude: lon,
                    facilityType: "visitor_center"
                ))
            }
            names.append(name)
        }
        return (names, locations)
    }

    /// 同步請求 /parks、/alerts，組裝成 ParkDetail；並請求 /visitorcenters 填入 facilities。
    static func fetchAllDetail(parkCode: String) async throws -> ParkDetail {
        try ensureAPIKey()
        async let parksTask = fetchParksRaw(parkCode: parkCode)
        async let alertsTask = fetchAlerts(parkCode: parkCode)
        let (parkItem, alerts) = try await (parksTask, alertsTask)
        var detail = parkItem.toParkDetail(alerts: alerts)
        let vcResult = try? await fetchVisitorCenters(parkCode: parkCode)
        if let vc = vcResult, (!vc.names.isEmpty || !vc.locations.isEmpty) {
            let existing = detail.facilities ?? FacilitiesInfo(
                visitorCenters: nil,
                visitorCenterLocations: nil,
                restrooms: nil,
                waterStations: nil,
                foodServices: nil,
                lodging: nil,
                gasNearby: nil,
                wifiAvailable: nil,
                cellSignalStrength: nil,
                wheelchairAccessibility: nil
            )
            detail.facilities = FacilitiesInfo(
                visitorCenters: vc.names.isEmpty ? existing.visitorCenters : vc.names,
                visitorCenterLocations: vc.locations.isEmpty ? existing.visitorCenterLocations : vc.locations,
                restrooms: existing.restrooms,
                waterStations: existing.waterStations,
                foodServices: existing.foodServices,
                lodging: existing.lodging,
                gasNearby: existing.gasNearby,
                wifiAvailable: existing.wifiAvailable,
                cellSignalStrength: existing.cellSignalStrength,
                wheelchairAccessibility: existing.wheelchairAccessibility
            )
        }
        #if DEBUG
        printParkDetailToConsole(detail, parkCode: parkCode)
        #endif
        return detail
    }

    /// 內部：只取 /parks 回傳的 NPSParkItem（不轉 NationalPark）
    private static func fetchParksRaw(parkCode: String) async throws -> NPSParkItem {
        try ensureAPIKey()
        var components = URLComponents(string: NPSAPIConfig.baseURL + "/parks")!
        components.queryItems = [
            URLQueryItem(name: "parkCode", value: parkCode),
            URLQueryItem(name: "api_key", value: NPSAPIConfig.apiKey),
            URLQueryItem(name: "fields", value: "images,elevation,operatingHours,addresses,entranceFees")
        ]
        guard let url = components.url else { throw NPSAPIServiceError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NPSParksResponse.self, from: data)
        guard let item = response.data.first else { throw NPSAPIServiceError.noParkFound }
        return item
    }

    #if DEBUG
    private static func printParkDetailToConsole(_ detail: ParkDetail, parkCode: String) {
        print("========== ParkDetail [\(parkCode)] ==========")
        print("BasicInfo: \(detail.basicInfo.parkName)")
        print("  lat/lng: \(detail.basicInfo.latitude ?? 0), \(detail.basicInfo.longitude ?? 0)")
        print("  description: \(detail.basicInfo.description?.prefix(80) ?? "")...")
        print("LiveStatus alerts: \(detail.liveStatus?.alertNotices.count ?? 0)")
        detail.liveStatus?.alertNotices.prefix(3).forEach { a in
            print("  - \(a.title ?? "")")
        }
        print("FeesAndPermits entryFee: \(detail.feesAndPermits?.entryFee ?? "—")")
        print("Campgrounds: \(detail.campgrounds.count) (Recreation.gov 待對接)")
        print("==============================================")
    }
    #endif
}
