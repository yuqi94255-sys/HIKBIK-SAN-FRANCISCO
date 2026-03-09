import SwiftUI

@main
struct HikBikApp: App {
    @State private var hasEnteredApp = false
    @StateObject private var userState = UserState()

    var body: some Scene {
        WindowGroup {
            if hasEnteredApp {
                ContentView()
                    .environmentObject(userState)
                    .fullScreenCover(isPresented: $userState.showLandingFromApp) {
                        LandingView(
                            onContinueAsGuest: {
                                userState.userStatus = .guest
                                userState.showLandingFromApp = false
                            },
                            onLoginSuccess: {
                                userState.userStatus = .registered
                                userState.showLandingFromApp = false
                            }
                        )
                    }
            } else {
                LandingView(
                    onContinueAsGuest: {
                        userState.userStatus = .guest
                        hasEnteredApp = true
                    },
                    onLoginSuccess: {
                        userState.userStatus = .registered
                        hasEnteredApp = true
                    }
                )
            }
        }
    }
}
