import SwiftUI

@main
struct HikBikApp: App {
    @StateObject private var authManager = AuthManager.shared
    @State private var hasEnteredApp = false
    @StateObject private var userState = UserState()

    private var showMainContent: Bool {
        authManager.isLoggedIn || hasEnteredApp
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showMainContent {
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
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .animation(.spring(), value: showMainContent)
            .environmentObject(authManager)
        }
    }
}
