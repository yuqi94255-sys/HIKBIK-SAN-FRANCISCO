// MARK: - NPS API Key 配置（請勿將真實 key 提交到公開 repo）
// 取得 key：https://www.nps.gov/subjects/developer/index.htm
// 將你的 API key 貼在下方，或建立 NPSSecrets.swift 並實作 apiKey（並加入 .gitignore）

import Foundation

enum NPSAPIConfig {
    /// NPS API Key。請替換成你在 developer.nps.gov 申請的 key。
    static var apiKey: String {
        NPSSecrets.apiKey
    }
    
    static var baseURL: String { "https://developer.nps.gov/api/v1" }
}

/// 請將你從 NPS 收到的 API key 貼在下方（僅限本機，勿提交到公開 repo）。
enum NPSSecrets {
    static let apiKey: String = "u0luYUA2DB6oUbHZ8N1TBkRvwKXUgbj1b7uGMhx5"
}
