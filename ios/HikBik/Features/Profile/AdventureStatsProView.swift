// Adventure Stats Pro – high-end Honor Center: radar, topographic bg, SF Mono, stamps & 3D medals, haptics, share
import SwiftUI
import MapKit
import CoreLocation

fileprivate enum ProTheme {
    static let background = Color(hex: "050A18")
    static let cardBg = Color(hex: "161C2C")
    static let cardBgWithBlur = Color(hex: "161C2C").opacity(0.8)
    static let borderStroke = Color(hex: "2A354F")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "8E8E93")
    static let neonGreen = Color(hex: "3FFD98")
    static let gold = Color(hex: "FFD700")
    static let silver = Color(hex: "C0C0C0")
    static let bronze = Color(hex: "CD7F32")
}

struct AdventureStatsProView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var radarValues: [Double] = [0, 0, 0, 0, 0]
    @State private var selectedStatIndex: Int? = nil  // 0=Distance, 1=Elevation, 2=Wilderness, 3=Frequency, 4=Exploration
    @State private var selectedAchievement: Achievement? = nil
    @State private var parks: [Achievement] = []
    @State private var epicMilestones: [Achievement] = []
    @State private var parksShowAll: Bool = false
    @State private var parksFilterState: String = ""

    var body: some View {
        ZStack {
            ProTheme.background.ignoresSafeArea()
            MovingTopographicPatternView()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    performanceRadarSection
                    parksStampSection
                    trophySection(title: "Epic Milestones", achievements: epicMilestones, style: .medal3D)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .font(.system(size: 15))
        .foregroundStyle(ProTheme.textPrimary)
        .navigationTitle("Adventure Stats Pro")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Back") { dismiss() }
                    .foregroundStyle(ProTheme.textMuted)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    shareProStatusCard()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(ProTheme.neonGreen)
                }
            }
        }
        .toolbarBackground(ProTheme.background, for: .navigationBar)
        .onAppear {
            radarValues = AdventureStatsService.radarValues()
            if parksFilterState.isEmpty {
                let codes = AdventureStatsService.parkStateCodes()
                parksFilterState = codes.first ?? "All"
            }
            refreshParks()
            epicMilestones = AdventureStatsService.epicMilestonesAchievements()
        }
        .onChange(of: parksShowAll) { _, _ in refreshParks() }
        .onChange(of: parksFilterState) { _, _ in refreshParks() }
        .sheet(item: $selectedAchievement) { achievement in
            HonorBadgeFlipModal(achievement: achievement) {
                selectedAchievement = nil
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedStatIndex == 2 },
            set: { if !$0 { selectedStatIndex = nil } }
        )) {
            RemoteRoutesSheet()
        }
        .preferredColorScheme(.dark)
    }

    private var performanceRadarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Performance Radar")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(ProTheme.textMuted)

            RadarChartView(
                values: radarValues,
                labels: AdventureStatsService.radarLabels,
                lineColor: ProTheme.neonGreen,
                fillColor: ProTheme.neonGreen.opacity(0.35),
                axisColor: ProTheme.textMuted.opacity(0.4),
                labelColor: ProTheme.textMuted
            )
            .frame(height: 220)
            .frame(maxWidth: .infinity)

            statValuesRow()
            HStack(spacing: 8) {
                ForEach(Array(AdventureStatsService.radarLabels.enumerated()), id: \.offset) { i, label in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        if i == 2 { selectedStatIndex = 2 }
                    } label: {
                        Text(label)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundStyle(ProTheme.textMuted)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(ProTheme.cardBg)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(ProTheme.cardBgWithBlur)
        .background(.ultraThinMaterial.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func refreshParks() {
        let state: String? = parksShowAll ? nil : (parksFilterState.isEmpty || parksFilterState == "All" ? nil : parksFilterState)
        parks = AdventureStatsService.parksAchievements(filterState: state)
    }

    private var parksStampSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("U.S. National Parks")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(ProTheme.textMuted)
                Spacer()
                if !parksShowAll {
                    Picker("State", selection: $parksFilterState) {
                        Text("All").tag("All")
                        ForEach(AdventureStatsService.parkStateCodes(), id: \.self) { code in
                            Text(code).tag(code)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .tint(ProTheme.neonGreen)
                }
                Button(parksShowAll ? "By State" : "Show All") {
                    withAnimation(.easeInOut(duration: 0.2)) { parksShowAll.toggle() }
                }
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundStyle(ProTheme.neonGreen)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 16)], spacing: 16) {
                ForEach(parks) { achievement in
                    StampBadgeCell(achievement: achievement) {
                        triggerHapticAndSelect(achievement)
                    }
                }
            }
        }
    }

    private func trophySection(title: String, achievements: [Achievement], style: TrophyStyle) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(ProTheme.textMuted)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: style == .stamp ? 72 : 80), spacing: 16)], spacing: 16) {
                ForEach(achievements) { achievement in
                    if style == .stamp {
                        StampBadgeCell(achievement: achievement) {
                            triggerHapticAndSelect(achievement)
                        }
                    } else {
                        Medal3DBadgeCell(achievement: achievement) {
                            triggerHapticAndSelect(achievement)
                        }
                    }
                }
            }
        }
    }

    private func statValuesRow() -> some View {
        let drafts = UnifiedDraftStore.loadAll()
        let recorded = drafts.filter { $0.source == .liveRecorded || $0.source == .imported }
        let miles = AchievementStore.cumulativeMiles
        let elevation = recorded.reduce(0.0) { $0 + $1.elevationGainMeters }
        let gridCount = Set(recorded.flatMap { draft in
            (draft.polyline2D ?? draft.coordinate2DPoints).map { c in
                "\((c.latitude / 0.1).rounded() * 0.1),\((c.longitude / 0.1).rounded() * 0.1)"
            }
        }).count
        let trend = AdventureStatsService.monthlyTrend()
        let showTrend = trend.current > trend.previous && trend.previous >= 0
        return HStack(spacing: 20) {
            statItem("\(String(format: "%.0f", miles)) mi", label: "Distance", showTrend: false)
            statItem("\(Int(elevation)) m", label: "Elev.", showTrend: false)
            statItem("\(Int(min(1, AdventureStatsService.radarValues()[2]) * 100))%", label: "Wild.", showTrend: false)
            statItem("\(trend.current)", label: "Freq.", showTrend: showTrend)
            statItem("\(gridCount)", label: "Explore", showTrend: false)
        }
        .font(.system(size: 12, weight: .bold, design: .monospaced))
        .foregroundStyle(ProTheme.textMuted)
    }

    private func statItem(_ value: String, label: String, showTrend: Bool) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(value)
                    .foregroundStyle(ProTheme.neonGreen)
                if showTrend {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(ProTheme.neonGreen)
                }
            }
            Text(label)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }

    private func triggerHapticAndSelect(_ achievement: Achievement) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        selectedAchievement = achievement
    }

    private func shareProStatusCard() {
        let image = renderProStatusCardImage()
        guard let img = image else { return }
        let text = "My Adventure Stats Pro on HikBik"
        let items: [Any] = [img, text]
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else { return }
        var top = root
        while let presented = top.presentedViewController { top = presented }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        top.present(vc, animated: true)
    }

    private func renderProStatusCardImage() -> UIImage? {
        let values = AdventureStatsService.radarValues()
        let top3 = AdventureStatsService.topThreeBadges()
        let card = ProStatusShareCardView(radarValues: values, topBadges: top3)
            .frame(width: 1080, height: 1920)
        return ImageRenderer(content: card).uiImage
    }
}

