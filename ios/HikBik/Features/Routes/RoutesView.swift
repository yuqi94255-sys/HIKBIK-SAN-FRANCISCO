// Route Discovery – Figma design: Trending Now, Pro Guide Routes, National Park National Forest, Family Route
import SwiftUI

// MARK: - Route colors (dark theme, 深海藍 #0B121F)
private enum RouteColors {
    static let background = Color(hex: "0B121F")
    static let cardBg = Color(hex: "2A3540")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "9CA3AF")
    static let accentGreen = Color(hex: "10B981")
    static let accentOrange = Color(hex: "F97316")
    static let accentRed = Color(hex: "EF4444")
    static let accentYellow = Color(hex: "EAB308")
    static let tabInactive = Color(hex: "374151")
    static let freeBadge = Color(hex: "10B981")
    static let proBadge = Color(hex: "F97316")
}

// MARK: - Models
enum RouteCategory: String, CaseIterable {
    case all = "All Routes"
    case aiPlanner = "AI Planner"
    case official = "Official Routes"

    var icon: String {
        switch self {
        case .all: return "mountain.2.fill"
        case .aiPlanner: return "bolt.fill"
        case .official: return "location.north.line.fill"
        }
    }
}

enum RouteTier: String {
    case free = "FREE"
    case pro = "PRO"
}

enum RouteDifficulty: String {
    case easy = "Easy"
    case moderate = "Moderate"
    case hard = "Hard"

    var color: Color {
        switch self {
        case .easy: return RouteColors.accentGreen
        case .moderate: return RouteColors.accentYellow
        case .hard: return RouteColors.accentRed
        }
    }
}

struct RouteItem: Identifiable {
    let id: String
    let title: String
    let location: String
    let imageUrl: String
    let tier: RouteTier
    let rating: Double
    let reviewCount: Int
    let distance: String
    let waterCount: Int?
    let gpsAccuracy: String?
    let difficulty: RouteDifficulty
    let showPreview: Bool
    /// Official Hiking 重點：海拔爬升 (e.g. "2,400 ft")
    let elevation: String?
    /// Official Biking 重點：路面類型 (e.g. "Gravel", "Single-track")
    let surface: String?

    init(id: String, title: String, location: String, imageUrl: String, tier: RouteTier,
         rating: Double, reviewCount: Int, distance: String, waterCount: Int?, gpsAccuracy: String?,
         difficulty: RouteDifficulty, showPreview: Bool, elevation: String? = nil, surface: String? = nil) {
        self.id = id
        self.title = title
        self.location = location
        self.imageUrl = imageUrl
        self.tier = tier
        self.rating = rating
        self.reviewCount = reviewCount
        self.distance = distance
        self.waterCount = waterCount
        self.gpsAccuracy = gpsAccuracy
        self.difficulty = difficulty
        self.showPreview = showPreview
        self.elevation = elevation
        self.surface = surface
    }
}

// MARK: - Mock data
private let trendingRoutes: [RouteItem] = [
    RouteItem(id: "t1", title: "Arizona Desert Explorer", location: "Sonoran Desert, Arizona",
              imageUrl: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800",
              tier: .free, rating: 4.8, reviewCount: 234, distance: "118 mi", waterCount: 8,
              gpsAccuracy: "±5m", difficulty: .moderate, showPreview: true),
    RouteItem(id: "t2", title: "South Rim to North Rim...", location: "Grand Canyon National Park",
              imageUrl: "https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800",
              tier: .pro, rating: 4.9, reviewCount: 567, distance: "23.5 miles", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false),
    RouteItem(id: "t3", title: "Half Dome via Mist Trail", location: "Yosemite National Park",
              imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
              tier: .pro, rating: 4.7, reviewCount: 892, distance: "14.2 miles", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false),
]

