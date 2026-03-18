// MARK: - 歸還流程後端對接：POST /api/v1/returns，面單 label_url
// 所有歸還相關數據經由此 Service 返回，Mock / 真實 API 可切換

import Foundation

/// 歸還方式（與後端枚舉對齊）
enum ReturnMethodAPI: String, Codable {
    case schedulePickup = "schedule_pickup"
    case mailBack = "mail_back"
    case dropOffAtStore = "drop_off_at_store"
}

/// 上門取件地址（POST body 可選）
struct PickupAddressDTO: Codable {
    var recipientName: String
    var phone: String
    var street: String
    var city: String
    var state: String
    var zip: String
}

/// POST /api/v1/returns 請求體
struct CreateReturnRequest: Encodable {
    let orderId: String
    let returnMethod: ReturnMethodAPI
    let pickupAddress: PickupAddressDTO?
    let storeId: String?
}

/// POST /api/v1/returns 成功響應（後端返回 label_url 時用於 Mail-back）
struct CreateReturnResponse: Decodable {
    let success: Bool
    let trackingNumber: String?
    /// Mail-back 時後端生成的面單 PDF URL
    let labelUrl: String?
    let message: String?
}

/// 歸還服務：提交歸還 + 面單由 API 返回或 Mock
final class ReturnService {
    static let shared = ReturnService()

    /// 是否使用真實 API（false 時用 Mock 延遲模擬）
    var useRealAPI: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["HIKBIK_USE_RETURN_API"] == "1"
        #else
        return true
        #endif
    }

    private let client = APIClientBase.shared

    private init() {}

    /// 提交歸還申請。請求體包含 order_id, return_method, pickup_address（上門時）, store_id（店還時）。
    /// 成功後若為 Mail-back，response.labelUrl 可用於下載/打印面單。
    func submitReturn(
        orderId: String,
        returnMethod: ReturnMethodAPI,
        pickupAddress: PickupAddressDTO?,
        storeId: String?
    ) async throws -> CreateReturnResponse {
        if useRealAPI {
            let body = CreateReturnRequest(
                orderId: orderId,
                returnMethod: returnMethod,
                pickupAddress: pickupAddress,
                storeId: storeId
            )
            return try await client.post("/api/v1/returns", body: body)
        }
        // Mock：模擬延遲與返回 label_url（Mail-back）
        try await Task.sleep(nanoseconds: 1_500_000_000)
        let labelUrl: String? = returnMethod == .mailBack ? "https://labels.example.com/return-\(orderId).pdf" : nil
        let trackingNumber = "MB\(Int.random(in: 1000000000...9999999999))"
        return CreateReturnResponse(
            success: true,
            trackingNumber: trackingNumber,
            labelUrl: labelUrl,
            message: "Return submitted successfully"
        )
    }
}
