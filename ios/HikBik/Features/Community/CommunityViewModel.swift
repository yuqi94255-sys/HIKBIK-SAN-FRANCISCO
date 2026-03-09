// MARK: - Community View Model — 帖子清單，發布時 prepend 新帖（模擬；接後端時替換為 API 調用）
import SwiftUI

/// 社區帖子清單：mock 數據 + 用戶剛發布的行程。prepend 後列表最前面顯示新帖。
final class CommunityViewModel: ObservableObject {
    /// 用戶剛發布的行程（prepend 到最前）。接後端時改為從 API 拉取。
    @Published var publishedPosts: [CommunityJourney] = []

    /// 模擬注入：將剛發布的行程加入列表最前面。
    func prepend(_ post: CommunityJourney) {
        publishedPosts.insert(post, at: 0)
    }
}
