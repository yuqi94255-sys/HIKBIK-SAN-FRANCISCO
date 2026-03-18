// Orders tab: Pending Shipment / Pending Delivery (aligned with Web)
import SwiftUI

// MARK: - Order status & models
enum OrderStatus: String, CaseIterable {
    case pendingShipment = "Pending Shipment"
    case pendingDelivery = "Pending Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    /// 租賃中（設備在用戶處）
    case renting = "Renting"
    /// 歸還中（用戶已發起歸還）
    case returning = "Returning"
    /// 租賃已結束（已歸還）
    case completed = "Completed"
    /// 模擬：快遞/倉庫已收貨（用於 Mock 歸還流程）
    case received = "Received"

    /// 從後端返回的 status 字符串映射為 UI 使用的枚舉（支援 snake_case / 小寫）
    static func from(backendValue: String) -> OrderStatus? {
        let normalized = backendValue.lowercased().replacingOccurrences(of: " ", with: "_")
        switch normalized {
        case "pending_shipment", "pendingShipment": return .pendingShipment
        case "pending_delivery", "pendingDelivery": return .pendingDelivery
        case "delivered": return .delivered
        case "cancelled", "canceled": return .cancelled
        case "renting": return .renting
        case "returning": return .returning
        case "received": return .received
        case "completed": return .completed
        default: return OrderStatus(rawValue: backendValue)
        }
    }
}

/// 訂單類型：買斷 / 租賃
enum OrderType: String, Codable, CaseIterable {
    case buy
    case rent
}

/// 租賃起訖日期
struct RentalPeriod: Codable, Equatable, Hashable {
    let start: Date
    let end: Date
}

/// 歸還方式：自寄 / 上門取件
enum ReturnMethod: String, Codable, CaseIterable {
    case selfShip = "self_ship"
    case pickup = "pickup"
}

struct OrderItem: Identifiable, Hashable {
    let id: String
    let name: String
    let quantity: Int
    let price: String
}

struct Order: Identifiable, Hashable {
    let id: String
    let orderNumber: String
    let date: Date
    let status: OrderStatus
    let total: String
    let items: [OrderItem]
    var estimatedDelivery: String?
    var trackingNumber: String?
    var shippingAddress: String?
    /// 買斷 vs 租賃
    var orderType: OrderType
    /// 僅 .rent：租期
    var rentalPeriod: RentalPeriod?
    /// 僅 .rent：歸還方式
    var returnMethod: ReturnMethod?
    /// 僅 .rent 且 returnMethod == .pickup：取件費（美元）
    var pickupFee: Int?
    /// 租賃歸還後押金是否已退（用於 Mock / 後端）
    var isDepositRefunded: Bool?

    init(
        id: String,
        orderNumber: String,
        date: Date,
        status: OrderStatus,
        total: String,
        items: [OrderItem],
        estimatedDelivery: String? = nil,
        trackingNumber: String? = nil,
        shippingAddress: String? = nil,
        orderType: OrderType = .buy,
        rentalPeriod: RentalPeriod? = nil,
        returnMethod: ReturnMethod? = nil,
        pickupFee: Int? = nil,
        isDepositRefunded: Bool? = nil
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.date = date
        self.status = status
        self.total = total
        self.items = items
        self.estimatedDelivery = estimatedDelivery
        self.trackingNumber = trackingNumber
        self.shippingAddress = shippingAddress
        self.orderType = orderType
        self.rentalPeriod = rentalPeriod
        self.returnMethod = returnMethod
        self.pickupFee = pickupFee
        self.isDepositRefunded = isDepositRefunded
    }

    /// 用於 Mock/後端：返回新 Order，僅更新 status 與 isDepositRefunded
    func with(status: OrderStatus, isDepositRefunded: Bool? = nil) -> Order {
        Order(
            id: id,
            orderNumber: orderNumber,
            date: date,
            status: status,
            total: total,
            items: items,
            estimatedDelivery: estimatedDelivery,
            trackingNumber: trackingNumber,
            shippingAddress: shippingAddress,
            orderType: orderType,
            rentalPeriod: rentalPeriod,
            returnMethod: returnMethod,
            pickupFee: pickupFee,
            isDepositRefunded: isDepositRefunded ?? self.isDepositRefunded
        )
    }
}

/// 用於導航到歸還詳情的包裝，每次點擊生成新 id 以確保能再次 push
private struct ReturnDestination: Identifiable, Hashable {
    let id = UUID()
    let order: Order
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: ReturnDestination, rhs: ReturnDestination) -> Bool { lhs.id == rhs.id }
}

/// 用於「View Details」進入訂單/歸還詳情
private struct OrderDetailDestination: Identifiable, Hashable {
    let id = UUID()
    let order: Order
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: OrderDetailDestination, rhs: OrderDetailDestination) -> Bool { lhs.id == rhs.id }
}

