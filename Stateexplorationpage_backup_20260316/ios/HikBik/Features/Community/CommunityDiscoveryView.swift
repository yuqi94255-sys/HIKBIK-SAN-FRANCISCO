// Community Discovery – Grand Journeys / Detailed Tracks / Live Activity; dark theme
import SwiftUI
import MapKit

// MARK: - Colors (#0B121F)
private enum CommunityColors {
    static let background = Color(hex: "0B121F")
    static let cardBg = Color(hex: "2A3540")
    static let searchBg = Color(hex: "1A2332")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "9CA3AF")
    /// Search bar placeholder only (brighter than textMuted for contrast on dark background).
    static let searchPlaceholder = Color.white.opacity(0.6)
    static let accentGreen = Color(hex: "10B981")
    static let segmentBg = Color(hex: "1A2332")
    static let segmentSelected = Color.white
    static let tagPurple = Color(hex: "8B5CF6")
    static let difficultyOrange = Color(hex: "F97316")
    static let difficultyRed = Color(hex: "EF4444")
}

// MARK: - View Mode (grand / detailed / liveActivity)
private enum CommunityViewMode: String, CaseIterable {
    case grandJourneys = "Grand Journeys"
    case detailedTracks = "Detailed Tracks"
    case liveActivity = "Live Activity"
}

// MARK: - Grand Journey Model (stateIds/tags for filter, createdAt for ranking)
struct GrandJourneyItem: Identifiable {
    let id: String
    let authorId: String
    let authorName: String
    let authorSubtitle: String
    let authorAvatarUrl: String?
    let isFollowing: Bool
    let imageUrl: String
    let days: Int
    let label: String
    let title: String
    let mileage: String
    let vehicle: String
    let waypoints: [String]
    let likeCount: Int
    let commentCount: Int
    /// Region filter (state id e.g. "ut", "ca")
    let stateIds: [String]
    /// Terrain filter (e.g. "Mountains", "Desert")
    let tags: [String]
    /// For heat formula HoursOld
    let createdAt: Date?
}

// MARK: - Live Activity Model (lightweight record: map + mileage/duration/weather)
struct LiveActivityItem: Identifiable {
    let id: String
    let authorId: String
    let authorName: String
    let authorSubtitle: String
    let authorAvatarUrl: String?
    let isFollowing: Bool
    /// User-recorded polyline for card background map
    let polylineCoordinates: [CLLocationCoordinate2D]
    let title: String
    let mileage: String      // e.g. "12.4 mi"
    let duration: String     // e.g. "2h 18m"
    let weatherStatus: String // e.g. "Sunny, 72°F"
    let likeCount: Int
    let commentCount: Int
}

// MARK: - Detailed Track Model
struct DetailedTrackItem: Identifiable {
    let id: String
    let authorId: String
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
        commentCount: 45,
        stateIds: ["ut"],
        tags: ["Canyons", "Mountains"],
        createdAt: Date().addingTimeInterval(-3600 * 24 * 2)
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
        commentCount: 92,
        stateIds: ["mt", "wy"],
        tags: ["Mountains", "Forests"],
        createdAt: Date().addingTimeInterval(-3600 * 24 * 5)
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
        commentCount: 78,
        stateIds: ["wa", "or"],
        tags: ["Mountains", "Forests", "Coastline"],
        createdAt: Date().addingTimeInterval(-3600 * 24 * 10)
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
        commentCount: 23,
        stateIds: ["ca", "nv"],
        tags: ["Desert", "Canyons"],
        createdAt: Date().addingTimeInterval(-3600 * 24)
    ),
]

