// MARK: - Social Data Manager — 全局點贊/收藏狀態，本地持久化
import Foundation

/// 單例：負責路線的收藏 (Favorite)、點贊 (Like) 狀態的讀寫與 UserDefaults 持久化。
/// 詳情頁點擊收藏時調用，重開 App 後狀態保留。
final class SocialDataManager {
    static let shared = SocialDataManager()

    private let favoriteKey = "SocialDataManager_favoriteRouteIDs"
    private let likeKey = "SocialDataManager_likedRouteIDs"

    private var favoriteIds: [String] {
        get { UserDefaults.standard.stringArray(forKey: favoriteKey) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: favoriteKey) }
    }

    private var likedIds: [String] {
        get { UserDefaults.standard.stringArray(forKey: likeKey) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: likeKey) }
    }

    private init() {}

    // MARK: - Favorite
    func isFavorite(routeID: String) -> Bool {
        favoriteIds.contains(routeID)
    }

    func setFavorite(routeID: String, _ value: Bool) {
        var ids = favoriteIds
        if value {
            if !ids.contains(routeID) { ids.append(routeID) }
        } else {
            ids.removeAll { $0 == routeID }
        }
        favoriteIds = ids
    }

    /// 切換收藏狀態，返回新值
    func toggleFavorite(routeID: String) -> Bool {
        let current = isFavorite(routeID: routeID)
        setFavorite(routeID: routeID, !current)
        return !current
    }

    // MARK: - Like（預留，與社區點贊統一可在此擴展）
    func isLiked(routeID: String) -> Bool {
        likedIds.contains(routeID)
    }

    func setLiked(routeID: String, _ value: Bool) {
        var ids = likedIds
        if value {
            if !ids.contains(routeID) { ids.append(routeID) }
        } else {
            ids.removeAll { $0 == routeID }
        }
        likedIds = ids
    }

    func toggleLike(routeID: String) -> Bool {
        let current = isLiked(routeID: routeID)
        setLiked(routeID: routeID, !current)
        return !current
    }

    // MARK: - Saved Track Journey（Profile Saved 顯示 TRACK 卡片並可再次打開詳情）
    private func trackJourneyKey(_ id: String) -> String { "SocialDataManager_trackJourney_\(id)" }

    func saveTrackJourney(id: String, journeyData: Data?) {
        guard !id.isEmpty else { return }
        if let data = journeyData {
            UserDefaults.standard.set(data, forKey: trackJourneyKey(id))
        } else {
            UserDefaults.standard.removeObject(forKey: trackJourneyKey(id))
        }
    }

    func getTrackJourneyData(id: String) -> Data? {
        UserDefaults.standard.data(forKey: trackJourneyKey(id))
    }

    func removeTrackJourney(id: String) {
        UserDefaults.standard.removeObject(forKey: trackJourneyKey(id))
    }
}
