# 前端與後端相關位置清單（給後端 / 另一 Cursor 對接用）

以下為 iOS 專案中**所有與後端相關**的檔案與位置，按類別羅列。接後端時只需改動這些位置，其餘 UI 無需改動。

---

## 一、網路層與 API 配置

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Services/APIConfig.swift` | 主後端根 URL | `static let baseURL`（例：`http://…:3000/api`）。真機區網 HTTP 依賴 `Info.plist` 中 `NSAllowsArbitraryLoads`。 |
| `Services/APIClientBase.swift` | 通用 API 客戶端（別名 `NetworkManager`） | `baseURL` 來自 `APIConfig`；DEBUG 可用環境變數 `HIKBIK_API_BASE` 覆蓋。`authToken` 從 `UserDefaults["hikbik.authToken"]` 讀。請求頭：`Authorization: Bearer {token}`，Body **snake_case**。 |
| `Services/RIDBAPIConfig.swift` | RIDB 休閒區 API 配置 | `apiKey`、`baseURL`（目前 `https://ridb.recreation.gov/api/v1`）。僅讀取第三方 RIDB，非你們後端。 |
| `Services/RIDBService.swift` | RIDB 請求實現 | 使用 `URLSession`，GET `/recareas`、`/recareas/{id}/media`、`/recareas/{id}/facilities`。若後端做 RIDB 代理，可改為調你們域名。 |
| `Services/NPSAPIConfig.swift` | NPS 公園 API 配置 | `apiKey`、`baseURL`（`https://developer.nps.gov/api/v1`）。僅讀取 NPS，非你們後端。 |
| `Services/NPSAPIService.swift` | NPS 請求實現 | GET `/parks`、`/alerts`、`/visitorcenters`，query 帶 `parkCode`、`api_key`。同上，可改為走你們後端代理。 |
| `Features/Login/LandingView.swift` | 登入/註冊頁 | 約 895、912 行：Terms/Privacy 連結為 `https://hikbik.example/...`，可改為你們的條款頁。 |
| `Services/AuthService.swift` | 登入/註冊/檢查郵箱 | `baseURL` 與 `APIConfig` 同源。`checkEmailExists` 等接真實後端時改為 URLSession 或 `APIClientBase`。登入成功後寫入 `UserDefaults["hikbik.authToken"]`。 |
| `Features/Orders/OrderService.swift` | 訂單服務 | 約 21 行：TODO 替換為 URLSession 或 APIClient，讀取/提交訂單。 |
| `Services/ShippingService.swift` | 物流/運單 | 約 49、71 行：TODO 替換為真實 API（如 EasyPost）。 |
| `Services/WeatherManager.swift` | 天氣 | 約 48 行：目前 Mock，註解「接入時替換為 WeatherService」。 |

---

## 二、當前用戶與社交（點讚 / 收藏 / 關注）

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Features/Community/CurrentUser.swift` | 點讚、收藏、關注、打卡 | 全文。目前：`likedPostIds`、`savedPostIds` 存 **UserDefaults**（key：`CurrentUser.likedPostIds`、`CurrentUser.savedPostIds`）；`toggleLike(postId:)`、`toggleSave(postId:)` 僅改本地並發 `Notification.socialStatusChanged`。接後端需：同步到 API（如 POST/DELETE like/save），並可選從 API 拉取當前用戶的 liked/saved 列表。`followingUserIds`、`toggleFollow` 目前為模擬延遲，需改為真實關注 API。 |
| `Services/SocialDataManager.swift` | 另一套 Like/Favorite + Track 快取 | `favoriteKey`、`likeKey`（UserDefaults）；`saveTrackJourney(id:journeyData:)`、`getTrackJourneyData(id:)` 存 per-track 的 Data。若後端統一管理收藏與軌跡快取，可改為調 API 讀寫。 |
| `Services/ProfileLikedStore.swift` | Profile「喜歡」列表持久化 | UserDefaults key 存 liked 的 id 數組。可改為從後端 GET /me/liked。 |
| `Features/Community/CommunityDiscoveryView.swift` | 社區列表與卡片 | 依賴 `CurrentUser.toggleLike`/`toggleSave`、`postCommentStore.commentCount`。數據來源見「發佈與草稿」；若 feed 來自後端，需在此處改為從 API 拉列表。 |
| `Features/Profile/ProfileView.swift` | 個人頁 | 約 124–125 行：`userName` 從 `UserDefaults["hikbik_user_name"]`，`isLoggedIn` 從 `UserDefaults["hikbik_user"]`。約 307、481–482、611、671–678、799–805 行：Liked/Saved 標籤與列表來自 `currentUser.likedPostIds`/`savedPostIds` 的解析。頭像、暱稱、簡介、Following/Followers 數目前多為寫死或本地（約 142–144、391–456 行）。後端需提供：用戶 profile（頭像、暱稱、簡介、following_count、followers_count）、可選總里程；GET /me/liked、/me/saved 用於列表。 |
| `App/SocialManager.swift` | 關注關係與用戶快取 | 全文。`users: [String: User]` 內存存儲；`currentUserId` 寫死 `"current_user"`；`toggleFollow(for:currentUserId:)` 模擬 0.5s 延遲後更新 followersCount/isFollowing。接後端需：GET /users/:id 或批量獲取作者信息；POST/DELETE /users/:id/follow；用 API 驅動 `users` 與關注數。使用處：`CommunityDiscoveryView`（266、340、355、363、417、431、439 行）、`CommunityMacroDetailView`（131、256–257、395、418 行）、`UserProfileView`（11、52–53、65–66、69、97、99 行）、`ContentView`（8、32、58 行）。 |

---

## 三、評論

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Features/Routes/CommunityMacroDetailView.swift` | 評論區定義與使用 | 約 84–122 行：`PostCommentStore`（`commentsByPostId: [String: [CommunityComment]]`），內存無持久化。約 1139–1161 行：`addComment(postId:authorName:text:date:)`、`sortedComments(for:)`、`toggleCommentLike`。接後端需：GET /posts/:id/comments、POST /posts/:id/comments、POST/DELETE 評論點讚，並用 API 數據驅動 `commentsByPostId`。 |
| `App/ContentView.swift` | 注入 PostCommentStore | 約 34、60 行：`.environmentObject(PostCommentStore.shared)`。若改為從後端拉評論，只需改 PostCommentStore 內部實現。 |