/// 模擬 Zion - Angel's Landing 詳情頁數據（含社交屬性：作者、評分、封面圖）
private let zionManualJourneyMock: DetailedTrackPost = DetailedTrackPost(
    category: .nationalPark,
    routeName: "Angel's Landing Trail - Zion",
    totalDurationMinutes: 30,
    viewPointNodes: [
        ViewPointNode(title: "The Grotto Trailhead", activityType: .hiking, latitude: 37.2591, longitude: -112.9501, photoCount: 1, arrivalTime: "09:00 AM", hasWater: true, hasFuel: false, signalStrength: 3),
        ViewPointNode(title: "Walter's Wiggles", activityType: .climbing, latitude: 37.2635, longitude: -112.9472, photoCount: 1, arrivalTime: "10:15 AM", hasWater: false, hasFuel: false, signalStrength: 1),
        ViewPointNode(title: "Angel's Landing Summit", activityType: .summit, latitude: 37.2662, longitude: -112.9468, photoCount: 1, arrivalTime: "11:30 AM", hasWater: false, hasFuel: false, signalStrength: 0)
    ],
    elevationGain: "1488 ft",
    elevationPeak: "5790 ft",
    amenitiesDisplay: ["Water Refill", "Cell Signal", "First Aid"],
    author: DetailedTrackAuthor(name: "Jessica Martinez", avatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200", isVerified: true),
    rating: 4.9,
    reviewCount: 24,
    heroImage: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
    routeID: "zion-angels-landing-001"
)

/// 輕量紀錄 Mock：小型靜態地圖 + 里程/耗時/天氣
private let mockLiveActivities: [LiveActivityItem] = {
    let zionTrail: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.2591, longitude: -112.9501),
        CLLocationCoordinate2D(latitude: 37.2610, longitude: -112.9485),
        CLLocationCoordinate2D(latitude: 37.2635, longitude: -112.9472),
        CLLocationCoordinate2D(latitude: 37.2662, longitude: -112.9468)
    ]
    let moabTrail: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 38.5733, longitude: -109.5498),
        CLLocationCoordinate2D(latitude: 38.5780, longitude: -109.5520),
        CLLocationCoordinate2D(latitude: 38.5820, longitude: -109.5480)
    ]
    let rainierTrail: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 46.7852, longitude: -121.7354),
        CLLocationCoordinate2D(latitude: 46.7880, longitude: -121.7320),
        CLLocationCoordinate2D(latitude: 46.7910, longitude: -121.7280),
        CLLocationCoordinate2D(latitude: 46.7940, longitude: -121.7240)
    ]
    return [
        LiveActivityItem(
            id: "la1",
            authorId: "jessica-martinez",
            authorName: "Jessica Martinez",
            authorSubtitle: "427 followers",
            authorAvatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200",
            isFollowing: true,
            polylineCoordinates: zionTrail,
            title: "Angels Landing Morning Run",
            mileage: "5.4 mi",
            duration: "1h 24m",
            weatherStatus: "Sunny, 68°F",
            likeCount: 234,
            commentCount: 18
        ),
        LiveActivityItem(
            id: "la2",
            authorId: "david-kim",
            authorName: "David Kim",
            authorSubtitle: "Overlanding Pro",
            authorAvatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
            isFollowing: false,
            polylineCoordinates: moabTrail,
            title: "Arches Scenic Drive",
            mileage: "18.2 mi",
            duration: "2h 18m",
            weatherStatus: "Partly cloudy, 82°F",
            likeCount: 89,
            commentCount: 6
        ),
        LiveActivityItem(
            id: "la3",
            authorId: "lauren-hughes",
            authorName: "Lauren Hughes",
            authorSubtitle: "Backcountry Expert",
            authorAvatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
            isFollowing: false,
            polylineCoordinates: rainierTrail,
            title: "Skyline Trail Segment",
            mileage: "6.1 mi",
            duration: "3h 05m",
            weatherStatus: "Clear, 58°F",
            likeCount: 312,
            commentCount: 22
        ),
    ]
}()