// MARK: - Static topographic pattern (dots + lines)
struct TopographicPatternView: View {
    var body: some View {
        Canvas { ctx, size in
            let step: CGFloat = 24
            var y: CGFloat = 0
            while y < size.height + step {
                var x: CGFloat = 0
                while x < size.width + step {
                    ctx.stroke(
                        Path(ellipseIn: CGRect(x: x - 2, y: y - 2, width: 4, height: 4)),
                        with: .color(ProTheme.textMuted.opacity(0.15)),
                        lineWidth: 0.5
                    )
                    x += step
                }
                y += step
            }
            y = 0
            while y < size.height + 40 {
                ctx.stroke(
                    Path { p in
                        p.move(to: CGPoint(x: 0, y: y))
                        p.addLine(to: CGPoint(x: size.width, y: y))
                    },
                    with: .color(ProTheme.textMuted.opacity(0.06)),
                    lineWidth: 0.5
                )
                y += 40
            }
        }
    }
}

// MARK: - Moving topographic lines (Deep Space Blue: very faint white 3% for depth)
fileprivate let topoPatternColor = Color.white.opacity(0.03)
struct MovingTopographicPatternView: View {
    private let lineSpacing: CGFloat = 32
    private let dotStep: CGFloat = 28

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.05, paused: false)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let offset = CGFloat(t.truncatingRemainder(dividingBy: 4)) / 4 * lineSpacing
                var y: CGFloat = -offset
                while y < size.height + lineSpacing {
                    ctx.stroke(
                        Path { p in
                            p.move(to: CGPoint(x: 0, y: y))
                            p.addLine(to: CGPoint(x: size.width, y: y))
                        },
                        with: .color(topoPatternColor),
                        lineWidth: 0.6
                    )
                    y += lineSpacing
                }
                let dx = CGFloat(t.truncatingRemainder(dividingBy: 3)) / 3 * dotStep
                var px: CGFloat = -dx
                while px < size.width + dotStep {
                    var py: CGFloat = 0
                    while py < size.height + dotStep {
                        ctx.stroke(
                            Path(ellipseIn: CGRect(x: px - 1.5, y: py - 1.5, width: 3, height: 3)),
                            with: .color(topoPatternColor),
                            lineWidth: 0.4
                        )
                        py += dotStep
                    }
                    px += dotStep
                }
            }
        }
    }
}

// MARK: - Trophy styles
fileprivate enum TrophyStyle {
    case stamp, medal3D
}

