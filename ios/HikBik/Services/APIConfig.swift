// MARK: - APIConfig — HikBik 主後端（真機 / 區域網）
// 與 NPS/RIDB 等第三方 API 無關；第三方仍使用各自 Config。

import Foundation

/// 主後端 REST 根路徑（已含 `/api`）。
/// 請求路徑示例：`APIClientBase.get("/users")` → `http://172.20.10.8:3000/api/users`
enum APIConfig {
    static let baseURL = "http://172.20.10.8:3000/api/"
}

/// 與主後端通訊的單例別名（實際類型為 `APIClientBase`）。
typealias NetworkManager = APIClientBase
