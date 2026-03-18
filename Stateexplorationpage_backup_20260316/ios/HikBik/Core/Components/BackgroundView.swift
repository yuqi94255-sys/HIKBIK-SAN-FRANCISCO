// MARK: - Immersive full-screen background for Login/Landing (image now; swap for video later)
import SwiftUI

/// Media source for the background. Use `.image` for now; replace with `.video` when ready.
enum LandingBackgroundMedia {
    case image(URL?)
    /// Reserved for future: play a looped full-screen video
    case video(URL)
}

/// Full-screen immersive background: dark-filtered media + gradient (#050A18 → #000000) + bottom 50% dark overlay for readability.
/// Replace `LandingBackgroundMedia.image` with `.video(url)` when you have a video asset.
struct BackgroundView<Content: View>: View {
    private let media: LandingBackgroundMedia
    private let content: () -> Content

    /// 泛型類型不能有 static stored property，用計算屬性代替
    private static var placeholderImageURL: URL? {
        URL(string: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920")
    }

    init(media: LandingBackgroundMedia = .image(Self.placeholderImageURL), @ViewBuilder content: @escaping () -> Content) {
        self.media = media
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 1) Base: image (or future video) with dark filter
                baseLayer
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                // 2) Linear gradient overlay (#050A18 → #000000)
                LinearGradient(
                    colors: [Color(hex: "050A18"), Color(hex: "000000")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // 3) Bottom 50% dark gradient for UI readability
                VStack {
                    Spacer()
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.5)
                }
                .ignoresSafeArea()

                // 4) Foreground content (logo, form, etc.)
                content()
            }
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var baseLayer: some View {
        switch media {
        case .image(let url):
            imageLayer(url: url ?? Self.placeholderImageURL)
        case .video:
            // Placeholder until video view is implemented; fall back to gradient-only
            Color(hex: "050A18")
        }
    }

    private func imageLayer(url: URL?) -> some View {
        Group {
            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color(hex: "050A18")
                    case .empty:
                        Color(hex: "050A18")
                            .overlay(ProgressView().tint(.white))
                    @unknown default:
                        Color(hex: "050A18")
                    }
                }
            } else {
                Color(hex: "050A18")
            }
        }
        .overlay(Color.black.opacity(0.55)) // dark filter
    }
}

// MARK: - Logo title style (HIKBIK: bold, wide, white, neon green glow)
struct HikBikLogoTitle: View {
    var text: String = "HIKBIK"
    var fontSize: CGFloat = 42

    private static let neonGreen = Color(hex: "3FFD98")

    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .bold))
            .tracking(4)
            .foregroundStyle(.white)
            .shadow(color: Self.neonGreen.opacity(0.8), radius: 12, x: 0, y: 0)
            .shadow(color: Self.neonGreen.opacity(0.5), radius: 24, x: 0, y: 0)
    }
}

#Preview("BackgroundView") {
    BackgroundView {
        VStack {
            HikBikLogoTitle()
                .padding(.top, 60)
            Spacer()
        }
    }
}
