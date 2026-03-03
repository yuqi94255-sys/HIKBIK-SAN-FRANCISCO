// Orders tab: Pending Shipment / Pending Delivery (aligned with Web)
import SwiftUI

// MARK: - Order status & models
enum OrderStatus: String, CaseIterable {
    case pendingShipment = "Pending Shipment"
    case pendingDelivery = "Pending Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
}

struct OrderItem: Identifiable {
    let id: String
    let name: String
    let quantity: Int
    let price: String
}

struct Order: Identifiable {
    let id: String
    let orderNumber: String
    let date: Date
    let status: OrderStatus
    let total: String
    let items: [OrderItem]
    var estimatedDelivery: String?
    var trackingNumber: String?
    var shippingAddress: String?
}

// MARK: - Test orders (design preview)
private let testOrders: [Order] = [
    Order(
        id: "test-1",
        orderNumber: "ORD-2026-TEST-1",
        date: Date(),
        status: .pendingShipment,
        total: "$129.99",
        items: [OrderItem(id: "p1", name: "Hiking Backpack 50L", quantity: 1, price: "$129.99")],
        estimatedDelivery: "Ships in 3 business days",
        trackingNumber: nil,
        shippingAddress: "Sample address"
    ),
    Order(
        id: "test-2",
        orderNumber: "ORD-2026-TEST-2",
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
        status: .pendingDelivery,
        total: "$89.99",
        items: [OrderItem(id: "p2", name: "4-Person Camping Tent", quantity: 1, price: "$89.99")],
        estimatedDelivery: "Jan 30, 2026",
        trackingNumber: "TRK-PREVIEW-888",
        shippingAddress: "Sample address"
    ),
]

// MARK: - OrdersView
struct OrdersView: View {
    @State private var selectedTab: OrderTab = .all

    enum OrderTab: String, CaseIterable {
        case all = "All"
        case pendingShipment = "Pending Shipment"
        case pendingDelivery = "Pending Delivery"
    }

    private var filteredOrders: [Order] {
        switch selectedTab {
        case .all: return testOrders
        case .pendingShipment: return testOrders.filter { $0.status == .pendingShipment }
        case .pendingDelivery: return testOrders.filter { $0.status == .pendingDelivery }
        }
    }

    private static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.locale = Locale(identifier: "en_US")
        return f
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab bar
                HStack(spacing: 24) {
                    ForEach(OrderTab.allCases, id: \.self) { tab in
                        Button {
                            selectedTab = tab
                        } label: {
                            Text(tab.rawValue)
                                .font(.system(size: 15, weight: selectedTab == tab ? .semibold : .regular, design: .rounded))
                                .foregroundStyle(selectedTab == tab ? Color.hikbikForeground : Color.hikbikMutedForeground)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.hikbikCard)

                Divider()

                if filteredOrders.isEmpty {
                    ContentUnavailableView(
                        "Orders",
                        systemImage: "shippingbox.fill",
                        description: Text("Your orders will appear here.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredOrders) { order in
                                OrderCard(order: order, dateFormatter: Self.dateFormatter)
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(Color.hikbikBackground)
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Order card
struct OrderCard: View {
    let order: Order
    let dateFormatter: DateFormatter

    private var statusColor: Color {
        switch order.status {
        case .pendingShipment: return Color(hex: "D97706")
        case .pendingDelivery: return Color(hex: "2563EB")
        case .delivered: return Color(hex: "059669")
        case .cancelled: return Color.hikbikMutedForeground
        }
    }

    private var statusBgColor: Color {
        switch order.status {
        case .pendingShipment: return Color(hex: "FEF3C7")
        case .pendingDelivery: return Color(hex: "DBEAFE")
        case .delivered: return Color(hex: "D1FAE5")
        case .cancelled: return Color.hikbikMuted.opacity(0.5)
        }
    }

    private var statusIcon: String {
        switch order.status {
        case .pendingShipment: return "shippingbox.fill"
        case .pendingDelivery: return "truck.box.fill"
        case .delivered: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: order number, date, status
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order \(order.orderNumber)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.hikbikForeground)
                    Text(dateFormatter.string(from: order.date))
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
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
            .background(Color.hikbikCard)

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
                .foregroundStyle(Color.hikbikMutedForeground)
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
                            .fill(Color.hikbikMuted)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color.hikbikMutedForeground)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikForeground)
                            Text("Qty: \(item.quantity) × \(item.price)")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 16)
            .background(Color.hikbikCard)

            Divider()
                .padding(.horizontal, 20)

            // Total + View details
            HStack {
                Text("Total: ")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikMutedForeground)
                Text(order.total)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.hikbikForeground)
                Spacer()
                HStack(spacing: 4) {
                    Text("View Details")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.hikbikTabActive)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.hikbikTabActive)
                }
            }
            .padding(20)
            .background(Color.hikbikSecondary.opacity(0.5))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.hikbikBorder, lineWidth: 1)
        )
    }
}

#Preview { OrdersView() }
