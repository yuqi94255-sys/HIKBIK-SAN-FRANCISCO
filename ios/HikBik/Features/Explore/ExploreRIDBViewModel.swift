// MARK: - Forest / Grassland 數據：優先使用 RIDB 真實數據，缺省時用本地 JSON

import Foundation
import Combine

@MainActor
final class ExploreRIDBViewModel: ObservableObject {
    @Published private(set) var forests: [NationalForest] = []
    @Published private(set) var grasslands: [NationalGrassland] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let ridb = RIDBService.shared

    init() {
        loadFromRIDBIfAvailable()
    }

    /// 先載入本地 JSON 以即時顯示，再非同步請求 RIDB，成功則以 RIDB 覆蓋
    func loadFromRIDBIfAvailable() {
        forests = DataLoader.loadNationalForests()
        grasslands = DataLoader.loadNationalGrasslands()
        errorMessage = nil
        Task {
            await fetchRIDBAndReplace()
        }
    }

    /// 請求 GET /recareas，依 RecAreaType 篩選國家森林與草原，轉為現有模型並覆蓋列表
    func fetchRIDBAndReplace() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let all = try await ridb.fetchRecAreas(limit: 100, offset: 0)
            let forestsList = all.filter { $0.type == .nationalForest }.map(RIDBAdapter.toNationalForest)
            let grasslandsList = all.filter { $0.type == .nationalGrassland }.map(RIDBAdapter.toNationalGrassland)
            if !forestsList.isEmpty { forests = forestsList }
            if !grasslandsList.isEmpty { grasslands = grasslandsList }
        } catch {
            errorMessage = error.localizedDescription
            #if DEBUG
            print("[ExploreRIDB] RIDB 請求失敗，沿用本地數據: \(error.localizedDescription)")
            #endif
        }
    }
}
