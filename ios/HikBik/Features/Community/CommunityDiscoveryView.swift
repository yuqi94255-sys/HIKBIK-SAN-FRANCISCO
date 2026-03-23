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
    /// 多圖輪播 URL 數組；為空時卡片用 imageUrl 單圖，有值時與 PostMediaStore 一起驅動輪播
    let imageUrls: [String]?
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

// MARK: - Detailed Track Model（支援輪播 imageUrls；isLiked/isSaved 由 CurrentUser 同步）
struct DetailedTrackItem: Identifiable {
    let id: String
    let authorId: String
    let authorName: String
    let authorSubtitle: String
    let authorAvatarUrl: String?
    let isFollowing: Bool
    /// 多圖輪播（至少 1 張）；列表卡片用 TabView 展示
    let imageUrls: [String]
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

extension DetailedTrackItem {
    /// 用於卡片底部 Duration 標籤；模型暫無 duration 時顯示佔位
    var durationDisplay: String { "— min" }
}

// MARK: - 真實示範數據（僅保留 Sarah Utah；CurrentUser 的「New York」來自 published_*）
private let mockGrandJourneys: [GrandJourneyItem] = [
    GrandJourneyItem(
        id: "1",
        authorId: "sarah-chen",
        authorName: "Sarah Chen",
        authorSubtitle: "339 followers",
        authorAvatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
        isFollowing: false,
        imageUrl: "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800",
        imageUrls: nil,
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
]

/// 模擬 Zion - Angel's Landing 詳情頁數據（含社交屬性、輪播 3 圖，routeID 與 mockDetailedTracks 的 id 前綴一致）
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
    heroImages: [
        "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
        "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800",
        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
    ],
    routeID: "zion-angels-landing-001"
)

/// 無實時後端數據時為空；Live Activity 分頁僅顯示用戶本地已發布之 Lively Activity。
private let mockLiveActivities: [LiveActivityItem] = []

/// 真實示範：Jessica Martinez「Angels Landing Summit」，id 與 zionManualJourneyMock.routeID 一致以便 Profile Saved 跳轉與 Like/Save 同步。
private let mockDetailedTracks: [DetailedTrackItem] = [
    DetailedTrackItem(
        id: "track_zion-angels-landing-001",
        authorId: "jessica-martinez",
        authorName: "Jessica Martinez",
        authorSubtitle: "427 followers",
        authorAvatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200",
        isFollowing: true,
        imageUrls: [
            "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
            "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800",
            "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
        ],
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
    @EnvironmentObject private var postCommentStore: PostCommentStore
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
    @State private var navigateToCreateFlow = false

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

    /// 微觀篩選是否啟用（任一條件有選即過濾列表）
    private var hasDetailedFilterActive: Bool {
        let s = communityViewModel.filterState
        return s.detailedTrackMainType != nil || !s.selectedLandManagers.isEmpty || !s.selectedUrbanCategories.isEmpty || !s.selectedActivities.isEmpty || s.selectedDurationMicro != nil
    }

    private var filteredDetailedTrackPublished: [DraftItem] {
        detailedTrackPublished.filter { draft in matchesDetailedFilter(draft, communityViewModel.filterState) }
    }

    private var detailedTrackListDataSource: [DraftItem] {
        (searchState == .results && hasDetailedFilterActive) ? filteredDetailedTrackPublished : detailedTrackPublished
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        Color.clear
                            .frame(height: stickyHeaderHeight)
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
                                            isSaved: currentUser.isSaved(postId: item.id),
                                            displayLikeCount: item.likeCount + (currentUser.isLiked(postId: item.id) ? 1 : 0),
                                            displayCommentCount: item.commentCount + postCommentStore.commentCount(for: item.id),
                                            authorSubtitleOverride: dynamicUser.map { "\($0.followersCount) followers" },
                                            onFollowTap: {
                                                AuthGuard.run(message: AuthGuardMessages.followUser) {
                                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                    socialManager.toggleFollow(for: item.authorId, currentUserId: socialManager.currentUserId)
                                                }
                                            },
                                            onLikeTap: { toggleLike(item.id) },
                                            onSaveTap: { toggleSave(item.id) }
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
                            // Detailed Tracks 欄目：依篩選狀態顯示 detailedTrackListDataSource 或全量
                            ForEach(detailedTrackListDataSource, id: \.id) { post in
                                let detailedTrackPostId = "track_\(post.routeID)"
                                let isLikedDt = currentUser.isLiked(postId: detailedTrackPostId)
                                VStack(alignment: .leading, spacing: 4) {
                                    CommunityCardView(
                                        draft: post,
                                        authorDisplayName: "Me",
                                        authorSubtitle: "My post",
                                        likeCount: 0 + (isLikedDt ? 1 : 0),
                                        commentCount: postCommentStore.commentCount(for: detailedTrackPostId),
                                        isLiked: isLikedDt,
                                        isSaved: currentUser.isSaved(postId: detailedTrackPostId),
                                        onLikeTap: { toggleLike(detailedTrackPostId) },
                                        onSaveTap: { toggleSave(detailedTrackPostId) }
                                    )
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
                                        isLiked: currentUser.isLiked(postId: item.id),
                                        isSaved: currentUser.isSaved(postId: item.id),
                                        displayLikeCount: item.likeCount + (currentUser.isLiked(postId: item.id) ? 1 : 0),
                                        displayCommentCount: item.commentCount + postCommentStore.commentCount(for: item.id),
                                        authorSubtitleOverride: dtDynamicSubtitle,
                                        onFollowTap: {
                                            AuthGuard.run(message: AuthGuardMessages.followUser) {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                socialManager.toggleFollow(for: item.authorId, currentUserId: socialManager.currentUserId)
                                            }
                                        },
                                        onLikeTap: { toggleLike(item.id) },
                                        onSaveTap: { toggleSave(item.id) }
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
                                    let postIdLive = post.id.uuidString
                                    let isLikedLive = currentUser.isLiked(postId: postIdLive)
                                    VStack(alignment: .leading, spacing: 4) {
                                        CommunityCardView(
                                            draft: post,
                                            authorDisplayName: "Me",
                                            authorSubtitle: "My post",
                                            likeCount: 0 + (isLikedLive ? 1 : 0),
                                            commentCount: postCommentStore.commentCount(for: postIdLive),
                                            isLiked: isLikedLive,
                                            isSaved: currentUser.isSaved(postId: postIdLive),
                                            onLikeTap: { toggleLike(postIdLive) },
                                            onSaveTap: { toggleSave(postIdLive) }
                                        )
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
            .onAppear {
                // Sarah Chen (id "1") 輪播效果：Utah Mighty 5 三張圖
                if PostMediaStore.shared.imageUrls(for: "1") == nil {
                    let sarahImageUrls = [
                        "https://images.unsplash.com/photo-1504192010706-96946577af45",
                        "https://images.unsplash.com/photo-1516939884455-1445c8652f83",
                        "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"
                    ]
                    PostMediaStore.shared.setImageUrls(id: "1", urls: sarahImageUrls)
                }
                // Jessica Martinez Detailed Track (track_zion-angels-landing-001) 輪播，與列表/詳情一致
                if PostMediaStore.shared.imageUrls(for: "track_zion-angels-landing-001") == nil {
                    let zionImageUrls = [
                        "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
                        "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800",
                        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
                    ]
                    PostMediaStore.shared.setImageUrls(id: "track_zion-angels-landing-001", urls: zionImageUrls)
                }
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
                CommunityFilterSheet(
                    viewMode: viewMode,
                    filterState: $communityViewModel.filterState,
                    grandJourneyItems: grandJourneyListForFilter,
                    communityViewModel: communityViewModel,
                    detailedTrackItems: detailedTrackPublished,
                    onApplyDetailedFilter: { mainType, land, urban, act, dur in
                        var s = communityViewModel.filterState
                        s.detailedTrackMainType = mainType
                        s.selectedLandManagers = land
                        s.selectedUrbanCategories = urban
                        s.selectedActivities = act
                        s.selectedDurationMicro = dur
                        communityViewModel.filterState = s
                    }
                )
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
            .onReceive(NotificationCenter.default.publisher(for: .postDeleted)) { _ in
                withAnimation(.easeOut(duration: 0.25)) {
                    trackDataManager.reloadFromStore()
                }
            }
            .onChange(of: showFilterSheet) { _, isShowing in
                if !isShowing { syncSearchState() }
            }
            .navigationDestination(isPresented: $navigateToCreateFlow) {
                CreateRouteFlowView()
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
            Text("No live activities right now")
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
                Button {
                    AuthGuard.run(message: AuthGuardMessages.publishPost) {
                        navigateToCreateFlow = true
                    }
                } label: {
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
        AuthGuard.run(message: AuthGuardMessages.likePost) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            currentUser.toggleLike(postId: id)
        }
    }

    private func toggleSave(_ id: String) {
        AuthGuard.run(message: AuthGuardMessages.collectRoute) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            currentUser.toggleSave(postId: id)
        }
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
            CommunityMacroDetailView(journey: draft.communityJourneyForMacroDetail(), journeyId: item.id, coverImageData: draft.coverImageData)
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

    /// Map DraftItem (from TrackDataManager.publishedTracks) to GrandJourneyItem for list; id "published_<index>" for detail lookup。Days 取 itinerary 真實數量；封面圖優先 PostMediaStore 再 draft。
    private func grandJourneyItemFromDraft(_ draft: DraftItem, publishedIndex: Int) -> GrandJourneyItem {
        let miles = draft.totalDistanceMeters / 1609.34
        let mileageText = miles >= 0.1 ? String(format: "%.1f mi", miles) : "—"
        let postId = "published_\(publishedIndex)"
        let dayCount: Int = {
            if let json = draft.macroJourneyJSON, let data = json.data(using: .utf8),
               let post = try? JSONDecoder().decode(MacroJourneyPost.self, from: data) {
                return max(1, post.days.count)
            }
            return max(1, draft.waypoints.count)
        }()
        let fallbackImage = "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"
        let imageUrls = PostMediaStore.shared.imageUrls(for: postId)
        let imageUrl = imageUrls?.first ?? fallbackImage
        return GrandJourneyItem(
            id: postId,
            authorId: "me",
            authorName: "Me",
            authorSubtitle: "Just published",
            authorAvatarUrl: nil,
            isFollowing: false,
            imageUrl: imageUrl,
            imageUrls: imageUrls,
            days: dayCount,
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

    /// Map CommunityJourney to GrandJourneyItem (for legacy/mock flow)。Days 用 itinerary.count；多圖用 journey.imageUrls。
    private func grandJourneyItem(from journey: CommunityJourney, publishedIndex: Int) -> GrandJourneyItem {
        let fallback = "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"
        let imageUrls = journey.imageUrls
        let imageUrl = imageUrls?.first ?? journey.coverImageURL ?? journey.days.first?.photoURL ?? fallback
        let stateIds = journey.selectedStates.map { Self.stateNameToId($0) }
        return GrandJourneyItem(
            id: "published_\(publishedIndex)",
            authorId: journey.author?.id ?? "guest",
            authorName: journey.author?.displayName ?? "Guest",
            authorSubtitle: "Just published",
            authorAvatarUrl: journey.author?.avatarURL,
            isFollowing: false,
            imageUrl: imageUrl,
            imageUrls: imageUrls,
            days: max(1, journey.days.count),
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
    var isSaved: Bool = false
    /// 樂觀 like 數：item.likeCount + (isLiked ? 1 : 0)
    var displayLikeCount: Int? = nil
    /// 評論數：item.commentCount + PostCommentStore 增量
    var displayCommentCount: Int? = nil
    var authorSubtitleOverride: String? = nil
    let onFollowTap: () -> Void
    let onLikeTap: () -> Void
    var onSaveTap: (() -> Void)? = nil

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

    /// 沉浸式圖片：多圖用輪播，單圖靜態；3:2 比例，底部漸變 + 標題與數據。優先 item.imageUrls，再 PostMediaStore，再 item.imageUrl。
    private var imageSection: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = w * 2 / 3
            let urls = (item.imageUrls ?? PostMediaStore.shared.imageUrls(for: item.id) ?? [item.imageUrl]).filter { !$0.isEmpty }
            let displayUrls = urls.isEmpty ? [item.imageUrl] : urls

            ZStack(alignment: .bottomLeading) {
                if displayUrls.count > 1 {
                    MediaCarouselView(urls: displayUrls, cornerRadius: 0, aspectRatio: 3/2, fixedHeight: h)
                        .frame(width: w, height: h)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } else {
                    AsyncImage(url: URL(string: displayUrls.first ?? item.imageUrl)) { phase in
                        switch phase {
                        case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                        case .failure: Color.gray.opacity(0.3)
                        default: Color.gray.opacity(0.2)
                        }
                    }
                    .frame(width: w, height: h)
                    .frame(maxWidth: .infinity)
                    .clipped()
                }

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

    private var effectiveLikeCount: Int { displayLikeCount ?? item.likeCount }
    private var effectiveCommentCount: Int { displayCommentCount ?? item.commentCount }

    /// 底部交互橫條：點讚、評論、收藏、分享（樂觀數字 + 愛心紅/書籤黃 + 縮放動畫）
    private var actionBar: some View {
        HStack(spacing: 16) {
            Button(action: onLikeTap) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .scaleEffect(isLiked ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)
                        .foregroundStyle(isLiked ? Color.red : CommunityColors.textMuted)
                    Text("\(effectiveLikeCount)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(CommunityColors.textMuted)
                }
            }
            .buttonStyle(.plain)
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
                Text("\(effectiveCommentCount)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            if let onSave = onSaveTap {
                Button(action: onSave) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16))
                        .foregroundStyle(isSaved ? Color.yellow : CommunityColors.textMuted)
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "bookmark")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
            }
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

private func communityActivityIcon(for activity: ViewPointActivityType) -> String {
    switch activity {
    case .hiking: return "figure.hiking"
    case .biking: return "bicycle"
    case .climbing: return "figure.climbing"
    case .summit: return "mountain.2.fill"
    case .mtb: return "bicycle"
    case .overlanding: return "car.fill"
    case .camping: return "tent.fill"
    case .paddling: return "water.waves"
    case .fishing: return "figure.fishing"
    case .boating: return "sailboat.fill"
    }
}

/// 運動類型 emoji，用於卡片第一顆膠囊「🚲 Biking · 2.4 km」
private func communityActivityEmoji(for activity: ViewPointActivityType) -> String {
    switch activity {
    case .hiking: return "🥾"
    case .biking, .mtb: return "🚲"
    case .climbing: return "🧗"
    case .summit: return "⛰️"
    case .overlanding: return "🚗"
    case .camping: return "⛺"
    case .paddling: return "🛶"
    case .fishing: return "🎣"
    case .boating: return "⛵"
    }
}

// MARK: - CommunityCardView（與 DetailedTrackCard 樣式 B 完全一致：頭像行 → 全幅圖+膠囊+標題 → 社交欄，無灰色塊）
/// showTypeLabel：Community 傳 false 隱藏左上角藍色標籤；Profile 若復用此組件可傳 true 保留標籤。
private struct CommunityCardView: View {
    let draft: DraftItem
    var authorDisplayName: String = "Me"
    var authorSubtitle: String = "My post"
    var likeCount: Int = 0
    var commentCount: Int = 0
    var isLiked: Bool = false
    var isSaved: Bool = false
    /// false = Community 不顯示藍色 [Activity]·DETAILED TRACK；true = Profile 保留標籤
    var showTypeLabel: Bool = false
    var onLikeTap: (() -> Void)? = nil
    var onSaveTap: (() -> Void)? = nil

    private var distanceKm: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "0 km" : String(format: "%.2f km", km)
    }
    /// 運動類型展示：用於第一顆膠囊「Biking · 2.4 km」
    private var activityDisplay: String {
        draft.detailedTrackPrimaryActivityType?.rawValue ?? "—"
    }
    /// 路線類別（如 National Park），替換原海拔 0m 位置
    private var categoryPillText: String {
        draft.detailedTrackCategoryDisplay ?? "—"
    }
    /// 時長：優先 Builder 存儲的 detailedTrackJSON（首尾 arrivalTime 計算或 totalDurationMinutes），否則 durationSeconds
    private var durationPillText: String {
        if let resolved = draft.resolvedDurationDisplay, !resolved.isEmpty { return resolved }
        guard let sec = draft.durationSeconds, sec >= 0 else { return "— min" }
        let min = Int(sec / 60)
        return min < 60 ? "\(min) min" : "\(min / 60)h \(min % 60)min"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            userAvatarRow
            fullImageWithPillsAndTitle
            socialBar
        }
        .background(CommunityColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: detailedTrackCardCorner))
        .overlay(
            RoundedRectangle(cornerRadius: detailedTrackCardCorner)
                .stroke(.white.opacity(0.15), lineWidth: 0.5)
        )
    }

    /// [1] 用戶頭像行：動態讀取發布者頭像與名稱
    private var userAvatarRow: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(CommunityColors.textMuted)
            VStack(alignment: .leading, spacing: 2) {
                Text(authorDisplayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(CommunityColors.textPrimary)
                Text(authorSubtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CommunityColors.cardBg)
    }

    /// [2] 全幅風景圖：fill + clipped，底部漸變；標題（白色粗體）在膠囊上方，里程/海拔/時間為半透明膠囊疊加在左下方
    private var fullImageWithPillsAndTitle: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let coverData = draft.coverImageData, let uiImage = UIImage(data: coverData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    CommunityCardViewHeroThumbnail(draft: draft)
                }
            }
            .frame(height: detailedTrackCardImageHeight)
            .frame(maxWidth: .infinity)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: detailedTrackCardImageHeight)
            .frame(maxWidth: .infinity)
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 10) {
                Spacer(minLength: 0)
                Text(draft.title.isEmpty ? "Recorded Route" : draft.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                dataPillsRow
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: detailedTrackCardImageHeight)

            if let tier = draft.detailedTrackTier {
                VStack {
                    HStack(spacing: 6) {
                        Text(tier == .nature ? "🌲 NATURE · DETAILED" : "🏙️ URBAN · DETAILED")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        tier == .nature
                            ? LinearGradient(colors: [Color(hex: "16A34A"), Color(hex: "16A34A")], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color(hex: "2563EB"), Color(hex: "EA580C")], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: detailedTrackCardImageHeight)
                .padding(12)
                .allowsHitTesting(false)
            }
        }
        .frame(height: detailedTrackCardImageHeight)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    /// 半透明膠囊：運動類型（含 emoji）· 里程、Land Manager/Sub-category、時長（無 0 m）
    private var dataPillsRow: some View {
        let activityType = draft.detailedTrackPrimaryActivityType
        let firstPillText: String = {
            if let a = activityType {
                let emoji = communityActivityEmoji(for: a)
                return "\(emoji) \(a.rawValue) · \(distanceKm)"
            }
            return "— · \(distanceKm)"
        }()
        let activityIcon = activityType.map { communityActivityIcon(for: $0) } ?? "figure.walk"
        return HStack(spacing: 8) {
            dataPill(icon: activityIcon, text: firstPillText)
            dataPill(icon: "leaf.fill", text: categoryPillText)
            dataPill(icon: "clock", text: durationPillText)
        }
    }

    private func dataPill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(communityMonoFont)
        }
        .foregroundStyle(.white.opacity(0.95))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }

    /// [3] 交互動作欄：Like / Comment / Save / Share（樂觀數字 + 愛心紅/書籤黃 + 縮放動畫）
    private var socialBar: some View {
        HStack(spacing: 16) {
            if let onLike = onLikeTap {
                Button(action: onLike) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .scaleEffect(isLiked ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)
                            .foregroundStyle(isLiked ? Color.red : CommunityColors.textMuted)
                        Text("\(likeCount)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(CommunityColors.textMuted)
                    }
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(CommunityColors.textMuted)
                    Text("\(likeCount)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(CommunityColors.textMuted)
                }
            }
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
                Text("\(commentCount)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            if let onSave = onSaveTap {
                Button(action: onSave) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16))
                        .foregroundStyle(isSaved ? Color.yellow : CommunityColors.textMuted)
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "bookmark")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            Spacer(minLength: 0)
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

// MARK: - DetailedTrackCard（Jessica 樣式 B 全局統一：頭像行 → 全幅圖+膠囊+標題 → 社交欄，無灰色塊）
private let detailedTrackCardImageHeight: CGFloat = 260
private let detailedTrackCardCorner: CGFloat = 16

struct DetailedTrackCard: View {
    let item: DetailedTrackItem
    let isFollowing: Bool
    let isLiked: Bool
    var isSaved: Bool = false
    /// 樂觀 like 數：item.likeCount + (isLiked ? 1 : 0)
    var displayLikeCount: Int? = nil
    /// 評論數：item.commentCount + PostCommentStore 增量
    var displayCommentCount: Int? = nil
    var authorSubtitleOverride: String? = nil
    let onFollowTap: () -> Void
    let onLikeTap: () -> Void
    var onSaveTap: (() -> Void)? = nil
    /// 用戶自己發布時傳入，右上角顯示 … 管理按鈕
    var onManageTap: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            userAvatarRow
            fullImageWithPillsAndTitle
            socialBar
        }
        .background(CommunityColors.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: detailedTrackCardCorner))
        .overlay(
            RoundedRectangle(cornerRadius: detailedTrackCardCorner)
                .stroke(.white.opacity(0.15), lineWidth: 0.5)
        )
    }

    /// [1] 用戶頭像行：動態讀取發布者頭像與名稱，與主頁暗藍色銜接
    private var userAvatarRow: some View {
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

    /// [2] 全幅風景圖：fill + clipped，底部漸變；標題（白色粗體）在膠囊上方，里程/海拔/時間為半透明膠囊疊加在左下方
    private var fullImageWithPillsAndTitle: some View {
        let urls = (PostMediaStore.shared.imageUrls(for: item.id) ?? item.imageUrls).filter { !$0.isEmpty }
        let displayUrls = urls.isEmpty ? ["https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800"] : urls

        return ZStack(alignment: .bottomLeading) {
            Group {
                if displayUrls.count > 1 {
                    MediaCarouselView(urls: displayUrls, cornerRadius: 0, aspectRatio: 16/10, fixedHeight: detailedTrackCardImageHeight)
                        .frame(height: detailedTrackCardImageHeight)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } else {
                    AsyncImage(url: URL(string: displayUrls[0])) { phase in
                        switch phase {
                        case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                        case .failure: Color.gray.opacity(0.3)
                        default: Color.gray.opacity(0.2)
                        }
                    }
                    .frame(height: detailedTrackCardImageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()
                }
            }
            .aspectRatio(contentMode: .fill)

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: detailedTrackCardImageHeight)
            .frame(maxWidth: .infinity)
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 10) {
                Spacer(minLength: 0)
                Text(item.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                dataPillsRow
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: detailedTrackCardImageHeight)

            if onManageTap != nil {
                VStack {
                    HStack {
                        Spacer(minLength: 0)
                        Menu {
                            Button(role: .destructive, action: { onManageTap?() }) {
                                Label("Delete Post", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .frame(width: 44, height: 44)
                        .padding(12)
                    }
                    Spacer(minLength: 0)
                }
                .frame(height: detailedTrackCardImageHeight)
                .frame(maxWidth: .infinity)
                .allowsHitTesting(true)
            }
        }
        .frame(height: detailedTrackCardImageHeight)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    /// 里程、海拔、時間：半透明膠囊疊加在圖片左下方
    private var dataPillsRow: some View {
        HStack(spacing: 8) {
            dataPill(icon: "location.fill", text: item.distance)
            dataPill(icon: "arrow.up.right", text: item.elevationGain)
            dataPill(icon: "clock", text: item.durationDisplay)
        }
    }

    private func dataPill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(communityMonoFont)
        }
        .foregroundStyle(.white.opacity(0.95))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }

    private var effectiveLikeCount: Int { displayLikeCount ?? item.likeCount }
    private var effectiveCommentCount: Int { displayCommentCount ?? item.commentCount }

    /// [3] 交互動作欄：Like / Comment / Save / Share（樂觀數字 + 愛心紅/書籤黃 + 縮放動畫）
    private var socialBar: some View {
        HStack(spacing: 16) {
            Button(action: onLikeTap) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .scaleEffect(isLiked ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)
                        .foregroundStyle(isLiked ? Color.red : CommunityColors.textMuted)
                    Text("\(effectiveLikeCount)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(CommunityColors.textMuted)
                }
            }
            .buttonStyle(.plain)
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
                Text("\(effectiveCommentCount)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(CommunityColors.textMuted)
            }
            if let onSave = onSaveTap {
                Button(action: onSave) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16))
                        .foregroundStyle(isSaved ? Color.yellow : CommunityColors.textMuted)
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "bookmark")
                    .font(.system(size: 16))
                    .foregroundStyle(CommunityColors.textMuted)
            }
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

/// 微觀篩選邏輯：與 DetailedTrackFilterView 內一致，用於列表過濾與結果數
private func matchesDetailedFilter(_ draft: DraftItem, _ state: CommunityFilterState) -> Bool {
    if let tier = state.detailedTrackMainType {
        guard draft.detailedTrackTier?.rawValue == tier else { return false }
        if tier == "Nature", !state.selectedLandManagers.isEmpty {
            guard let cat = draft.detailedTrackCategoryDisplay, state.selectedLandManagers.contains(cat) else { return false }
        }
        if tier == "Urban", !state.selectedUrbanCategories.isEmpty {
            guard let cat = draft.detailedTrackCategoryDisplay, state.selectedUrbanCategories.contains(cat) else { return false }
        }
    }
    if !state.selectedActivities.isEmpty {
        guard let act = draft.detailedTrackPrimaryActivityType?.rawValue, state.selectedActivities.contains(act) else { return false }
    }
    if let band = state.selectedDurationMicro, let min = draft.durationMinutesForFilter {
        let inRange: Bool = switch band {
        case "< 30min": min < 30
        case "30-60min": min >= 30 && min < 60
        case "1-2h": min >= 60 && min < 120
        case "2h+": min >= 120
        default: true
        }
        if !inRange { return false }
    }
    return true
}

// MARK: - Detailed Track Filter Options (Micro only: Main Type → Sub-category, Activity, Duration)
private let dtLandManagerOptions = ["National Park", "National Forest", "State Park", "State Forest", "National Recreation Area", "National Grassland"]
private let dtUrbanOptions = ["Cafe", "Architecture", "City Park", "Historic Site", "Shopping"]
private let dtActivityOptions = ["Hiking", "Biking", "MTB", "Overlanding", "Climbing", "Camping", "Paddling", "Summit"]
private let dtDurationMicroOptions = ["< 30min", "30-60min", "1-2h", "2h+"]

// MARK: - Grand Journey Filter View (結果數與州別路線數依 allItems 實際數據)
struct GrandJourneyFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedStateIds: Set<String>
    @Binding var selectedTerrains: Set<String>
    @Binding var selectedDuration: String?
    var allItems: [GrandJourneyItem] = []
    var viewModel: CommunityViewModel? = nil

    @State private var showAllRegions = false

    private var visibleRegions: [FilterRegionItem] {
        if showAllRegions { return filterRegionsAll }
        return filterRegionsAll.filter { filterInitialRegionIds.contains($0.id) }
    }

    /// 符合當前篩選條件的路線數（由 viewModel.filteredJourneys 依實際數據計算）
    private var resultCount: Int {
        guard let vm = viewModel else { return allItems.count }
        return vm.filteredJourneys(from: allItems).count
    }

    /// 某州實際路線數
    private func routeCount(forStateId stateId: String) -> Int {
        allItems.filter { $0.stateIds.contains(stateId) }.count
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
                                            routeCount: routeCount(forStateId: state.id),
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

// MARK: - Filter State Card (路線數由傳入 routeCount 決定，無佔位)
private struct FilterStateCard: View {
    let state: FilterStateItem
    /// 該州實際路線數（由數據計算）；未傳時用 state.routeCount 兼容
    var routeCount: Int? = nil
    let isSelected: Bool
    let onTap: () -> Void

    private var displayCount: Int { routeCount ?? state.routeCount }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(state.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(CommunityColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(displayCount) Routes")
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

// MARK: - Detailed Track Filter View (結果數依 allItems 篩選後實際數量)
struct DetailedTrackFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var mainType: String?
    @Binding var selectedLandManagers: Set<String>
    @Binding var selectedUrbanCategories: Set<String>
    @Binding var selectedActivities: Set<String>
    @Binding var selectedDurationMicro: String?
    var allItems: [DraftItem] = []
    var onShowResults: (() -> Void)? = nil

    /// 符合當前篩選條件的微觀路線數
    private var resultCount: Int {
        allItems.filter { matchesDetailedFilter($0) }.count
    }

    private func matchesDetailedFilter(_ draft: DraftItem) -> Bool {
        if let tier = mainType {
            guard draft.detailedTrackTier?.rawValue == tier else { return false }
            if tier == "Nature", !selectedLandManagers.isEmpty {
                guard let cat = draft.detailedTrackCategoryDisplay, selectedLandManagers.contains(cat) else { return false }
            }
            if tier == "Urban", !selectedUrbanCategories.isEmpty {
                guard let cat = draft.detailedTrackCategoryDisplay, selectedUrbanCategories.contains(cat) else { return false }
            }
        }
        if !selectedActivities.isEmpty {
            guard let act = draft.detailedTrackPrimaryActivityType?.rawValue, selectedActivities.contains(act) else { return false }
        }
        if let band = selectedDurationMicro, let min = draft.durationMinutesForFilter {
            let inRange: Bool = switch band {
            case "< 30min": min < 30
            case "30-60min": min >= 30 && min < 60
            case "1-2h": min >= 60 && min < 120
            case "2h+": min >= 120
            default: true
            }
            if !inRange { return false }
        }
        return true
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    mainTypeSection
                    if mainType == "Nature" {
                        filterSection(title: "LAND MANAGER", options: dtLandManagerOptions, selected: selectedLandManagers, columns: 2) { selectedLandManagers = $0 }
                    }
                    if mainType == "Urban" {
                        filterSection(title: "CITY CATEGORY", options: dtUrbanOptions, selected: selectedUrbanCategories, columns: 2) { selectedUrbanCategories = $0 }
                    }
                    filterSection(title: "ACTIVITY TYPE", options: dtActivityOptions, selected: selectedActivities, columns: 3) { selectedActivities = $0 }
                    durationSection
                    Color.clear.frame(height: 100)
                }
                .padding(16)
            }

            detailedTrackStickyBar(resultCount: resultCount) {
                mainType = nil
                selectedLandManagers.removeAll()
                selectedUrbanCategories.removeAll()
                selectedActivities.removeAll()
                selectedDurationMicro = nil
            } onShowResults: {
                onShowResults?() ?? dismiss()
            }
        }
        .background(CommunityColors.background)
        .preferredColorScheme(.dark)
    }

    private var mainTypeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MAIN TYPE")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(CommunityColors.textMuted)
                .textCase(.uppercase)
            HStack(spacing: 12) {
                Button {
                    mainType = mainType == "Nature" ? nil : "Nature"
                    if mainType != "Nature" { selectedLandManagers.removeAll() }
                    if mainType == "Nature" { selectedUrbanCategories.removeAll() }
                } label: {
                    Text("Nature")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(CommunityColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(mainType == "Nature" ? Color.white.opacity(0.2) : Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(mainType == "Nature" ? CommunityColors.accentGreen : Color.white.opacity(0.12), lineWidth: 1))
                }
                .buttonStyle(.plain)
                Button {
                    mainType = mainType == "Urban" ? nil : "Urban"
                    if mainType != "Urban" { selectedUrbanCategories.removeAll() }
                    if mainType == "Urban" { selectedLandManagers.removeAll() }
                } label: {
                    Text("Urban")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(CommunityColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(mainType == "Urban" ? Color.white.opacity(0.2) : Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(mainType == "Urban" ? CommunityColors.accentGreen : Color.white.opacity(0.12), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DURATION")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(CommunityColors.textMuted)
                .textCase(.uppercase)
            HStack(spacing: 8) {
                ForEach(dtDurationMicroOptions, id: \.self) { option in
                    Button {
                        selectedDurationMicro = selectedDurationMicro == option ? nil : option
                    } label: {
                        Text(option)
                            .font(.system(size: 13, weight: selectedDurationMicro == option ? .semibold : .medium))
                            .foregroundStyle(CommunityColors.textPrimary)
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedDurationMicro == option ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedDurationMicro == option ? CommunityColors.accentGreen : Color.white.opacity(0.12), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
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

// MARK: - Community Filter Sheet（依實際數據：結果數與選項數量由路線數據定義）
struct CommunityFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    fileprivate var viewMode: CommunityViewMode = .grandJourneys
    @Binding var filterState: CommunityFilterState
    var grandJourneyItems: [GrandJourneyItem] = []
    var communityViewModel: CommunityViewModel? = nil
    var detailedTrackItems: [DraftItem] = []
    var onApplyDetailedFilter: ((String?, Set<String>, Set<String>, Set<String>, String?) -> Void)? = nil

    @State private var detailedTrackMainType: String? = nil
    @State private var selectedLandManagers: Set<String> = []
    @State private var selectedUrbanCategories: Set<String> = []
    @State private var selectedActivities: Set<String> = []
    @State private var selectedDurationMicro: String? = nil

    var body: some View {
        NavigationStack {
            Group {
                if viewMode == .detailedTracks {
                    DetailedTrackFilterView(
                        mainType: $detailedTrackMainType,
                        selectedLandManagers: $selectedLandManagers,
                        selectedUrbanCategories: $selectedUrbanCategories,
                        selectedActivities: $selectedActivities,
                        selectedDurationMicro: $selectedDurationMicro,
                        allItems: detailedTrackItems,
                        onShowResults: {
                            onApplyDetailedFilter?(detailedTrackMainType, selectedLandManagers, selectedUrbanCategories, selectedActivities, selectedDurationMicro)
                            dismiss()
                        }
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
                        ),
                        allItems: grandJourneyItems,
                        viewModel: communityViewModel
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if viewMode == .detailedTracks { syncDetailedFilterToState() }
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(CommunityColors.accentGreen)
                }
            }
            .onAppear {
                if viewMode == .detailedTracks {
                    detailedTrackMainType = filterState.detailedTrackMainType
                    selectedLandManagers = filterState.selectedLandManagers
                    selectedUrbanCategories = filterState.selectedUrbanCategories
                    selectedActivities = filterState.selectedActivities
                    selectedDurationMicro = filterState.selectedDurationMicro
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func syncDetailedFilterToState() {
        onApplyDetailedFilter?(detailedTrackMainType, selectedLandManagers, selectedUrbanCategories, selectedActivities, selectedDurationMicro)
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
                        userState.requestLandingForAuth()
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
