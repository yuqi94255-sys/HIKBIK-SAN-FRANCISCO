// MARK: - Checkout 用戶檔案：歷史收貨地址 + 默認支付方式（美團式多地址 + 去重）
import Foundation
import Combine

/// 單條收貨地址（與結帳表單一致）
struct Address: Codable, Equatable, Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneCountryCodeIndex: Int
    var phoneNumber: String
    var streetAddress: String
    var city: String
    var stateAbbr: String
    var zipCode: String
    var countryRaw: String

    var fullName: String { "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces) }

    /// 磁貼主行：姓名（簡約）
    var tileNameLine: String {
        let n = fullName
        return n.isEmpty ? "Address" : n
    }

    /// 磁貼副行：僅城市（清爽）；無城市時顯示州縮寫
    var tileCityLine: String {
        let c = city.trimmingCharacters(in: .whitespaces)
        return c.isEmpty ? stateAbbr : c
    }

    /// 橫向標籤用：姓名 + 電話前三位… + 城市/州
    var quickPickerLabel: String {
        let digits = phoneNumber.filter(\.isNumber)
        let phoneHint = digits.count >= 3 ? "\(digits.prefix(3))···" : (phoneNumber.isEmpty ? "—" : phoneNumber)
        let place = city.isEmpty ? (CheckoutUSStates.name(forAbbr: stateAbbr) ?? stateAbbr) : city
        let shortPlace = place.count > 6 ? String(place.prefix(6)) + "…" : place
        let given = firstName.isEmpty ? fullName : firstName
        return "\(given), \(phoneHint) \(shortPlace)"
    }

    /// 去重：同一收件 + 同一門牌級地址視為同一條
    func isSameLocation(as other: Address) -> Bool {
        func norm(_ s: String) -> String {
            s.lowercased().filter { !$0.isWhitespace }
        }
        return norm(streetAddress) == norm(other.streetAddress)
            && norm(city) == norm(other.city)
            && stateAbbr == other.stateAbbr
            && norm(zipCode) == norm(other.zipCode)
            && phoneNumber.filter(\.isNumber) == other.phoneNumber.filter(\.isNumber)
    }

    static func fromForm(
        firstName: String, lastName: String, email: String,
        phoneCountryCodeIndex: Int, phoneNumber: String,
        streetAddress: String, city: String, stateAbbr: String,
        zipCode: String, countryRaw: String
    ) -> Address {
        Address(
            id: UUID().uuidString,
            firstName: firstName, lastName: lastName, email: email,
            phoneCountryCodeIndex: phoneCountryCodeIndex, phoneNumber: phoneNumber,
            streetAddress: streetAddress, city: city, stateAbbr: stateAbbr,
            zipCode: zipCode, countryRaw: countryRaw
        )
    }
}

/// 舊版單地址（僅用於遷移）
private struct LegacySavedShippingAddress: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var phoneCountryCodeIndex: Int
    var phoneNumber: String
    var streetAddress: String
    var city: String
    var stateAbbr: String
    var zipCode: String
    var countryRaw: String
}

private struct LegacyProfileV1: Codable {
    var savedShippingAddress: LegacySavedShippingAddress?
    var defaultPaymentMethod: StoredPaymentMethod?
}

struct StoredPaymentMethod: Codable, Equatable {
    var kindRaw: String
    var cardLastFour: String?

    static func creditCard(lastFour: String) -> StoredPaymentMethod {
        StoredPaymentMethod(kindRaw: "creditCard", cardLastFour: lastFour)
    }
    static let applePay = StoredPaymentMethod(kindRaw: "applePay", cardLastFour: nil)
    static let payPal = StoredPaymentMethod(kindRaw: "payPal", cardLastFour: nil)
}

struct CheckoutUserProfile: Codable, Equatable {
    /// 最新在 index 0（與美團一致：最近使用的排最前）
    var addressHistory: [Address]
    var defaultPaymentMethod: StoredPaymentMethod?
}

