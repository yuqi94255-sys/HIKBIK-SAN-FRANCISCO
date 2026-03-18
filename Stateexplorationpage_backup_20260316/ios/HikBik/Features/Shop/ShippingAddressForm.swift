// MARK: - 收貨地址（深色 + 名片磁貼）
import SwiftUI

private enum AddrDark {
    static let bg = Color.deepSpaceBackground
    static let card = Color.deepSpaceCard
    static let title = Color.white
    static let body = Color.white.opacity(0.65)
    static let border = Color.white.opacity(0.16)
    static let accent = Color.shopNeonGreen
    static let input = Color.white.opacity(0.1)
    static let tileSelected = Color.white.opacity(0.12)
}

private enum CheckoutAddressUI {
    static let tileCorner: CGFloat = 12
    static let savedTileWidth: CGFloat = 118
    static let newTileWidth: CGFloat = 72
    static let tileHeight: CGFloat = 70
    static let rowSpacing: CGFloat = 16
}

struct ShippingAddressForm: View {
    @ObservedObject var vm: CheckoutViewModel
    @ObservedObject var profile = UserProfileManager.shared

    private var isNewAddressMode: Bool { vm.selectedAddressId == nil }

    var body: some View {
        VStack(alignment: .leading, spacing: CheckoutAddressUI.rowSpacing) {
            Text("Shipping Address")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AddrDark.title)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    newAddressTile
                    ForEach(profile.user.addressHistory) { addr in
                        savedAddressTile(addr)
                    }
                }
                .padding(.vertical, 2)
            }

            addressFields
        }
        .onAppear {
            if vm.selectedAddressId == nil, let first = profile.user.addressHistory.first {
                vm.applyAddress(first)
            }
        }
    }

    private var newAddressTile: some View {
        Button { vm.clearForNewAddress() } label: {
            VStack(spacing: 4) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isNewAddressMode ? AddrDark.accent : AddrDark.body)
                Text("New")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(isNewAddressMode ? AddrDark.accent : AddrDark.body)
            }
            .frame(width: CheckoutAddressUI.newTileWidth, height: CheckoutAddressUI.tileHeight)
            .background(isNewAddressMode ? AddrDark.tileSelected : AddrDark.card)
            .clipShape(RoundedRectangle(cornerRadius: CheckoutAddressUI.tileCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CheckoutAddressUI.tileCorner, style: .continuous)
                    .stroke(isNewAddressMode ? AddrDark.accent : AddrDark.border, lineWidth: isNewAddressMode ? 2.5 : 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("New address")
    }

    private func savedAddressTile(_ addr: Address) -> some View {
        let selected = vm.selectedAddressId == addr.id
        return Button { vm.applyAddress(addr) } label: {
            VStack(alignment: .leading, spacing: 3) {
                Text(addr.tileNameLine)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(AddrDark.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Text(addr.tileCityLine)
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundStyle(AddrDark.body)
                    .lineLimit(1)
            }
            .frame(width: CheckoutAddressUI.savedTileWidth, height: CheckoutAddressUI.tileHeight, alignment: .leading)
            .padding(.horizontal, 10)
            .background(selected ? AddrDark.tileSelected : AddrDark.card)
            .clipShape(RoundedRectangle(cornerRadius: CheckoutAddressUI.tileCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CheckoutAddressUI.tileCorner, style: .continuous)
                    .stroke(selected ? AddrDark.accent : AddrDark.border, lineWidth: selected ? 2.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var addressFields: some View {
        Group {
            darkField("Street address", text: $vm.streetAddress, keyboard: .default) { vm.selectedAddressId = nil }
            darkField("City", text: $vm.city, keyboard: .default) { vm.selectedAddressId = nil }
                .autocapitalization(.words)
            HStack(spacing: 12) {
                statePickerField
                VStack(alignment: .leading, spacing: 6) {
                    Text("ZIP / Postal code")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(AddrDark.body)
                    TextField("", text: $vm.zipCode)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(AddrDark.input)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(AddrDark.border))
                        .foregroundStyle(AddrDark.title)
                        .tint(AddrDark.accent)
                        .onChange(of: vm.zipCode) { _, _ in vm.selectedAddressId = nil }
                }
                .frame(width: 120)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Country")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(AddrDark.body)
                Picker("Country", selection: $vm.countryRaw) {
                    ForEach(CheckoutCountry.allCases, id: \.rawValue) { c in
                        Text(c.rawValue).tag(c.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .tint(AddrDark.accent)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(AddrDark.input)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var statePickerField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("State")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(AddrDark.body)
            Menu {
                ForEach(Array(CheckoutUSStates.list.enumerated()), id: \.offset) { index, state in
                    Button(state.name) { vm.selectedStateIndex = index }
                }
            } label: {
                HStack {
                    Text(CheckoutUSStates.list[vm.selectedStateIndex].name)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundStyle(CheckoutUSStates.list[vm.selectedStateIndex].abbr.isEmpty ? AddrDark.body : AddrDark.title)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(AddrDark.body)
                }
                .padding(12)
                .background(AddrDark.input)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(AddrDark.border))
            }
            .buttonStyle(.plain)
            .onChange(of: vm.selectedStateIndex) { _, _ in vm.selectedAddressId = nil }
        }
        .frame(maxWidth: .infinity)
    }

    private func darkField(_ label: String, text: Binding<String>, keyboard: UIKeyboardType, onEdit: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(AddrDark.body)
            TextField("", text: text)
                .keyboardType(keyboard)
                .padding(12)
                .background(AddrDark.input)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(AddrDark.border))
                .foregroundStyle(AddrDark.title)
                .tint(AddrDark.accent)
                .onChange(of: text.wrappedValue) { _, _ in onEdit() }
        }
    }
}
