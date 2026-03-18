// MARK: - 全屏媒體瀏覽 ViewModel：傳入 [MediaDetail]，支援前後切換
import SwiftUI

/// 點擊圖片時傳入整個 [MediaDetail] 與當前索引，實現全屏左右切換
final class MediaBrowserViewModel: ObservableObject {
    @Published var items: [MediaDetail] = []
    @Published var currentIndex: Int = 0

    var currentItem: MediaDetail? {
        guard currentIndex >= 0, currentIndex < items.count else { return nil }
        return items[currentIndex]
    }

    func set(items: [MediaDetail], initialIndex: Int = 0) {
        self.items = items
        self.currentIndex = max(0, min(initialIndex, items.count - 1))
    }

    func next() {
        guard !items.isEmpty else { return }
        currentIndex = (currentIndex + 1) % items.count
    }

    func previous() {
        guard !items.isEmpty else { return }
        currentIndex = currentIndex - 1
        if currentIndex < 0 { currentIndex = items.count - 1 }
    }
}
