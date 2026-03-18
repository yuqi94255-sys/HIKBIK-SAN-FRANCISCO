// 虛擬後端 Mock 測試系統：訂單唯一數據源，模擬網絡延遲與狀態變更
import Foundation
import Combine
import UIKit

/// 虛擬伺服器：持有一份 orders 作為唯一數據來源，供 OrdersView 觀察
final class MockAPIService: ObservableObject {
    static let shared = MockAPIService()

    /// 訂單列表唯一數據源，UI 依此自動更新
    @Published private(set) var orders: [Order] = []

    private init() {
        orders = Self.initialMockOrders()
    }

    /// 模擬從服務器拉取訂單（1.5 秒延遲）
    func fetchOrdersFromServer() async {
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        await MainActor.run {
            orders = Self.initialMockOrders()
        }
    }

    /// 更新指定訂單的狀態與押金退還標記（主線程更新，觸發 UI 刷新）
    @MainActor
    func updateOrderStatus(orderId: String, status: OrderStatus, isRefunded: Bool) {
        guard let index = orders.firstIndex(where: { $0.id == orderId }) else { return }
        let current = orders[index]
        orders[index] = current.with(status: status, isDepositRefunded: isRefunded)
        if status == .completed && isRefunded {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }

    // MARK: - 初始 Mock 數據

    private static func initialMockOrders() -> [Order] {
        let defaultShipping = "Jane Smith | +1 303-555-0142\n456 Oak Ave\nDenver, CO 80202"
        return [
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
                pickupFee: nil,
                isDepositRefunded: nil
            ),
        ]
    }
}

// MARK: - OrdersViewModel（動態歸還模擬腳本）

/// 訂單列表 ViewModel：驅動 Mock 歸還流程的時間軸
final class OrdersViewModel {
    private let api: MockAPIService

    init(api: MockAPIService = .shared) {
        self.api = api
    }

    /// 啟動虛擬歸還流程：三階段自動更新訂單狀態，模擬真實後端
    /// - Parameter orderId: 訂單 ID（對應 Order.id）
    /// - Note: 僅對 Rent 訂單生效；Buy 訂單調用時會被攔截，不報錯、不更新狀態
    func startMockReturnFlow(for orderId: String) {
        Task { @MainActor in
            guard api.orders.first(where: { $0.id == orderId })?.orderType == .rent else { return }
            // Stage 1：用戶已提交歸還
            api.updateOrderStatus(orderId: orderId, status: .returning, isRefunded: false)

            // Stage 2：5 秒後，模擬快遞已收貨
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            api.updateOrderStatus(orderId: orderId, status: .received, isRefunded: false)

            // Stage 3：再 10 秒後，倉庫檢查完畢並退款
            try? await Task.sleep(nanoseconds: 10_000_000_000)
            api.updateOrderStatus(orderId: orderId, status: .completed, isRefunded: true)
        }
    }
}
