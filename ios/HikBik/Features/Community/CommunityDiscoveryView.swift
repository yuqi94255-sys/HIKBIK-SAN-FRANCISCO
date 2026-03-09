// Community Discovery – Grand Journeys / Detailed Tracks，深色高端風格
import SwiftUI

// MARK: - Colors (#0B121F)
private enum CommunityColors {
    static let background = Color(hex: "0B121F")
    static let cardBg = Color(hex: "2A3540")
    static let searchBg = Color(hex: "1A2332")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "9CA3AF")
    static let accentGreen = Color(hex: "10B981")
    static let segmentBg = Color(hex: "1A2332")
    static let segmentSelected = Color.white
    static let tagPurple = Color(hex: "8B5CF6")
    static let difficultyOrange = Color(hex: "F97316")
    static let difficultyRed = Color(hex: "EF4444")
}

// MARK: - View Mode
private enum CommunityViewMode: String, CaseIterable {
    case grandJourneys = "Grand Journeys"
    case detailedTracks = "Detailed Tracks"
}

// MARK: - Grand Journey Model
struct GrandJourneyItem: Identifiable {
    let id: String
    let authorId: String
    let authorName: String
    let authorSubtitle: String // "339 followers" or "Mountain Guide"
    let authorAvatarUrl: String?
    let isFollowing: Bool
    let imageUrl: String
    let days: Int
    let label: String // "EPIC COLLECTION"
    let title: String
    let mileage: String
    let vehicle: String
    let waypoints: [String]
    let likeCount: Int
    let commentCount: Int
}

// MARK: - Detailed Track Model
struct DetailedTrackItem: Identifiable {
    let id: String
    let authorName: String
    let authorSubtitle: String
    let authorAvatarUrl: String?
    let isFollowing: Bool
    let imageUrl: String
    let activityTag: String // "4X4 ONLY", "ROCK/CHAIN", "ALPINE TRAIL"
    let title: String
    let distance: String   // "45.8 mi"
    let elevationGain: String // "+2,100 ft"
    let difficulty: String   // "Hard", "Expert"
    let difficultyColor: Color
    let elevationProfileHeights: [CGFloat] // 0...1 for bar heights
    let likeCount: Int
    let commentCount: Int
}

// MARK: - Mock Data
private let mockGrandJourneys: [GrandJourneyItem] = [
    GrandJourneyItem(
        id: "1",
        authorId: "sarah-chen",
        authorName: "Sarah Chen",
        authorSubtitle: "339 followers",
        authorAvatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800",
        days: 7,
        label: "EPIC COLLECTION",
        title: "The Ultimate Utah Mighty 5 Loop",
        mileage: "1,200",
        vehicle: "SUV",
        waypoints: ["Zion", "Bryce Canyon", "Capitol Reef", "Arches", "Canyonlands"],
        likeCount: 909,
        commentCount: 45
    ),
    GrandJourneyItem(
        id: "2",
        authorId: "emma-wilson",
        authorName: "Emma Wilson",
        authorSubtitle: "542 followers",
        authorAvatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
        days: 12,
        label: "EPIC COLLECTION",
        title: "Montana Glacier Country Circuit",
        mileage: "2,100",
        vehicle: "SUV",
        waypoints: ["Glacier", "Yellowstone", "Grand Teton"],
        likeCount: 1876,
        commentCount: 92
    ),
    GrandJourneyItem(
        id: "3",
        authorId: "mike-rodriguez",
        authorName: "Mike Rodriguez",
        authorSubtitle: "Mountain Guide",
        authorAvatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
        isFollowing: true,
        imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
        days: 10,
        label: "EPIC COLLECTION",
        title: "Pacific Northwest Mountain Majesty",
        mileage: "1,850",
        vehicle: "SUV",
        waypoints: ["Olympic", "North Cascades", "Mount Rainier", "Crater Lake"],
        likeCount: 1432,
        commentCount: 78
    ),
    GrandJourneyItem(
        id: "4",
        authorId: "alex-turner",
        authorName: "Alex Turner",
        authorSubtitle: "Desert Expert",
        authorAvatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1534430480872-3498386e7856?w=800",
        days: 5,
        label: "EPIC COLLECTION",
        title: "California Desert Explorer",
        mileage: "890",
        vehicle: "4x4",
        waypoints: ["Joshua Tree", "Death Valley", "Mojave National Preserve"],
        likeCount: 567,
        commentCount: 23
    ),
]

