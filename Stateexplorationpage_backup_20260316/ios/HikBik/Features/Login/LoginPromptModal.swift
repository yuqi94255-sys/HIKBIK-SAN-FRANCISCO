// MARK: - Login prompt when guest tries to use Record Trek (or other gated actions)
import SwiftUI

private let promptNeonGreen = Color(hex: "3FFD98")

struct LoginPromptModal: View {
    var title: String = "Sign in to record treks"
    var message: String = "Create an account or sign in to record live tracks and save your routes."
    var onSignIn: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 48))
                .foregroundStyle(promptNeonGreen)

            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button(action: {
                    onSignIn()
                }) {
                    Text("Sign In")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(promptNeonGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

                Button(action: onDismiss) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 8)
        }
        .padding(28)
        .background(Color(hex: "161C2C"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(promptNeonGreen.opacity(0.4), lineWidth: 1)
        )
        .padding(32)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.6)
        LoginPromptModal(onSignIn: {}, onDismiss: {})
    }
}
