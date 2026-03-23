// MARK: - HIKBIK Official Route Detail — 數據驅動 + 像素級還原
// UI 與數據分離：所有內容來自 routeData（RouteDataProtocol），組件僅接收 props。
import SwiftUI
import MapKit

// MARK: - Step 1: 視覺基調與全局常量 (HIKBIKTheme)
// 不准使用預設值；Figma 硬性標準。
struct HIKBIKTheme {
    /// 背景色
    static let background = Color(hex: "0A0C10")
    /// 組件間距（呼吸感）
    static let sectionSpacing: CGFloat = 48
    /// 磨砂玻璃：blur 25（iOS 以 Material 近似）, bgOpacity 0.03, stroke rgba(255,255,255,0.08)
    static let glassBlur: CGFloat = 25
    static let glassBgOpacity: CGFloat = 0.03
    static let glassBg = Color.white.opacity(glassBgOpacity)
    static let glassStroke = Color.white.opacity(0.08)
    /// 字體：SF Pro（系統預設即 SF Pro）
    static let fontTitle = Font.system(size: 24, weight: .bold)
    static let fontBody = Font.system(size: 16, weight: .regular)
    static let fontCaption = Font.system(size: 14, weight: .regular)
    /// 卡片圓角（Figma 16px）
    static let cardCornerRadius: CGFloat = 16
    /// 主文字 / 次要文字 / 強調色
    static let textPrimary = Color.white
    static let textMuted = Color.white.opacity(0.7)
    static let accentNeonGreen = Color(hex: "3FFD98")
    static let timelineBlue = Color(hex: "4A90D9")
    static let timelineBlueLight = Color(hex: "7BB3E8")
    static let permitYellow = Color(hex: "EAB308")
    static let criticalRed = Color(hex: "EF4444")
    static let blockPadding: CGFloat = 20
}

// MARK: - Main View（僅組裝組件 + 黑色容器 + 雙軌制點評 + 收藏）
struct OfficialRouteDetailView: View {
    /// 數據驅動：切換此對象即可全頁更新，無需改 UI 代碼
    var routeData: RouteDetailData
    @Environment(\.dismiss) private var dismiss

    @State private var trailReports: [TrailReport] = []
    @StateObject private var reviewManager = ReviewManager.shared
    /// 海拔圖表選中里程（未來聯動）；Share Report 默認使用此值
    @State private var selectedMileForReport: Double = 0
    @State private var showShareReport = false
    @State private var showWriteReview = false
    @State private var showMacroNavigation = false
    @StateObject private var routeFavorites = RouteFavoritesStore.shared

    /// 從列表進入：由 RouteItem 組裝 routeData
    init(route: RouteItem?) {
        self.init(routeData: route.map { RouteDetailData(routeItem: $0) } ?? .mockArizona)
    }

    /// 直接注入 routeData（Preview 或 API 用）
    init(routeData: RouteDetailData) {
        self.routeData = routeData
    }

