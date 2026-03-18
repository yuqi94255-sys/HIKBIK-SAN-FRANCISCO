// MARK: - Checkout 表單校驗、下單、成功後同步 UserProfile
import Foundation
import SwiftUI
import Combine
import UIKit

struct CheckoutSuccessContext {
    let productNames: [String]
    let isBuyMode: Bool
    let subtotal: Int
    let discount: Int
    let tax: Int
    /// 租賃押金（會退還）
    let refundableDeposit: Int
    var total: Int { max(0, subtotal - discount + tax + refundableDeposit) }
}

@MainActor
final class CheckoutViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var selectedPhoneCodeIndex = 0
    @Published var phoneNumber = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var selectedStateIndex = 0
    @Published var zipCode = ""
    @Published var countryRaw = CheckoutCountry.unitedStates.rawValue

    @Published var paymentMethod: PaymentMethod = .creditCard
    @Published var cardNumber = ""
    @Published var expiryDate = ""
    @Published var cvv = ""

    /// 當前選中的歷史地址 id；nil 表示「新增地址」或未選歷史
    @Published var selectedAddressId: String?
    @Published var isSubmitting = false
    @Published var showSuccess = false
    /// 成功頁用：下單前快照（清空購物車前寫入）
    @Published var successContext: CheckoutSuccessContext?

    @Published var promoSectionExpanded = false
    @Published var promoCodeInput = ""
    /// 預留：匹配簡單碼時減免（0 表示未啟用活動）
    @Published private(set) var appliedPromoDiscount: Int = 0

    // MARK: - 租賃專用（僅 Rent 路徑使用）
    /// 租期開始（可從購物車第一項帶入）
    @Published var rentalStartDate = Date()
    /// 租期結束
    @Published var rentalEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    /// 是否預約上門取件（開啟時加收取件費、取件地址默認送貨地址）
    @Published var schedulePickupService = false
    /// 上門取件費（美元）
    static let pickupServiceFee: Int = 15
    /// 押金（美元），歸還後退還
    static let securityDeposit: Int = 50

    private var cancellables = Set<AnyCancellable>()

    init() {
        let pub = Publishers.MergeMany(
            $firstName.map { _ in () }.eraseToAnyPublisher(),
            $lastName.map { _ in () }.eraseToAnyPublisher(),
            $email.map { _ in () }.eraseToAnyPublisher(),
            $phoneNumber.map { _ in () }.eraseToAnyPublisher(),
            $streetAddress.map { _ in () }.eraseToAnyPublisher(),
            $city.map { _ in () }.eraseToAnyPublisher(),
            $zipCode.map { _ in () }.eraseToAnyPublisher(),
            $paymentMethod.map { _ in () }.eraseToAnyPublisher(),
            $cardNumber.map { _ in () }.eraseToAnyPublisher(),
            $expiryDate.map { _ in () }.eraseToAnyPublisher(),
            $cvv.map { _ in () }.eraseToAnyPublisher(),
            $selectedAddressId.map { _ in () }.eraseToAnyPublisher()
        )
        pub.sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    /// Rent 路徑：從購物車帶入租期（最早開始、最晚結束）
    func bindRentalPeriodFromCart(_ cartStore: CartStore) {
        guard let first = cartStore.items.first else { return }
        let calendar = Calendar.current
        var start = first.startDate
        var end = calendar.date(byAdding: .day, value: first.rentalDays, to: first.startDate) ?? first.startDate
        for item in cartStore.items.dropFirst() {
            if item.startDate < start { start = item.startDate }
            let itemEnd = calendar.date(byAdding: .day, value: item.rentalDays, to: item.startDate) ?? item.startDate
            if itemEnd > end { end = itemEnd }
        }
        rentalStartDate = start
        rentalEndDate = end
    }

    /// 進入頁面：默認選中歷史第一條（最新）並填滿表單
    func loadSavedProfileIfNeeded() {
        let history = UserProfileManager.shared.user.addressHistory
        if let first = history.first {
            applyAddress(first)
            selectedAddressId = first.id
        } else {
            selectedAddressId = nil
        }
        if let pm = UserProfileManager.shared.user.defaultPaymentMethod {
            switch pm.kindRaw {
            case "applePay": paymentMethod = .applePay
            case "payPal": paymentMethod = .payPal
            default: paymentMethod = .creditCard
            }
        }
    }

    /// 選中歷史名片：表單 + State Picker 與該條目完全一致
    func applyAddress(_ a: Address) {
        firstName = a.firstName
        lastName = a.lastName
        email = a.email
        selectedPhoneCodeIndex = min(a.phoneCountryCodeIndex, 20)
        phoneNumber = a.phoneNumber
        streetAddress = a.streetAddress
        city = a.city
        selectedStateIndex = CheckoutUSStates.index(forAbbr: a.stateAbbr)
        zipCode = a.zipCode
        countryRaw = a.countryRaw
        selectedAddressId = a.id
        objectWillChange.send()
    }

    /// ＋ New：取消所有歷史選中，清空表單重新輸入
    func clearForNewAddress() {
        selectedAddressId = nil
        firstName = ""
        lastName = ""
        email = ""
        selectedPhoneCodeIndex = 0
        phoneNumber = ""
        streetAddress = ""
        city = ""
        selectedStateIndex = 0
        zipCode = ""
        countryRaw = CheckoutCountry.unitedStates.rawValue
        objectWillChange.send()
    }

    func currentAddressForOrder() -> Address {
        Address.fromForm(
            firstName: firstName, lastName: lastName, email: email,
            phoneCountryCodeIndex: selectedPhoneCodeIndex, phoneNumber: phoneNumber,
            streetAddress: streetAddress, city: city,
            stateAbbr: CheckoutUSStates.list[selectedStateIndex].abbr,
            zipCode: zipCode, countryRaw: countryRaw
        )
    }

    func validateForm() -> Bool {
        let stateAbbr = CheckoutUSStates.list[selectedStateIndex].abbr
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty,
              email.contains("@"),
              phoneNumber.count >= 7,
              !streetAddress.trimmingCharacters(in: .whitespaces).isEmpty,
              !city.trimmingCharacters(in: .whitespaces).isEmpty,
              !stateAbbr.isEmpty,
              zipCode.count >= 4 else { return false }

        switch paymentMethod {
        case .creditCard:
            let digits = cardNumber.filter(\.isNumber)
            guard digits.count >= 15, digits.count <= 19,
                  expiryDate.replacingOccurrences(of: "/", with: "").count >= 4,
                  cvv.count >= 3 else { return false }
        case .applePay, .payPal:
            break
        }
        return true
    }

    /// 試算優惠（預留；示例碼 WELCOME10 / HIKBIK10 減 $10，不超過小計）
    func applyPromo(subtotal: Int) {
        let code = promoCodeInput.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if code == "WELCOME10" || code == "HIKBIK10" {
            appliedPromoDiscount = min(10, max(0, subtotal))
        } else {
            appliedPromoDiscount = 0
        }
    }

    func completeOrder(mode: CheckoutMode, cartStore: CartStore) async {
        guard validateForm() else { return }
        isSubmitting = true
        var subtotal = mode == .rent ? cartStore.rentalTotalPrice : cartStore.purchaseTotalPrice
        if mode == .rent && schedulePickupService {
            subtotal += Self.pickupServiceFee
        }
        applyPromo(subtotal: subtotal)
        let discount = appliedPromoDiscount
        let tax = 0
        let names: [String] = mode == .rent
            ? cartStore.items.map(\.product.name)
            : cartStore.purchaseItems.map(\.product.name)

        try? await Task.sleep(nanoseconds: 900_000_000)
        let address = currentAddressForOrder()
        let payment: StoredPaymentMethod
        switch paymentMethod {
        case .creditCard:
            let digits = String(cardNumber.filter(\.isNumber).suffix(4))
            payment = .creditCard(lastFour: digits.isEmpty ? "0000" : digits)
        case .applePay:
            payment = .applePay
        case .payPal:
            payment = .payPal
        }
        UserProfileManager.shared.updateProfileAfterSuccessfulOrder(address: address, payment: payment)
        Task { try? await UserAddressService.shared.syncAddress(address) }
        let deposit = mode == .rent ? Self.securityDeposit : 0
        successContext = CheckoutSuccessContext(
            productNames: names,
            isBuyMode: mode == .buy,
            subtotal: subtotal,
            discount: discount,
            tax: tax,
            refundableDeposit: deposit
        )
        if mode == .rent { cartStore.removeAllRentals() } else { cartStore.removeAllPurchases() }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        isSubmitting = false
        showSuccess = true
    }
}