enum CheckoutUSStates {
    /// 首項為空選項「Select State」，其後為美國 50 州（字母序）+ DC + International / Other
    static let list: [(abbr: String, name: String)] = [
        ("", "Select State"),
        ("AL", "Alabama"), ("AK", "Alaska"), ("AZ", "Arizona"), ("AR", "Arkansas"),
        ("CA", "California"), ("CO", "Colorado"), ("CT", "Connecticut"), ("DE", "Delaware"),
        ("DC", "District of Columbia"), ("FL", "Florida"), ("GA", "Georgia"), ("HI", "Hawaii"),
        ("ID", "Idaho"), ("IL", "Illinois"), ("IN", "Indiana"), ("IA", "Iowa"), ("KS", "Kansas"),
        ("KY", "Kentucky"), ("LA", "Louisiana"), ("ME", "Maine"), ("MD", "Maryland"),
        ("MA", "Massachusetts"), ("MI", "Michigan"), ("MN", "Minnesota"), ("MS", "Mississippi"),
        ("MO", "Missouri"), ("MT", "Montana"), ("NE", "Nebraska"), ("NV", "Nevada"),
        ("NH", "New Hampshire"), ("NJ", "New Jersey"), ("NM", "New Mexico"), ("NY", "New York"),
        ("NC", "North Carolina"), ("ND", "North Dakota"), ("OH", "Ohio"), ("OK", "Oklahoma"),
        ("OR", "Oregon"), ("PA", "Pennsylvania"), ("RI", "Rhode Island"), ("SC", "South Carolina"),
        ("SD", "South Dakota"), ("TN", "Tennessee"), ("TX", "Texas"), ("UT", "Utah"),
        ("VT", "Vermont"), ("VA", "Virginia"), ("WA", "Washington"), ("WV", "West Virginia"),
        ("WI", "Wisconsin"), ("WY", "Wyoming"), ("OTHER", "International / Other")
    ]

    static func index(forAbbr abbr: String) -> Int {
        let u = abbr.uppercased().trimmingCharacters(in: .whitespaces)
        guard !u.isEmpty else { return 0 }
        return list.firstIndex { $0.abbr == u } ?? 0
    }

    static func name(forAbbr abbr: String) -> String? {
        list.first { $0.abbr == abbr }?.name
    }
}

final class UserProfileManager: ObservableObject {
    static let shared = UserProfileManager()

    private let keyV2 = "hikbik.checkoutUserProfile.v2"
    private let keyV1 = "hikbik.checkoutUserProfile.v1"

    @Published private(set) var user: CheckoutUserProfile {
        didSet { save() }
    }

    private init() {
        if let data = UserDefaults.standard.data(forKey: keyV2),
           let decoded = try? JSONDecoder().decode(CheckoutUserProfile.self, from: data) {
            user = decoded
        } else if let data = UserDefaults.standard.data(forKey: keyV1),
                  let legacy = try? JSONDecoder().decode(LegacyProfileV1.self, from: data) {
            var history: [Address] = []
            if let s = legacy.savedShippingAddress {
                history.append(Address(
                    id: UUID().uuidString,
                    firstName: s.firstName, lastName: s.lastName, email: s.email,
                    phoneCountryCodeIndex: s.phoneCountryCodeIndex, phoneNumber: s.phoneNumber,
                    streetAddress: s.streetAddress, city: s.city, stateAbbr: s.stateAbbr,
                    zipCode: s.zipCode, countryRaw: s.countryRaw
                ))
            }
            user = CheckoutUserProfile(addressHistory: history, defaultPaymentMethod: legacy.defaultPaymentMethod)
            save()
        } else {
            user = CheckoutUserProfile(addressHistory: [], defaultPaymentMethod: nil)
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: keyV2)
        }
    }

    /// 結算成功：新地址插到最前，與現有條目去重（同一地址只保留最新一條在最前）
    func appendAddressAfterSuccessfulOrder(_ new: Address) {
        var list = user.addressHistory.filter { !$0.isSameLocation(as: new) }
        list.insert(new, at: 0)
        user.addressHistory = list
    }

    func updatePaymentMethod(_ payment: StoredPaymentMethod) {
        user.defaultPaymentMethod = payment
    }

    func updateProfileAfterSuccessfulOrder(address: Address, payment: StoredPaymentMethod) {
        appendAddressAfterSuccessfulOrder(address)
        user.defaultPaymentMethod = payment
    }
}