    /// 從 OfficialDetailedTrack 注入（100 條官方路線只改數據、不改代碼）
    init(track: OfficialDetailedTrack) {
        self.routeData = RouteDetailData(from: track)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(showsIndicators: false) {
                // 頂部貼合：Hero 全寬且貼合螢幕頂端，下方內容再套水平 padding
                VStack(alignment: .leading, spacing: 0) {
                    HeroMap(data: routeData)
                    VStack(alignment: .leading, spacing: 0) {
                        StatCards(stats: routeData.stats, themeColor: routeData.themeColor, isSingleTrack: routeData.itinerary.isEmpty)
                        WeatherModuleView(data: routeData)
                        LiveTrailReportsView(reports: trailReports, highlightedMile: selectedMileForReport > 0 ? selectedMileForReport : nil, onShareReport: { showShareReport = true })
                        if !routeData.itinerary.isEmpty {
                            ItineraryList(items: routeData.itinerary)
                        }
                        TechSpecs(specs: routeData.techSpecs)
                        GearGrid(gear: routeData.gear)
                        OverallRouteReviewsView(reviews: reviewManager.reviews(for: routeData.routeId), routeId: routeData.routeId, onWriteReview: { showWriteReview = true })
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                .ignoresSafeArea(edges: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(HIKBIKTheme.background)
            .ignoresSafeArea(edges: .top) // ScrollView 頂到螢幕上緣，Hero 才能真貼合

            topBar
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom, spacing: 0) { grandJourneyStartButton }
        .fullScreenCover(isPresented: $showMacroNavigation) {
            NavigationStack {
                OfficialMacroNavigationView(route: macroRouteForRouteData())
            }
        }
        .onAppear {
            trailReports = routeData.trailReports
            reviewManager.seedIfNeeded(routeData.reviews, routeId: routeData.routeId)
            // TODO: Fetch data from Firebase/Backend; replace @State trailReports and ReviewManager with API response
        }
        .sheet(isPresented: $showShareReport) {
            ShareReportSheet(isPresented: $showShareReport, defaultMileMarker: selectedMileForReport) { status, segment, desc, mile in
                let segmentName = (segment.isEmpty || segment == "Segment") ? "User_\(Int.random(in: 1...999))" : segment
                let content = desc.isEmpty || desc == "No description." ? "Report at mile \(String(format: "%.1f", mile))" : desc
                let newReport = TrailReport(status: status, segmentLabel: segmentName, description: content, mileMarker: mile)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    trailReports.insert(newReport, at: 0)
                }
            }
        }
        .sheet(isPresented: $showWriteReview) {
            WriteReviewSheet(
                isPresented: $showWriteReview,
                routeId: routeData.routeId,
                existingReview: reviewManager.reviews(for: routeData.routeId).first { RouteReview.isCurrentUser($0) }
            ) { rating, comment, selectedTags, photoData in
                let newReview = RouteReview(rating: rating, comment: comment.isEmpty ? "No comment." : comment, author: nil, date: Date(), selectedTags: selectedTags, photoData: photoData, userId: ReviewManager.currentUserId)
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    reviewManager.add(newReview, routeId: routeData.routeId)
                }
            }
        }
    }

    /// Grand Journey / 宏觀路線頁底部：Start Navigation（與本頁佈局同色，與 StatCards 一致：themeColor ?? timelineBlueLight）
    private var grandJourneyStartButton: some View {
        let accent = routeData.themeColor ?? HIKBIKTheme.timelineBlueLight
        return Button {
            AuthGuard.run(message: AuthGuardMessages.startNavigation) {
                showMacroNavigation = true
            }
        } label: {
            Text("Start Navigation")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [accent, accent.opacity(0.75)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(HIKBIKTheme.background)
    }

    private func macroRouteForRouteData() -> OfficialMacroRoute {
        // Trip Itinerary（Phoenix → Sedona → Grand Canyon）用 arizonaTripItinerary
        if routeData.routeId == "az_mock" {
            return .arizonaTripItinerary
        }
        if let firstDay = routeData.itinerary.first, firstDay.title == "Phoenix to Sedona" {
            return .arizonaTripItinerary
        }
        // Sonoran 環線（Apache Junction → Roosevelt → Saguaro）用 arizonaDesertExplorer
        return .arizonaDesertExplorer
    }

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17, weight: .regular))
                }
                .foregroundStyle(HIKBIKTheme.textPrimary)
                .padding(.leading, 4)
                .frame(height: 44)
            }
            .buttonStyle(.plain)
            Spacer()
            Button {
                AuthGuard.run(message: AuthGuardMessages.collectRoute) {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    routeFavorites.toggle(routeData.routeId)
                }
            } label: {
                Image(systemName: routeFavorites.isFavorite(routeData.routeId) ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundStyle(routeFavorites.isFavorite(routeData.routeId) ? Color(hex: "EC4899") : HIKBIKTheme.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.top, 12) // 避開動態島/狀態列，確保 Back、愛心可點
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [HIKBIKTheme.background, HIKBIKTheme.background.opacity(0)],
                startPoint: .top, endPoint: .bottom
            )
        )
    }
}

// MARK: - Step 3: Hero & Stats — 對齊圖二：全寬貼邊、高 460、標題沉底、底部漸層
struct HeroMap: View {
    let data: RouteDataProtocol

    private static let heroHeight: CGFloat = 460

    var body: some View {
        // 外層無 padding，左右徹底頂死
        ZStack(alignment: .bottomLeading) {
            // 1. 底層大圖：全寬拉長、比例填充、頂部貼合劉海
            heroImageLayer
                .frame(width: UIScreen.main.bounds.width, height: Self.heroHeight)
                .clipped()
                .ignoresSafeArea(edges: .top)

            // 2. 底部遮罩（讓文字更清晰）
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 180)
                .frame(maxWidth: .infinity)
            }

            // 3. 標題內容（ZStack .bottomLeading 壓在底部，.padding(.bottom, 40) 下沉；主題色綁定）
            VStack(alignment: .leading, spacing: 10) {
                if !data.heroTagLabels.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(Array(data.heroTagLabels.enumerated()), id: \.offset) { offset, tag in
                            Text(tag)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    (data.themeColor != nil && tag.uppercased().contains("OFFICIAL")) ? data.themeColor! : Color.white.opacity(0.15)
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
                Text(data.routeName)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(HIKBIKTheme.textPrimary)
                    .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 2)
                HStack(spacing: 12) {
                    if let rating = data.heroRating, let count = data.heroReviewCount {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(data.themeColor ?? HIKBIKTheme.permitYellow)
                            Text("\(rating) (\(count))")
                                .font(.system(size: 14))
                                .foregroundStyle(HIKBIKTheme.textPrimary)
                        }
                    }
                    if let initials = data.heroAuthorInitials, let handle = data.heroAuthorHandle {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(HIKBIKTheme.timelineBlue)
                                .frame(width: 24, height: 24)
                                .overlay(Text(initials).font(.system(size: 10, weight: .bold)).foregroundStyle(.white))
                            Text(handle)
                                .font(.system(size: 14))
                                .foregroundStyle(HIKBIKTheme.textMuted)
                        }
                    }
                }
                if let desc = data.heroShortDescription, !desc.isEmpty {
                    Text(desc)
                        .font(HIKBIKTheme.fontCaption)
                        .foregroundStyle(HIKBIKTheme.textMuted)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(width: UIScreen.main.bounds.width)
        .frame(height: Self.heroHeight)
        .clipped()
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: HIKBIKTheme.cardCornerRadius,
            bottomTrailingRadius: HIKBIKTheme.cardCornerRadius,
            topTrailingRadius: 0
        ))
        .ignoresSafeArea(edges: .top)
        .padding(.bottom, HIKBIKTheme.sectionSpacing)
    }

    private var heroImageLayer: some View {
        Group {
            if data.heroImage.isEmpty {
                HIKBIKTheme.background
            } else {
                AsyncImage(url: URL(string: data.heroImage)) { phase in
                    switch phase {
                    case .success(let img):
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        HIKBIKTheme.background
                    @unknown default:
                        HIKBIKTheme.background
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: Self.heroHeight)
        .clipped()
    }
}

// MARK: - StatCards（磨砂玻璃 2x2；單次路線時不顯示 Day，改為 Route）
struct StatCards: View {
    let stats: RouteDetailStats
    var themeColor: Color? = nil
    var isSingleTrack: Bool = false

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(
                icon: isSingleTrack ? "map" : "calendar",
                value: isSingleTrack ? "Single" : "\(stats.days) Days",
                label: isSingleTrack ? "Route" : "Total Days",
                themeColor: themeColor
            )
            StatCard(icon: "point.topleft.down.to.point.bottomright.curvedpath", value: stats.distance, label: "Total Distance", themeColor: themeColor)
            StatCard(icon: "car.fill", value: stats.vehicle, label: "Vehicle", themeColor: themeColor)
            StatCard(icon: "antenna.radiowaves.left.and.right", value: stats.signal, label: "Cell Signal", themeColor: themeColor)
        }
        .padding(.top, 0)
        .padding(.bottom, HIKBIKTheme.sectionSpacing)
    }
}

private struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    var themeColor: Color? = nil

    var body: some View {
        let accent = themeColor ?? HIKBIKTheme.timelineBlueLight
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(HIKBIKTheme.textPrimary)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(HIKBIKTheme.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(HIKBIKTheme.glassBg)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius)
                .strokeBorder(themeColor != nil ? accent.opacity(0.6) : HIKBIKTheme.glassStroke, lineWidth: 1)
        )
    }
}

// MARK: - ItineraryList（Map 循環渲染，僅用 items）
struct ItineraryList: View {
    let items: [RouteDetailItineraryItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Trip Itinerary")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(HIKBIKTheme.textPrimary)
                .padding(.bottom, 8)
            Text("Your complete day-by-day journey")
                .font(.system(size: 14))
                .foregroundStyle(HIKBIKTheme.textMuted)
                .padding(.bottom, 24)

            ForEach(items) { day in
                ItineraryDayView(day: day, isLast: day.id == items.last?.id)
            }
        }
        .padding(.bottom, HIKBIKTheme.sectionSpacing)
    }
}

// MARK: - 統一行程日組件（每一天 UI 完全相同，僅依 day.displayImages.count 自動切換單圖 / 橫滑+分頁點）
private struct ItineraryDayView: View {
    let day: RouteDetailItineraryItem
    let isLast: Bool
    private let nodeSize: CGFloat = 28
    private let breathing: CGFloat = 48
    private var lineHeight: CGFloat { isLast ? 24 : 280 + breathing }

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            timelineNode
            dayContent
        }
        .padding(.bottom, breathing)
    }

    private var timelineNode: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(LinearGradient(colors: [HIKBIKTheme.timelineBlueLight, HIKBIKTheme.timelineBlue], startPoint: .top, endPoint: .bottom))
                .frame(width: 2, height: lineHeight)
                .offset(x: 0, y: nodeSize / 2)
                .shadow(color: HIKBIKTheme.timelineBlue.opacity(0.6), radius: 4)
            Circle()
                .fill(HIKBIKTheme.timelineBlue)
                .frame(width: nodeSize, height: nodeSize)
                .overlay(Text("\(day.day)").font(.system(size: 14, weight: .bold)).foregroundStyle(.white))
                .overlay(Circle().strokeBorder(HIKBIKTheme.timelineBlueLight.opacity(0.8), lineWidth: 1.5))
                .shadow(color: HIKBIKTheme.timelineBlue.opacity(0.9), radius: 8)
                .shadow(color: HIKBIKTheme.timelineBlueLight.opacity(0.5), radius: 14)
        }
        .frame(width: 36, height: lineHeight + nodeSize / 2, alignment: .top)
    }

    private var dayContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(day.day)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(HIKBIKTheme.timelineBlueLight)
            HStack(alignment: .firstTextBaseline) {
                Text(day.title)
                    .font(.system(size: 18, weight: .bold))
                    .tracking(-0.2)
                    .lineSpacing(4)
                    .foregroundStyle(HIKBIKTheme.textPrimary)
                Spacer(minLength: 8)
                Text(day.distance)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(HIKBIKTheme.timelineBlueLight)
            }
            Text(day.desc)
                .font(.system(size: 14))
                .lineSpacing(5)
                .foregroundStyle(HIKBIKTheme.textMuted)
                .fixedSize(horizontal: false, vertical: true)
            OfficialRoute_ImageCarousel(images: day.displayImages)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - 全員大尺寸輪播（單一組件：單圖/多圖/無圖統一尺寸，單圖隱藏 Dots，多圖顯示 Dots）
/// 視覺基準：屏幕寬度 90%+（外層已 20pt 留白）、高度 max(250pt, 30% 屏高)、16:9 大氣比例、16pt 圓角 + 1pt 白邊 0.08
private struct OfficialRoute_ImageCarousel: View {
    let images: [String]

    /// 大尺寸：寬度由外層 20pt 留白後 ~90% 屏寬，高度 16:9 且至少 250pt
    private static var carouselHeight: CGFloat {
        let w = UIScreen.main.bounds.width - 40
        return max(250, w * 9 / 16)
    }