private let mockDetailedTracks: [DetailedTrackItem] = [
    DetailedTrackItem(
        id: "dt1",
        authorName: "Tom Wilson",
        authorSubtitle: "234 followers",
        authorAvatarUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
        activityTag: "4X4 ONLY",
        title: "Maze District - Backcountry Route",
        distance: "45.8 mi",
        elevationGain: "+2,100 ft",
        difficulty: "Hard",
        difficultyColor: CommunityColors.difficultyOrange,
        elevationProfileHeights: [0.3, 0.5, 0.8, 0.6, 0.9, 0.7, 0.4, 0.6, 0.8, 0.5],
        likeCount: 445,
        commentCount: 28
    ),
    DetailedTrackItem(
        id: "dt2",
        authorName: "Jessica Martinez",
        authorSubtitle: "427 followers",
        authorAvatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200",
        isFollowing: true,
        imageUrl: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
        activityTag: "ROCK/CHAIN",
        title: "Angels Landing Summit",
        distance: "5.4 mi",
        elevationGain: "+1,488 ft",
        difficulty: "Hard",
        difficultyColor: CommunityColors.difficultyOrange,
        elevationProfileHeights: [0.2, 0.4, 0.7, 0.9, 0.6, 0.8],
        likeCount: 1234,
        commentCount: 89
    ),
    DetailedTrackItem(
        id: "dt3",
        authorName: "David Kim",
        authorSubtitle: "Overlanding Pro",
        authorAvatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800",
        activityTag: "ROUGH GRAVEL",
        title: "Racetrack Playa - The Sliding Rocks",
        distance: "27.5 mi",
        elevationGain: "+3,708 ft",
        difficulty: "Hard",
        difficultyColor: CommunityColors.difficultyOrange,
        elevationProfileHeights: [0.4, 0.5, 0.6, 0.7, 0.5, 0.8, 0.6, 0.4],
        likeCount: 567,
        commentCount: 34
    ),
    DetailedTrackItem(
        id: "dt4",
        authorName: "Lauren Hughes",
        authorSubtitle: "Backcountry Expert",
        authorAvatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
        activityTag: "ALPINE TRAIL",
        title: "The Enchantments - Core Zone",
        distance: "18 mi",
        elevationGain: "+6,000 ft",
        difficulty: "Expert",
        difficultyColor: CommunityColors.difficultyRed,
        elevationProfileHeights: [0.3, 0.6, 0.9, 0.85, 0.7, 0.8, 0.5],
        likeCount: 1890,
        commentCount: 112
    ),
    DetailedTrackItem(
        id: "dt5",
        authorName: "Chris Anderson",
        authorSubtitle: "MTB Guide",
        authorAvatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800",
        activityTag: "DIRT/ROCK",
        title: "White Rim Trail - Complete Loop",
        distance: "103.2 mi",
        elevationGain: "+1,500 ft",
        difficulty: "Expert",
        difficultyColor: CommunityColors.difficultyRed,
        elevationProfileHeights: [0.2, 0.3, 0.25, 0.4, 0.35, 0.3, 0.25, 0.2],
        likeCount: 678,
        commentCount: 45
    ),
]

private let communityMonoFont = Font.system(size: 14, weight: .medium, design: .monospaced)

// 頂部固定欄高度（佔位與疊加一致，避免第一張卡片被擋）
private let stickyHeaderHeight: CGFloat = 260

// MARK: - CommunityDiscoveryView
struct CommunityDiscoveryView: View {
    @EnvironmentObject private var communityViewModel: CommunityViewModel
    @EnvironmentObject private var currentUser: CurrentUser
    @State private var viewMode: CommunityViewMode = .grandJourneys
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var followStates: [String: Bool] = [:]
    @State private var likeStates: [String: Bool] = [:]