private let mockDetailedTracks: [DetailedTrackItem] = [
    DetailedTrackItem(
        id: "dt1",
        authorId: "tom-wilson",
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
        authorId: "jessica-martinez",
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
        authorId: "david-kim",
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
        authorId: "lauren-hughes",
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
        authorId: "chris-anderson",
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

// 頂部固定欄：標題距 safe area 與 Route 一致（16pt），總高度 = safeAreaTop + 16 + contentHeight
private let stickyHeaderTitlePadding: CGFloat = 16
private let stickyHeaderContentHeight: CGFloat = 132

private struct SafeAreaTopKey: PreferenceKey {
    static var defaultValue: CGFloat { 59 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

/// 搜尋視圖狀態：原地切換，不跳新頁。idle 預設列表 / searching 搜尋建議遮罩 / results 搜尋或篩選結果
private enum SearchState {
    case idle
    case searching
    case results
}

// MARK: - CommunityDiscoveryView
struct CommunityDiscoveryView: View {
    @EnvironmentObject private var communityViewModel: CommunityViewModel
    @EnvironmentObject private var currentUser: CurrentUser
    @EnvironmentObject private var socialManager: SocialManager
    /// 強制全局唯一讀取：直接綁定單例，避免環境傳遞或錯誤實例
    @ObservedObject private var trackDataManager = TrackDataManager.shared
    @ObservedObject private var tabSelection = TabSelectionManager.shared
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchState: SearchState = .idle
    @State private var viewMode: CommunityViewMode = .grandJourneys
    @State private var showFilterSheet = false
    @State private var likeStates: [String: Bool] = [:]
    @State private var safeAreaTop: CGFloat = 59
    /// 暴力測試：點擊卡片強行綁定跳轉詳情
    @State private var selectedJourney: ManualJourney? = nil
    @State private var showDetail = false

    private var stickyHeaderHeight: CGFloat {
        safeAreaTop + stickyHeaderTitlePadding + stickyHeaderContentHeight
    }

    /// 三大板塊物理隔離：按 category 過濾後再投遞到對應 Tab。
    private var grandJourneyPublished: [DraftItem] {
        trackDataManager.publishedTracks.filter { $0.category == .grandJourney }
    }
    private var detailedTrackPublished: [DraftItem] {
        trackDataManager.publishedTracks.filter { $0.category == .detailedTrack }
    }
    private var livelyActivityPublished: [DraftItem] {
        trackDataManager.publishedTracks.filter { $0.category == .livelyActivity }
    }

    /// Grand Journeys 欄目：僅 .grandJourney，再疊加 mock。
    private var grandJourneyListForFilter: [GrandJourneyItem] {
        let fromPublished = grandJourneyPublished.enumerated().map { index, draft in
            grandJourneyItemFromDraft(draft, publishedIndex: index)
        }
        return fromPublished + mockGrandJourneys
    }

    private var filteredGrandJourneyList: [GrandJourneyItem] {
        communityViewModel.filteredJourneys(from: grandJourneyListForFilter)
    }

    private var grandJourneyListDataSource: [GrandJourneyItem] {
        switch searchState {
        case .idle, .searching: return grandJourneyListForFilter
        case .results: return filteredGrandJourneyList
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        Color.clear
                            .frame(height: stickyHeaderHeight)
                        Text("實時數據總數: \(trackDataManager.publishedTracks.count)")
                            .font(.caption)
                            .foregroundStyle(.blue)
                        if viewMode == .grandJourneys {
                            // Grand Journeys 欄目：僅 category == .grandJourney 的發布數據 + mock
                            ForEach(grandJourneyListDataSource, id: \.id) { item in
                                let author = CommunityAuthor(id: item.authorId, displayName: item.authorName, avatarURL: item.authorAvatarUrl)
                                let dynamicUser = socialManager.users[item.authorId]
                                let dynamicSubtitle = dynamicUser.map { "\($0.followersCount) followers" } ?? item.authorSubtitle
                                let isFollowing = dynamicUser?.isFollowing ?? item.isFollowing
                                ZStack(alignment: .topLeading) {
                                    NavigationLink(destination: communityDetailDestination(for: item)) {
                                        GrandJourneyCard(
                                            item: item,
                                            isFollowing: isFollowing,
                                            isLiked: currentUser.isLiked(postId: item.id),
                                            authorSubtitleOverride: dynamicUser.map { "\($0.followersCount) followers" },
                                            onFollowTap: {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                socialManager.toggleFollow(for: item.authorId, currentUserId: socialManager.currentUserId)
                                            },
                                            onLikeTap: { toggleLike(item.id) }
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .onAppear {
                                        socialManager.register(author: author, initialFollowersCount: Self.parseFollowersFromSubtitle(item.authorSubtitle))
                                    }
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
                                                Text(dynamicSubtitle)
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(CommunityColors.textMuted)
                                                    .contentTransition(.numericText())
                                            }
                                        }
                                        .padding(16)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else if viewMode == .detailedTracks {
                            // Detailed Tracks 欄目：僅 category == .detailedTrack 的發布數據 + mock
                            ForEach(detailedTrackPublished, id: \.id) { post in
                                VStack(alignment: .leading, spacing: 4) {
                                    CommunityCardView(draft: post)
                                }
                                .onTapGesture {
                                    selectedJourney = post.toManualJourney()
                                    showDetail = true
                                }
                            }
                            ForEach(mockDetailedTracks) { item in
                                let dtAuthor = CommunityAuthor(id: item.authorId, displayName: item.authorName, avatarURL: item.authorAvatarUrl)
                                let dtDynamicUser = socialManager.users[item.authorId]
                                let dtDynamicSubtitle = dtDynamicUser.map { "\($0.followersCount) followers" } ?? item.authorSubtitle
                                let dtIsFollowing = dtDynamicUser?.isFollowing ?? item.isFollowing
                                NavigationLink(destination: ManualJourneyDetailView(journey: zionManualJourneyMock)) {
                                    DetailedTrackCard(
                                        item: item,
                                        isFollowing: dtIsFollowing,
                                        isLiked: likeStates[item.id] ?? false,
                                        authorSubtitleOverride: dtDynamicSubtitle,
                                        onFollowTap: {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            socialManager.toggleFollow(for: item.authorId, currentUserId: socialManager.currentUserId)
                                        },
                                        onLikeTap: { toggleLike(item.id) }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    socialManager.register(author: dtAuthor, initialFollowersCount: Self.parseFollowersFromSubtitle(item.authorSubtitle))
                                }
                            }
                        } else {
                            // Live Activity 欄目：僅 category == .livelyActivity 的發布數據
                            if livelyActivityPublished.isEmpty {
                                liveActivityEmptyState
                            } else {
                                ForEach(livelyActivityPublished, id: \.id) { post in
                                    VStack(alignment: .leading, spacing: 4) {
                                        CommunityCardView(draft: post)
                                    }
                                    .onTapGesture {
                                        selectedJourney = post.toManualJourney()
                                        showDetail = true
                                    }
                                }
                                .id(livelyActivityPublished.count)
                            }
                        }
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                    .opacity(viewMode == .grandJourneys && searchState == .searching ? 0.9 : 1)
                }
                .scrollContentBackground(.hidden)
                .background(CommunityColors.background.ignoresSafeArea(edges: .all))
                .animation(.easeInOut(duration: 0.25), value: searchState)
                .navigationBarHidden(true)

                // Search overlay when .searching
                if searchState == .searching && viewMode == .grandJourneys {
                    searchSuggestionsOverlay
                }

                stickyHeaderOverlay
                helpFAB
            }
            .background(GeometryReader { g in
                Color.clear.preference(key: SafeAreaTopKey.self, value: g.safeAreaInsets.top)
            })
            .onPreferenceChange(SafeAreaTopKey.self) { newTop in
                if abs(safeAreaTop - newTop) > 0.5 { safeAreaTop = newTop }
            }
            .sheet(isPresented: $showDetail) {
                if let j = selectedJourney {
                    ManualJourneyDetailView(journey: j)
                        .onDisappear {
                            showDetail = false
                            selectedJourney = nil
                        }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                CommunityFilterSheet(viewMode: viewMode, filterState: $communityViewModel.filterState)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .onChange(of: communityViewModel.searchText) { _, _ in syncSearchState() }
            .onChange(of: isSearchFieldFocused) { _, _ in syncSearchState() }
            .onChange(of: tabSelection.selectedTabIndex) { _, newIndex in
                // 切到 Community (index 3) 且是發布後跳轉時，強制顯示 Live Activity 分頁（避免只觸發 onAppear 時漏掉）
                if newIndex == 3 && tabSelection.shouldOpenCommunityOnLiveActivity {
                    viewMode = .liveActivity
                    tabSelection.shouldOpenCommunityOnLiveActivity = false
                }
            }
            .onAppear {
                if TabSelectionManager.shared.shouldOpenCommunityOnLiveActivity {
                    viewMode = .liveActivity
                    TabSelectionManager.shared.shouldOpenCommunityOnLiveActivity = false
                }
                trackDataManager.reloadFromStore()
            }
            .onChange(of: showFilterSheet) { _, isShowing in
                if !isShowing { syncSearchState() }
            }
        }
    }

    /// Sync searchState from query, focus, filter; .results only when unfocused or after tapping suggestion.
    private func syncSearchState() {
        let trimmed = communityViewModel.searchText.trimmingCharacters(in: .whitespaces)
        let hasSearch = !trimmed.isEmpty
        let hasFilter = communityViewModel.hasActiveFilter
        let newState: SearchState
        if (hasSearch || hasFilter) && !isSearchFieldFocused {
            newState = .results
        } else if isSearchFieldFocused {
            newState = .searching
        } else {
            newState = .idle
        }
        if searchState != newState {
            withAnimation(.easeInOut(duration: 0.25)) { searchState = newState }
            if newState == .results, !trimmed.isEmpty {
                communityViewModel.saveSearchQuery(trimmed)
            }
        }
    }

    /// Sticky header: material + opaque; height aligned with Route (safeArea + 16pt)
    private var liveActivityEmptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "map.circle")
                .font(.system(size: 56))
                .foregroundStyle(CommunityColors.textMuted.opacity(0.8))
            Text("No activities yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(CommunityColors.textPrimary)
            Text("Record a route in Community, then publish. Your posts will show here.")
                .font(.system(size: 14))
                .foregroundStyle(CommunityColors.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

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

    /// Header content: title 16pt below safe area, aligned with Route Discovery
    private var stickyHeaderContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                Text("Community")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(CommunityColors.textPrimary)
                Spacer(minLength: 8)
                NavigationLink(destination: CreateRouteFlowView()) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(CommunityColors.textPrimary)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            segmentedControl
            searchAndFilterRow
        }
        .padding(.horizontal, 20)
        .padding(.top, safeAreaTop + stickyHeaderTitlePadding)
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var searchPlaceholderForMode: String {
        switch viewMode {
        case .grandJourneys: return "Search journeys by name, location, or keywords..."
        case .detailedTracks: return "Search tracks by name, trail, or activity..."
        case .liveActivity: return "Search activities by route or location..."
        }
    }

    /// 可滑動標籤欄：三分類不擠，小屏可橫向滾動
    private var segmentedControl: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CommunityViewMode.allCases, id: \.self) { mode in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { viewMode = mode }
                    } label: {
                        Text(mode.rawValue)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(viewMode == mode ? CommunityColors.background : CommunityColors.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewMode == mode ? CommunityColors.segmentSelected : Color.clear)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(3)
        }
        .background(CommunityColors.segmentBg)
        .clipShape(Capsule())
    }

    private var searchAndFilterRow: some View {
        HStack(spacing: 12) {
            Button {
                showFilterSheet = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18))
                    .foregroundStyle(CommunityColors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(CommunityColors.segmentBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundStyle(CommunityColors.searchPlaceholder)
                ZStack(alignment: .leading) {
                    if communityViewModel.searchText.isEmpty {
                        Text(searchPlaceholderForMode)
                            .font(.system(size: 15))
                            .foregroundStyle(CommunityColors.searchPlaceholder)
                    }
                    TextField("", text: $communityViewModel.searchText)
                        .font(.system(size: 15))
                        .foregroundStyle(CommunityColors.textPrimary)
                        .focused($isSearchFieldFocused)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(CommunityColors.searchBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            if isSearchFieldFocused {
                Button("Cancel") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isSearchFieldFocused = false
                        communityViewModel.searchText = ""
                        searchState = .idle
                    }
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(CommunityColors.accentGreen)
                .buttonStyle(.plain)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSearchFieldFocused)
    }

    /// 熱門搜尋 Mock（膠囊標籤，點擊填入並執行）
    private static let trendingSearches = ["Utah Mighty 5", "California Coast", "Solo Winter Trip", "Off-road"]

    /// 推薦行程：全量中按點讚數取前 3，用於建議層小卡片
    private var recommendedJourneys: [GrandJourneyItem] {
        Array(grandJourneyListForFilter.sorted { $0.likeCount > $1.likeCount }.prefix(3))
    }

    /// 聯想詞庫：從所有行程的標題、地點、標籤拆成單詞/短語，去重後供前綴匹配
    private var searchKeywordBank: [String] {
        var tokens: [String] = []
        for item in grandJourneyListForFilter {
            tokens.append(item.title)
            tokens.append(contentsOf: item.waypoints)
            tokens.append(contentsOf: item.tags)
        }
        let split = CharacterSet.whitespaces.union(CharacterSet(charactersIn: ","))
        let words = tokens
            .flatMap { $0.components(separatedBy: split) }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { $0.count >= 2 }
        var seen = Set<String>()
        return words.filter { seen.insert($0.lowercased()).inserted }.sorted()
    }

    /// 預測詞清單：僅顯示與 searchText 開頭匹配的單詞/短語（前綴匹配）
    private var searchSuggestionsFromKeywords: [String] {
        let q = communityViewModel.searchText.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return [] }
        return searchKeywordBank
            .filter { $0.lowercased().hasPrefix(q) }
            .prefix(20)
            .map { $0 }
    }

    /// 搜尋建議遮罩：全域可滾動；有輸入時顯示聯想清單，無輸入時顯示 Recent / Trending / Recommended；鍵盤聯動收起。
    private var searchSuggestionsOverlay: some View {
        ZStack {
            CommunityColors.background.opacity(0.97)
                .ignoresSafeArea(edges: .bottom)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: stickyHeaderHeight)
                    VStack(alignment: .leading, spacing: 12) {
                        if !communityViewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                            autocompleteSection
                        } else {
                            if !communityViewModel.recentSearches.isEmpty {
                                recentSectionHeader
                                VStack(spacing: 0) {
                                    ForEach(Array(communityViewModel.recentSearches.enumerated()), id: \.element) { index, query in
                                        recentSearchRow(query: query, index: index)
                                    }
                                }
                                .background(CommunityColors.cardBg)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            sectionTitle("Trending Now")
                            trendingChipsSection
                            sectionTitle("Recommended")
                            recommendedSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                    Spacer(minLength: 50)
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .zIndex(0.5)
        .onAppear {
            communityViewModel.refreshRecentSearches()
        }
    }

    /// 預測詞清單：前綴匹配的單詞/短語，magnifyingglass + 文字；點擊後填入搜尋框並執行行程列表搜尋、隱藏清單。
    private var autocompleteSection: some View {
        let suggestions = searchSuggestionsFromKeywords
        return Group {
            if suggestions.isEmpty {
                Text("No suggestions")
                    .font(.system(size: 15))
                    .foregroundStyle(CommunityColors.textMuted)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(suggestions, id: \.self) { word in
                            Button {
                                communityViewModel.searchText = word
                                communityViewModel.saveSearchQuery(word)
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    isSearchFieldFocused = false
                                    searchState = .results
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 16))
                                        .foregroundStyle(CommunityColors.textMuted)
                                        .frame(width: 24, alignment: .center)
                                    Text(word)
                                        .font(.system(size: 15))
                                        .foregroundStyle(CommunityColors.textPrimary)
                                        .lineLimit(1)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxHeight: 280)
                .scrollIndicators(.hidden)
            }
        }
        .background(CommunityColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    /// 標題中匹配關鍵字的部分用 accentGreen，其餘白色
    @ViewBuilder
    private func highlightTitleLabel(title: String, query: String) -> some View {
        let q = query.lowercased()
        let t = title
        if q.isEmpty {
            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(CommunityColors.textPrimary)
                .lineLimit(1)
        } else if let range = t.lowercased().range(of: q) {
            let before = String(t[..<range.lowerBound])
            let match = String(t[range])
            let after = String(t[range.upperBound...])
            (Text(before).font(.system(size: 15)).foregroundStyle(CommunityColors.textPrimary)
                + Text(match).font(.system(size: 15, weight: .semibold)).foregroundStyle(CommunityColors.accentGreen)
                + Text(after).font(.system(size: 15)).foregroundStyle(CommunityColors.textPrimary))
                .lineLimit(1)
        } else {
            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(CommunityColors.textPrimary)
                .lineLimit(1)
        }
    }

    /// 區塊一：標題「Recent」+ 右側「Clear All」按鈕
    private var recentSectionHeader: some View {
        HStack {
            Text("Recent")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(CommunityColors.textMuted)
            Spacer(minLength: 0)
            Button {
                communityViewModel.clearAllSearchHistory()
            } label: {
                Text("Clear All")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(CommunityColors.textMuted)
            .padding(.top, 20)
            .padding(.bottom, 8)
    }

    private var recommendedSection: some View {
        VStack(spacing: 10) {
            ForEach(recommendedJourneys) { item in
                Button {
                    communityViewModel.searchText = item.title
                    communityViewModel.saveSearchQuery(item.title)
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isSearchFieldFocused = false
                        searchState = .results
                    }
                } label: {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: item.imageUrl)) { phase in
                            switch phase {
                            case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                            case .failure, .empty: Color.gray.opacity(0.3)
                            @unknown default: Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text(item.title)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(CommunityColors.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(CommunityColors.textMuted)
                    }
                    .padding(12)
                    .background(CommunityColors.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var trendingChipsSection: some View {
        FlowLayout(spacing: 8) {
            ForEach(Self.trendingSearches, id: \.self) { term in
                Button {
                    communityViewModel.searchText = term
                    communityViewModel.saveSearchQuery(term)
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isSearchFieldFocused = false
                        searchState = .results
                    }
                } label: {
                    Text(term)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(CommunityColors.textPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(CommunityColors.cardBg)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
    }

    private func recentSearchRow(query: String, index: Int) -> some View {
        HStack(spacing: 12) {
            Button {
                communityViewModel.searchText = query
                communityViewModel.saveSearchQuery(query)
                withAnimation(.easeInOut(duration: 0.25)) {
                    isSearchFieldFocused = false
                    searchState = .results
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 16))
                        .foregroundStyle(CommunityColors.textMuted)
                        .frame(width: 24, alignment: .center)
                    Text(query)
                        .font(.system(size: 15))
                        .foregroundStyle(CommunityColors.textPrimary)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Button {
                communityViewModel.removeSearchQuery(at: index)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(CommunityColors.textMuted)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
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

    private func toggleLike(_ id: String) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        currentUser.toggleLike(postId: id)
    }

    /// 從 "339 followers" 解析出 339，用於列表 onAppear 時註冊作者初始粉絲數。
    private static func parseFollowersFromSubtitle(_ subtitle: String) -> Int {
        Int(subtitle.split(separator: " ").first ?? Substring("")) ?? 0
    }

    /// Tap Grand Journey card: published_* 來自 grandJourneyPublished → 宏觀用 Itinerary View（CommunityMacroDetailView），id "1" Sarah mock；其餘 placeholder。
    @ViewBuilder
    private func communityDetailDestination(for item: GrandJourneyItem) -> some View {
        if item.id.hasPrefix("published_"), let idx = Int(item.id.replacingOccurrences(of: "published_", with: "")),
           idx >= 0, idx < grandJourneyPublished.count {
            let draft = grandJourneyPublished[idx]
            CommunityMacroDetailView(journey: communityJourneyFromDraft(draft), journeyId: item.id, coverImageData: draft.coverImageData)
        } else if item.id == "1" {
            CommunityMacroDetailView(journey: Self.sarahChenUtahCommunityJourney, journeyId: item.id)
        } else {
            CommunityMacroDetailView(journey: Self.placeholderCommunityJourney(for: item), journeyId: item.id)
        }
    }

    /// 將發布的 Grand Journey DraftItem 轉為 CommunityJourney，供 Itinerary View（CommunityMacroDetailView）使用；waypoints 對應行程單日數。
    private func communityJourneyFromDraft(_ draft: DraftItem) -> CommunityJourney {
        let days = draft.waypoints.enumerated().map { index, w in
            CommunityJourneyDay(
                dayNumber: index + 1,
                location: CommunityGeoLocation(latitude: w.latitude, longitude: w.longitude),
                locationName: nil,
                dateString: nil,
                notes: nil,
                photoURL: nil,
                recommendedStay: nil,
                hasWater: nil,
                hasFuel: nil,
                signalStrength: nil
            )
        }
        return CommunityJourney(
            journeyName: draft.title.isEmpty ? "Published Journey" : draft.title,
            days: days.isEmpty ? [CommunityJourneyDay(dayNumber: 1, location: nil, locationName: nil, notes: "No waypoints.")] : days,
            selectedStates: [],
            duration: nil,
            vehicle: nil,
            pace: nil,
            difficulty: nil,
            tags: nil,
            state: "",
            author: CommunityAuthor(id: "me", displayName: "Me", avatarURL: nil),
            likeCount: 0,
            commentCount: 0,
            coverImageURL: nil,
            aspectRatio: 16.0 / 10.0
        )
    }

    /// Map DraftItem (from TrackDataManager.publishedTracks) to GrandJourneyItem for list; id "published_<index>" for detail lookup.
    private func grandJourneyItemFromDraft(_ draft: DraftItem, publishedIndex: Int) -> GrandJourneyItem {
        let miles = draft.totalDistanceMeters / 1609.34
        let mileageText = miles >= 0.1 ? String(format: "%.1f mi", miles) : "—"
        return GrandJourneyItem(
            id: "published_\(publishedIndex)",
            authorId: "me",
            authorName: "Me",
            authorSubtitle: "Just published",
            authorAvatarUrl: nil,
            isFollowing: false,
            imageUrl: "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800",
            days: 1,
            label: "LIVE RECORD",
            title: draft.title,
            mileage: mileageText,
            vehicle: "",
            waypoints: [],
            likeCount: 0,
            commentCount: 0,
            stateIds: [],
            tags: [],
            createdAt: draft.createdAt
        )
    }

    /// Map CommunityJourney to GrandJourneyItem (for legacy/mock flow).
    private func grandJourneyItem(from journey: CommunityJourney, publishedIndex: Int) -> GrandJourneyItem {
        let imageUrl = journey.days.first?.photoURL ?? "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"
        let stateIds = journey.selectedStates.map { Self.stateNameToId($0) }
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
            commentCount: journey.commentCount,
            stateIds: stateIds.isEmpty ? [] : stateIds,
            tags: [],
            createdAt: Date()
        )
    }

    /// Filter Region: state name -> id (e.g. Utah -> ut)
    private static func stateNameToId(_ name: String) -> String {
        let map: [String: String] = [
            "Utah": "ut", "California": "ca", "Montana": "mt", "Wyoming": "wy", "Washington": "wa", "Oregon": "or",
            "Colorado": "co", "Arizona": "az", "Nevada": "nv", "Idaho": "id", "Alaska": "ak", "Texas": "tx"
        ]
        return map[name] ?? name.prefix(2).lowercased()
    }

    /// Sarah Chen "Ultimate Utah Mighty 5 Loop" detail mock: 7 days, SUV, 3 parks; Day 2 low signal, no water/fuel.
    private static let sarahChenUtahCommunityJourney = CommunityJourney(
        journeyName: "The Ultimate Utah Mighty 5 Loop",
        days: [
            CommunityJourneyDay(
                dayNumber: 1,
                location: CommunityGeoLocation(latitude: 38.7331, longitude: -109.5925),
                locationName: "Arches National Park",
                notes: "Day one from Moab. Don’t miss sunset at Delicate Arch—bring a headlamp; it gets dark fast on the way back.",
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
                notes: "Stunning canyon views. Shafer Trail is demanding—use low gear. No services in the backcountry.",
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
                notes: "Drive UT-24—scenery like Mars. The pie here is famous; grab one at Gifford House.",
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
        difficulty: "Moderate",
        tags: ["Utah", "7 Days", "SUV", "Moderate", "Difficulty · Moderate", "Mighty 5"],
        state: "Utah",
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
            difficulty: nil,
            tags: nil,
            state: "",
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
    var authorSubtitleOverride: String? = nil
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
                        Text(authorSubtitleOverride ?? item.authorSubtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(CommunityColors.textMuted)
                            .contentTransition(.numericText())
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

// MARK: - CommunityCardView (Template A: Hero 封面、標題、橫向儀表盤 km/m/min、天氣與地點)
private struct CommunityCardView: View {
    let draft: DraftItem

    private var distanceKm: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "0 km" : String(format: "%.2f km", km)
    }
    private var elevationM: String {
        let m = draft.elevationGainMeters
        return m < 1 ? "0 m" : String(format: "%.0f m", m)
    }
    private var durationMin: String {
        guard let sec = draft.durationSeconds, sec >= 0 else { return "— min" }
        let min = Int(sec / 60)
        return "\(min) min"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                if let coverData = draft.coverImageData, let uiImage = UIImage(data: coverData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } else {
                    CommunityCardViewHeroThumbnail(draft: draft)
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                }
                LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 180)
                VStack(alignment: .leading, spacing: 6) {
                    Text(draft.title.isEmpty ? "Recorded Route" : draft.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2)
                        .lineLimit(2)
                    if let loc = draft.locationName, !loc.isEmpty {
                        HStack(spacing: 5) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                            Text(loc)
                                .font(.system(size: 13))
                        }
                        .foregroundStyle(.white.opacity(0.95))
                    }
                }
                .padding(14)
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 20) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.triangle.swap")
                        .font(.system(size: 14))
                        .foregroundStyle(CommunityColors.accentGreen)
                    Text(distanceKm)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundStyle(CommunityColors.textPrimary)
                }
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 14))
                        .foregroundStyle(CommunityColors.accentGreen)
                    Text(elevationM)
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundStyle(CommunityColors.textMuted)
                }
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(CommunityColors.accentGreen)
                    Text(durationMin)
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundStyle(CommunityColors.textMuted)
                }
                Spacer(minLength: 0)
                if let weather = draft.currentWeather, !weather.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 14))
                        Text(weather)
                            .font(.system(size: 12))
                            .lineLimit(1)
                    }
                    .foregroundStyle(CommunityColors.textMuted)
                }
                if let facilities = draft.nearbyFacilities, !facilities.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 14))
                        Text(facilities.prefix(2).joined(separator: ", "))
                            .font(.system(size: 12))
                            .lineLimit(1)
                    }
                    .foregroundStyle(CommunityColors.textMuted)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(CommunityColors.cardBg)
        }
        .background(CommunityColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.06), lineWidth: 1))
    }
}

private struct CommunityCardViewHeroThumbnail: View {
    let draft: DraftItem
    var body: some View {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        Group {
            if coords.count >= 2 {
                Map(initialPosition: .region(region), interactionModes: []) {
                    MapPolyline(coordinates: coords)
                        .stroke(CommunityColors.accentGreen, lineWidth: 4)
                }
                .mapStyle(.standard(elevation: .flat))
            } else {
                Rectangle()
                    .fill(CommunityColors.cardBg)
                Image(systemName: "map")
                    .font(.system(size: 40))
                    .foregroundStyle(CommunityColors.textMuted.opacity(0.5))
            }
        }
    }
    private var region: MKCoordinateRegion {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: max(0.01, (maxLat - minLat) * 1.5 + 0.005), longitudeDelta: max(0.01, (maxLon - minLon) * 1.5 + 0.005))
        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - DetailedTrackCard（與 GrandJourneyCard 圓角、圖片比例、頭部一致）
struct DetailedTrackCard: View {
    let item: DetailedTrackItem
    let isFollowing: Bool
    let isLiked: Bool
    var authorSubtitleOverride: String? = nil
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
                Text(authorSubtitleOverride ?? item.authorSubtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(CommunityColors.textMuted)
                    .contentTransition(.numericText())
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

// MARK: - ActivityCard（輕量紀錄：無 heroImage，背景為小型靜態地圖 + Polyline，突出里程/耗時/天氣）
private func regionForCoordinates(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
    guard !coords.isEmpty else {
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    var minLat = coords[0].latitude, maxLat = minLat
    var minLon = coords[0].longitude, maxLon = minLon
    for c in coords.dropFirst() {
        minLat = min(minLat, c.latitude); maxLat = max(maxLat, c.latitude)
        minLon = min(minLon, c.longitude); maxLon = max(maxLon, c.longitude)
    }
    let padding = 0.008
    let center = CLLocationCoordinate2D(
        latitude: (minLat + maxLat) / 2,
        longitude: (minLon + maxLon) / 2
    )
    let span = MKCoordinateSpan(
        latitudeDelta: max((maxLat - minLat) + padding, 0.012),
        longitudeDelta: max((maxLon - minLon) + padding, 0.012)
    )
    return MKCoordinateRegion(center: center, span: span)
}

struct ActivityCard: View {
    let item: LiveActivityItem
    let isFollowing: Bool
    let isLiked: Bool
    var authorSubtitleOverride: String? = nil
    let onFollowTap: () -> Void
    let onLikeTap: () -> Void
    let onConvertToProGuide: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            activityCardHeader
            mapBackgroundSection
            activityStatsRow
            activityActionBar
            convertToProGuideButton
        }
        .background(CommunityColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: grandCardCorner))
        .overlay(
            RoundedRectangle(cornerRadius: grandCardCorner)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private var activityCardHeader: some View {
        HStack(alignment: .center, spacing: 12) {
            Color.clear.frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.authorName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(CommunityColors.textPrimary)
                Text(authorSubtitleOverride ?? item.authorSubtitle)
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

    /// 小型靜態地圖 + 用戶紀錄 Polyline，無 heroImage
    private var mapBackgroundSection: some View {
        let region = regionForCoordinates(item.polylineCoordinates)
        return ZStack(alignment: .bottomLeading) {
            Map(initialPosition: .region(region), interactionModes: []) {
                MapPolyline(coordinates: item.polylineCoordinates)
                    .stroke(CommunityColors.accentGreen, lineWidth: 4)
            }
            .frame(height: 160)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 0))

            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 160)
            .allowsHitTesting(false)

            Text(item.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .padding(16)
        }
        .frame(height: 160)
    }

    /// 突出顯示：里程、耗時、當前天氣狀態
    private var activityStatsRow: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(CommunityColors.accentGreen)
                Text(item.mileage)
                    .font(grandCardMonoSmall)
                    .foregroundStyle(CommunityColors.textPrimary)
            }
            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(CommunityColors.accentGreen)
                Text(item.duration)
                    .font(grandCardMonoSmall)
                    .foregroundStyle(CommunityColors.textPrimary)
            }
            HStack(spacing: 4) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(CommunityColors.accentGreen)
                Text(item.weatherStatus)
                    .font(grandCardMonoSmall)
                    .foregroundStyle(CommunityColors.textPrimary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(CommunityColors.cardBg)
    }

    private var activityActionBar: some View {
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
        .padding(.vertical, 10)
        .background(CommunityColors.cardBg)
    }

    /// 引導用戶將原生軌跡美化為精選路線
    private var convertToProGuideButton: some View {
        Button(action: onConvertToProGuide) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                Text("Convert to Pro Guide")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(CommunityColors.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(CommunityColors.accentGreen)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
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
                selectedStateIds = []
                selectedTerrains = []
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

// MARK: - Community Filter Sheet (Grand Journey 使用 ViewModel.filterState，與搜尋並行)
struct CommunityFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    fileprivate var viewMode: CommunityViewMode = .grandJourneys
    @Binding var filterState: CommunityFilterState

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
                } else if viewMode == .liveActivity {
                    liveActivityFilterPlaceholder
                } else {
                    GrandJourneyFilterView(
                        selectedStateIds: Binding(
                            get: { filterState.selectedStateIds },
                            set: { filterState.selectedStateIds = $0 }
                        ),
                        selectedTerrains: Binding(
                            get: { filterState.selectedTerrains },
                            set: { filterState.selectedTerrains = $0 }
                        ),
                        selectedDuration: Binding(
                            get: { filterState.selectedDuration },
                            set: { filterState.selectedDuration = $0 }
                        )
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

    private var liveActivityFilterPlaceholder: some View {
        VStack(spacing: 12) {
            Text("Live Activity")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(CommunityColors.textPrimary)
            Text("Filters for lightweight records can be added here.")
                .font(.system(size: 14))
                .foregroundStyle(CommunityColors.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CommunityColors.background)
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

#Preview { CommunityDiscoveryView().environmentObject(CommunityViewModel()).environmentObject(CurrentUser()).environmentObject(SocialManager()).environmentObject(TrackDataManager.shared) }
