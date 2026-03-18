// 訂單與歸還後端接口抽象：便於未來對接 API
import Foundation

/// 歸還方式（與 ReturnMethod 對齊，供 API 使用）
enum ReturnRequestMethod: String, Codable {
    case schedulePickup = "schedule_pickup"
    case mailBack = "mail_back"
    case dropOffAtStore = "drop_off_at_store"
}

/// 訂單與歸還服務：數據讀取與提交均由此抽象，未來替換為真實網絡請求
final class OrderService {
    static let shared = OrderService()

    private init() {}

    // MARK: - 訂單列表（抽象化數據讀取）

    /// 拉取當前用戶的訂單列表。現為本地 Mock，上線後改為 GET /orders 等。
    func fetchOrders() async -> [Order] {
        // TODO: 替換為 URLSession 或 APIClient
        // let data = try await api.get("/orders")
        // return data.orders.map { Order(from: $0) } 並用 OrderStatus.from(backendValue: $0.status)
        try? await Task.sleep(nanoseconds: 300_000_000) // 模擬輕微延遲
        return Self.mockOrders
    }

    // MARK: - 歸還請求（預留接口）

    /// 提交歸還申請。上線後對接 POST /orders/:id/return 等。
    /// - Parameters:
    ///   - orderId: 訂單 ID
    ///   - method: 歸還方式（Schedule Pickup / Mail-back / Drop-off at Store）
    func submitReturnRequest(orderId: String, method: ReturnRequestMethod) async throws {
        // TODO: await api.post("/orders/\(orderId)/return", body: ["method": method.rawValue])
        _ = (orderId, method)
    }

    /// 查詢歸還物流。上線後對接 GET /returns/track?trackingId=xxx 等。
    func trackReturn(trackingId: String) async throws -> String? {
        // TODO: let data = try await api.get("/returns/track", query: ["trackingId": trackingId])
        // return data.statusDescription
        _ = trackingId
        return nil
    }

    // MARK: - Mock 數據（與後端對接前使用；UI 標籤由 Order.status.rawValue 自動渲染）

    private static let defaultShipping = "Jane Smith | +1 303-555-0142\n456 Oak Ave\nDenver, CO 80202"

    private static var mockOrders: [Order] {
        [
            Order(
                id: "ord-2026-001",
                orderNumber: "ORD-2026-001",
                date: Date(),
                status: .pendingShipment,
                total: "$129.99",
                items: [OrderItem(id: "p1", name: "Hiking Backpack 50L", quantity: 1, price: "$129.99")],
                estimatedDelivery: "Ships in 3 business days",
                trackingNumber: nil,
                shippingAddress: defaultShipping
            ),
            Order(
                id: "ord-2026-002",
                orderNumber: "ORD-2026-002",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                status: .pendingDelivery,
                total: "$89.99",
                items: [OrderItem(id: "p2", name: "4-Person Camping Tent", quantity: 1, price: "$89.99")],
                estimatedDelivery: "Jan 30, 2026",
                trackingNumber: "TRK-PREVIEW-888",
                shippingAddress: defaultShipping
            ),
            Order(
                id: "ord-2026-rent-001",
                orderNumber: "ORD-2026-RENT-001",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                status: .renting,
                total: "$49.99",
                items: [OrderItem(id: "p3", name: "Trail Running Shoes", quantity: 1, price: "$49.99")],
                estimatedDelivery: nil,
                trackingNumber: nil,
                shippingAddress: defaultShipping,
                orderType: .rent,
                rentalPeriod: RentalPeriod(
                    start: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                    end: Calendar.current.date(byAdding: .day, value: 9, to: Date()) ?? Date()
                ),
                returnMethod: .selfShip,
                pickupFee: nil
            ),
        ]
    }
}