// MARK: - OrdersView
struct OrdersView: View {
    @State private var selectedTab: OrderTab = .all
    @State private var returnDestination: ReturnDestination?
    @State private var orderDetailDestination: OrderDetailDestination?
    @StateObject private var mockAPI = MockAPIService.shared
    private let viewModel = OrdersViewModel(api: .shared)

    enum OrderTab: String, CaseIterable {
        case all = "All"
        case renting = "Renting"
        case pendingShipment = "Pending Shipment"
        case pendingDelivery = "Pending Delivery"
    }

    private var filteredOrders: [Order] {
        switch selectedTab {
        case .all: return mockAPI.orders
        case .renting: return mockAPI.orders.filter { $0.orderType == .rent }
        case .pendingShipment: return mockAPI.orders.filter { $0.status == .pendingShipment }
        case .pendingDelivery: return mockAPI.orders.filter { $0.status == .pendingDelivery }
        }
    }

    private func loadOrders() async {
        await mockAPI.fetchOrdersFromServer()
    }

    private static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.locale = Locale(identifier: "en_US")
        return f
    }

    var body: some View {
        VStack(spacing: 0) {
            // Tab bar
            HStack(spacing: 24) {
                ForEach(OrderTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Text(tab.rawValue)
                            .font(.system(size: 15, weight: selectedTab == tab ? .semibold : .regular, design: .rounded))
                            .foregroundStyle(selectedTab == tab ? Color.white : Color.white.opacity(0.55))
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.deepSpaceCard)

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 1)

            ScrollView {
                if filteredOrders.isEmpty {
                    ContentUnavailableView(
                        "Orders",
                        systemImage: "shippingbox.fill",
                        description: Text("Your orders will appear here.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredOrders) { order in
                            OrderCard(
                                order: order,
                                dateFormatter: Self.dateFormatter,
                                onReturnNowTapped: { returnDestination = ReturnDestination(order: $0) },
                                onViewDetailsTapped: { orderDetailDestination = OrderDetailDestination(order: $0) }
                            )
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .refreshable {
                await loadOrders()
            }
        }
        .background(Color.deepSpaceBackground)
        .task {
            await loadOrders()
        }
        .navigationDestination(item: $returnDestination) { dest in
            if dest.order.orderType == .rent {
                ReturnDetailView(order: dest.order, mockAPI: mockAPI)
            } else {
                ReturnCenterView(order: dest.order)
            }
        }
        .navigationDestination(item: $orderDetailDestination) { dest in
            if dest.order.orderType == .rent {
                ReturnDetailView(order: dest.order, mockAPI: mockAPI)
            } else {
                OrderDetailView(order: dest.order)
            }
        }
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.deepSpaceBackground, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
        #if DEBUG
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Run Return Flow Check", action: runSmokeTest)
                } label: {
                    Text("Debug")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
            }
        }
        #endif
    }

    #if DEBUG
    /// 冒煙測試：租賃歸還流程 + 邊際案例（Buy 訂單不可歸還），每步在控制台打印校驗結果
    private func runSmokeTest() {
        let api = mockAPI
        let vm = viewModel

        // 邊際案例：Buy 訂單調用歸還應被攔截
        if let buyOrder = api.orders.first(where: { $0.orderType == .buy }) {
            let beforeStatus = buyOrder.status
            vm.startMockReturnFlow(for: buyOrder.id)
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                let after = api.orders.first(where: { $0.id == buyOrder.id })
                if after?.status == beforeStatus {
                    print("[Smoke Test] ✅ 邊際案例通過：Buy 訂單 \(buyOrder.orderNumber) 調用歸還後狀態未變 (\(beforeStatus.rawValue))")
                } else {
                    print("[Smoke Test] ❌ 邊際案例失敗：Buy 訂單狀態被修改為 \(after?.status.rawValue ?? "nil")")
                }
            }
        }

        guard let rental = api.orders.first(where: { $0.orderType == .rent && $0.status == .renting }) else {
            print("[Smoke Test] ❌ 未找到 Renting 租賃訂單，跳過歸還流程")
            return
        }

        print("[Smoke Test] ✅ 找到租賃訂單: \(rental.orderNumber), id: \(rental.id)")
        print("[Smoke Test] 啟動歸還流程...")
        vm.startMockReturnFlow(for: rental.id)

        Task { @MainActor in
            for step in 0..<11 {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                let current = api.orders.first(where: { $0.id == rental.id })
                let statusStr = current?.status.rawValue ?? "nil"
                let refundStr = current?.isDepositRefunded.map { $0 ? "true" : "false" } ?? "nil"
                print("[Smoke Test] Step \(step * 2)s — status: \(statusStr), isDepositRefunded: \(refundStr)")
                if current?.status == .completed && current?.isDepositRefunded == true {
                    print("[Smoke Test] ✅ 歸還流程完成，押金已退，數據校驗通過")
                    return
                }
            }
            print("[Smoke Test] ⏱ 20s 內未達 completed+refunded（流程需約 15s）")
        }
    }
    #endif
}

