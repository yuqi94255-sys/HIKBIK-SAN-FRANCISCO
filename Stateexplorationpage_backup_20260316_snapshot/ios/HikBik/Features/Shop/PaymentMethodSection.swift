// MARK: - 支付方式（深色結帳）
import SwiftUI

private enum PayDark {
    static let card = Color.deepSpaceCard
    static let title = Color.white
    static let body = Color.white.opacity(0.65)
    static let border = Color.white.opacity(0.16)
    static let accent = Color.shopNeonGreen
    static let input = Color.white.opacity(0.1)
}

struct PaymentMethodSection: View {
    @ObservedObject var vm: CheckoutViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Information")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(PayDark.title)

            ForEach([PaymentMethod.creditCard, .applePay, .payPal], id: \.self) { method in
                Button(action: { vm.paymentMethod = method }) {
                    HStack(spacing: 12) {
                        Image(systemName: vm.paymentMethod == method ? "circle.inset.filled" : "circle")
                            .font(.system(size: 22))
                            .foregroundStyle(vm.paymentMethod == method ? PayDark.accent : PayDark.body)
                        switch method {
                        case .creditCard:
                            Text("Credit Card")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(PayDark.title)
                        case .applePay:
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 20))
                                    .foregroundStyle(PayDark.title)
                                Text("Apple Pay")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(PayDark.title)
                            }
                        case .payPal:
                            Text("PayPal")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(PayDark.title)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(PayDark.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(vm.paymentMethod == method ? PayDark.accent : PayDark.border,
                                    lineWidth: vm.paymentMethod == method ? 2 : 1)
                    )
                }
                .buttonStyle(.plain)
            }

            if vm.paymentMethod == .creditCard {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Card Number", text: $vm.cardNumber)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(PayDark.input)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(PayDark.border, lineWidth: 1))
                        .foregroundStyle(PayDark.title)
                        .tint(PayDark.accent)
                        .onChange(of: vm.cardNumber) { _, new in vm.cardNumber = Self.formatCardNumber(new) }
                    TextField("Expiry (MM/YY)", text: $vm.expiryDate)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(PayDark.input)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(PayDark.border, lineWidth: 1))
                        .foregroundStyle(PayDark.title)
                        .tint(PayDark.accent)
                        .onChange(of: vm.expiryDate) { _, new in vm.expiryDate = Self.formatExpiry(new) }
                    TextField("CVV", text: $vm.cvv)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(PayDark.input)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(PayDark.border, lineWidth: 1))
                        .foregroundStyle(PayDark.title)
                        .tint(PayDark.accent)
                        .frame(maxWidth: 120)
                        .onChange(of: vm.cvv) { _, new in vm.cvv = String(new.filter(\.isNumber).prefix(4)) }
                }
                .padding(.top, 8)
            }
        }
    }

    static func formatCardNumber(_ raw: String) -> String {
        let digits = raw.filter(\.isNumber).prefix(19)
        var out = ""
        for (i, c) in digits.enumerated() {
            if i > 0 && i % 4 == 0 { out.append(" ") }
            out.append(c)
        }
        return out
    }

    static func formatExpiry(_ raw: String) -> String {
        let d = raw.filter(\.isNumber).prefix(4)
        if d.count <= 2 { return String(d) }
        return "\(d.prefix(2))/\(d.dropFirst(2))"
    }
}
