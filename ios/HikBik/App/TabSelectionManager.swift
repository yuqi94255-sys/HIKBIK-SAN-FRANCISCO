import SwiftUI

/// 全局 Tab 選擇，用於發布成功後強制切回 Community/Home 大清單。
final class TabSelectionManager: ObservableObject {
    static let shared = TabSelectionManager()

    /// 0=Home, 1=Routes, 2=Shop, 3=Community, 4=Profile
    @Published var selectedTabIndex: Int = 0
    /// When true, CommunityDiscoveryView onAppear will set viewMode to .liveActivity so the new post is visible.
    @Published var shouldOpenCommunityOnLiveActivity: Bool = false

    private init() {}

    func switchToCommunity() {
        selectedTabIndex = 3
        shouldOpenCommunityOnLiveActivity = true
    }

    func switchToHome() {
        selectedTabIndex = 0
    }
}
