// 从 Bundle 或远程加载 JSON 数据（与 Figma/Web 数据一致）
import Foundation

enum DataLoader {
    
    // MARK: - 州列表（states-list.json）
    static func loadStatesList() -> [StateListItem] {
        loadBundleJSON("states-list") ?? []
    }
    
    // MARK: - 国家公园（national-parks.json，应为 63 座）
    static func loadNationalParks() -> [NationalPark] {
        let list: [NationalPark]? = loadBundleJSON("national-parks")
        let count = list?.count ?? 0
        #if DEBUG
        if count == 0 {
            if Bundle.main.url(forResource: "national-parks", withExtension: "json") == nil {
                print("[DataLoader] national-parks.json 未在 Bundle 中找到 → Xcode: Build Phases → Copy Bundle Resources 中确认包含 national-parks.json")
            } else {
                print("[DataLoader] national-parks.json 解码失败，返回空数组。请检查 JSON 与 NationalPark 模型字段是否一致")
            }
        } else {
            print("[DataLoader] 已加载 \(count) 座国家公园")
        }
        #endif
        return list ?? []
    }

    // MARK: - 公園備援數據（ParkBackupData.json，缺 Coordinates/Fees/OperatingHours 時補齊）
    static func loadParkBackup() -> ParkBackupData {
        loadBundleJSON("ParkBackupData") ?? [:]
    }

    // MARK: - 公園門戶數據（ParkPortalsData.json，手動整理的機場/入口/駕車時間/建議）
    static func loadParkPortals() -> [String: ParkPortalsItem] {
        let wrapper: ParkPortalsData? = loadBundleJSON("ParkPortalsData")
        return wrapper?.parks ?? [:]
    }

    // MARK: - 单州公园数据（states-parks.json 中按 code 取）
    static func loadStateParks() -> [String: StateData] {
        loadBundleJSON("states-parks") ?? [:]
    }
    
    // MARK: - 国家森林（national-forests.json）
    static func loadNationalForests() -> [NationalForest] {
        let list: [NationalForest]? = loadBundleJSON("national-forests")
        let count = list?.count ?? 0
        #if DEBUG
        if count == 0 {
            if Bundle.main.url(forResource: "national-forests", withExtension: "json") == nil {
                print("[DataLoader] national-forests.json 未在 Bundle 中找到 → Xcode: Build Phases → Copy Bundle Resources 中确认包含 national-forests.json")
            } else {
                print("[DataLoader] national-forests.json 解码失败，返回空数组。请检查 JSON 与 NationalForest 模型字段是否一致")
            }
        } else {
            print("[DataLoader] 已加载 \(count) 座国家森林")
        }
        #endif
        return list ?? []
    }
    
    // MARK: - 国家草原（national-grasslands.json）
    static func loadNationalGrasslands() -> [NationalGrassland] {
        let list: [NationalGrassland]? = loadBundleJSON("national-grasslands")
        let count = list?.count ?? 0
        #if DEBUG
        if count == 0 {
            if Bundle.main.url(forResource: "national-grasslands", withExtension: "json") == nil {
                print("[DataLoader] national-grasslands.json 未在 Bundle 中找到 → Xcode: Build Phases → Copy Bundle Resources 中确认包含 national-grasslands.json")
            } else {
                print("[DataLoader] national-grasslands.json 解码失败，返回空数组。请检查 JSON 与 NationalGrassland 模型字段是否一致")
            }
        } else {
            print("[DataLoader] 已加载 \(count) 处国家草原")
        }
        #endif
        return list ?? []
    }

    // MARK: - 国家森林/草原设施（forest-grassland-facilities.json）
    static func loadForestFacilities() -> [String: ForestFacilitiesData] {
        let dict: [String: ForestFacilitiesData]? = loadBundleJSON("forest-grassland-facilities")
        let count = dict?.count ?? 0
        #if DEBUG
        if count == 0 {
            if Bundle.main.url(forResource: "forest-grassland-facilities", withExtension: "json") == nil {
                print("[DataLoader] forest-grassland-facilities.json 未在 Bundle 中找到 → Xcode: Build Phases → Copy Bundle Resources 中确认包含 forest-grassland-facilities.json")
            } else {
                print("[DataLoader] forest-grassland-facilities.json 解码失败，返回空字典。请检查 JSON 与 ForestFacilitiesData 模型字段是否一致")
            }
        } else {
            print("[DataLoader] 已加载 \(count) 份森林/草原设施数据")
        }
        #endif
        return dict ?? [:]
    }
    
    // MARK: - 国家休闲区（national-recreation.json）
    static func loadNationalRecreation() -> [NationalRecreationArea] {
        loadBundleJSON("national-recreation") ?? []
    }
    
    // MARK: - 区域配置（alabama-regions.json）
    static func loadAlabamaRegions() -> [String: RegionConfig] {
        loadBundleJSON("alabama-regions") ?? [:]
    }

    // MARK: - 国家公园扩展（与 Figma 设计一致）
    static func loadNationalParksFacilities() -> [String: ParkFacilitiesData] {
        loadBundleJSON("national-parks-facilities") ?? [:]
    }

    static func loadNationalParksGallery() -> [String: [String]] {
        loadBundleJSON("national-parks-gallery") ?? [:]
    }

    static func loadNationalParksWeather() -> [ParkWeather] {
        loadBundleJSON("national-parks-weather") ?? []
    }

    static func loadNationalParksWildlife() -> [ParkWildlife] {
        loadBundleJSON("national-parks-wildlife") ?? []
    }

    static func loadNationalParksStats() -> [ParkStatistics] {
        loadBundleJSON("national-parks-stats") ?? []
    }

    static func loadNationalParksLodging() -> [String: ParkLodging] {
        loadBundleJSON("national-parks-lodging") ?? [:]
    }

    private static func loadBundleJSON<T: Decodable>(_ name: String) -> T? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