    /// Mock 數據 + 用戶剛發布的帖子（prepend 在最前）。
    private var grandJourneyList: [GrandJourneyItem] {
        let published = communityViewModel.publishedPosts.enumerated().map { index, journey in
            grandJourneyItem(from: journey, publishedIndex: index)
        }
        return published + mockGrandJourneys
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        Color.clear
                            .frame(height: stickyHeaderHeight)
                        if viewMode == .grandJourneys {
                            ForEach(grandJourneyList) { item in
                                let author = CommunityAuthor(id: item.authorId, displayName: item.authorName, avatarURL: item.authorAvatarUrl)
                                ZStack(alignment: .topLeading) {
                                    NavigationLink(destination: communityDetailDestination(for: item)) {
                                        GrandJourneyCard(
                                            item: item,
                                            isFollowing: followStates[item.id] ?? item.isFollowing,
                                            isLiked: currentUser.isLiked(postId: item.id),
                                            onFollowTap: { toggleFollow(item.id) },
                                            onLikeTap: { toggleLike(item.id) }
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    // 作者區疊在上層，點擊頭像/名字跳 UserProfileView，不被整卡連結搶走
                                    NavigationLink(destination: UserProfileView(user: author, subtitle: item.authorSubtitle)) {
                                        HStack(spacing: 12) {
                                            AsyncImage(url: item.authorAvatarUrl.flatMap(URL.init(string:))) { phase in
                                                switch phase {
                                                case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                                                case .failure, .empty: Color.gray.opacity(0.3)
                                                @unknown default: Color.gray.opacity(0.3)
                                                }
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(item.authorName)
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundStyle(CommunityColors.textPrimary)
                                                Text(item.authorSubtitle)
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(CommunityColors.textMuted)
                                            }
                                        }
                                        .padding(16)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else {
                            ForEach(mockDetailedTracks) { item in
                                DetailedTrackCard(
                                    item: item,
                                    isFollowing: followStates[item.id] ?? item.isFollowing,
                                    isLiked: likeStates[item.id] ?? false,
                                    onFollowTap: { toggleFollow(item.id) },
                                    onLikeTap: { toggleLike(item.id) }
                                )
                            }
                        }
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                }
                .scrollContentBackground(.hidden)
                .background(CommunityColors.background.ignoresSafeArea(edges: .all))
                .navigationBarHidden(true)

                stickyHeaderOverlay
                helpFAB
            }
            .sheet(isPresented: $showFilterSheet) {
                CommunityFilterSheet(viewMode: viewMode)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    /// 固定頂部容器：毛玻璃 + 不透明底，置於 ScrollView 之上，裁切下方滾動內容
    private var stickyHeaderOverlay: some View {
        VStack(spacing: 0) {
            stickyHeaderContent
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: stickyHeaderHeight)
        .background(CommunityColors.background)
        .background(.thickMaterial)
        .ignoresSafeArea(edges: .top)
        .zIndex(1)
    }

    /// 頂部內容：避開劉海/動態島，右側 toolbar 為「+」跳轉 CreateRouteFlow
    private var stickyHeaderContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                Text("Community")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(CommunityColors.textPrimary)
                Spacer(minLength: 8)
                NavigationLink(destination: CreateRouteFlowView()) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(CommunityColors.textPrimary)
                }
                .buttonStyle(.plain)
            }
            segmentedControl
            searchAndFilterRow
        }
        .padding(.horizontal, 20)
        .padding(.top, 54)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(CommunityViewMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { viewMode = mode }
                } label: {
                    Text(mode.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(viewMode == mode ? CommunityColors.background : CommunityColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(viewMode == mode ? CommunityColors.segmentSelected : Color.clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(CommunityColors.segmentBg)
        .clipShape(Capsule())
    }

    private var searchAndFilterRow: some View {
        HStack(spacing: 12) {
            Button {
                showFilterSheet = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundStyle(CommunityColors.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(CommunityColors.segmentBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
                TextField(viewMode == .detailedTracks ? "Search tracks by name, trail, or activity..." : "Search journeys by name, location, or keywords...", text: $searchText)
                    .font(.system(size: 15))
                    .foregroundStyle(CommunityColors.textPrimary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(CommunityColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var helpFAB: some View {
        Button { } label: {
            Image(systemName: "questionmark")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(CommunityColors.accentGreen)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(20)
    }

    private func toggleFollow(_ id: String) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let current = followStates[id]
        if current != nil {
            followStates[id] = !current!
        } else {
            let fromGrand = mockGrandJourneys.first(where: { $0.id == id })?.isFollowing
            let fromTrack = mockDetailedTracks.first(where: { $0.id == id })?.isFollowing
            followStates[id] = !(fromGrand ?? fromTrack ?? false)
        }
    }

    private func toggleLike(_ id: String) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        currentUser.toggleLike(postId: id)
    }

    /// 點擊 Grand Journey 卡片進入的詳情頁。published_* 用 ViewModel 的完整 CommunityJourney，id "1" 用 Sarah 模擬數據，其餘用 placeholder。
    @ViewBuilder
    private func communityDetailDestination(for item: GrandJourneyItem) -> some View {
        if item.id.hasPrefix("published_"), let idx = Int(item.id.replacingOccurrences(of: "published_", with: "")),
           idx >= 0, idx < communityViewModel.publishedPosts.count {
            CommunityMacroDetailView(journey: communityViewModel.publishedPosts[idx], journeyId: item.id)
        } else if item.id == "1" {
            CommunityMacroDetailView(journey: Self.sarahChenUtahCommunityJourney, journeyId: item.id)
        } else {
            CommunityMacroDetailView(journey: Self.placeholderCommunityJourney(for: item), journeyId: item.id)
        }
    }

    /// 將 CommunityJourney 轉成列表用的 GrandJourneyItem（id = published_索引）。
    private func grandJourneyItem(from journey: CommunityJourney, publishedIndex: Int) -> GrandJourneyItem {
        let imageUrl = journey.days.first?.photoURL ?? "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"
        return GrandJourneyItem(
            id: "published_\(publishedIndex)",
            authorId: journey.author?.id ?? "guest",
            authorName: journey.author?.displayName ?? "Guest",
            authorSubtitle: "Just published",
            authorAvatarUrl: journey.author?.avatarURL,
            isFollowing: false,
            imageUrl: imageUrl,
            days: journey.days.count,
            label: "EPIC COLLECTION",
            title: journey.journeyName,
            mileage: "",
            vehicle: journey.vehicle ?? "SUV",
            waypoints: journey.days.compactMap { $0.locationName },
            likeCount: journey.likeCount,
            commentCount: journey.commentCount
        )
    }

    /// Sarah Chen「The Ultimate Utah Mighty 5 Loop」詳情用數據：7 天、SUV、地圖連線三園座標，Day 2 信號 1 格、無水無油。
    private static let sarahChenUtahCommunityJourney = CommunityJourney(
        journeyName: "The Ultimate Utah Mighty 5 Loop",
        days: [
            CommunityJourneyDay(
                dayNumber: 1,
                location: CommunityGeoLocation(latitude: 38.7331, longitude: -109.5925),
                locationName: "Arches National Park",
                notes: "第一天從 Moab 出發。Delicate Arch 的落日絕對不能錯過，但記得帶頭燈，回程天黑很快。",
                photoURL: "https://images.unsplash.com/photo-1504192010706-96946577af45",
                recommendedStay: "Under Canvas Moab",
                hasWater: true,
                hasFuel: false,
                signalStrength: 4
            ),
            CommunityJourneyDay(
                dayNumber: 2,
                location: CommunityGeoLocation(latitude: 38.4367, longitude: -109.8108),
                locationName: "Canyonlands (Island in the Sky)",
                notes: "壯闊的峽谷景觀。Shafer Trail 非常考驗駕駛技術，建議低速檔前進。荒原地帶無補給。",
                photoURL: "https://images.unsplash.com/photo-1516939884455-1445c8652f83",
                recommendedStay: "Willow Flat Campground",
                hasWater: false,
                hasFuel: false,
                signalStrength: 1
            ),
            CommunityJourneyDay(
                dayNumber: 3,
                location: CommunityGeoLocation(latitude: 38.3670, longitude: -111.2615),
                locationName: "Capitol Reef National Park",
                notes: "穿過 UT-24 公路，風景像是在火星。這裡的派 (Pie) 很有名，一定要去 Gifford House 買一個！",
                photoURL: "https://images.unsplash.com/photo-1516939884455-1445c8652f83",
                recommendedStay: "Capitol Reef Resort (Wagons)",
                hasWater: true,
                hasFuel: true,
                signalStrength: 3
            )
        ],
        selectedStates: ["Utah"],
        duration: "7 Days",
        vehicle: "SUV",
        pace: "Moderate",
        author: CommunityAuthor(id: "sarah-chen", displayName: "Sarah Chen", avatarURL: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200"),
        likeCount: 909,
        commentCount: 45
    )

    private static func placeholderCommunityJourney(for item: GrandJourneyItem) -> CommunityJourney {
        CommunityJourney(
            journeyName: item.title,
            days: [CommunityJourneyDay(dayNumber: 1, location: nil, locationName: nil, notes: "Placeholder detail.")],
            selectedStates: [],
            duration: "\(item.days) Days",
            vehicle: item.vehicle,
            pace: nil,
            author: CommunityAuthor(id: item.id, displayName: item.authorName, avatarURL: item.authorAvatarUrl),
            likeCount: item.likeCount,
            commentCount: item.commentCount
        )
    }
}

// MARK: - GrandJourneyCard（獨立頭部 + 沉浸圖片 + 底部交互）
private let grandCardCorner: CGFloat = 22
private let grandCardMonoSmall = Font.system(size: 10, weight: .medium, design: .monospaced)

struct GrandJourneyCard: View {
    let item: GrandJourneyItem
    let isFollowing: Bool
    let isLiked: Bool
    let onFollowTap: () -> Void
    let onLikeTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader
            imageSection
            actionBar
        }
        .background(CommunityColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: grandCardCorner))
        .overlay(
            RoundedRectangle(cornerRadius: grandCardCorner)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    /// 獨立的卡片頭部：點擊頭像/名字跳轉 UserProfileView(user: post.author)，Follow 按鈕獨立；PlainButtonStyle 避免藍色樣式。
    private var cardHeader: some View {
        let author = CommunityAuthor(id: item.authorId, displayName: item.authorName, avatarURL: item.authorAvatarUrl)
        return HStack(alignment: .center, spacing: 12) {
            NavigationLink(destination: UserProfileView(user: author, subtitle: item.authorSubtitle)) {
                HStack(spacing: 12) {
                    AsyncImage(url: item.authorAvatarUrl.flatMap(URL.init(string:))) { phase in
                        switch phase {
                        case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                        case .failure, .empty: Color.gray.opacity(0.3)
                        @unknown default: Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.authorName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(CommunityColors.textPrimary)
                        Text(item.authorSubtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(CommunityColors.textMuted)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: onFollowTap) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isFollowing ? CommunityColors.textMuted : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isFollowing ? CommunityColors.segmentBg : CommunityColors.accentGreen)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CommunityColors.cardBg)
    }

    /// 沉浸式圖片：3:2 比例，底部漸變 + 標題與數據
    private var imageSection: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = w * 2 / 3
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: item.imageUrl)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    case .failure: Color.gray.opacity(0.3)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .frame(width: w, height: h)
                .frame(maxWidth: .infinity)
                .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: w, height: h)
                .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    Text(item.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    HStack(spacing: 4) {
                        Text("\(item.days) Days")
                            .font(grandCardMonoSmall)
                            .foregroundStyle(.white.opacity(0.8))
                        Text("•")
                            .font(grandCardMonoSmall)
                            .foregroundStyle(.white.opacity(0.6))
                        Text("\(item.mileage) mi")
                            .font(grandCardMonoSmall)
                            .foregroundStyle(.white.opacity(0.8))
                        Text("•")
                            .font(grandCardMonoSmall)
                            .foregroundStyle(.white.opacity(0.6))
                        Text(item.vehicle)
                            .font(grandCardMonoSmall)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(16)
                .frame(width: w, height: h, alignment: .leading)
            }
            .frame(width: w, height: h)
        }
        .aspectRatio(3/2, contentMode: .fit)
    }

    /// 底部交互橫條：點讚、評論、收藏、分享
    private var actionBar: some View {
        HStack(spacing: 16) {
            Button(action: onLikeTap) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(isLiked ? CommunityColors.accentGreen : CommunityColors.textMuted)
                    Text("\(item.likeCount)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(CommunityColors.textMuted)
                }
            }
            .buttonStyle(.plain)
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
                Text("\(item.commentCount)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            Image(systemName: "bookmark")
                .font(.system(size: 16))
                .foregroundStyle(CommunityColors.textMuted)
            Spacer()
            Button { } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(CommunityColors.cardBg)
    }
}

// MARK: - DetailedTrackCard（與 GrandJourneyCard 圓角、圖片比例、頭部一致）
struct DetailedTrackCard: View {
    let item: DetailedTrackItem
    let isFollowing: Bool
    let isLiked: Bool
    let onFollowTap: () -> Void
    let onLikeTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader
            imageSection
            elevationProfileRow
            interactionsRow
        }
        .background(CommunityColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: grandCardCorner))
        .overlay(
            RoundedRectangle(cornerRadius: grandCardCorner)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    /// 頭部與 GrandJourneyCard 一致：40pt 頭像、14pt 名字、12pt 副標
    private var cardHeader: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: item.authorAvatarUrl.flatMap(URL.init(string:))) { phase in
                switch phase {
                case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                case .failure, .empty: Color.gray.opacity(0.3)
                @unknown default: Color.gray.opacity(0.3)
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(item.authorName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(CommunityColors.textPrimary)
                Text(item.authorSubtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            Spacer()
            Button(action: onFollowTap) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isFollowing ? CommunityColors.textMuted : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isFollowing ? CommunityColors.segmentBg : CommunityColors.accentGreen)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CommunityColors.cardBg)
    }

    /// 圖片區與 GrandJourneyCard 一致：3:2 比例，底部漸變 + 標題與數據
    private var imageSection: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = w * 2 / 3
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: item.imageUrl)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    case .failure: Color.gray.opacity(0.3)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .frame(width: w, height: h)
                .frame(maxWidth: .infinity)
                .clipped()

                activityTagView
                targetIconView

                LinearGradient(
                    colors: [.clear, .black.opacity(0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: w, height: h)
                .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    Text("TECHNICAL TRACK")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(CommunityColors.textMuted)
                    Text(item.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    HStack(spacing: 6) {
                        Text(item.distance)
                            .font(communityMonoFont)
                            .foregroundStyle(.white)
                        Text("•")
                            .foregroundStyle(.white.opacity(0.7))
                        Text("↑ \(item.elevationGain)")
                            .font(communityMonoFont)
                            .foregroundStyle(.white)
                        Text("•")
                            .foregroundStyle(.white.opacity(0.7))
                        HStack(spacing: 4) {
                            Circle()
                                .fill(item.difficultyColor)
                                .frame(width: 6, height: 6)
                            Text(item.difficulty)
                                .font(communityMonoFont)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(16)
                .frame(width: w, height: h, alignment: .leading)
            }
            .frame(width: w, height: h)
        }
        .aspectRatio(3/2, contentMode: .fit)
    }

    private var activityTagView: some View {
        Text(item.activityTag)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(CommunityColors.tagPurple.opacity(0.85))
            .clipShape(Capsule())
            .padding(12)
    }

    private var targetIconView: some View {
        Image(systemName: "scope")
            .font(.system(size: 18))
            .foregroundStyle(CommunityColors.accentGreen)
            .frame(width: 36, height: 36)
            .background(Color.black.opacity(0.4))
            .clipShape(Circle())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(12)
    }

    private var elevationProfileRow: some View {
        HStack(spacing: 3) {
            ForEach(Array(item.elevationProfileHeights.enumerated()), id: \.offset) { _, h in
                RoundedRectangle(cornerRadius: 2)
                    .fill(CommunityColors.accentGreen)
                    .frame(height: max(4, 24 * h))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    /// 底部交互與 GrandJourneyCard 一致：圖標 + 數字，padding 12
    private var interactionsRow: some View {
        HStack(spacing: 16) {
            Button(action: onLikeTap) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(isLiked ? CommunityColors.accentGreen : CommunityColors.textMuted)
                    Text("\(item.likeCount)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(CommunityColors.textMuted)
                }
            }
            .buttonStyle(.plain)
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
                Text("\(item.commentCount)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            Image(systemName: "bookmark")
                .font(.system(size: 16))
                .foregroundStyle(CommunityColors.textMuted)
            Spacer()
            Button { } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(CommunityColors.cardBg)
    }
}

// MARK: - Grand Journey Filter Data
private struct FilterStateItem: Identifiable {
    let id: String
    let name: String
    let routeCount: Int
}

private struct FilterRegionItem: Identifiable {
    let id: String
    let name: String
    let states: [FilterStateItem]
}

private let filterTerrainOptions = ["Mountains", "Desert", "Coastline", "Canyons", "Forests"]
private let filterDurationOptions = ["1-3", "4-7", "8-14", "15+"]

private let filterRegionsAll: [FilterRegionItem] = [
    FilterRegionItem(id: "west", name: "WEST", states: [
        FilterStateItem(id: "ca", name: "California", routeCount: 412),
        FilterStateItem(id: "ak", name: "Alaska", routeCount: 156),
        FilterStateItem(id: "wa", name: "Washington", routeCount: 289),
        FilterStateItem(id: "or", name: "Oregon", routeCount: 198),
        FilterStateItem(id: "nv", name: "Nevada", routeCount: 124),
    ]),
    FilterRegionItem(id: "southwest", name: "SOUTHWEST", states: [
        FilterStateItem(id: "az", name: "Arizona", routeCount: 267),
        FilterStateItem(id: "tx", name: "Texas", routeCount: 334),
    ]),
    FilterRegionItem(id: "mountain", name: "MOUNTAIN", states: [
        FilterStateItem(id: "co", name: "Colorado", routeCount: 389),
        FilterStateItem(id: "ut", name: "Utah", routeCount: 245),
        FilterStateItem(id: "wy", name: "Wyoming", routeCount: 112),
        FilterStateItem(id: "mt", name: "Montana", routeCount: 178),
        FilterStateItem(id: "id", name: "Idaho", routeCount: 134),
    ]),
    FilterRegionItem(id: "northeast", name: "NORTHEAST", states: [
        FilterStateItem(id: "ct", name: "Connecticut", routeCount: 89),
        FilterStateItem(id: "me", name: "Maine", routeCount: 156),
        FilterStateItem(id: "ma", name: "Massachusetts", routeCount: 134),
        FilterStateItem(id: "nh", name: "New Hampshire", routeCount: 98),
        FilterStateItem(id: "nj", name: "New Jersey", routeCount: 76),
        FilterStateItem(id: "ny", name: "New York", routeCount: 267),
    ]),
    FilterRegionItem(id: "midwest", name: "MIDWEST", states: [
        FilterStateItem(id: "il", name: "Illinois", routeCount: 112),
        FilterStateItem(id: "mi", name: "Michigan", routeCount: 189),
        FilterStateItem(id: "mn", name: "Minnesota", routeCount: 145),
        FilterStateItem(id: "oh", name: "Ohio", routeCount: 98),
        FilterStateItem(id: "wi", name: "Wisconsin", routeCount: 167),
    ]),
    FilterRegionItem(id: "southeast", name: "SOUTHEAST", states: [
        FilterStateItem(id: "fl", name: "Florida", routeCount: 223),
        FilterStateItem(id: "ga", name: "Georgia", routeCount: 178),
        FilterStateItem(id: "nc", name: "North Carolina", routeCount: 245),
        FilterStateItem(id: "tn", name: "Tennessee", routeCount: 156),
    ]),
]

private let filterInitialRegionIds = ["west", "southwest", "mountain"]
private let filterMonoFont = Font.system(size: 12, weight: .medium, design: .monospaced)

// MARK: - Detailed Track Filter Options (Technical)
private let dtLandManagerOptions = ["National Park", "National Forest", "State Park", "State Forest", "National Recreation"]
private let dtActivityOptions = ["Hiking", "MTB", "Overlanding", "Backcountry", "Trail Running", "Climbing"]
private let dtSurfaceOptions = ["Paved", "Gravel", "Dirt", "4x4 Only", "Rock/Scramble", "Mixed"]
private let dtDifficultyOptions = ["Easy", "Moderate", "Hard", "Expert"]

// MARK: - Grand Journey Filter View (Expandable Regions, Terrain, Duration)
struct GrandJourneyFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedStateIds: Set<String>
    @Binding var selectedTerrains: Set<String>
    @Binding var selectedDuration: String?

    @State private var showAllRegions = false

    private var visibleRegions: [FilterRegionItem] {
        if showAllRegions { return filterRegionsAll }
        return filterRegionsAll.filter { filterInitialRegionIds.contains($0.id) }
    }

    private var resultCount: Int {
        let stateCount = selectedStateIds.isEmpty ? 0 : selectedStateIds.count * 48
        let terrainBonus = selectedTerrains.isEmpty ? 0 : selectedTerrains.count * 12
        let durationBonus = selectedDuration == nil ? 0 : 24
        return max(0, stateCount + terrainBonus + durationBonus)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(visibleRegions) { region in
                            Section {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12),
                                ], spacing: 12) {
                                    ForEach(region.states) { state in
                                        FilterStateCard(
                                            state: state,
                                            isSelected: selectedStateIds.contains(state.id),
                                            onTap: { toggleState(state.id) }
                                        )
                                    }
                                }
                                .padding(.horizontal, 4)
                            } header: {
                                Text(region.name)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(CommunityColors.textMuted)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 8)
                            }
                            .id(region.id)

                            if region.id == "mountain", !showAllRegions {
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showAllRegions = true
                                    }
                                } label: {
                                    Text("Show all 50 States")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(CommunityColors.accentGreen)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.bottom, 8)
                            }
                        }

                        terrainSection
                        durationSection
                        Color.clear.frame(height: 100)
                    }
                    .padding(20)
                }
                .onChange(of: showAllRegions) { _, expanded in
                    if expanded {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                proxy.scrollTo("northeast", anchor: .top)
                            }
                        }
                    }
                }
            }

            stickyBottomBar
        }
        .background(CommunityColors.background)
        .preferredColorScheme(.dark)
    }

    private var terrainSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TERRAIN")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(CommunityColors.textMuted)
                .textCase(.uppercase)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(filterTerrainOptions, id: \.self) { terrain in
                        filterCapsuleButton(
                            title: terrain,
                            isSelected: selectedTerrains.contains(terrain),
                            action: {
                                var next = selectedTerrains
                                if next.contains(terrain) { next.remove(terrain) } else { next.insert(terrain) }
                                selectedTerrains = next
                            }
                        )
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("DURATION")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(CommunityColors.textMuted)
                .textCase(.uppercase)
            HStack(spacing: 10) {
                ForEach(filterDurationOptions, id: \.self) { option in
                    filterCapsuleButton(
                        title: option,
                        isSelected: selectedDuration == option,
                        action: {
                            if selectedDuration == option {
                                selectedDuration = nil
                            } else {
                                selectedDuration = option
                            }
                        }
                    )
                }
            }
        }
    }

    /// 膠囊標籤：單行、左右 16 / 上下 8，未選 0.08+深灰描邊，選中 0.2+螢光綠邊
    private func filterCapsuleButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? CommunityColors.textPrimary : CommunityColors.textPrimary)
                .lineLimit(1)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.08))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? CommunityColors.accentGreen : Color(white: 0.35),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }

    private var stickyBottomBar: some View {
        VStack(spacing: 12) {
            Button("Clear All") {
                selectedStateIds.removeAll()
                selectedTerrains.removeAll()
                selectedDuration = nil
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(CommunityColors.textMuted)

            Button {
                dismiss()
            } label: {
                Text("Show \(resultCount) Results")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(CommunityColors.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(CommunityColors.accentGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 34)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }

    private func toggleState(_ id: String) {
        var next = selectedStateIds
        if next.contains(id) { next.remove(id) } else { next.insert(id) }
        selectedStateIds = next
    }
}

// MARK: - Filter State Card (Two-column grid, neon green when selected)
private struct FilterStateCard: View {
    let state: FilterStateItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(state.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(CommunityColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(state.routeCount) Routes")
                    .font(filterMonoFont)
                    .foregroundStyle(CommunityColors.textMuted)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.white.opacity(0.12) : Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? CommunityColors.accentGreen : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Detailed Track Filter View (Land Manager, Activity, Surface, Difficulty)
struct DetailedTrackFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLandManagers: Set<String>
    @Binding var selectedActivities: Set<String>
    @Binding var selectedSurfaces: Set<String>
    @Binding var selectedDifficulties: Set<String>

    private var resultCount: Int {
        let a = selectedLandManagers.isEmpty ? 0 : selectedLandManagers.count * 20
        let b = selectedActivities.isEmpty ? 0 : selectedActivities.count * 15
        let c = selectedSurfaces.isEmpty ? 0 : selectedSurfaces.count * 12
        let d = selectedDifficulties.isEmpty ? 0 : selectedDifficulties.count * 18
        return max(0, a + b + c + d)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    filterSection(title: "LAND MANAGER", options: dtLandManagerOptions, selected: selectedLandManagers, columns: 2) { selectedLandManagers = $0 }
                    filterSection(title: "ACTIVITY TYPE", options: dtActivityOptions, selected: selectedActivities, columns: 3) { selectedActivities = $0 }
                    filterSection(title: "SURFACE TYPE", options: dtSurfaceOptions, selected: selectedSurfaces, columns: 2) { selectedSurfaces = $0 }
                    filterSection(title: "DIFFICULTY LEVEL", options: dtDifficultyOptions, selected: selectedDifficulties, columns: 2) { selectedDifficulties = $0 }
                    Color.clear.frame(height: 100)
                }
                .padding(16)
            }

            detailedTrackStickyBar(resultCount: resultCount) {
                selectedLandManagers.removeAll()
                selectedActivities.removeAll()
                selectedSurfaces.removeAll()
                selectedDifficulties.removeAll()
            } onShowResults: {
                dismiss()
            }
        }
        .background(CommunityColors.background)
        .preferredColorScheme(.dark)
    }

    private func filterSection(title: String, options: [String], selected: Set<String>, columns: Int, onToggle: @escaping (Set<String>) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(CommunityColors.textMuted)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)

            DetailedTrackFilterGrid(columns: columns, options: options, selected: selected) { option in
                var next = selected
                if next.contains(option) { next.remove(option) } else { next.insert(option) }
                onToggle(next)
            }
        }
    }
}

