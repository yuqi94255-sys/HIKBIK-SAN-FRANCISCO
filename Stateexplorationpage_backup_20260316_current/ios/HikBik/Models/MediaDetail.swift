// MARK: - 媒體詳情：Community / OfficialRoute 照片對象，供全屏瀏覽
import Foundation

/// 單張媒體（照片）：含高解析 URL、說明、作者，供 MediaBrowserViewModel 全屏切換
struct MediaDetail: Identifiable {
    let id: String
    let highResUrl: String?
    let caption: String?
    let author: String?

    init(id: String = UUID().uuidString, highResUrl: String?, caption: String? = nil, author: String? = nil) {
        self.id = id
        self.highResUrl = highResUrl
        self.caption = caption
        self.author = author
    }

    var url: URL? { highResUrl.flatMap { URL(string: $0) } }
}
