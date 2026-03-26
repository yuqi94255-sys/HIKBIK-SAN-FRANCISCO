// MARK: - APIConfig — HikBik 主後端（Render 雲端）
// 與 NPS/RIDB 等第三方 API 無關；第三方仍使用各自 Config。

import Foundation

/// 主後端 REST 根路徑（已含 `/api/`）。
/// 請求示例：`APIClientBase.get("users/me")` → `https://hikbik-backend.onrender.com/api/users/me`
/// `post("auth/login", …)` → `https://hikbik-backend.onrender.com/api/auth/login`
enum APIConfig {
    static let baseURL = "https://hikbik-backend.onrender.com/api/"
}

/// 與主後端通訊的單例別名（實際類型為 `APIClientBase`）。
typealias NetworkManager = APIClientBase
