// MARK: - RIDB API 安全配置（Recreation Information Database）
// API Key 存放在 RIDBConfig.plist，勿提交至公開 repo（可將 RIDBConfig.plist 加入 .gitignore）

import Foundation

enum RIDBAPIConfig {
    private static let plistKey = "RIDB_API_KEY"

    /// RIDB API Key，從 RIDBConfig.plist 讀取；若無則回傳空字串（請求會失敗，便於除錯）
    /// 先嘗試 Bundle.main.url，失敗則用 path(forResource:ofType:) 提高相容性
    static var apiKey: String {
        // 方式一：URL 讀取
        if let url = Bundle.main.url(forResource: "RIDBConfig", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let key = dict[plistKey] as? String, !key.isEmpty {
            return key.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        // 方式二：傳統 path 讀取（當 URL 讀取失敗或 Key 為空時）
        if let path = Bundle.main.path(forResource: "RIDBConfig", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let key = dict[plistKey] as? String, !key.isEmpty {
            #if DEBUG
            print("[RIDBAPIConfig] 已透過 path(forResource:ofType:) 讀取到 RIDB_API_KEY")
            #endif
            return key.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        #if DEBUG
        print("[RIDBAPIConfig] RIDBConfig.plist 或 RIDB_API_KEY 未設定，請在 Xcode 中加入 RIDBConfig.plist 並填寫 API Key，並勾選 Target Membership")
        #endif
        return ""
    }

    static var baseURL: String { "https://ridb.recreation.gov/api/v1" }
}
