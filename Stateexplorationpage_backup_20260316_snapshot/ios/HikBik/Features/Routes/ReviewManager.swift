// MARK: - Reviewable 協議 + ReviewManager 單例（官方/社區統一切換，未來可遷 SwiftData）
import SwiftUI

/// 無論官方預載 JSON 還是用戶本地提交，均符合此協議；UI 只依協議渲染
protocol Reviewable: Identifiable {
    var id: String { get }
    var rating: Int { get }
    var comment: String { get }
    var author: String? { get }
    var date: Date { get }
}

/// 統一管理 reviews 讀寫；遷移 SwiftData 時僅改此 Manager，無需重寫 UI
/// TODO: Fetch data from Firebase/Backend; replace in-memory storage with API sync
final class ReviewManager: ObservableObject {
    static let shared = ReviewManager()

    /// 當前用戶 ID（僅本人評論顯示刪除；可替換為 Auth 狀態）
    static var currentUserId: String = "me"

    @Published private(set) var storage: [String: [RouteReview]] = [:]

    private init() {}

    /// 當前路線的評論列表（供 UI 綁定）
    func reviews(for routeId: String) -> [RouteReview] {
        storage[routeId] ?? []
    }

    /// 用戶提交後寫入；若該 route 尚未有條目則先種子化
    func add(_ review: RouteReview, routeId: String) {
        var list = storage[routeId] ?? []
        list.append(review)
        storage[routeId] = list
    }

    /// 當前用戶是否已評價過該路線（一人限評一次）
    func hasCurrentUserReviewed(routeId: String) -> Bool {
        (storage[routeId] ?? []).contains { $0.userId == ReviewManager.currentUserId }
    }

    /// 刪除指定評論；詳情頁與 AllReviewsView 會即時同步
    /// 權限硬鎖定：僅當該條評論的 userId == currentUserId 時才執行刪除，否則直接 return
    func remove(reviewId: String, routeId: String) {
        guard var list = storage[routeId] else { return }
        guard let review = list.first(where: { $0.id == reviewId }) else { return }
        guard review.userId == ReviewManager.currentUserId else { return }
        list.removeAll { $0.id == reviewId }
        storage[routeId] = list
    }

    /// 首次進入詳情時用官方/預載數據種子化（僅當該 route 尚無數據時）
    func seedIfNeeded(_ initialReviews: [RouteReview], routeId: String) {
        guard storage[routeId] == nil || storage[routeId]?.isEmpty == true else { return }
        storage[routeId] = initialReviews
    }
}