private let proGuideRoutes: [RouteItem] = [
    RouteItem(id: "p1", title: "South Rim to North Rim...", location: "Grand Canyon National Park",
              imageUrl: "https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800",
              tier: .pro, rating: 4.9, reviewCount: 567, distance: "23.5 miles", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false),
    RouteItem(id: "p2", title: "Half Dome via Mist Trail", location: "Yosemite National Park",
              imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
              tier: .pro, rating: 4.7, reviewCount: 892, distance: "14.2 miles", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false),
    RouteItem(id: "p3", title: "Rim to Rim Overlook", location: "Red Rock Canyon",
              imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
              tier: .pro, rating: 4.6, reviewCount: 421, distance: "18 miles", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false),
]

private let nationalParkForestRoutes: [RouteItem] = [
    RouteItem(id: "np1", title: "Sequoia General Sherman Trail", location: "Sequoia National Park",
              imageUrl: "https://images.unsplash.com/photo-1448375240586-882707db888b?w=800",
              tier: .free, rating: 4.8, reviewCount: 312, distance: "2 miles", waterCount: 3,
              gpsAccuracy: "±3m", difficulty: .easy, showPreview: false),
    RouteItem(id: "np2", title: "Olympic Hoh Rainforest Loop", location: "Olympic National Forest",
              imageUrl: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
              tier: .free, rating: 4.9, reviewCount: 201, distance: "8 miles", waterCount: 6,
              gpsAccuracy: "±5m", difficulty: .moderate, showPreview: false),
    RouteItem(id: "np3", title: "Glacier Going-to-the-Sun", location: "Glacier National Park",
              imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800",
              tier: .pro, rating: 4.9, reviewCount: 567, distance: "52 miles", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false),
]

private let familyRoutes: [RouteItem] = [
    RouteItem(id: "f1", title: "Family Camping Adventure", location: "Sequoia National Forest",
              imageUrl: "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800",
              tier: .free, rating: 4.6, reviewCount: 145, distance: "8 miles", waterCount: 5,
              gpsAccuracy: "±8m", difficulty: .easy, showPreview: false),
    RouteItem(id: "f2", title: "Arizona Desert Explorer", location: "Sonoran Desert, Arizona",
              imageUrl: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800",
              tier: .free, rating: 4.8, reviewCount: 234, distance: "118 miles", waterCount: 8,
              gpsAccuracy: "±5m", difficulty: .moderate, showPreview: false),
    RouteItem(id: "f3", title: "Delicate Arch Trail", location: "Arches National Park",
              imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
              tier: .free, rating: 4.9, reviewCount: 634, distance: "3 miles", waterCount: 1,
              gpsAccuracy: "±3m", difficulty: .moderate, showPreview: false),
]

private let officialHikingRoutes: [RouteItem] = [
    RouteItem(id: "h1", title: "Half Dome Cable Route", location: "Yosemite National Park",
              imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
              tier: .free, rating: 4.9, reviewCount: 1890, distance: "14.2 mi", waterCount: 4,
              gpsAccuracy: "±2m", difficulty: .hard, showPreview: false, elevation: "4,800 ft"),
    RouteItem(id: "h2", title: "Angels Landing Summit", location: "Zion National Park",
              imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
              tier: .pro, rating: 4.9, reviewCount: 2340, distance: "5.4 mi", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false, elevation: "1,488 ft"),
    RouteItem(id: "h3", title: "Bright Angel to Plateau", location: "Grand Canyon National Park",
              imageUrl: "https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800",
              tier: .free, rating: 4.7, reviewCount: 1456, distance: "9.5 mi", waterCount: 3,
              gpsAccuracy: "±3m", difficulty: .hard, showPreview: false, elevation: "4,400 ft"),
]

private let officialBikingRoutes: [RouteItem] = [
    RouteItem(id: "b1", title: "Mammoth Lakes Bike Path", location: "Inyo National Forest",
              imageUrl: "https://images.unsplash.com/photo-1571333250630-f0230c320b6d?w=800",
              tier: .free, rating: 4.8, reviewCount: 567, distance: "12 mi", waterCount: 2,
              gpsAccuracy: "±5m", difficulty: .easy, showPreview: false, surface: "Paved"),
    RouteItem(id: "b2", title: "Slickrock Trail Loop", location: "Moab", imageUrl: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800",
              tier: .pro, rating: 4.9, reviewCount: 890, distance: "10.6 mi", waterCount: nil,
              gpsAccuracy: nil, difficulty: .hard, showPreview: false, surface: "Sandstone"),
    RouteItem(id: "b3", title: "Kokopelli Trail", location: "Colorado Plateau",
              imageUrl: "https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800",
              tier: .free, rating: 4.6, reviewCount: 421, distance: "142 mi", waterCount: 8,
              gpsAccuracy: "±8m", difficulty: .moderate, showPreview: false, surface: "Gravel"),
]