    var body: some View {
        let displayURLs = images.isEmpty ? [""] : images
        let showDots = images.count > 1

        TabView {
            ForEach(Array(displayURLs.enumerated()), id: \.offset) { index, url in
                ItineraryImageCard(imageURL: url)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: showDots ? .always : .never))
        .frame(maxWidth: .infinity)
        .frame(height: Self.carouselHeight)
        .clipShape(RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius)
                .strokeBorder(HIKBIKTheme.glassStroke, lineWidth: 1)
        )
    }
}

private struct ItineraryImageCard: View {
    let imageURL: String

    var body: some View {
        Group {
            if imageURL.isEmpty {
                placeholderView
            } else {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .success(let img):
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderView
                    default:
                        placeholderView
                            .overlay(ProgressView().tint(.white))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius))
    }

    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius)
            .fill(Color(hex: "1a1d24"))
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.35))
                    Text("Photos")
                        .font(.system(size: 13))
                        .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.35))
                }
            )
    }
}

// MARK: - TechSpecs（2x2，僅用 specs）
struct TechSpecs: View {
    let specs: RouteDetailTechSpecs

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "map")
                    .font(.system(size: 16))
                    .foregroundStyle(HIKBIKTheme.accentNeonGreen)
                Text("Technical Specifications")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(HIKBIKTheme.textPrimary)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                TechSpecCell(icon: "mountain.2.fill", label: "Surface Type", value: specs.surfaceType)
                TechSpecCell(icon: "antenna.radiowaves.left.and.right", label: "Cell Signal", value: specs.cellSignal, valueColor: HIKBIKTheme.accentNeonGreen)
                TechSpecCell(icon: "car.fill", label: "Vehicle Access", value: specs.vehicleAccess, valueColor: HIKBIKTheme.accentNeonGreen, borderColor: HIKBIKTheme.accentNeonGreen)
                TechSpecCell(icon: "clipboard.fill", label: "Permit Status", value: specs.permitStatus, valueColor: HIKBIKTheme.permitYellow, borderColor: HIKBIKTheme.permitYellow)
            }
        }
        .padding(.bottom, HIKBIKTheme.sectionSpacing)
    }
}

private struct TechSpecCell: View {
    let icon: String
    let label: String
    let value: String
    var valueColor: Color = HIKBIKTheme.textPrimary
    var borderColor: Color? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(HIKBIKTheme.textMuted)
                Text(label)
                    .font(.system(size: 13))
                    .foregroundStyle(HIKBIKTheme.textMuted)
            }
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(valueColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(HIKBIKTheme.glassBg)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 1 : 0)
        )
    }
}

// MARK: - GearGrid（橫向 scroller，僅用 gear；critical 紅點）
struct GearGrid: View {
    let gear: [RouteDetailGearItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "backpack.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(HIKBIKTheme.accentNeonGreen)
                Text("Essential Gear")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(HIKBIKTheme.textPrimary)
                Spacer()
                Text("Moderate")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(HIKBIKTheme.permitYellow)
                    .clipShape(Capsule())
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(gear) { item in
                        GearCard(name: item.name, icon: item.icon, critical: item.critical)
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(height: 100)

            HStack {
                HStack(spacing: 6) {
                    Circle().fill(HIKBIKTheme.criticalRed).frame(width: 6, height: 6)
                    Text("\(gear.filter(\.critical).count) Essential Items")
                        .font(.system(size: 13))
                        .foregroundStyle(HIKBIKTheme.textMuted)
                }
                Spacer()
                Text("\(gear.count) Total Items")
                    .font(.system(size: 13))
                    .foregroundStyle(HIKBIKTheme.textMuted)
            }
        }
        .padding(.bottom, HIKBIKTheme.sectionSpacing)
    }
}

private struct GearCard: View {
    let name: String
    let icon: String
    let critical: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(HIKBIKTheme.accentNeonGreen)
                if critical {
                    Circle()
                        .fill(HIKBIKTheme.criticalRed)
                        .frame(width: 8, height: 8)
                        .offset(x: 4, y: -4)
                }
            }
            Text(name)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(HIKBIKTheme.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 88, height: 88)
        .background(HIKBIKTheme.glassBg)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(HIKBIKTheme.glassStroke, lineWidth: 1)
        )
    }
}

// MARK: - Preview（切換 mock 即可驗證數據驅動）
#Preview("Arizona") {
    NavigationStack {
        OfficialRouteDetailView(routeData: .mockArizona)
    }
}

#Preview("Arizona Desert Explorer") {
    NavigationStack {
        OfficialRouteDetailView(routeData: .mockArizonaDesertExplorer)
    }
}

#Preview("Moab Official Track") {
    NavigationStack {
        OfficialRouteDetailView(track: .moabSlickrock)
    }
}

// MARK: - Official Detailed Track View（統一戰術紫 #A855F7，與 OfficialRouteDetailView 同 target）
private enum OfficialTrackViewTheme {
    static let background = Color(hex: "0A0C10")
    static let cardBackground = Color.white.opacity(0.06)
    static let sectionSpacing: CGFloat = 32
    static let blockPadding: CGFloat = 20
    static let cardCornerRadius: CGFloat = 16
    static let textPrimary = Color.white
    static let textMuted = Color.white.opacity(0.7)
    static let permitWarning = Color(hex: "EAB308")
    static let permitDanger = Color(hex: "EF4444")
    /// 所有 Official Detailed Track 統一戰術紫
    static let tacticalPurple = Color(hex: "A855F7")
}

