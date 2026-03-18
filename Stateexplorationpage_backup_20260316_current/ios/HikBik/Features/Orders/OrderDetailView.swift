// 買斷訂單詳情：與 ReturnDetailView 一致設計語彙，僅展示已購買資訊（無租賃/歸還/押金）
import SwiftUI
import UIKit

struct OrderDetailView: View {
    let order: Order
    @State private var didCopyTracking = false

    private static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.locale = Locale(identifier: "en_US")
        return f
    }

    private var cardBackground: Color {
        Color(uiColor: .secondarySystemBackground)
    }

    private var statusColor: Color {
        switch order.status {
        case .pendingShipment: return Color(hex: "D97706")
        case .pendingDelivery: return Color(hex: "2563EB")
        case .delivered: return Color(hex: "22C55E")
        case .cancelled: return Color.white.opacity(0.5)
        default: return Color.shopNeonGreen
        }
    }

    /// 買斷頁面不展示任何租賃/歸還/押金，僅用於 orderType == .buy
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                statusCard
                productSection
                paymentSummary
            }
            .padding(20)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.deepSpaceBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.deepSpaceBackground, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    // MARK: - Header（訂單號與下單日期）
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(order.orderNumber)
                .font(.headline)
                .foregroundStyle(Color.white)
            Text("Order date: \(Self.dateFormatter.string(from: order.date))")
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.65))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Status Card（物流狀態；若已發貨顯示快遞單號 + Copy）
    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Status")
                .font(.headline)
                .foregroundStyle(Color.white)
            HStack(alignment: .center, spacing: 10) {
                Text(order.status.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(statusColor)
                Spacer()
            }
            if let est = order.estimatedDelivery {
                Text(est)
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.7))
            }
            if let tracking = order.trackingNumber, !tracking.isEmpty {
                HStack(spacing: 10) {
                    Text(tracking)
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundStyle(Color.white.opacity(0.9))
                    Spacer()
                    Button {
                        UIPasteboard.general.string = tracking
                        didCopyTracking = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { didCopyTracking = false }
                    } label: {
                        Text(didCopyTracking ? "Copied" : "Copy")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(didCopyTracking ? Color.shopNeonGreen : Color.shopNeonGreen)
                    }
                    .buttonStyle(.plain)
                }
                .padding(12)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Product Section（商品列表）
    private var productSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Products")
                .font(.headline)
                .foregroundStyle(Color.white)
            ForEach(order.items) { item in
                HStack(alignment: .center, spacing: 16) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 72, height: 72)
                        .overlay(
                            Image(systemName: "bag.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.white.opacity(0.6))
                        )
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.white)
                        Text("Qty: \(item.quantity) × \(item.price)")
                            .font(.caption)
                            .foregroundStyle(Color.white.opacity(0.65))
                    }
                    Spacer()
                    Text(item.price)
                        .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                        .foregroundStyle(Color.white)
                }
                .padding(14)
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Payment Summary（小計、運費、稅金、實付總額）
    private var paymentSummary: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Payment summary")
                .font(.headline)
                .foregroundStyle(Color.white)
            paymentRow(label: "Subtotal", value: subtotalString)
            paymentRow(label: "Shipping", value: "Included")
            paymentRow(label: "Tax", value: "Included")
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.vertical, 4)
            HStack {
                Text("Total paid")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                Spacer()
                Text(order.total)
                    .font(.system(.title3, design: .monospaced).weight(.bold))
                    .foregroundStyle(Color.shopNeonGreen)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var subtotalString: String {
        if order.items.isEmpty { return order.total }
        let totalCents = order.items.reduce(0) { sum, item in
            let priceStr = item.price.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
            if let d = Double(priceStr) {
                return sum + Int(d * Double(item.quantity) * 100)
            }
            return sum
        }
        return String(format: "$%.2f", Double(totalCents) / 100)
    }

    private func paymentRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.75))
            Spacer()
            Text(value)
                .font(.system(.subheadline, design: .monospaced).weight(.medium))
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(order: Order(
            id: "1",
            orderNumber: "ORD-2026-TEST-1",
            date: Date(),
            status: .pendingDelivery,
            total: "$129.99",
            items: [
                OrderItem(id: "p1", name: "Hiking Backpack 50L", quantity: 1, price: "$129.99")
            ],
            estimatedDelivery: "Jan 30, 2026",
            trackingNumber: "TRK-PREVIEW-888",
            shippingAddress: "123 Main St\nBoulder, CO 80301"
        ))
    }
}
