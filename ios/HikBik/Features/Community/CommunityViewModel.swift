// MARK: - Community View Model (feed, search, filter; union + rank)
import SwiftUI
import Foundation

/// Filter state: Region / Terrain / Duration (Grand Journey)；微觀篩選單獨一組，依實際數據計數
struct CommunityFilterState {
    var selectedStateIds: Set<String> = []
    var selectedTerrains: Set<String> = []
    var selectedDuration: String?

    var detailedTrackMainType: String? = nil
    var selectedLandManagers: Set<String> = []
    var selectedUrbanCategories: Set<String> = []
    var selectedActivities: Set<String> = []
    var selectedDurationMicro: String? = nil
}

private let recentSearchesKey = "recentSearches"
private let recentSearchesMaxCount = 10

/// Community search and filter state；本地發布在 `TrackDataManager`，雲端 Feed 在 `cloudGrandJourneys` / `cloudDetailedTracks`。
final class CommunityViewModel: ObservableObject {
    enum FeedLoadTrigger: String {
        case onAppear
        case pullToRefresh
        case manual
    }

    private enum FeedCancelReason: String {
        case onDisappear
        case overriddenByNewRequest
        case unknown
    }

    /// Legacy: used only for Profile liked resolution and CustomRouteBuilder macro flow. Do NOT use for Community feed.
    @Published var publishedPosts: [CommunityJourney] = []

    /// `GET /api/social/feed` 解析後的宏觀列表（卡片用 `GrandJourneyItem`）。
    @Published var cloudGrandJourneys: [GrandJourneyItem] = []
    /// `GET /api/social/feed` 解析後的微觀列表。
    @Published var cloudDetailedTracks: [DetailedTrackItem] = []
    @Published var isFeedLoading = false
    private var currentFeedTask: Task<[SocialFeedEntry], Error>? = nil
    private var feedCancelReason: FeedCancelReason? = nil

    @Published var searchText: String = ""
    @Published var filterState: CommunityFilterState = CommunityFilterState()
    @Published var recentSearches: [String] = []

    init() {
        loadRecentSearches()
    }

    /// Whether any filter is active (for search state .result)；Grand Journey 或 Detailed Track 任一有篩選即為 true
    var hasActiveFilter: Bool {
        let grand = !filterState.selectedStateIds.isEmpty || !filterState.selectedTerrains.isEmpty || filterState.selectedDuration != nil
        let detailed = filterState.detailedTrackMainType != nil || !filterState.selectedLandManagers.isEmpty || !filterState.selectedUrbanCategories.isEmpty || !filterState.selectedActivities.isEmpty || filterState.selectedDurationMicro != nil
        return grand || detailed
    }

    /// Prepend a journey (e.g. from CustomRouteBuilder macro flow).
    func prepend(_ post: CommunityJourney) {
        publishedPosts.insert(post, at: 0)
    }

    /// 清空由 `prepend` 寫入的本地列表（與 `TrackDataManager` 清空發布箱時一併重置 UI 用）。
    func clearPrependedPublishedPosts() {
        publishedPosts.removeAll()
        objectWillChange.send()
    }

    /// 拉取全網 Feed（`SocialFeedService` → `GET /api/social/feed`）。
    @MainActor
    func loadFeed(trigger: FeedLoadTrigger = .manual) async {
        if isFeedLoading {
            if trigger == .pullToRefresh, let runningTask = currentFeedTask {
                feedCancelReason = .overriddenByNewRequest
                runningTask.cancel()
                _ = try? await runningTask.value
            } else {
            #if DEBUG
                print("📥 [NETWORK] 略過重複請求（trigger=\(trigger.rawValue)）")
            #endif
                return
            }
        }

        isFeedLoading = true
        feedCancelReason = nil
        defer {
            isFeedLoading = false
            currentFeedTask = nil
            feedCancelReason = nil
        }
        do {
            let task = Task.detached(priority: .userInitiated) {
                try await SocialFeedService.shared.fetchFeed()
            }
            currentFeedTask = task
            let posts = try await task.value
            var macro: [GrandJourneyItem] = []
            var micro: [DetailedTrackItem] = []
            macro.reserveCapacity(posts.count)
            micro.reserveCapacity(posts.count)
            for e in posts {
                switch e {
                case .macro(let g): macro.append(g)
                case .micro(let d): micro.append(d)
                }
            }
            cloudGrandJourneys = macro
            cloudDetailedTracks = micro
            print("📥 [NETWORK] 成功從雲端拉取 \(posts.count) 條動態")
        } catch is CancellationError {
            let reason = feedCancelReason ?? .overriddenByNewRequest
            switch reason {
            case .onDisappear:
                print("📥 [NETWORK] Feed 請求已取消：onDisappear 觸發")
            case .overriddenByNewRequest:
                print("📥 [NETWORK] Feed 請求已取消：新的請求覆蓋了舊請求")
            case .unknown:
                print("📥 [NETWORK] Feed 請求已取消：未知原因")
            }
        } catch {
            #if DEBUG
            print("📥 [NETWORK] Feed 拉取失敗: \(error.localizedDescription)")
            #endif
        }
    }

    @MainActor
    func cancelFeedLoadOnDisappear() {
        feedCancelReason = .onDisappear
        currentFeedTask?.cancel()
    }

    /// Union of filter match (A) and search match (B); then rank.
    func filteredJourneys(from items: [GrandJourneyItem]) -> [GrandJourneyItem] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        let hasSearch = !trimmed.isEmpty
        let hasFilter = !filterState.selectedStateIds.isEmpty || !filterState.selectedTerrains.isEmpty || filterState.selectedDuration != nil