---

## 四、評分 / 評論（路線 Review）

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Features/Routes/ReviewManager.swift` | 路線評分與評論存儲 | 全文。`storage: [String: [RouteReview]]` 按 routeId 存，**內存**無持久化。`currentUserId` 寫死 `"me"`。約 15 行註解：TODO 改為 Firebase/Backend。接後端需：GET /routes/:id/reviews、POST 提交 review、DELETE 刪除本人評論，並用 API 驅動 `storage`。 |
| `Features/Routes/OverallRouteReviewsView.swift` | 全部評分/評論 UI | 約 350、543、549、665、758、1039 行：調用 `ReviewManager.shared` 的 add/remove/hasCurrentUserReviewed。 |
| `Features/Routes/OfficialRouteDetailView.swift` | 官方路線詳情 | 約 42、104、122、722 行：同上，並有 TODO「Fetch data from Firebase/Backend」。 |

---

## 五、發佈與草稿（帖子 / 軌跡）

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Services/TrackDataManager.swift` | 發佈列表與草稿列表的單一數據源 | `publishedTracks` 持久化到 **文件** `publishedTracks.json`（Document 目錄）；`draftTracks` 僅內存。`addPublished`、`addDraft`、`removePublished`、`removeDraft`、`reloadFromStore`。接後端需：發佈時 POST 到後端並可選仍寫本地；列表改為 GET /me/posts 與 /me/drafts（或等價），並寫回 `publishedTracks`/`draftTracks`。 |
| `Features/Routes/UnifiedDraftBox.swift` | 草稿單條持久化 | 約 498–508 行：UserDefaults key `"UnifiedDraftBox"` 存單一 DraftItem 的 Data（恢復用）。若草稿改為後端存儲，可改為從 API 拉/寫。 |
| `Features/Routes/CustomRouteBuilderView.swift` | 發布宏觀行程 | 約 556 行註解：模擬上傳 Macro Journey，寫入 PostMediaStore、publishedTracks、prepend；「接後端時替換為 API 調用」。需改為：上傳媒體 + POST 行程到後端，再調 `TrackDataManager.addPublished`（或由 API 返回列表後刷新）。 |
| `Features/Routes/PostEditorView.swift` | 發布微觀/其他類型 | 依賴 TrackDataManager 的 addPublished/addDraft。若發布改為走 API，需在此處調用你們的發布接口並刷新列表。 |

---

## 六、收藏（目的地 / 公園等）

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Models/SavedDestination.swift` | 收藏目的地模型 | 結構體：id, name, category, agency, imageUrl, latitude, longitude, dateSaved。後端若做「收藏目的地」，可與此結構對齊。 |
| `Services/FavoritesManager.swift` | 目的地收藏讀寫 | UserDefaults key `"savedDestinations"` 存 `[SavedDestination]`；save/remove/load/contains。接後端需：GET /me/destinations、POST/DELETE 收藏，並用 API 驅動 load/save。 |
| `Features/Routes/RouteFavoritesStore.swift` | 路線收藏 ID 列表 | UserDefaults 存 favoriteIds（字串數組）。可改為從後端 GET /me/favorites 或等價。 |

---

## 七、媒體與帖子關聯

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Services/PostMediaStore.swift` | 帖子媒體 URL 按 postId 存儲 | UserDefaults key 前綴 `"PostMediaStore_urls_"` + postId，存 [String]（圖片 URL）。用於輪播與詳情。若圖片改為後端 CDN，上傳後需把返回的 URL 寫入此處或由 API 在帖子數據裡帶回。 |
| `Features/Routes/CommunityMacroDetailView.swift` 約 348 | 頭圖下載 | `URLSession.shared.data(from: url)` 下載圖片。若 URL 來自後端，無需改此處；若需帶 Token 或專用域名，可改為 APIClientBase 或自定義請求。 |

