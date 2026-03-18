// MARK: - Official Macro Journey — 官方數據，禁止與 Community 共用邏輯
// 數據來源：我們提供的完整 JSON（Bundle / 後台），包含專業軌跡 pathCoordinates。
// 詳情與導航使用 OfficialMacroModels（MacroJourneyJSON, OfficialMacroRoute, MacroJourneyTemplate）。

import Foundation

/// 官方宏觀行程數據源標識。實際數據類型為 MacroJourneyJSON 或 OfficialMacroRoute → MacroJourneyTemplate。
/// 詳情頁使用 OfficialMacroJourneyView，導航使用 OfficialMacroNavigationView。
enum OfficialJourneySource {
    /// 從 Bundle JSON 載入（MacroJourneyJSON.load(bundle:filename:)）
    case bundleJSON(MacroJourneyJSON)
    /// 從預定義路線（OfficialMacroRoute）
    case predefinedRoute(OfficialMacroRoute)
}