// Stamp style (U.S. National Parks): landmark icon; unlocked = colored embossed 3D stamp, locked = dull grey outline
struct StampBadgeCell: View {
    let achievement: Achievement
    var onTap: () -> Void

    private var landmarkIconName: String {
        let parkId = ParkLandmarkIcons.parkId(fromAchievementId: achievement.id)
        return ParkLandmarkIcons.iconName(forParkId: parkId)
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack {
                    if achievement.isUnlocked {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [ProTheme.neonGreen.opacity(0.4), ProTheme.neonGreen.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 58, height: 58)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(ProTheme.neonGreen.opacity(0.8), lineWidth: 2)
                            )
                            .shadow(color: ProTheme.neonGreen.opacity(0.3), radius: 4, x: 0, y: 2)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.25), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                            .frame(width: 58, height: 58)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Image(systemName: landmarkIconName)
                            .font(.system(size: 24))
                            .foregroundStyle(ProTheme.neonGreen)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(ProTheme.textMuted.opacity(0.25), lineWidth: 2)
                            .frame(width: 58, height: 58)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .frame(width: 58, height: 58)
                        Image(systemName: landmarkIconName)
                            .font(.system(size: 22))
                            .foregroundStyle(ProTheme.textMuted.opacity(0.35))
                    }
                }
                Text(achievement.title)
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundStyle(ProTheme.textMuted)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 64)
            }
        }
        .buttonStyle(.plain)
    }
}

// 3D medal style (Epic Milestones)
struct Medal3DBadgeCell: View {
    let achievement: Achievement
    var onTap: () -> Void

    private var tierColor: Color {
        if !achievement.isUnlocked { return ProTheme.textMuted }
        if achievement.id.hasPrefix("milestone_500") { return ProTheme.gold }
        if achievement.id.hasPrefix("milestone_100") { return ProTheme.silver }
        if achievement.id.hasPrefix("milestone_50") || achievement.id.hasPrefix("milestone_10") { return ProTheme.bronze }
        return ProTheme.neonGreen
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [tierColor.opacity(0.95), tierColor.opacity(0.5), tierColor.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    if achievement.isUnlocked {
                        Circle()
                            .strokeBorder(ProTheme.neonGreen.opacity(0.6), lineWidth: 2)
                            .frame(width: 64, height: 64)
                    } else {
                        Circle()
                            .strokeBorder(ProTheme.textMuted.opacity(0.2), lineWidth: 2)
                            .frame(width: 64, height: 64)
                    }
                    Image(systemName: achievement.iconAssetName)
                        .font(.system(size: 26))
                        .foregroundStyle(achievement.isUnlocked ? ProTheme.background : ProTheme.textMuted.opacity(0.5))
                }
                Text(achievement.title)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(ProTheme.textMuted)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 76)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Wilderness drill-down: most remote routes
struct RemoteRoutesSheet: View {
    @Environment(\.dismiss) private var dismiss
    private let routes = AdventureStatsService.remoteRoutes()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Routes sorted by elevation gain (most remote first).")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundStyle(ProTheme.textMuted)
                }
                ForEach(routes) { draft in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(draft.title)
                                .font(.system(size: 15, weight: .medium, design: .monospaced))
                            Text("\(Int(draft.elevationGainMeters)) m gain · \(formatDistance(draft.totalDistanceMeters))")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundStyle(ProTheme.textMuted)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .background(ProTheme.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("Wilderness Routes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(ProTheme.neonGreen)
                }
            }
            .toolbarBackground(ProTheme.background, for: .navigationBar)
        }
        .presentationDetents([.medium, .large])
    }

    private func formatDistance(_ meters: Double) -> String {
        let mi = meters / 1609.34
        if mi >= 1 { return String(format: "%.1f mi", mi) }
        return String(format: "%.0f m", meters)
    }
}

// MARK: - Pro Status share card (radar + top 3 badges)
struct ProStatusShareCardView: View {
    let radarValues: [Double]
    let topBadges: [Achievement]

    var body: some View {
        ZStack {
            ProTheme.background.ignoresSafeArea()
            VStack(spacing: 32) {
                Text("ADVENTURE STATS PRO")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundStyle(ProTheme.neonGreen)
                RadarChartView(
                    values: radarValues,
                    labels: AdventureStatsService.radarLabels,
                    lineColor: ProTheme.neonGreen,
                    fillColor: ProTheme.neonGreen.opacity(0.35),
                    axisColor: ProTheme.textMuted.opacity(0.5),
                    labelColor: ProTheme.textMuted
                )
                .frame(width: 320, height: 320)
                HStack(spacing: 24) {
                    ForEach(topBadges.prefix(3)) { a in
                        VStack(spacing: 8) {
                            Image(systemName: a.iconAssetName)
                                .font(.system(size: 44))
                                .foregroundStyle(ProTheme.neonGreen)
                            Text(a.title)
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .foregroundStyle(ProTheme.textPrimary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(width: 100)
                        }
                    }
                }
                Text("HikBik")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(ProTheme.textMuted)
            }
            .padding(48)
        }
    }
}