// 押金退還成功用亮綠色（Success Green）
private let refundSuccessGreen = Color(hex: "22C55E")

// MARK: - Order card
struct OrderCard: View {
    let order: Order
    let dateFormatter: DateFormatter
    var onReturnNowTapped: ((Order) -> Void)? = nil
    var onViewDetailsTapped: ((Order) -> Void)? = nil

    private var statusColor: Color {
        switch order.status {
        case .pendingShipment: return Color(hex: "D97706")
        case .pendingDelivery: return Color(hex: "2563EB")
        case .delivered: return Color(hex: "059669")
        case .cancelled: return Color.white.opacity(0.5)
        case .renting: return Color.shopNeonGreen
        case .returning: return Color(hex: "2563EB")
        case .received: return Color(hex: "2563EB")
        case .completed: return Color(hex: "059669")
        }
    }

    private var statusBgColor: Color {
        switch order.status {
        case .pendingShipment: return Color(hex: "D97706").opacity(0.25)
        case .pendingDelivery: return Color(hex: "2563EB").opacity(0.25)
        case .delivered: return Color.shopNeonGreen.opacity(0.2)
        case .cancelled: return Color.white.opacity(0.1)
        case .renting: return Color.shopNeonGreen.opacity(0.25)
        case .returning: return Color(hex: "2563EB").opacity(0.25)
        case .received: return Color(hex: "2563EB").opacity(0.25)
        case .completed: return Color.shopNeonGreen.opacity(0.2)
        }
    }

    private var statusIcon: String {
        switch order.status {
        case .pendingShipment: return "shippingbox.fill"
        case .pendingDelivery: return "truck.box.fill"
        case .delivered: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        case .renting: return "clock.badge.checkmark"
        case .returning: return "arrow.uturn.backward.circle.fill"
        case .received: return "shippingbox.fill"
        case .completed: return "checkmark.circle.fill"
        }
    }

    private var refundDetailBar: some View {
        Text("The security deposit has been credited back to your original payment method.")
            .font(.system(size: 13, weight: .regular, design: .rounded))
            .foregroundStyle(Color.white.opacity(0.85))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .bottom)),
                removal: .opacity
            ))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: order number, date, status
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order \(order.orderNumber)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white)
                    Text(dateFormatter.string(from: order.date))
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.65))
                }
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: statusIcon)
                        .font(.system(size: 12))
                    Text(order.status.rawValue)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(statusColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(statusBgColor)
                .clipShape(Capsule())
            }
            .padding(20)
            .background(Color.deepSpaceCard)

            // Tracking when pending delivery
            if order.status == .pendingDelivery, let tracking = order.trackingNumber {
                HStack(spacing: 8) {
                    Image(systemName: "truck.box.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "1D4ED8"))
                    Text("In Transit")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(hex: "1E3A8A"))
                    Spacer()
                }
                .padding(12)
                .background(Color(hex: "EFF6FF"))
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                Text("Tracking: \(tracking)")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color(hex: "1E40AF"))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }

            // Est. delivery
            if let est = order.estimatedDelivery, order.status != .delivered {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                    Text("Est. delivery: \(est)")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                }
                .foregroundStyle(Color.white.opacity(0.65))
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }

            Divider()
                .padding(.horizontal, 20)

            // Items
            VStack(alignment: .leading, spacing: 12) {
                ForEach(order.items) { item in
                    HStack(alignment: .center, spacing: 16) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color.white.opacity(0.65))
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikForeground)
                            Text("Qty: \(item.quantity) × \(item.price)")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.65))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 16)
            .background(Color.deepSpaceCard)

            // Return Now（僅租賃且狀態為 renting）或 Refunded（已完成且押金已退）
            if order.orderType == .rent && order.status == .renting {
                Divider()
                    .padding(.horizontal, 20)
                Button {
                    onReturnNowTapped?(order)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .font(.system(size: 18))
                        Text("Return Now")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(Color.shopNeonGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                .background(Color.deepSpaceCard)
            } else if order.orderType == .rent && order.status == .completed && order.isDepositRefunded == true {
                Group {
                    Divider()
                        .padding(.horizontal, 20)
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                        Text("Refunded: $50.00")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(refundSuccessGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.deepSpaceCard)

                    refundDetailBar
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .bottom)),
                    removal: .opacity
                ))
            }

            Divider()
                .padding(.horizontal, 20)

            // Total + View details
            HStack {
                Text("Total: ")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.65))
                Text(order.total)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.hikbikForeground)
                Spacer()
                Button {
                    onViewDetailsTapped?(order)
                } label: {
                    HStack(spacing: 4) {
                        Text("View Details")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(Color.hikbikTabActive)
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(Color.hikbikSecondary.opacity(0.5))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .animation(.easeOut(duration: 0.4), value: order.isDepositRefunded)
    }
}

#Preview { OrdersView() }
