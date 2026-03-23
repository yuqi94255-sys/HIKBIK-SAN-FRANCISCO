import SwiftUI

@main
struct HikBikApp: App {
    @StateObject private var authManager = AuthManager.shared
    @State private var hasEnteredApp = false
    @StateObject private var userState = UserState()

    /// 有 Token 或已登入 → 主 Tab；僅無 Token 且未以訪客進入時顯示 Landing。
    private var showMainContent: Bool {
        authManager.isLoggedIn || hasEnteredApp
    }

    /// 已登入時強制關閉 Landing（禁令：不得覆蓋 MainTab）。
    private var shouldPresentLandingCover: Bool {
        userState.showLandingFromApp && !authManager.isLoggedIn
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showMainContent {
                    ContentView()
                        .environmentObject(userState)
                        .fullScreenCover(isPresented: Binding(
                            get: { shouldPresentLandingCover },
                            set: { newValue in
                                if !newValue { userState.showLandingFromApp = false }
                            }
                        )) {
                            LandingView(
                                onContinueAsGuest: {
                                    userState.userStatus = .guest
                                    AuthManager.shared.setLoggedIn(false)
                                    userState.showLandingFromApp = false
                                },
                                onLoginSuccess: {
                                    userState.userStatus = .registered
                                    AuthManager.shared.setLoggedIn(true)
                                    userState.showLandingFromApp = false
                                    Task { await UserProfileViewModel.shared.refreshFromServerIfLoggedIn() }
                                }
                            )
                        }
                } else {
                    LandingView(
                        onContinueAsGuest: {
                            userState.userStatus = .guest
                            AuthManager.shared.setLoggedIn(false)
                            hasEnteredApp = true
                        },
                        onLoginSuccess: {
                            userState.userStatus = .registered
                            AuthManager.shared.setLoggedIn(true)
                            hasEnteredApp = true
                            Task { await UserProfileViewModel.shared.refreshFromServerIfLoggedIn() }
                        }
                    )
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .animation(.spring(), value: showMainContent)
            .environmentObject(authManager)
            .onAppear {
                authManager.syncSessionAtLaunch(userState: userState)
            }
            .onChange(of: authManager.isLoggedIn) { _, loggedIn in
                if loggedIn {
                    userState.userStatus = .registered
                    userState.showLandingFromApp = false
                    Task { await UserProfileViewModel.shared.refreshFromServerIfLoggedIn() }
                }
            }
        }
    }
}