---

## 八、其他本地持久化（可選遷移後端）

| 檔案路徑 | 說明 | 後端需對接內容 |
|----------|------|----------------|
| `Features/Community/CommunityViewModel.swift` | 最近搜尋 | UserDefaults key `recentSearchesKey`，存 [String]。可選：同步到後端 /me/recent-searches。 |
| `Features/Explore/StatePickerView.swift` | 最近選擇的州 | UserDefaults key `recentStatesKey`。可選同步。 |
| `App/UserState.swift` | 登入狀態 | UserDefaults key `"hikbik_user_status"`（UserStatus rawValue）。登入/登出時寫入；與 AuthService 配合。 |
| `Features/Profile/ProfileView.swift` | 用戶名、是否登入 | `hikbik_user_name`、`hikbik_user`（約 124–125、307）。登入後由 Auth 流程寫入；可改為從後端 profile 拉暱稱。 |
| `Services/ProfileCollectionsStore.swift` | 用戶自建合集 | UserDefaults 存 [ProfileCollection]。可選改為後端 CRUD。 |
| `Services/ProfileAchievementsStore.swift` | 成就進度（里程等） | UserDefaults 存 cumulativeMiles、hasImportedGPX 等。可選改為後端統計。 |
| `Services/AchievementStore.swift` | 成就解鎖狀態 | UserDefaults 存 unlockedIds、unlockedDates 等。可選改為後端。 |
| `Services/TripStore.swift` | 行程存儲 | UserDefaults 存行程數據。可選改為後端。 |
| `Services/FavoritesStore.swift` | 舊版收藏（按類型分鍵） | 已由 FavoritesManager 遷移，可忽略或刪除。 |
| `Features/Shop/UserProfileManager.swift` | 商店用戶資料/支付方式 | 約 148–172 行：UserDefaults 讀寫用戶資料。可改為從後端 GET/PUT profile。 |
| `Features/Routes/CustomRouteBuilderView.swift` | 草稿恢復、LiveTrack 草稿 | 約 17–21、3737、3793、3836 行：UserDefaults 存 draft 恢復數據。若草稿改為後端，可改為從 API 拉取。 |

---

## 九、數據模型（後端需對齊或提供）

| 模型 | 檔案路徑 | 用途 |
|------|----------|------|
| DraftItem / Track | `Features/Routes/UnifiedDraftBox.swift`、`Services/TrackDataManager.swift` | 草稿與發佈條目；含 category、title、waypoints、polylineCoordinates、durationSeconds、coverImageData、macroJourneyJSON、detailedTrackJSON 等。 |
| DetailedTrackPost / ViewPointNode | `Models/DetailedTrackModel.swift` | 微觀路線：trackTier、subCategoryDisplay、routeName、viewPointNodes（含 latitude、longitude、arrivalTime、elevation、hasWater、hasFuel、signalStrength）、primaryActivityType 等。 |
| CommunityJourney / MacroJourneyPost | `Models/CommunityJourney.swift`、`Models/MacroJourneyModel.swift` | 宏觀行程：journeyName、days、selectedStates、tags、author、likeCount、commentCount、imageUrls 等。 |
| SavedDestination | `Models/SavedDestination.swift` | 收藏目的地：id、name、category、agency、imageUrl、latitude、longitude、dateSaved。 |
| RouteReview / CommunityComment | 見 ReviewManager、CommunityMacroDetailView | 評分評論：rating、comment、author、date、userId；評論：authorName、text、date、likeCount、isLiked。 |

---

## 十、後端接口建議彙總（給後端實現用）

- **Auth**：POST 登入/註冊；返回或刷新 token；前端寫入 `UserDefaults["hikbik.authToken"]`。GET 檢查郵箱是否已註冊（AuthService）。
- **用戶 Profile**：GET /me 或 /user/profile（頭像、暱稱、簡介、following_count、followers_count、可選 total_mileage）。
- **Like/Save 貼文**：POST/DELETE 如 /posts/:id/like、/posts/:id/save；參數僅 postId（或由 token 識別用戶）。GET /me/liked、/me/saved 用於 Profile 列表。
- **評論**：GET /posts/:id/comments；POST /posts/:id/comments（body: authorName/authorId, text）；POST 評論點讚。
- **路線評分/評論**：GET /routes/:id/reviews；POST 提交 review；DELETE 刪除本人 review。
- **發佈/草稿**：POST 發布（body 含軌跡/行程 JSON、媒體 URL）；GET /me/posts、/me/drafts；DELETE 刪除發佈。
- **收藏目的地**：GET /me/destinations；POST/DELETE /me/destinations 或 /favorites/destinations（body 與 SavedDestination 對齊）。
- **關注**：POST/DELETE 如 /users/:id/follow；GET /me/following、/me/followers。

---

**使用說明**：把本文件交給負責後端的 Cursor 或工程師，按上述檔案與行號改動或對接 API 即可；前端其餘 UI 綁定不變。
