// MARK: - 用戶地址同步：PUT /api/v1/user/address，多端一致
// Checkout 填寫的地址經由此 Service 同步後端，不只在本地

import Foundation

/// PUT /api/v1/user/address 請求體（與 Address 對齊）
struct UserAddressPayload: Codable {
    let id: String?
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

/// 地址同步服務
final class UserAddressService {
    static let shared = UserAddressService()

    /// 是否使用真實 API（false 時僅寫本地，不發請求）
    var useRealAPI: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["HIKBIK_USE_ADDRESS_API"] == "1"
        #else
        return true
        #endif
    }

    private let client = NetworkManager.shared

    private init() {}

    /// 同步單條地址到後端。Checkout 成功或用戶新增/更新地址時調用。
    /// - Parameter address: 當前表單或選中的地址
    func syncAddress(_ address: Address) async throws {
        let payload = UserAddressPayload(
            id: address.id.isEmpty ? nil : address.id,
            firstName: address.firstName,
            lastName: address.lastName,
            email: address.email,
            phoneCountryCodeIndex: address.phoneCountryCodeIndex,
            phoneNumber: address.phoneNumber,
            streetAddress: address.streetAddress,
            city: address.city,
            stateAbbr: address.stateAbbr,
            zipCode: address.zipCode,
            countryRaw: address.countryRaw
        )
        if useRealAPI {
            try await client.put("/api/v1/user/address", body: payload)
        }
        // Mock：不發請求，僅本地已由 UserProfileManager 保存
    }
}