// Grid columns modifier for section override (LAND 2, ACTIVITY 3, etc.)
private struct DetailedTrackFilterGrid: View {
    let columns: Int
    let options: [String]
    let selected: Set<String>
    let onTap: (String) -> Void

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 8) {
            ForEach(options, id: \.self) { option in
                DetailedTrackFilterChip(
                    title: option,
                    isSelected: selected.contains(option),
                    action: { onTap(option) }
                )
            }
        }
    }
}

// Compact capsule chip: selected = dark bg + green border + bold; unselected = semi-transparent
private struct DetailedTrackFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(CommunityColors.textPrimary)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(isSelected ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? CommunityColors.accentGreen : Color.white.opacity(0.12), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// Sticky bottom bar for Detailed Track (Clear All + Show X Results)
private func detailedTrackStickyBar(resultCount: Int, onClearAll: @escaping () -> Void, onShowResults: @escaping () -> Void) -> some View {
    VStack(spacing: 10) {
        Button(action: onClearAll) {
            Text("Clear All")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(CommunityColors.textMuted)
        }
        .buttonStyle(.plain)

        Button(action: onShowResults) {
            Text("Show \(resultCount) Results")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(CommunityColors.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(CommunityColors.accentGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .padding(.bottom, 34)
    .frame(maxWidth: .infinity)
    .background(.ultraThinMaterial)
}

// MARK: - Community Filter Sheet (Grand Journey or Detailed Track by viewMode)
struct CommunityFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    fileprivate var viewMode: CommunityViewMode = .grandJourneys

    @State private var selectedStateIds: Set<String> = []
    @State private var selectedTerrains: Set<String> = []
    @State private var selectedDuration: String?

    @State private var selectedLandManagers: Set<String> = []
    @State private var selectedActivities: Set<String> = []
    @State private var selectedSurfaces: Set<String> = []
    @State private var selectedDifficulties: Set<String> = []

    var body: some View {
        NavigationStack {
            Group {
                if viewMode == .detailedTracks {
                    DetailedTrackFilterView(
                        selectedLandManagers: $selectedLandManagers,
                        selectedActivities: $selectedActivities,
                        selectedSurfaces: $selectedSurfaces,
                        selectedDifficulties: $selectedDifficulties
                    )
                } else {
                    GrandJourneyFilterView(
                        selectedStateIds: $selectedStateIds,
                        selectedTerrains: $selectedTerrains,
                        selectedDuration: $selectedDuration
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(CommunityColors.accentGreen)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Create Route Flow（與 Community 同款深色背景 #0B121F）
struct CreateRouteFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userState: UserState
    @State private var showLoginPrompt = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                backButton
                headerSection
                NavigationLink(destination: UnifiedDraftBoxView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "tray.full.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(CommunityColors.accentGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Draft Box")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(CommunityColors.textPrimary)
                            Text("View and open saved drafts by source.")
                                .font(.system(size: 13))
                                .foregroundStyle(CommunityColors.textMuted)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(CommunityColors.textMuted)
                    }
                    .padding(14)
                    .background(CommunityColors.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(CommunityColors.accentGreen.opacity(0.4), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                VStack(spacing: 12) {
                    createRouteOptionCard(
                        icon: "camera",
                        title: "Auto-Scan Photos",
                        badge: "AI POWERED",
                        subtitle: "Upload your trip photos and let AI extract location data & create your route.",
                        trailingIcon: "sparkles",
                        cardBg: CommunityColors.accentGreen.opacity(0.35),
                        iconCircleColor: CommunityColors.accentGreen.opacity(0.5),
                        borderColor: CommunityColors.accentGreen.opacity(0.6)
                    ) {}
                    NavigationLink(destination: CustomRouteBuilderView()) {
                        createRouteOptionCardContent(
                            icon: "doc.text",
                            title: "Custom Route Builder",
                            badge: nil,
                            subtitle: "Manual entry for total control. Supports Pro Mode for precision data.",
                            trailingIcon: "chevron.right",
                            cardBg: CommunityColors.cardBg,
                            iconCircleColor: CommunityColors.difficultyOrange.opacity(0.4),
                            borderColor: CommunityColors.difficultyOrange
                        )
                    }
                    .buttonStyle(.plain)
                    recordLiveTrackEntry
                }
                .padding(.horizontal, 20)
                Spacer(minLength: 40)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CommunityColors.background)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showLoginPrompt) {
            ZStack {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture { showLoginPrompt = false }
                LoginPromptModal(
                    onSignIn: {
                        userState.showLandingFromApp = true
                        showLoginPrompt = false
                    },
                    onDismiss: { showLoginPrompt = false }
                )
            }
        }
    }

    @ViewBuilder
    private var recordLiveTrackEntry: some View {
        let card = createRouteOptionCardContent(
            icon: "location.fill",
            title: "Record Live Track",
            badge: nil,
            subtitle: "Track your route in real time. Auto-waypoints every 500m or when you stop 2+ mins. Save as draft.",
            trailingIcon: "chevron.right",
            cardBg: CommunityColors.cardBg,
            iconCircleColor: CommunityColors.accentGreen.opacity(0.4),
            borderColor: CommunityColors.accentGreen
        )
        if userState.isGuest {
            Button {
                showLoginPrompt = true
            } label: { card }
            .buttonStyle(.plain)
        } else {
            NavigationLink(destination: LiveTrackRecordingView()) { card }
                .buttonStyle(.plain)
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Back to Discovery")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(CommunityColors.textMuted)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 14))
                    .foregroundStyle(CommunityColors.accentGreen)
                Text("MAGIC ROUTE CREATOR")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(CommunityColors.accentGreen.opacity(0.25))
                    .clipShape(Capsule())
            }
            Text("How would you like to create your route?")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(CommunityColors.textPrimary)
            Text("Choose your preferred method to capture your adventure.")
                .font(.system(size: 15))
                .foregroundStyle(CommunityColors.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }

    private func createRouteOptionCard(
        icon: String,
        title: String,
        badge: String?,
        subtitle: String,
        trailingIcon: String,
        cardBg: Color,
        iconCircleColor: Color,
        borderColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            createRouteOptionCardContent(
                icon: icon,
                title: title,
                badge: badge,
                subtitle: subtitle,
                trailingIcon: trailingIcon,
                cardBg: cardBg,
                iconCircleColor: iconCircleColor,
                borderColor: borderColor
            )
        }
        .buttonStyle(.plain)
    }

    private func createRouteOptionCardContent(
        icon: String,
        title: String,
        badge: String?,
        subtitle: String,
        trailingIcon: String,
        cardBg: Color,
        iconCircleColor: Color,
        borderColor: Color
    ) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(iconCircleColor)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(CommunityColors.textPrimary)
                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(CommunityColors.accentGreen.opacity(0.8))
                            .clipShape(Capsule())
                    }
                }
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: trailingIcon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(borderColor, lineWidth: 1)
        )
    }
}

#Preview { CommunityDiscoveryView().environmentObject(CommunityViewModel()).environmentObject(CurrentUser()) }