        if !hasSearch && !hasFilter {
            return rankJourneys(items)
        }

        let pathA: [GrandJourneyItem] = hasFilter ? items.filter { matchesFilter($0) } : []
        let pathB: [GrandJourneyItem] = hasSearch ? items.filter { matchesSearch($0, query: trimmed) } : []
        var union: [GrandJourneyItem]
        if hasFilter && hasSearch {
            union = pathA
            for item in pathB where !union.contains(where: { $0.id == item.id }) {
                union.append(item)
            }
        } else if hasFilter {
            union = pathA
        } else {
            union = pathB
        }

        return rankJourneys(union, boostDoubleMatch: hasSearch && hasFilter)
    }

    /// Filter: Region, Terrain, Duration range
    private func matchesFilter(_ item: GrandJourneyItem) -> Bool {
        if !filterState.selectedStateIds.isEmpty {
            let matchState = item.stateIds.contains(where: { filterState.selectedStateIds.contains($0) })
            if !matchState { return false }
        }
        if !filterState.selectedTerrains.isEmpty {
            let matchTerrain = item.tags.contains(where: { filterState.selectedTerrains.contains($0) })
            if !matchTerrain { return false }
        }
        if let duration = filterState.selectedDuration {
            guard let (low, high) = parseDurationRange(duration) else { return false }
            if item.days < low || item.days > high { return false }
        }
        return true
    }

    /// Search: title, author, tags
    private func matchesSearch(_ item: GrandJourneyItem, query: String) -> Bool {
        if item.title.lowercased().contains(query) { return true }
        if item.authorName.lowercased().contains(query) { return true }
        if item.tags.contains(where: { $0.lowercased().contains(query) }) { return true }
        if item.waypoints.contains(where: { $0.lowercased().contains(query) }) { return true }
        return false
    }

    /// Parse duration string to (minDays, maxDays), e.g. "4-7" -> (4,7), "15+" -> (15, 999)
    private func parseDurationRange(_ option: String) -> (Int, Int)? {
        if option == "15+" { return (15, 999) }
        let parts = option.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 2 else { return nil }
        return (parts[0], parts[1])
    }

    /// Rank: double match first; else heat Score = (Likes + Comments*2) / pow(HoursOld+2, 1.8)
    private func rankJourneys(_ items: [GrandJourneyItem], boostDoubleMatch: Bool = false) -> [GrandJourneyItem] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        let hasSearch = !trimmed.isEmpty
        let hasFilter = !filterState.selectedStateIds.isEmpty || !filterState.selectedTerrains.isEmpty || filterState.selectedDuration != nil

        return items.sorted { a, b in
            let aDouble = boostDoubleMatch && hasSearch && hasFilter && matchesFilter(a) && matchesSearch(a, query: trimmed)
            let bDouble = boostDoubleMatch && hasSearch && hasFilter && matchesFilter(b) && matchesSearch(b, query: trimmed)
            if aDouble != bDouble { return aDouble }

            let scoreA = heatScore(item: a)
            let scoreB = heatScore(item: b)
            return scoreA > scoreB
        }
    }

    private func heatScore(item: GrandJourneyItem) -> Double {
        let likes = Double(item.likeCount)
        let comments = Double(item.commentCount)
        let hoursOld = item.createdAt.map { Date().timeIntervalSince($0) / 3600 } ?? 24 * 7
        return (likes + comments * 2) / pow(hoursOld + 2, 1.8)
    }

    // MARK: - Search History (UserDefaults)

    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
    }

    /// Reload recent searches from UserDefaults for overlay.
    func refreshRecentSearches() {
        loadRecentSearches()
    }

    private func persistRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
    }

    /// Save one search: trim, dedupe, move existing to front; max 10.
    func saveSearchQuery(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var list = recentSearches.filter { $0.trimmingCharacters(in: .whitespaces).lowercased() != trimmed.lowercased() }
        list.insert(trimmed, at: 0)
        list = Array(list.prefix(recentSearchesMaxCount))
        recentSearches = list
        persistRecentSearches()
    }

    /// Remove one search history by index.
    func removeSearchQuery(at index: Int) {
        guard index >= 0, index < recentSearches.count else { return }
        var list = recentSearches
        list.remove(at: index)
        recentSearches = list
        persistRecentSearches()
    }

    /// Clear all search history.
    func clearAllSearchHistory() {
        recentSearches = []
        persistRecentSearches()
    }

    // MARK: - Profile 解析：id "1" = Sarah Chen Utah，供 Liked/Saved 標籤顯示與跳轉詳情
    static let sarahUtahJourney: CommunityJourney = CommunityJourney(
        journeyName: "The Ultimate Utah Mighty 5 Loop",
        days: [
            CommunityJourneyDay(
                dayNumber: 1,
                location: CommunityGeoLocation(latitude: 38.7331, longitude: -109.5925),
                locationName: "Arches National Park",
                notes: "Day one from Moab. Don't miss sunset at Delicate Arch—bring a headlamp; it gets dark fast on the way back.",
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

    /// 依貼文 ID 解析為 CommunityJourney，供 Profile Liked/Saved 顯示與 NavigationLink 詳情。
    static func journey(forPostId id: String) -> CommunityJourney? {
        if id == "1" { return sarahUtahJourney }
        return nil
    }
}