struct OfficialDetailedTrackView: View {
    private let payload: OfficialTrackPayload?
    private let track: OfficialDetailedTrack?

    @Environment(\.dismiss) private var dismiss
    @StateObject private var reviewManager = ReviewManager.shared
    @State private var showDetailedTrackNavigation = false

    /// 統一戰術紫，忽略 JSON/track 的綠色等
    private var themeColor: Color { OfficialTrackViewTheme.tacticalPurple }
    private var routeId: String {
        payload?.trackId ?? track!.id.uuidString
    }

    init(payload: OfficialTrackPayload) {
        self.payload = payload
        self.track = nil
    }

    init(track: OfficialDetailedTrack) {
        self.payload = nil
        self.track = track
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    buildHeroHeader()
                    VStack(alignment: .leading, spacing: OfficialTrackViewTheme.sectionSpacing) {
                        buildDashboard()
                        buildElevationProfile()
                        buildWeatherSection()
                        buildTechnicalSpecs()
                        buildWaypoints()
                        buildEssentialGear()
                        buildLiveReports()
                    }
                    .padding(.horizontal, OfficialTrackViewTheme.blockPadding)
                    .padding(.bottom, 140)
                }
                .ignoresSafeArea(edges: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(OfficialTrackViewTheme.background)
            .ignoresSafeArea(edges: .top)
            topBar
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .onAppear {
            if let t = track {
                let routeData = RouteDetailData(from: t)
                reviewManager.seedIfNeeded(routeData.reviews, routeId: routeData.routeId)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { startNavigationButton }
        .fullScreenCover(isPresented: $showDetailedTrackNavigation) {
            NavigationStack {
                if let t = track {
                    OfficialDetailedTrackNavigationView(
                        track: t,
                        pathCoordinates: pathCoordinatesForTrack(t),
                        gpxData: Self.loadMistTrailGPXFromBundle()
                    )
                }
            }
        }
    }

    /// Path from DetailedTrack only (pathPoints). No Macro Journey data.
    private func pathCoordinatesForTrack(_ t: OfficialDetailedTrack) -> [CLLocationCoordinate2D] {
        if let points = t.pathPoints, !points.isEmpty { return points }
        return OfficialMacroRoute.yosemiteHalfDomeCables.coordinates
    }

    /// Load MistTrail.gpx from Resources for GPX-driven navigation (curved polyline, elevation).
    private static func loadMistTrailGPXFromBundle() -> Data? {
        guard let url = Bundle.main.url(forResource: "MistTrail", withExtension: "gpx") else { return nil }
        return try? Data(contentsOf: url)
    }

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17, weight: .regular))
                }
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
                .padding(.leading, 4)
                .frame(height: 44)
            }
            .buttonStyle(.plain)
            Spacer()
            Button { } label: {
                Image(systemName: "heart")
                    .font(.system(size: 20))
                    .foregroundStyle(OfficialTrackViewTheme.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [OfficialTrackViewTheme.background, OfficialTrackViewTheme.background.opacity(0)],
                startPoint: .top, endPoint: .bottom
            )
        )
    }

    /// 官方細節路線（Yosemite）：只開精密導航頁，不開 Macro（無 Day 1/2/3）
    private var startNavigationButton: some View {
        VStack(spacing: 10) {
            Button {
                AuthGuard.run(message: AuthGuardMessages.startNavigation) {
                    showDetailedTrackNavigation = true
                }
            } label: {
                Text("Start Navigation")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [OfficialTrackViewTheme.tacticalPurple, OfficialTrackViewTheme.tacticalPurple.opacity(0.75)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, OfficialTrackViewTheme.blockPadding)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(OfficialTrackViewTheme.background)
    }

    private func buildHeroHeader() -> some View {
        if let p = payload {
            return AnyView(OfficialPayloadHeroHeader(payload: p))
        } else {
            return AnyView(OfficialTrackHeroHeaderView(track: track!))
        }
    }

    private func buildDashboard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                if let p = payload {
                    dashboardCard(title: "Quality", value: p.dashboard.trackQuality)
                    dashboardCard(title: "Safety", value: p.dashboard.safetyRating)
                    dashboardCard(title: "Distance", value: p.dashboard.distance)
                    dashboardCard(title: "Duration", value: p.dashboard.duration)
                } else {
                    dashboardCard(title: "Quality", value: track!.trackQuality)
                    dashboardCard(title: "Safety", value: String(format: "%.1f/5", track!.safetyRating))
                    dashboardCard(title: "Distance", value: track!.distance)
                    dashboardCard(title: "Duration", value: track!.estimatedTime)
                }
            }
        }
    }

    private func dashboardCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(OfficialTrackViewTheme.textMuted)
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(OfficialTrackViewTheme.cardBackground)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: OfficialTrackViewTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: OfficialTrackViewTheme.cardCornerRadius)
                .strokeBorder(OfficialTrackViewTheme.tacticalPurple.opacity(0.4), lineWidth: 1)
        )
    }

    private func buildElevationProfile() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Terrain & Elevation")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
            // Top: Total Gain / Total Loss big cards
            HStack(spacing: 12) {
                elevationBigCard(label: "Total Gain", value: track?.totalGain ?? payload?.elevationProfile.totalGain ?? track?.elevationGain ?? "—")
                elevationBigCard(label: "Total Loss", value: track?.totalLoss ?? payload?.elevationProfile.totalLoss ?? "0 ft")
            }
            // Middle: interactive purple elevation chart (X: 0–0.5 mi, Y: 8400–8900 ft when track data)
            InteractiveElevationChartView(
                elevationData: resolvedElevationPoints(),
                fixedYMin: track?.elevationData != nil ? 8400 : nil,
                fixedYMax: track?.elevationData != nil ? 8900 : nil
            )
            .frame(minHeight: 180, maxHeight: 180)
            .frame(maxWidth: .infinity)
            .background(OfficialTrackViewTheme.cardBackground.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            // Bottom: Start / Max / End altitude blocks（有 track 海拔數據時用 8,442 / 8,842 / 8,842）
            HStack(spacing: 12) {
                elevationAltBlock(label: "Start", value: resolvedStartAlt())
                elevationAltBlock(label: "Max", value: resolvedMaxAlt())
                elevationAltBlock(label: "End", value: resolvedEndAlt())
            }
        }
    }

    private func resolvedStartAlt() -> String {
        let points = track?.elevationData
        guard let first = points?.first else { return payload?.elevationProfile.startAlt ?? "—" }
        return formatElevation(Int(first.elevation))
    }

    private func resolvedMaxAlt() -> String {
        guard let points = track?.elevationData, !points.isEmpty else { return payload?.elevationProfile.maxAlt ?? "—" }
        let m = points.map(\.elevation).max() ?? 0
        return formatElevation(Int(m))
    }

    private func resolvedEndAlt() -> String {
        guard let last = track?.elevationData?.last else { return payload?.elevationProfile.endAlt ?? "—" }
        return formatElevation(Int(last.elevation))
    }

    private func formatElevation(_ ft: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: ft)) ?? "\(ft)"
    }

    private func resolvedElevationPoints() -> [ElevationPoint] {
        if let points = track?.elevationData, !points.isEmpty { return points }
        guard let dataPoints = payload?.elevationProfile.dataPoints, !dataPoints.isEmpty else { return [] }
        let maxMile = 0.5
        return dataPoints.enumerated().map { i, elev in
            let mile = dataPoints.count > 1 ? (Double(i) / Double(dataPoints.count - 1)) * maxMile : 0
            return ElevationPoint(mile: mile, elevation: elev)
        }
    }

    private func elevationBigCard(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(OfficialTrackViewTheme.textMuted)
            Text(value)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.tacticalPurple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(OfficialTrackViewTheme.cardBackground)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: OfficialTrackViewTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: OfficialTrackViewTheme.cardCornerRadius)
                .strokeBorder(OfficialTrackViewTheme.tacticalPurple.opacity(0.4), lineWidth: 1)
        )
    }

    private func elevationAltBlock(label: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(OfficialTrackViewTheme.textMuted)
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(OfficialTrackViewTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func buildWeatherSection() -> some View {
        let location = payload?.weather.location ?? track?.location ?? ""
        let forecast: [WeatherForecastItem] = payload?.weather.forecast ?? []
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weather")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(OfficialTrackViewTheme.textPrimary)
                Spacer()
                Text(location)
                    .font(.system(size: 14))
                    .foregroundStyle(OfficialTrackViewTheme.textMuted)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(forecast.enumerated()), id: \.offset) { _, item in
                        weatherCard(time: item.time, temp: item.temp, condition: item.condition)
                    }
                    if forecast.isEmpty {
                        ForEach(0..<3, id: \.self) { _ in weatherCard(time: "—", temp: "—", condition: "—") }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
            }
        }
    }

    private func weatherCard(time: String, temp: String, condition: String) -> some View {
        VStack(spacing: 8) {
            Text(time).font(.system(size: 11)).foregroundStyle(OfficialTrackViewTheme.textMuted)
            Image(systemName: condition.lowercased().contains("wind") ? "wind" : "sun.max.fill")
                .font(.system(size: 22))
                .foregroundStyle(OfficialTrackViewTheme.tacticalPurple)
            Text(temp).font(.system(size: 14, weight: .semibold)).foregroundStyle(OfficialTrackViewTheme.textPrimary)
        }
        .frame(minWidth: 80)
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(OfficialTrackViewTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func buildTechnicalSpecs() -> some View {
        let surface: String
        let cellSignal: String
        let vehicleAccess: String
        let permit: String
        if let p = payload {
            surface = p.technicalSpecs.surface
            cellSignal = p.technicalSpecs.cellSignal
            vehicleAccess = p.technicalSpecs.vehicleAccess
            permit = p.technicalSpecs.permit
        } else {
            surface = "—"
            cellSignal = "—"
            vehicleAccess = "—"
            permit = "—"
        }
        return VStack(alignment: .leading, spacing: 12) {
            Text("Technical Specs")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                specCard(icon: "circle.grid.2x2", label: "Surface", value: surface, isWarning: false)
                specCard(icon: "antenna.radiowaves.left.and.right", label: "Signal", value: cellSignal, isWarning: false)
                specCard(icon: "car.fill", label: "Vehicle", value: vehicleAccess, isWarning: false)
                specCard(icon: "doc.badge.gearshape", label: "Permit", value: permit, isWarning: permit.uppercased() == "REQUIRED")
            }
        }
    }

    private func specCard(icon: String, label: String, value: String, isWarning: Bool) -> some View {
        let valueColor = isWarning ? OfficialTrackViewTheme.permitWarning : OfficialTrackViewTheme.textPrimary
        return HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(isWarning ? OfficialTrackViewTheme.permitDanger : OfficialTrackViewTheme.tacticalPurple)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.system(size: 11)).foregroundStyle(OfficialTrackViewTheme.textMuted)
                Text(value).font(.system(size: 13, weight: .semibold)).foregroundStyle(valueColor)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(isWarning ? OfficialTrackViewTheme.permitWarning.opacity(0.12) : OfficialTrackViewTheme.cardBackground)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: OfficialTrackViewTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: OfficialTrackViewTheme.cardCornerRadius)
                .strokeBorder(isWarning ? OfficialTrackViewTheme.permitWarning.opacity(0.6) : Color.clear, lineWidth: 1)
        )
    }

    private func buildWaypoints() -> some View {
        let points: [(name: String, distance: String)]
        if let p = payload {
            points = p.waypoints.map { ($0.name, $0.distance) }
        } else {
            points = []
        }
        return VStack(alignment: .leading, spacing: 12) {
            Text("Waypoints")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
            VStack(spacing: 0) {
                ForEach(Array(points.enumerated()), id: \.offset) { i, pt in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(OfficialTrackViewTheme.tacticalPurple)
                            .frame(width: 8, height: 8)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(pt.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
                            Text(pt.distance)
                                .font(.system(size: 12))
                                .foregroundStyle(OfficialTrackViewTheme.textMuted)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(OfficialTrackViewTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    if i < points.count - 1 {
                        Rectangle()
                            .fill(OfficialTrackViewTheme.textMuted.opacity(0.3))
                            .frame(width: 2)
                            .padding(.leading, 3)
                    }
                }
            }
        }
    }

    private func buildEssentialGear() -> some View {
        let gear: [EssentialGearItem]
        if let p = payload {
            gear = p.essentialGear
        } else {
            gear = []
        }
        return VStack(alignment: .leading, spacing: 12) {
            Text("Essential Gear")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(OfficialTrackViewTheme.textPrimary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 88))], spacing: 12) {
                ForEach(gear) { g in
                    gearCard(item: g.item, icon: g.icon, isMandatory: g.isMandatory)
                }
            }
            Button { } label: {
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Download List")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundStyle(OfficialTrackViewTheme.tacticalPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(OfficialTrackViewTheme.tacticalPurple.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }

    private func gearCard(item: String, icon: String, isMandatory: Bool) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(OfficialTrackViewTheme.tacticalPurple)
                Text(item)
                    .font(.system(size: 11))
                    .foregroundStyle(OfficialTrackViewTheme.textMuted)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.top, 8)
            .background(OfficialTrackViewTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            if isMandatory {
                Circle()
                    .fill(OfficialTrackViewTheme.permitDanger)
                    .frame(width: 10, height: 10)
                    .padding(6)
            }
        }
    }

    private func buildLiveReports() -> some View {
        OverallRouteReviewsView(reviews: reviewManager.reviews(for: routeId), routeId: routeId, onWriteReview: { })
    }
}

