// MARK: - 前端通用戶外目的地模型（由 RIDB RecArea 適配後供 UI 使用）

import Foundation

/// 戶外目的地類型（對應 RIDB RecAreaType）
enum OutdoorDestinationType: String, CaseIterable {
    case nationalForest = "National Forest"
    case nationalGrassland = "National Grassland"
    case nationalRecreationArea = "National Recreation Area"
    case other = "Other"
}

/// 前端通用模型：名稱、描述（已去 HTML）、座標、聯絡方式等
struct OutdoorDestination: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let type: OutdoorDestinationType
    let latitude: Double?
    let longitude: Double?
    let phone: String?
    let email: String?
    let websiteURL: String?
    let reservationURL: String?
    let mapURL: String?
    let directions: String?
    let addressLine: String?
    let stateCode: String?
    let keywords: String?
}
