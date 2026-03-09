// MARK: - Current User — 喜歡、收藏、打卡（模擬；接後端時替換為 API）
import SwiftUI

/// 當前用戶的社交狀態：點讚的 Post ID、已打卡的行程 ID、顯示名稱（評論用）。
final class CurrentUser: ObservableObject {
    @Published var likedPostIds: Set<String> = []
    @Published var completedJourneyIds: Set<String> = []
    @Published var displayName: String = "Guest"

    func toggleLike(postId: String) {
        if likedPostIds.contains(postId) {
            likedPostIds.remove(postId)
        } else {
            likedPostIds.insert(postId)
        }
    }

    func isLiked(postId: String) -> Bool {
        likedPostIds.contains(postId)
    }

    func checkIn(journeyId: String) {
        completedJourneyIds.insert(journeyId)
    }

    func hasCompleted(journeyId: String) -> Bool {
        completedJourneyIds.contains(journeyId)
    }
}