private struct OfficialPayloadHeroHeader: View {
    let payload: OfficialTrackPayload
    private static let heroHeight: CGFloat = 460

    var body: some View {
        let theme = OfficialTrackViewTheme.tacticalPurple
        ZStack(alignment: .bottomLeading) {
            Group {
                if let url = payload.heroImageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                        default: Color.gray.opacity(0.3)
                        }
                    }
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: Self.heroHeight)
            .clipped()
            .ignoresSafeArea(edges: .top)
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                LinearGradient(colors: [Color.clear, Color.black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(payload.header.badge)
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(theme)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                Text(payload.header.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 2)
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(theme)
                    Text(payload.header.rating)
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Text("(\(payload.header.reviewsCount) reviews)")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, OfficialTrackViewTheme.blockPadding)
            .padding(.bottom, 40)
        }
        .frame(width: UIScreen.main.bounds.width)
        .frame(height: Self.heroHeight)
        .clipped()
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: OfficialTrackViewTheme.cardCornerRadius,
            bottomTrailingRadius: OfficialTrackViewTheme.cardCornerRadius,
            topTrailingRadius: 0
        ))
        .ignoresSafeArea(edges: .top)
        .padding(.bottom, OfficialTrackViewTheme.sectionSpacing)
    }
}

// MARK: - Interactive elevation chart: 戰術紫漸變 + 網格 + 手勢浮窗
private struct InteractiveElevationChartView: View {
    let elevationData: [ElevationPoint]
    var fixedYMin: Double? = nil
    var fixedYMax: Double? = nil
    private let accentColor = OfficialTrackViewTheme.tacticalPurple

