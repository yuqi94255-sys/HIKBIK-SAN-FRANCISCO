// 歸還管理中心：Schedule Pickup / Mail-back / Drop-off at Store
import SwiftUI
import CoreImage.CIFilterBuiltins

// MARK: - 歸還方式選項
enum ReturnOption: String, CaseIterable {
    case schedulePickup = "Schedule Pickup"
    case mailBack = "Mail-back"
    case dropOffAtStore = "Drop-off at Store"
}

struct ReturnCenterView: View {
    let order: Order
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: ReturnOption = .schedulePickup
    @State private var trackingNumber: String = ""
    /// 本筆歸還的唯一碼（用於 QR）
    private var returnCode: String {
        order.id + "-return-" + (order.orderNumber.replacingOccurrences(of: " ", with: ""))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                optionPicker
                optionContent
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

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Return Center")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
            Text("Order \(order.orderNumber)")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.65))
        }
    }

    private var optionPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How would you like to return?")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            HStack(spacing: 0) {
                ForEach(ReturnOption.allCases, id: \.self) { option in
                    Button {
                        selectedOption = option
                    } label: {
                        Text(option.rawValue)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(selectedOption == option ? Color.deepSpaceBackground : Color.white.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedOption == option ? Color.shopNeonGreen : Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private var optionContent: some View {
        switch selectedOption {
        case .schedulePickup:
            schedulePickupContent
        case .mailBack:
            mailBackContent
        case .dropOffAtStore:
            dropOffAtStoreContent
        }
    }

    // MARK: - Schedule Pickup
    private var schedulePickupContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            if order.returnMethod == .pickup {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.shopNeonGreen)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pickup already scheduled")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text("We'll collect the items from your address at the end of the rental period.")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.65))
                    }
                    Spacer()
                }
                .padding(16)
                .background(Color.deepSpaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Add pickup service")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white)
                    Text("You didn't select pickup at checkout. Add it now for $15 and we'll collect the gear from your address.")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.65))
                    Button {
                        // TODO: 接支付流程
                    } label: {
                        HStack(spacing: 8) {
                            Text("Pay $15 to schedule pickup")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(Color.deepSpaceBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.shopNeonGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
                .background(Color.deepSpaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Mail-back
    private static let returnAddress = "HIKBIK Returns\n1234 Warehouse Way\nFresno, CA 93721"

    private var mailBackContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Return address")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.9))
                Text(Self.returnAddress)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.deepSpaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text("Tracking Number")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.9))
                TextField("Enter carrier tracking number", text: $trackingNumber)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white)
                    .padding(14)
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .autocapitalization(.allCharacters)
                Button {
                    Task {
                        try? await OrderService.shared.submitReturnRequest(orderId: order.id, method: .mailBack)
                        _ = try? await OrderService.shared.trackReturn(trackingId: trackingNumber.trimmingCharacters(in: .whitespaces))
                    }
                } label: {
                    Text("Submit tracking number")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.deepSpaceBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.shopNeonGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(trackingNumber.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(trackingNumber.trimmingCharacters(in: .whitespaces).isEmpty ? 0.6 : 1)
            }
        }
    }

    // MARK: - Drop-off at Store
    private var dropOffAtStoreContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(spacing: 12) {
                Text("Show this QR code at the store")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.9))
                ReturnQRView(code: returnCode)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color.deepSpaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 10) {
                Text("Drop-off locations")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                ForEach(StoresView.allStores) { store in
                    StoreReturnRow(store: store)
                }
            }
        }
    }
}

// MARK: - Return QR
private struct ReturnQRView: View {
    let code: String
    private let size: CGFloat = 200

    var body: some View {
        if let image = qrImage(from: code) {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: "qrcode")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.white.opacity(0.4))
                )
        }
    }

    private func qrImage(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 8, y: 8))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - Store row for return list
private struct StoreReturnRow: View {
    let store: HikBikStore

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.12))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.shopNeonGreen)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(store.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                Text(store.address)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.65))
                Text(store.hours)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.5))
            }
            Spacer()
        }
        .padding(14)
        .background(Color.deepSpaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        ReturnCenterView(order: Order(
            id: "p",
            orderNumber: "ORD-2026-RENT-1",
            date: Date(),
            status: .renting,
            total: "$49.99",
            items: [OrderItem(id: "i1", name: "Trail Running Shoes", quantity: 1, price: "$49.99")],
            orderType: .rent,
            rentalPeriod: RentalPeriod(start: Date(), end: Date()),
            returnMethod: .selfShip,
            pickupFee: nil
        ))
    }
}
