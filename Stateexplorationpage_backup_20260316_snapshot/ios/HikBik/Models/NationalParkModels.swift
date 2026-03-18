// 与 national-parks-data.ts 对应（national-parks.json）
import Foundation

struct NationalPark: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let state: String
    let states: [String]?
    let description: String?
    let established: String?
    let area: String?
    let visitors: String?
    let entrance: String?
    let difficulty: String?
    let crowdLevel: String?
    let highlights: [String]?
    let features: [String]?
    let activities: [String]?
    let bestTime: [String]?
    let websiteUrl: String?
    let phone: String?
    let parkCode: String?
    let basicInfoUrl: String?
    let feesUrl: String?
    let mapsUrl: String?
    let classification: String?
    let address: String?
    let facilities: [String]?
    let mapLinks: [String]?
    let coordinates: ParkCoordinates?
    let fees: [String]?
    let feesDetail: [FeeDetail]?
    let operatingHours: String?
    let weather: String?
    let directions: String?
    let lodging: String?
    let acreage: Int?
    /// 海拔（可來自 NPS API 或 Mock），供詳情頁狀態條顯示
    let elevation: String?
}

struct ParkCoordinates: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

struct FeeDetail: Codable, Hashable {
    let type: String
    let amount: String
}

// MARK: - 備援數據（ParkBackupData.json）
/// 缺失 Coordinates / entrance / operatingHours 時從備援補齊；portals 為交通門戶數據（升級版 Access）
struct ParkBackupItem: Codable {
    let coordinates: ParkCoordinates?
    let entrance: String?
    let operatingHours: String?
    /// 交通門戶陣列（type, airport, driveTime, entrance, tip）
    let portals: [PortalItem]?
    /// 租車建議、路況預警、季節性封路提醒
    let proTip: String?
    /// 相容舊版；現由 portals 取代
    let access: AccessInfo?
}

typealias ParkBackupData = [String: ParkBackupItem]