    @State private var dragX: CGFloat? = nil

    private var minMile: Double { elevationData.map(\.mile).min() ?? 0 }
    private var maxMile: Double { elevationData.map(\.mile).max() ?? 1 }
    private var minE: Double { elevationData.map(\.elevation).min() ?? 0 }
    private var maxE: Double { elevationData.map(\.elevation).max() ?? 1 }
    private var displayMinE: Double { fixedYMin ?? minE }
    private var displayMaxE: Double { fixedYMax ?? maxE }
    private var mileRange: Double { max(maxMile - minMile, 0.01) }
    private var elevRange: Double { max(displayMaxE - displayMinE, 1) }

    var body: some View {
        GeometryReader { geo in
            let w = max(geo.size.width, 1)
            let h = max(geo.size.height, 1)
            ZStack(alignment: .topLeading) {
                // 戰術風格：極細紫色網格線 (opacity 0.1)
                elevationGrid(in: w, h: h)
                // 線條下方：紫色到透明的漸變填充
                elevationFillPath(in: w, h: h)
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.35), accentColor.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                // 戰術紫漸變線條 + 發光
                elevationLinePath(in: w, h: h)
                    .stroke(
                        LinearGradient(
                            colors: [accentColor, accentColor.opacity(0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 3
                    )
                    .shadow(color: accentColor.opacity(0.8), radius: 8)
                    .shadow(color: accentColor.opacity(0.4), radius: 4)
                // 手勢：垂直指示線 + 半透明氣泡 (Distance / Elevation)
                if let x = dragX, let point = pointAt(x: x, width: w) {
                    Rectangle()
                        .fill(accentColor.opacity(0.8))
                        .frame(width: 2)
                        .frame(height: h)
                        .position(x: x, y: h / 2)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Distance: \(String(format: "%.2f", point.mile)) mi")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("Elevation: \(Int(point.elevation)) ft")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(OfficialTrackViewTheme.textMuted)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.78))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(accentColor, lineWidth: 1)
                    )
                    .position(x: x, y: 28)
                    .allowsHitTesting(false)
                }
                // 無數據時提示（避免空白一片）
                if elevationData.count < 2 {
                    Text("No elevation data")
                        .font(.system(size: 13))
                        .foregroundStyle(accentColor.opacity(0.6))
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        dragX = min(max(value.location.x, 0), w)
                    }
                    .onEnded { _ in
                        dragX = nil
                    }
            )
        }
    }

    private func elevationGrid(in w: CGFloat, h: CGFloat) -> some View {
        let vSteps = 5
        let hSteps = 5
        return ZStack {
            ForEach(0..<(vSteps + 1), id: \.self) { i in
                let x = w * CGFloat(i) / CGFloat(vSteps)
                Path { p in p.move(to: CGPoint(x: x, y: 0)); p.addLine(to: CGPoint(x: x, y: h)) }
                    .stroke(accentColor.opacity(0.1), lineWidth: 1)
            }
            ForEach(0..<(hSteps + 1), id: \.self) { i in
                let y = h * CGFloat(i) / CGFloat(hSteps)
                Path { p in p.move(to: CGPoint(x: 0, y: y)); p.addLine(to: CGPoint(x: w, y: y)) }
                    .stroke(accentColor.opacity(0.1), lineWidth: 1)
            }
        }
    }

    private func xForMile(_ mile: Double, width: CGFloat) -> CGFloat {
        guard mileRange > 0 else { return 0 }
        let t = (mile - minMile) / mileRange
        return CGFloat(t) * width
    }

    private func yForElevation(_ elev: Double, height: CGFloat) -> CGFloat {
        let t = (elev - displayMinE) / elevRange
        return height - CGFloat(t) * height
    }

    private func pointAt(x: CGFloat, width: CGFloat) -> ElevationPoint? {
        guard !elevationData.isEmpty, width > 0 else { return nil }
        let mile = minMile + (Double(x / width) * mileRange)
        return elevationData.min(by: { abs($0.mile - mile) < abs($1.mile - mile) })
    }

    private func elevationLinePath(in w: CGFloat, h: CGFloat) -> Path {
        var path = Path()
        guard elevationData.count >= 2 else { return path }
        for (i, pt) in elevationData.enumerated() {
            let x = xForMile(pt.mile, width: w)
            let y = yForElevation(pt.elevation, height: h)
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        return path
    }

    private func elevationFillPath(in w: CGFloat, h: CGFloat) -> Path {
        var path = elevationLinePath(in: w, h: h)
        guard elevationData.count >= 2 else { return path }
        path.addLine(to: CGPoint(x: xForMile(elevationData.last!.mile, width: w), y: h))
        path.addLine(to: CGPoint(x: xForMile(elevationData[0].mile, width: w), y: h))
        path.closeSubpath()
        return path
    }
}

private struct OfficialTrackHeroHeaderView: View {
    let track: OfficialDetailedTrack
    private static let heroHeight: CGFloat = 460

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: track.headerImage)) { phase in
                switch phase {
                case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                default: Color.gray.opacity(0.3)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: Self.heroHeight)
            .clipped()
            .ignoresSafeArea(edges: .top)
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                LinearGradient(colors: [Color.clear, Color.black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("OFFICIAL TRACK")
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(OfficialTrackViewTheme.tacticalPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                Text(track.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 2)
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(OfficialTrackViewTheme.tacticalPurple)
                    Text(String(format: "%.1f", track.safetyRating))
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Text("· \(track.difficulty) · \(track.estimatedTime)")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, OfficialTrackViewTheme.blockPadding)
            .padding(.bottom, 40)
        }
        .frame(width: UIScreen.main.bounds.width)
        .frame(height: Self.heroHeight)
        .clipped()
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: OfficialTrackViewTheme.cardCornerRadius,
            bottomTrailingRadius: OfficialTrackViewTheme.cardCornerRadius,
            topTrailingRadius: 0
        ))
        .ignoresSafeArea(edges: .top)
        .padding(.bottom, OfficialTrackViewTheme.sectionSpacing)
    }
}
