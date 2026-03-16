// 物流 API 預留：第三方物流（FedEx / EasyPost 等）對接接口
// 當前為 Mock，正式對接時在此處配置 API Key 與請求邏輯

import Foundation

// MARK: - 面單模型（與 FedEx / EasyPost 等響應對齊）

struct ShippingLabel: Identifiable {
    let id: String
    let trackingNumber: String
    let carrierName: String
    let labelURL: String
    let estimatedArrival: Date
}

// MARK: - 物流追蹤階段（用於 UI 進度條）

enum TrackingStage: String, CaseIterable {
    case inTransit = "In Transit"
    case outForDelivery = "Out for Delivery"
    case returned = "Returned"

    var stepIndex: Int {
        switch self {
        case .inTransit: return 1
        case .outForDelivery: return 2
        case .returned: return 3
        }
    }
}

// MARK: - 物流服務（Mock + API 預留）

final class ShippingService {
    static let shared = ShippingService()

    // TODO: 正式對接時在此配置 API Key，例如：
    // private let fedExApiKey = ProcessInfo.processInfo.environment["FEDEX_API_KEY"]
    // private let easyPostApiKey = ProcessInfo.processInfo.environment["EASYPOST_API_KEY"]

    private init() {}

    /// 生成退貨面單（Mail-back / Home Pickup）
    /// - Parameters:
    ///   - orderId: 訂單 ID
    ///   - mode: .mailBack 或 .homePickup
    /// - Returns: 面單信息；正式對接時改為調用第三方 API
    func generateReturnLabel(orderId: String, mode: ReturnLabelMode) async -> ShippingLabel? {
        // TODO: 替換為真實 API 調用，例如：
        // let url = URL(string: "https://api.easypost.com/v2/shipments")!
        // var request = URLRequest(url: url)
        // request.setValue("Bearer \(easyPostApiKey)", forHTTPHeaderField: "Authorization")
        // request.httpMethod = "POST"
        // ... 構建 body、解析 response、返回 ShippingLabel

        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let prefix = mode == .homePickup ? "HP" : "MB"
        return ShippingLabel(
            id: "\(orderId)-label",
            trackingNumber: "\(prefix)\(Int.random(in: 1000000000...9999999999))",
            carrierName: "FedEx",
            labelURL: "https://labels.example.com/return-\(orderId)",
            estimatedArrival: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
        )
    }

    /// 查詢物流追蹤階段（用於頂部進度條）
    /// - Parameter trackingNumber: 運單號
    /// - Returns: 當前階段；正式對接時調用 carrier Tracking API
    func fetchTrackingStatus(trackingNumber: String) async -> TrackingStage {
        // TODO: 替換為真實 API，例如：
        // let url = URL(string: "https://api.fedex.com/track/v1/trackingnumbers")!
        // ... 解析 status 映射為 TrackingStage

        try? await Task.sleep(nanoseconds: 500_000_000)
        let hash = abs(trackingNumber.hashValue) % 3
        switch hash {
        case 0: return .inTransit
        case 1: return .outForDelivery
        default: return .returned
        }
    }
}

enum ReturnLabelMode {
    case mailBack
    case homePickup
}