// MARK: - RoutesView
struct RoutesView: View {
    @State private var activeTab: RouteCategory = .all
    @State private var isLoadingContent = false
    @State private var aiPlannerInput = ""

    var body: some View {
        NavigationStack {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                categoryTabs
                // 局部內容切換（無跳轉）
                contentArea
                    .padding(.horizontal, 20)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            RouteColors.background
                .ignoresSafeArea(edges: .all)
        )
        .navigationBarHidden(true)
        }
    }

    // MARK: - Content area (switch by activeTab)
    @ViewBuilder
    private var contentArea: some View {
        if isLoadingContent {
            skeletonCards
        } else {
            switch activeTab {
            case .all:
                allRoutesContent
            case .aiPlanner:
                aiPlannerContent
            case .official:
                officialRoutesContent
            }
        }
    }

    private var allRoutesContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            officialDetailedTrackSection
            routeSection(title: "Trending Now", icon: "chart.line.uptrend.xyaxis", routes: trendingRoutes)
            routeSection(title: "Pro Guide Routes", icon: "person.badge.shield.checkmark.fill", routes: proGuideRoutes)
            routeSection(title: "National Park National Forest", icon: "leaf.fill", routes: nationalParkForestRoutes)
            routeSection(title: "Family Route", icon: "tent.fill", routes: familyRoutes)
            Spacer(minLength: 80)
        }
        .animation(.easeInOut(duration: 0.25), value: activeTab)
    }

    private var aiPlannerContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("AI Route Planner")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(RouteColors.textPrimary)
                Text("Describe your adventure and we'll suggest the best routes.")
                    .font(.system(size: 15))
                    .foregroundStyle(RouteColors.textMuted)
            }
            .padding(.top, 16)

            TextField("e.g. 3-day hike in Yosemite with lakes", text: $aiPlannerInput)
                .font(.system(size: 16))
                .foregroundStyle(RouteColors.textPrimary)
                .padding(16)
                .background(RouteColors.cardBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button { } label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Generate Routes")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(RouteColors.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(RouteColors.accentGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            Spacer(minLength: 80)
        }
        .animation(.easeInOut(duration: 0.25), value: activeTab)
    }

    private var officialRoutesContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            officialDetailedTrackSection
            routeSection(title: "Official Macro Journeys", icon: "mountain.2.fill", routes: trendingRoutes)
            routeSection(title: "Expert Micro Tracks", icon: "scope", routes: proGuideRoutes)
            routeSection(title: "Family & Beginner", icon: "person.3.fill", routes: familyRoutes)
            routeSection(title: "Official Hiking", icon: "figure.hiking", routes: officialHikingRoutes)
            routeSection(title: "Official Biking", icon: "bicycle", routes: officialBikingRoutes)
            Spacer(minLength: 80)
        }
        .animation(.easeInOut(duration: 0.25), value: activeTab)
    }

    /// 骨架屏：Official 為 5 列 × 4 張，其餘為 1 列 × 4 張
    private var skeletonCards: some View {
        let rows = activeTab == .official ? 5 : 1
        return VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<rows, id: \.self) { _ in
                HStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(RouteColors.tabInactive.opacity(0.6))
                            .frame(width: 160, height: 200)
                    }
                }
            }
            .padding(.vertical, 12)
            Spacer(minLength: 80)
        }
    }

    private var header: some View {
        HStack {
            Text("Route Discovery")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(RouteColors.textPrimary)
            Spacer()
            HStack(spacing: 12) {
                NavigationLink(destination: TripsListView()) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(hex: "F8FAFC"))
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(IconButtonStyle())

                NavigationLink(destination: FavoritesListView()) {
                    Image(systemName: "heart")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(hex: "F8FAFC"))
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(IconButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }

    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(RouteCategory.allCases, id: \.self) { cat in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            activeTab = cat
                            isLoadingContent = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            withAnimation(.easeOut(duration: 0.25)) {
                                isLoadingContent = false
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.icon)
                                .font(.system(size: 14))
                            Text(cat.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(activeTab == cat ? .white : RouteColors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(activeTab == cat ? RouteColors.accentOrange : RouteColors.tabInactive)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }

    /// Official Detailed Track 入口：Half Dome Cables Section，點擊進入 JSON 驅動的綠色戰術詳情頁
    private var officialDetailedTrackSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "location.north.line.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(RouteColors.accentGreen)
                Text("Official Detailed")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(RouteColors.textPrimary)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if let payload = OfficialTrackPayload.yosemiteHalfDome {
                        NavigationLink(destination: OfficialDetailedTrackView(track: .yosemiteCables)) {
                            YosemiteHalfDomeCard(
                                title: payload.header.title,
                                location: payload.header.location,
                                rating: payload.header.rating,
                                reviewsCount: payload.header.reviewsCount,
                                imageURL: payload.heroImageURL
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.trailing, 44)
                .padding(.vertical, 4)
            }
        }
        .padding(.bottom, 12)
    }

    private func routeSection(title: String, subtitle: String? = nil, icon: String, routes: [RouteItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(RouteColors.accentGreen)
                    HStack(spacing: 4) {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(RouteColors.textPrimary)
                        if let sub = subtitle {
                            Text("(\(sub))")
                                .font(.system(size: 14))
                                .foregroundStyle(RouteColors.textMuted)
                        }
                    }
                }
                Spacer()
                Button("View All >") { }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(RouteColors.textPrimary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(routes) { route in
                        Group {
                            if title == "Official Macro Journeys" {
                                NavigationLink(destination: OfficialMacroJourneyView(selectedRoute: .arizonaDesertExplorer)) {
                                    RouteCard(route: route)
                                }
                            } else {
                                NavigationLink(destination: OfficialRouteDetailView(route: route)) {
                                    RouteCard(route: route)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.trailing, 44)
                .padding(.vertical, 4)
            }
        }
        .padding(.bottom, 12)
    }
}

// MARK: - JetBrains Mono 風格（等寬數據字體）
private let monoFont = Font.system(size: 13, weight: .regular, design: .monospaced)
private let monoFontBold = Font.system(size: 14, weight: .bold, design: .monospaced)

// MARK: - Route card
struct RouteCard: View {
    let route: RouteItem
    private let cardWidth: CGFloat = 280
    private let imageHeight: CGFloat = 140

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: route.imageUrl)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    case .failure: Color.gray.opacity(0.3)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .frame(width: cardWidth, height: imageHeight)
                .clipped()

                Text(route.tier.rawValue)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(route.tier == .free ? RouteColors.freeBadge : RouteColors.proBadge)
                    .clipShape(Capsule())
                    .padding(12)

                if route.tier == .pro {
                    ZStack {
                        Color.black.opacity(0.5)
                        Image(systemName: "lock.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(RouteColors.accentOrange)
                    }
                    .frame(width: cardWidth, height: imageHeight)
                }

                if route.showPreview {
                    Text("Preview")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(width: cardWidth, height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(route.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(route.tier == .pro ? RouteColors.accentOrange : RouteColors.accentGreen)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 12))
                        .foregroundStyle(RouteColors.textMuted)
                    Text(route.location)
                        .font(.system(size: 13))
                        .foregroundStyle(RouteColors.textMuted)
                        .lineLimit(1)
                }

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(RouteColors.accentYellow)
                        Text(String(format: "%.1f (%d)", route.rating, route.reviewCount))
                            .font(monoFontBold)
                            .foregroundStyle(RouteColors.textPrimary)
                    }
                    Spacer()
                    Text(route.distance)
                        .font(monoFont)
                        .foregroundStyle(RouteColors.textPrimary)
                }

                // Water & GPS row: FREE shows values, PRO shows lock + PRO
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "3B82F6"))
                        if let w = route.waterCount {
                            Text("Water: \(w)")
                                .font(monoFont)
                                .foregroundStyle(Color(hex: "3B82F6"))
                        } else {
                            HStack(spacing: 4) {
                                Text("Water:")
                                    .foregroundStyle(RouteColors.textPrimary)
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 10))
                                Text("PRO")
                                    .foregroundStyle(RouteColors.accentOrange)
                            }
                            .font(monoFont)
                        }
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(RouteColors.accentGreen)
                        if let g = route.gpsAccuracy {
                            Text("GPS: \(g)")
                                .font(monoFont)
                                .foregroundStyle(RouteColors.accentGreen)
                        } else {
                            HStack(spacing: 4) {
                                Text("GPS:")
                                    .foregroundStyle(RouteColors.textPrimary)
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 10))
                                Text("PRO")
                                    .foregroundStyle(RouteColors.accentOrange)
                            }
                            .font(monoFont)
                        }
                    }
                }

                // Official Hiking: 海拔爬升 Elevation
                if let elev = route.elevation {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12))
                            .foregroundStyle(RouteColors.accentGreen)
                        Text("Elev: \(elev)")
                            .font(monoFont)
                            .foregroundStyle(RouteColors.accentGreen)
                    }
                }

                // Official Biking: 路面類型 Surface
                if let surf = route.surface {
                    HStack(spacing: 4) {
                        Image(systemName: "circle.grid.2x2")
                            .font(.system(size: 12))
                            .foregroundStyle(RouteColors.textMuted)
                        Text("Surface: \(surf)")
                            .font(monoFont)
                            .foregroundStyle(RouteColors.textPrimary)
                    }
                }

                HStack {
                    Text(route.difficulty.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(route.difficulty.color)
                        .clipShape(Capsule())

                    if route.tier == .free && route.showPreview {
                        Spacer()
                        HStack(spacing: 4) {
                            Text("Start Exploring")
                                .font(.system(size: 14, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(RouteColors.textPrimary)
                    }
                }
            }
            .padding(16)
            .frame(width: cardWidth, alignment: .leading)
            .background(RouteColors.cardBg)
        }
        .frame(width: cardWidth)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Yosemite Half Dome 入口卡（Official Detailed，戰術紫 OFFICIAL 標籤，跳轉 JSON 詳情頁）
private struct YosemiteHalfDomeCard: View {
    let title: String
    let location: String
    let rating: String
    let reviewsCount: Int
    let imageURL: URL?

    private let cardWidth: CGFloat = 280
    private let imageHeight: CGFloat = 140
    private let tacticalPurple = Color(hex: "A855F7")

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    case .failure: Color.gray.opacity(0.3)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .frame(width: cardWidth, height: imageHeight)
                .clipped()

                Text("OFFICIAL")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(tacticalPurple)
                    .clipShape(Capsule())
                    .padding(12)
            }
            .frame(width: cardWidth, height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(tacticalPurple)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 12))
                        .foregroundStyle(RouteColors.textMuted)
                    Text(location)
                        .font(.system(size: 13))
                        .foregroundStyle(RouteColors.textMuted)
                        .lineLimit(1)
                }

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(RouteColors.accentYellow)
                        Text("\(rating) (\(reviewsCount))")
                            .font(monoFontBold)
                            .foregroundStyle(RouteColors.textPrimary)
                    }
                    Spacer()
                    Text("Detailed Track")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(tacticalPurple)
                }

                HStack {
                    Text("Official Detailed")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(tacticalPurple)
                        .clipShape(Capsule())
                    Spacer()
                    HStack(spacing: 4) {
                        Text("View")
                            .font(.system(size: 14, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(RouteColors.textPrimary)
                }
            }
            .padding(16)
            .frame(width: cardWidth, alignment: .leading)
            .background(RouteColors.cardBg)
        }
        .frame(width: cardWidth)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Icon button style (hover opacity, active scale)
struct IconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview { RoutesView() }
