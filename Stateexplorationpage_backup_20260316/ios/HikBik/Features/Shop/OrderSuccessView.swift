// MARK: - 訂單成功（深色 + 解鎖動效）
import SwiftUI

private enum SuccessDark {
    static let bg = Color.deepSpaceBackground
    static let title = Color.white
    static let body = Color.white.opacity(0.72)
    static let accent = Color.shopNeonGreen
    static let track = Color.white.opacity(0.15)
}

struct OrderSuccessView: View {
    var context: CheckoutSuccessContext?
    var onDone: () -> Void

    @State private var unlockProgress: CGFloat = 0
    @State private var unlockPhaseDone = false

    private var primaryName: String {
        context?.productNames.first ?? "your journey"
    }

    var body: some View {
        VStack(spacing: 20) {
            if !unlockPhaseDone {
                Image(systemName: "lock.open.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(SuccessDark.accent)
                Text("Syncing to your account…")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(SuccessDark.title)
                Text("Unlocking journey access")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(SuccessDark.body)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6).fill(SuccessDark.track)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(SuccessDark.accent)
                            .frame(width: max(8, geo.size.width * unlockProgress))
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, 40)
                Text("Securing maps, waypoints & future updates")
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundStyle(SuccessDark.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(SuccessDark.accent)
                    .symbolRenderingMode(.hierarchical)
                Text("You’re all set")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(SuccessDark.title)
                if context?.isBuyMode == true {
                    (
                        Text("You now have permanent access to ") +
                        Text(primaryName).fontWeight(.semibold).foregroundStyle(SuccessDark.accent) +
                        Text(" including future updates.")
                    )
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(SuccessDark.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                } else {
                    Text("Rental confirmed. Enjoy your trip!")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(SuccessDark.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }
                Button(action: onDone) {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(SuccessDark.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 32)
                .padding(.top, 12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SuccessDark.bg.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onAppear {
            unlockProgress = 0
            withAnimation(.easeInOut(duration: 1.35)) { unlockProgress = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.45) {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                    unlockPhaseDone = true
                }
            }
        }
    }
}
