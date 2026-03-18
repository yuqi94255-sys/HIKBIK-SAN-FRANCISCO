// MARK: - Global user state (registered vs guest); no backend yet
import SwiftUI

enum UserStatus: String, Codable {
    case registered
    case guest
}

final class UserState: ObservableObject {
    @Published var userStatus: UserStatus {
        didSet {
            UserDefaults.standard.set(userStatus.rawValue, forKey: "hikbik_user_status")
        }
    }

    /// When true, app presents Landing (e.g. from "Sign In" in Login Prompt) to register/log in
    @Published var showLandingFromApp = false

    init() {
        let raw = UserDefaults.standard.string(forKey: "hikbik_user_status") ?? UserStatus.guest.rawValue
        self.userStatus = UserStatus(rawValue: raw) ?? .guest
    }

    var isGuest: Bool { userStatus == .guest }
    var isRegistered: Bool { userStatus == .registered }
}
