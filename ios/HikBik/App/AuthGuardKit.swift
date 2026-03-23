// MARK: - Auth Guard — Guest vs Member 統一攔截（半屏提示 + PrimitiveButtonStyle）
import SwiftUI

// MARK: - Copy (English; adjust product-wide as needed)

enum AuthGuardMessages {
    /// Route detail: start navigation
    static let startNavigation = "Sign in to start navigation, log your trips, and sync your tracks."
    /// Export / share (incl. GPX)
    static let exportRoute = "Sign in to export or share your route and tracks (including GPX)."
    /// Community publish
    static let publishPost = "Sign in to post updates, upload routes, and share with the community."
    /// Travel booking (hotels / flights / rental)
    static let travelBooking = "Sign in for exclusive booking perks and trip management."
    /// Park reservations
    static let parkReservation = "Sign in to book timed entry, permits, and manage your visits."
    /// Default
    static let generic = "Sign in to unlock the full experience and cloud sync."
    /// Follow author
    static let followUser = "登錄後即可關注你喜愛的冒險家，獲取最新動態。"
    /// Like post / heart
    static let likePost = "覺得這條動態很棒？登錄後即可點讚支持！"
    /// Save / bookmark route or post
    static let collectRoute = "想要收藏這條路線？登錄後即可永久保存。"
}

// MARK: - 全局半屏提示狀態
// 注意：不可標註整類 @MainActor，否則 AuthGuard / PrimitiveButtonStyle 等非隔离上下文無法同步讀取 `shared` 或調用 `present`。

final class AuthPromptState: ObservableObject {
    static let shared = AuthPromptState()

    @Published var isPresented = false
    @Published var message: String = AuthGuardMessages.generic

    private init() {}

    /// 總在主線程上改動 @Published，避免併發隔離報錯。
    func present(message: String) {
        let apply = {
            self.message = message
            self.isPresented = true
        }
        if Thread.isMainThread { apply() }
        else { DispatchQueue.main.async(execute: apply) }
    }

    func dismiss() {
        let apply = { self.isPresented = false }
        if Thread.isMainThread { apply() }
        else { DispatchQueue.main.async(execute: apply) }
    }
}

// MARK: - 非 Button 場景：一行攔截

enum AuthGuard {
    /// 已登入則執行 action，否則彈出 Auth 半屏
    static func run(message: String = AuthGuardMessages.generic, action: () -> Void) {
        if AuthManager.shared.isLoggedIn {
            action()
        } else {
            AuthPromptState.shared.present(message: message)
        }
    }

    /// async 版本（預留）
    static func run(message: String = AuthGuardMessages.generic, action: () async -> Void) async {
        if AuthManager.shared.isLoggedIn {
            await action()
        } else {
            AuthPromptState.shared.present(message: message)
        }
    }
}

// MARK: - WeWork 風半屏

struct AuthActionSheetView: View {
    let message: String
    var onDismiss: () -> Void
    var onLoginRegister: () -> Void

    private let titleText = "Unlock the full adventure"
    private let accent = Color(hex: "3FFD98")
    private let cardBg = Color(hex: "161C2C")

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.white.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 12) {
                Text(titleText)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(message)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)

            Spacer(minLength: 24)

            VStack(spacing: 12) {
                Button {
                    onDismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        onLoginRegister()
                    }
                } label: {
                    Text("Log in / Sign up")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(accent, in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)

                Button {
                    onDismiss()
                } label: {
                    Text("Maybe later")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.55))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [cardBg, Color(hex: "0B121F")],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Button 修飾：`.requiresAuth(message:)`

/// 使用 PrimitiveButtonStyle 攔截 `configuration.trigger()`，保留原 label 外觀
struct RequiresAuthPrimitiveStyle: PrimitiveButtonStyle {
    var message: String

    func makeBody(configuration: Configuration) -> some View {
        SwiftUI.Button(role: configuration.role) {
            if AuthManager.shared.isLoggedIn {
                configuration.trigger()
            } else {
                AuthPromptState.shared.present(message: message)
            }
        } label: {
            configuration.label
        }
    }
}

extension Button {
    /// 僅在未再鏈式 `.buttonStyle(...)` 時可用（否則類型已非 `Button`，請改在 action 內使用 `AuthGuard.run`）。
    /// 社區 Follow / Like / Save 等多數已用 `AuthGuard.run`，避免先 `.buttonStyle(.plain)` 再掛修飾符失敗。
    /// 範例：`Button("发布") { publish() }.requiresAuth(message: AuthGuardMessages.publishPost)`
    func requiresAuth(message: String) -> some View {
        self.buttonStyle(RequiresAuthPrimitiveStyle(message: message))
    }
}
