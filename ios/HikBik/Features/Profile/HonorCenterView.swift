// Honor Center (Hall of Fame) – dark #121212, categorized badges, 3D flip, Share Trophy
import SwiftUI
import MapKit
import CoreLocation

fileprivate enum HonorTheme {
    static let background = Color(hex: "121212")
    static let cardBg = Color(hex: "1E1E1E")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "8E8E93")
    static let neonGreen = Color(hex: "39FF14")
    static let gold = Color(hex: "FFD700")
    static let silver = Color(hex: "C0C0C0")
    static let bronze = Color(hex: "CD7F32")
}

struct HonorCenterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var grouped: [(section: String, achievements: [Achievement])] = []
    @State private var selectedAchievement: Achievement? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ForEach(Array(grouped.enumerated()), id: \.offset) { _, pair in
                    sectionView(title: pair.section, achievements: pair.achievements)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(HonorTheme.background)
        .navigationTitle("Honor Center")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Back") { dismiss() }
                    .foregroundStyle(HonorTheme.textMuted)
            }
        }
        .toolbarBackground(HonorTheme.background, for: .navigationBar)
        .onAppear { grouped = AchievementStore.achievementsByCategory() }
        .fullScreenCover(item: $selectedAchievement) { achievement in
            HonorBadgeFlipModal(achievement: achievement) {
                selectedAchievement = nil
            }
        }
        .preferredColorScheme(.dark)
    }

    private func sectionView(title: String, achievements: [Achievement]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(HonorTheme.textMuted)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 16)], spacing: 16) {
                ForEach(achievements) { achievement in
                    HonorBadgeCell(achievement: achievement) {
                        selectedAchievement = achievement
                    }
                }
            }
        }
    }
}

// MARK: - Badge cell: circular, metallic (Gold/Silver/Bronze) + neon green when unlocked; etched 0.2 when locked
struct HonorBadgeCell: View {
    let achievement: Achievement
    var onTap: () -> Void

    private var tierColor: Color {
        if !achievement.isUnlocked { return HonorTheme.textMuted }
        if achievement.id.hasPrefix("milestone_500") { return HonorTheme.gold }
        if achievement.id.hasPrefix("milestone_100") { return HonorTheme.silver }
        if achievement.id.hasPrefix("milestone_50") || achievement.id.hasPrefix("milestone_10") { return HonorTheme.bronze }
        return HonorTheme.neonGreen
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    if achievement.isUnlocked {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [tierColor.opacity(0.9), tierColor.opacity(0.4), tierColor.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 72, height: 72)
                        Circle()
                            .strokeBorder(HonorTheme.neonGreen.opacity(0.6), lineWidth: 2)
                            .frame(width: 72, height: 72)
                    } else {
                        Circle()
                            .strokeBorder(HonorTheme.textMuted.opacity(0.2), lineWidth: 2)
                            .frame(width: 72, height: 72)
                    }
                    Image(systemName: achievement.iconAssetName)
                        .font(.system(size: 28))
                        .foregroundStyle(achievement.isUnlocked ? HonorTheme.background : HonorTheme.textMuted.opacity(0.5))
                }
                Text(achievement.title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(HonorTheme.textMuted)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 3D flip modal: front = badge icon, back = stats (Unlocked on Jan 12 at Yosemite)
struct HonorBadgeFlipModal: View {
    let achievement: Achievement
    let onDismiss: () -> Void
    @State private var isFlipped = false

    var body: some View {
        ZStack {
            HonorTheme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    frontCard
                    backCard
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .onTapGesture { withAnimation(.easeInOut(duration: 0.35)) { isFlipped.toggle() } }

                Text("Tap badge to flip")
                    .font(.system(size: 12))
                    .foregroundStyle(HonorTheme.textMuted)

                Button {
                    shareTrophyImage()
                    onDismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Trophy")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(HonorTheme.neonGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(HonorTheme.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

                Button("Done") { onDismiss() }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(HonorTheme.textMuted)
            }
            .padding(24)
        }
        .preferredColorScheme(.dark)
    }

    private var frontCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [HonorTheme.neonGreen.opacity(0.3), HonorTheme.cardBg],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 160, height: 160)
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(HonorTheme.neonGreen.opacity(0.6), lineWidth: 2)
                .frame(width: 160, height: 160)
            Image(systemName: achievement.iconAssetName)
                .font(.system(size: 64))
                .foregroundStyle(HonorTheme.neonGreen)
        }
        .opacity(isFlipped ? 0 : 1)
    }

    private var backCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(HonorTheme.cardBg)
                .frame(width: 160, height: 160)
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(HonorTheme.textMuted.opacity(0.3), lineWidth: 1)
                .frame(width: 160, height: 160)
            VStack(spacing: 8) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(HonorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                if achievement.isUnlocked, let date = achievement.unlockedDate {
                    Text("Unlocked on \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 11))
                        .foregroundStyle(HonorTheme.textMuted)
                    if let loc = achievement.unlockedLocationName {
                        Text("at \(loc)")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(HonorTheme.neonGreen)
                    }
                } else {
                    Text("Locked")
                        .font(.system(size: 11))
                        .foregroundStyle(HonorTheme.textMuted)
                }
            }
            .padding(12)
        }
        .opacity(isFlipped ? 1 : 0)
    }

    private func shareTrophyImage() {
        let storyImage = renderStoryImage()
        guard let img = storyImage else { return }
        let text = "I earned \"\(achievement.title)\" on HikBik! \(achievement.unlockedLocationName.map { "at \($0)." } ?? "")"
        let items: [Any] = [img, text]
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else { return }
        var top = root
        while let presented = top.presentedViewController { top = presented }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        top.present(vc, animated: true)
    }

    private func renderStoryImage() -> UIImage? {
        let mapImage = renderRouteMapSnapshot()
        let badgeImage = renderBadgeSnapshot()
        let size = CGSize(width: 1080, height: 1920)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            UIColor(red: 0x12/255, green: 0x12/255, blue: 0x12/255, alpha: 1).setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            if let map = mapImage {
                map.draw(in: CGRect(origin: .zero, size: size))
            }
            if let badge = badgeImage {
                badge.draw(in: CGRect(x: 340, y: 760, width: 400, height: 400))
            }
        }
    }

    private func renderRouteMapSnapshot() -> UIImage? {
        let drafts = UnifiedDraftStore.loadAll()
        let poly: [CLLocationCoordinate2D]? = {
            guard let draft = drafts.first(where: { $0.source == .liveRecorded || $0.source == .imported }) else { return nil }
            let p = draft.polyline2D ?? draft.coordinate2DPoints
            return p.count >= 2 ? p : nil
        }()
        guard let poly = poly else { return nil }
        let options = MKMapSnapshotter.Options()
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: poly.map(\.latitude).reduce(0, +) / Double(poly.count),
                longitude: poly.map(\.longitude).reduce(0, +) / Double(poly.count)
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        options.region = region
        options.size = CGSize(width: 1080, height: 1920)
        options.scale = UIScreen.main.scale
        let snapshotter = MKMapSnapshotter(options: options)
        var result: UIImage?
        let sem = DispatchSemaphore(value: 0)
        snapshotter.start { snapshot, _ in
            result = snapshot?.image
            sem.signal()
        }
        sem.wait()
        return result
    }

    private func renderBadgeSnapshot() -> UIImage? {
        let view = ZStack {
            HonorTheme.background
            Image(systemName: achievement.iconAssetName)
                .font(.system(size: 120))
                .foregroundStyle(HonorTheme.neonGreen)
        }
        .frame(width: 400, height: 400)
        return ImageRenderer(content: view).uiImage
    }
}
