# HikBik 公園詳情頁 — API 缺口分析（Gap Analysis）

對齊產品藍圖與 NPS API 文檔，標註各模組數據來源與缺口。

---

## 一、NPS API 直接提供

| 藍圖模組 | NPS 端點/欄位 | 說明 |
|----------|----------------|------|
| **BasicInfo** | `/parks`：id, fullName, parkCode, description, latLong/latitude/longitude, states, addresses, url, designation | 封面圖/相冊需用 `fields=images`；elevation 部分公園有；area/acreage、成立年份、timezone 多數無，需補 |
| **LiveStatus** | `/alerts?parkCode=xxx`：id, title, description, category, url | 開放狀態、季節關閉、火災/道路管制需從 alerts 文案或另接 Forest Service / 本地 |
| **FeesAndPermits** | `/parks`：entranceFees, entrancePasses | 入園費、年票；預約/時段入園需從 alerts 或 NPS 網頁/本地 |
| **FacilitiesInfo** | `/parks`：addresses；可選 visitor centers 等 | 遊客中心、地址有；廁所/水/網路/無障礙需本地或擴充 |
| **SafetyInfo** | `/alerts` 文案、部分 parks 描述 | 野生動物/天氣/海拔風險多來自描述或 alerts，無獨立欄位 |
| **TerrainInfo** | `/parks`：description, weatherInfo | 地形類型、植被多為文字描述，無結構化 elevation_profile/geology |

---

## 二、需對接 Recreation.gov（營地）

| 藍圖模組 | 缺口 | 建議 |
|----------|------|------|
| **Campgrounds** | NPS 無營地列表/預訂 API | 使用 **Recreation.gov API**（需單獨註冊 API key）：營地列表、類型、可預約、價格、設施、booking_url。NPS 僅部分公園頁面有營地連結，無統一結構化數據 |

---

## 三、需對接 NOAA / 天氣服務

| 藍圖模組 | 缺口 | 建議 |
|----------|------|------|
| **WeatherInfo** | NPS 僅有 `weatherInfo` 文字描述，無即時/預報 | 使用 **NOAA Weather API** 或 **OpenWeather**：依公園 coordinates 取 current、7-day、溫度/風/降水、日出日落；best_visit_months 可本地或 AI 補 |

---

## 四、需本地 JSON / 手動補全

| 藍圖模組 | 缺口 | 建議 |
|----------|------|------|
| **BasicInfo** | elevation_range, area_size（acre/km²）, established, timezone | 在 `national-parks.json` 或單獨補充 JSON 依 parkCode 對應 |
| **ActivitiesInfo** | activities_supported, difficulty_level, family_friendly, dog_allowed | NPS 有 topics/activities 但結構與藍圖不盡相同，可從 NPS 映射 + 本地補 |
| **MapData** | boundary_polygon, entrances, parking, viewpoints, danger_zones | NPS 無；需 Mapbox/MapKit 或 USGS/OSM 資料，或本地 GeoJSON |
| **SeasonsInfo** | best_seasons, crowd_level_by_month, peak_months, recommended_duration | NPS 無；本地或 AI 生成 |
| **AccessInfo** | nearest_airport, drive_time_from_major_cities, winter_access | 本地或第三方 |

---

## 五、小結

- **NPS 直接可用**：BasicInfo（部分）、LiveStatus（alerts）、FeesAndPermits（部分）、Facilities（部分）、Safety（來自 alerts/描述）。
- **需另接 API**：**Recreation.gov**（Campgrounds）、**NOAA/OpenWeather**（Weather）。
- **需本地/手動**：elevation_range、area、established、timezone、MapData、Seasons、Access、部分 Activities。

目前 `fetchAllDetail(parkCode:)` 已串接 **/parks** 與 **/alerts**；營地由 **Recreation.gov** 另行對接後再併入同一結構。
