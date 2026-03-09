// 与 Figma/Web 国家公园设计一致：Hero、Tab（Overview/Activities/Facilities/Plan Visit）、完整区块
import SwiftUI
import MapKit

enum NationalParkTab: String, CaseIterable {
    case overview = "Overview"
    case activities = "Activities"
    case facilities = "Facilities"
    case plan = "Plan Visit"
}

struct NationalParkDetailView: View {
    let park: NationalPark
    @Environment(\.dismiss) private var dismiss
    @State private var activeTab: NationalParkTab = .overview
    @State private var isFavorite: Bool = false

    private var favId: String { "nationalPark:\(park.id)" }
    private var parkBackup: ParkBackupData { DataLoader.loadParkBackup() }
    /// 優先主數據，缺失時從 ParkBackupData 補齊（腳本 check_park_completeness.py 生成）
    private var coordinate: CLLocationCoordinate2D? {
        let c = park.coordinates ?? parkBackup[park.id]?.coordinates
        guard let c = c else { return nil }
        return CLLocationCoordinate2D(latitude: c.latitude, longitude: c.longitude)
    }
    private var isCoordinateFromBackup: Bool { park.coordinates == nil && parkBackup[park.id]?.coordinates != nil }
    private var heroImageUrl: String? {
        let photos = DataLoader.loadNationalParksGallery()[park.id] ?? []
        return photos.first ?? "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200"
    }
    private var galleryPhotos: [String] {
        DataLoader.loadNationalParksGallery()[park.id] ?? []
    }
    private var facilitiesData: ParkFacilitiesData? {
        DataLoader.loadNationalParksFacilities()[park.id]
    }
    private var weatherData: ParkWeather? {
        DataLoader.loadNationalParksWeather().first { $0.parkId == park.id }
    }
    private var wildlifeData: ParkWildlife? {
        DataLoader.loadNationalParksWildlife().first { $0.parkId == park.id }
    }
    private var statsData: ParkStatistics? {
        DataLoader.loadNationalParksStats().first { $0.parkId == park.id }
    }
    private var lodgingData: ParkLodging? {
        DataLoader.loadNationalParksLodging()[park.id]
    }

    private let parkThemeColor = Color(red: 0.98, green: 0.45, blue: 0.09)
    @State private var showDetailSheet = true
    @State private var selectedDetent: PresentationDetent = .fraction(0.6)
    @State private var parkDetail: ParkDetail?
    @State private var selectedFacilityForMap: FacilityLocation?

    var body: some View {
        GeometryReader { geo in
            let fullScreenHeight = geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom
            ZStack {
                ZStack(alignment: .bottomLeading) {
                    MapHeaderView(
                        coordinate: coordinate,
                        facilityAnnotation: selectedFacilityForMap,
                        viewpoints: parkDetail?.mapData?.viewpoints,
                        dangerZones: parkDetail?.mapData?.dangerZones,
                        themeColor: parkThemeColor,
                        fixedHeight: fullScreenHeight
                    )
                    if isCoordinateFromBackup {
                        Text("Approximate location")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.black.opacity(0.4), in: Capsule())
                            .padding(12)
                    }
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .background(Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255))
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showDetailSheet) {
            ParkDetailSheetContent(park: park, parkDetail: parkDetail, selectedFacilityForMap: $selectedFacilityForMap, themeColor: parkThemeColor)
                .presentationDetents(
                    [.height(200), .fraction(0.6), .large], // 鎖定三段：200pt / 60% / large，收納時不侷促
                    selection: $selectedDetent
                )
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.6))) // 收納與 60% 時地圖可流暢縮放
                .interactiveDismissDisabled() // 抽屜不可下拉關閉
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar) // 詳情頁隱藏底部五個 Tab（Home / Route / Shop / Community / Profile）
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showDetailSheet = false
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(HikBikFont.caption())
                            .fontWeight(.medium)
                    }
                            .foregroundStyle(Color.hikbikPrimary)
                    .padding(.horizontal, HikBikSpacing.md)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                }
            }
        }
        .onAppear { isFavorite = FavoritesStore.contains(favId) }
        .task {
            guard let code = park.parkCode else { return }
            do {
                let detail = try await NPSAPIService.fetchAllDetail(parkCode: code)
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    parkDetail = detail
                }
            } catch {
                #if DEBUG
                print("[ParkDetail] fetchAllDetail failed: \(error)")
                #endif
            }
        }
    }

    // MARK: - Hero（贴顶、渐变、徽章、Save 固定右上角安全区）
    private func heroSection(height: CGFloat) -> some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let urlString = heroImageUrl, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let img): img.resizable().scaledToFill()
                        default: Color.hikbikMuted
                                            }
                                        }
                    .frame(height: height)
                                        .clipped()
                } else {
                    Color.hikbikMuted
                        .frame(height: height)
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            LinearGradient(
                colors: [.black.opacity(0.4), .black.opacity(0.2), .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.container, edges: .top)
            // 右上角：Save / Saved，顶层 + 安全区 padding 确保可见
            VStack {
                HStack {
                    Spacer()
                    Button {
                        if isFavorite { FavoritesStore.remove(favId) } else { FavoritesStore.add(favId) }
                        isFavorite.toggle()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.body)
                            Text(isFavorite ? "Saved" : "Save")
                                .font(HikBikFont.caption())
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(isFavorite ? .white : Color.hikbikPrimary)
                        .padding(.horizontal, HikBikSpacing.md)
                        .padding(.vertical, 10)
                        .background(isFavorite ? Color.hikbikDestructive : Color.white.opacity(0.9), in: Capsule())
                    }
                    .padding(.trailing, HikBikSpacing.lg)
                    .padding(.top, 60)
                }
                Spacer()
            }
            .frame(height: height)
            .allowsHitTesting(true)
            // 底部标题区（National Park Service 绿徽章 + 州 + 标题 + 首句描述）
            VStack(alignment: .leading, spacing: HikBikSpacing.xs) {
                HStack(spacing: HikBikSpacing.sm) {
                    Text("National Park Service")
                        .font(HikBikFont.caption2())
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color.hikbikTabActive.opacity(0.9))
                        .clipShape(Capsule())
                    Text(park.state)
                        .font(HikBikFont.caption2())
                        .fontWeight(.medium)
                        .foregroundStyle(Color.hikbikPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Capsule())
                }
                Text(park.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4)
                if let firstSentence = (park.description ?? "").split(separator: ".").first {
                    Text(String(firstSentence) + ".")
                        .font(HikBikFont.caption())
                        .foregroundStyle(.white.opacity(0.95))
                        .lineLimit(2)
                        .shadow(color: .black.opacity(0.5), radius: 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(HikBikSpacing.lg)
            .padding(.bottom, HikBikSpacing.md)
        }
        .frame(height: height)
    }

    // Tab 图标与设计一致：Overview=Info, Activities=Tent, Facilities=Store, Plan=Calendar
    private func tabIcon(_ tab: NationalParkTab) -> String {
        switch tab {
        case .overview: return "info.circle"
        case .activities: return "tent"
        case .facilities: return "building.2"
        case .plan: return "calendar"
        }
    }

    private var tabBar: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let adaptiveSpacing = max(8, min(16, width * 0.04))
            let adaptivePadding = max(12, min(16, width * 0.045))
            let useSubheadline = width < 340
            HStack(spacing: adaptiveSpacing) {
                ForEach(NationalParkTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { activeTab = tab }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: tabIcon(tab))
                                .font(.system(size: useSubheadline ? 12 : 14))
                            Text(tab.rawValue)
                                .font(useSubheadline ? .subheadline : HikBikFont.caption())
                                .fontWeight(activeTab == tab ? .semibold : .regular)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .foregroundStyle(activeTab == tab ? Color.hikbikTabActive : Color.hikbikMutedForeground)
                        .padding(.horizontal, adaptivePadding)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .overlay(alignment: .bottom) {
                            if activeTab == tab {
                                Rectangle()
                                    .fill(Color.hikbikTabActive)
                                    .frame(height: 2)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 52)
        .background(Color.white.opacity(0.95))
        .overlay(alignment: .bottom) { Rectangle().fill(Color.hikbikBorder).frame(height: 1) }
    }

    @ViewBuilder
    private var tabContent: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            switch activeTab {
            case .overview: overviewContent
            case .activities: activitiesContent
            case .facilities: facilitiesContent
            case .plan: planContent
            }
        }
        .padding(HikBikSpacing.lg)
        .padding(.bottom, 40)
    }

    // MARK: - Overview
    private var overviewContent: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            // Quick Actions
            quickActionsSection
            // Quick Stats
            quickStatsSection
            // About
            aboutSection
            // Highlights
            if let highlights = park.highlights, !highlights.isEmpty { highlightsSection(highlights) }
            // Weather
            if let weather = weatherData { weatherSection(weather) }
            // Wildlife
            if let wildlife = wildlifeData { wildlifeSection(wildlife) }
            // Park Statistics
            if let stats = statsData { parkStatisticsSection(stats) }
        }
    }

    private var quickActionsSection: some View {
        FlowLayout(spacing: HikBikSpacing.sm) {
            if let coord = coordinate,
               let mapsUrl = URL(string: "maps://?ll=\(coord.latitude),\(coord.longitude)&q=\((park.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? park.name))") {
                Link(destination: mapsUrl) {
                    Label("Directions", systemImage: "location.fill")
                        .font(HikBikFont.caption())
                        .fontWeight(.medium)
                        .foregroundStyle(Color.hikbikTabActive)
                }
                .padding(.horizontal, HikBikSpacing.md)
                .padding(.vertical, 10)
                .background(Color.hikbikTabActiveTint)
                .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
            }
            ShareLink(
                item: park.name,
                subject: Text(park.name),
                message: Text(park.description ?? "")
            ) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .font(HikBikFont.caption())
                    .fontWeight(.medium)
                    .foregroundStyle(Color.hikbikPrimary)
            }
            .padding(.horizontal, HikBikSpacing.md)
            .padding(.vertical, 10)
            .background(Color.hikbikCard)
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.xl).stroke(Color.hikbikBorder, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
            if let u = park.websiteUrl.flatMap({ URL(string: $0) }) {
                Link(destination: u) {
                    Label("Official Website", systemImage: "link")
                        .font(HikBikFont.caption())
                        .fontWeight(.medium)
                        .foregroundStyle(Color.hikbikPrimary)
                }
                .padding(.horizontal, HikBikSpacing.md)
                .padding(.vertical, 10)
                .background(Color.hikbikCard)
                .overlay(RoundedRectangle(cornerRadius: HikBikRadius.xl).stroke(Color.hikbikBorder, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
            }
            if let phone = park.phone, let tel = URL(string: "tel:\(phone.replacingOccurrences(of: " ", with: ""))") {
                Link(destination: tel) {
                    Label("Call Park", systemImage: "phone.fill")
                        .font(HikBikFont.caption())
                        .fontWeight(.medium)
                        .foregroundStyle(Color.hikbikPrimary)
                }
                .padding(.horizontal, HikBikSpacing.md)
                .padding(.vertical, 10)
                .background(Color.hikbikCard)
                .overlay(RoundedRectangle(cornerRadius: HikBikRadius.xl).stroke(Color.hikbikBorder, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
            }
        }
    }

    private var quickStatsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
            if let v = park.visitors { statCard(icon: "person.2.fill", label: "Annual Visitors", value: v) }
            if let d = park.difficulty { statCard(icon: "mountain.2.fill", label: "Difficulty", value: d) }
            if let c = park.crowdLevel { statCard(icon: "person.3.fill", label: "Crowd Level", value: c) }
            if let e = park.entrance ?? parkBackup[park.id]?.entrance { statCard(icon: "dollarsign", label: "Entrance Fee", value: e) }
        }
    }

    private func statCard(icon: String, label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.hikbikTabActive)
            Text(label)
                .font(HikBikFont.caption2())
                .foregroundStyle(Color.hikbikMutedForeground)
            Text(value)
                            .font(HikBikFont.headline())
                            .foregroundStyle(Color.hikbikPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(HikBikSpacing.md)
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
            Label("About This Park", systemImage: "camera.fill")
                .font(HikBikFont.headline())
                                    .foregroundStyle(Color.hikbikPrimary)
            Text(park.description ?? "")
                                    .font(HikBikFont.body())
                                    .foregroundStyle(Color.hikbikForeground)
                        }
                        .padding(HikBikSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.hikbikCard)
                        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
                        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
    }

    private func highlightsSection(_ highlights: [String]) -> some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
            Label("Must-See Highlights", systemImage: "star.fill")
                .font(HikBikFont.headline())
                .foregroundStyle(Color.hikbikPrimary)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(highlights, id: \.self) { h in
                    HStack(alignment: .top, spacing: 6) {
                        Circle().fill(Color.hikbikTabActive).frame(width: 6, height: 6).padding(.top, 6)
                        Text(h).font(HikBikFont.body()).foregroundStyle(Color.hikbikForeground)
                    }
                }
            }
        }
        .padding(HikBikSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hikbikTabActiveTint.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikTabActive.opacity(0.3), lineWidth: 1))
    }

    private func weatherSection(_ weather: ParkWeather) -> some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.md) {
            HStack {
                Label("Weather", systemImage: "cloud.fill")
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                Spacer()
                if let temp = weather.currentTemp {
                    Text("\(temp)°F")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.hikbikPrimary)
                }
                if let cond = weather.condition {
                    Text(cond)
                        .font(HikBikFont.caption())
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
            }
            HStack(spacing: HikBikSpacing.lg) {
                if let h = weather.humidity {
                    HStack(spacing: 4) {
                        Image(systemName: "humidity.fill").foregroundStyle(Color.hikbikTabActive)
                        Text("Humidity \(h)%").font(HikBikFont.caption()).foregroundStyle(Color.hikbikForeground)
                    }
                }
                if let w = weather.windSpeed {
                    HStack(spacing: 4) {
                        Image(systemName: "wind").foregroundStyle(Color.hikbikTabActive)
                        Text("Wind \(w) mph").font(HikBikFont.caption()).foregroundStyle(Color.hikbikForeground)
                    }
                }
            }
                        if let forecast = weather.forecast, !forecast.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: HikBikSpacing.sm) {
                                    ForEach(forecast.prefix(7), id: \.day) { d in
                                        VStack(spacing: 4) {
                                            Text(d.day).font(HikBikFont.caption2()).foregroundStyle(Color.hikbikMutedForeground)
                                            Text(d.icon ?? "").font(.title3)
                                            Text("\(d.high)°").font(HikBikFont.caption()).foregroundStyle(Color.hikbikPrimary)
                                            Text("\(d.low)°").font(HikBikFont.caption2()).foregroundStyle(Color.hikbikMutedForeground)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 6)
                            .background(Color.hikbikMuted.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
                        }
                    }
                }
            }
            if let months = weather.bestMonths, !months.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Best Months").font(HikBikFont.caption()).fontWeight(.semibold).foregroundStyle(Color.hikbikPrimary)
                    FlowLayout(spacing: 4) {
                        ForEach(months, id: \.self) { m in
                            Text(m)
                                .font(HikBikFont.caption2())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.hikbikTabActive)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding(HikBikSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
    }

    @ViewBuilder
    private func wildlifeSection(_ wildlife: ParkWildlife) -> some View {
        if let animals = wildlife.animals, !animals.isEmpty {
            let common = animals.filter { $0.commonlySeen == true }
            let displayList = common.isEmpty ? animals : common
            VStack(alignment: .leading, spacing: HikBikSpacing.md) {
                Label("Wildlife", systemImage: "leaf.fill")
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
                    ForEach(displayList.prefix(6)) { a in
                        VStack(spacing: 4) {
                            Text(a.icon ?? "🐾").font(.title2)
                            Text(a.name).font(HikBikFont.caption2()).foregroundStyle(Color.hikbikForeground).lineLimit(2).multilineTextAlignment(.center)
                        }
                        .padding(HikBikSpacing.sm)
                        .frame(maxWidth: .infinity)
                        .background(Color.hikbikCard)
                                        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
                                    }
                                }
                if let times = wildlife.bestViewingTimes, !times.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Best Viewing Times").font(HikBikFont.caption()).fontWeight(.semibold).foregroundStyle(Color.hikbikPrimary)
                        FlowLayout(spacing: 4) {
                            ForEach(times, id: \.self) { t in
                                Text(t).font(HikBikFont.caption2()).foregroundStyle(.white).padding(.horizontal, 8).padding(.vertical, 4).background(Color.hikbikTabActive).clipShape(Capsule())
                            }
                        }
                    }
                }
                if let tips = wildlife.safetyTips, !tips.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Safety Tips", systemImage: "exclamationmark.triangle.fill").font(HikBikFont.caption()).foregroundStyle(Color.orange)
                        ForEach(tips.prefix(3), id: \.self) { tip in
                            Text("• \(tip)").font(HikBikFont.caption2()).foregroundStyle(Color.hikbikForeground)
                        }
                    }
                    .padding(HikBikSpacing.sm)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
                }
            }
            .padding(HikBikSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.hikbikTabActiveTint.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikTabActive.opacity(0.2), lineWidth: 1))
        }
    }

    private func parkStatisticsSection(_ stats: ParkStatistics) -> some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.md) {
            HStack {
                Label("Park Statistics", systemImage: "mountain.2.fill")
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                if stats.worldHeritageSite == true {
                    Text("UNESCO").font(HikBikFont.caption2()).fontWeight(.semibold)
                        .foregroundStyle(Color.purple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
                if let e = stats.established { statRow("Established", e) }
                if let a = stats.area { statRow("Area", a) }
                if let v = stats.annualVisitors { statRow("Annual Visitors", v) }
                if let elev = stats.elevation, let high = elev.highestFeet {
                    statRow("Elevation", "\(high) ft")
                }
            }
            if let elev = stats.elevation, let highest = elev.highest {
                HStack(spacing: 4) {
                    Image(systemName: "figure.walk").foregroundStyle(Color.hikbikTabActive)
                    Text("Highest Point: \(highest)").font(HikBikFont.caption()).foregroundStyle(Color.hikbikForeground)
                }
                .padding(HikBikSpacing.sm)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.hikbikMuted.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
            }
        }
        .padding(HikBikSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
    }

    private func statRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(HikBikFont.caption2()).foregroundStyle(Color.hikbikMutedForeground)
            Text(value).font(HikBikFont.headline()).foregroundStyle(Color.hikbikPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(HikBikSpacing.sm)
        .background(Color.hikbikMuted.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
    }

    // MARK: - Activities
    private var activitiesContent: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
                if let activities = park.activities, !activities.isEmpty {
                VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                    Text("Activities")
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.hikbikPrimary)
                    FlowLayout(spacing: HikBikSpacing.sm) {
                        ForEach(activities, id: \.self) { a in
                            Text(a)
                                .font(HikBikFont.caption())
                                .padding(.horizontal, HikBikSpacing.sm)
                                .padding(.vertical, HikBikSpacing.xs)
                                .background(Color.hikbikTabActiveTint)
                                .foregroundStyle(Color.hikbikTabActive)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            Text("Trails & detailed activities data can be added when trail JSON is included.")
                .font(HikBikFont.caption())
                .foregroundStyle(Color.hikbikMutedForeground)
        }
    }

    // MARK: - Facilities
    private var facilitiesContent: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            if let facilities = facilitiesData {
                VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                    Label("Facilities", systemImage: "building.2.fill")
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.hikbikPrimary)
                    if let info = facilities.generalInfo {
                        Text(info).font(HikBikFont.caption()).foregroundStyle(Color.hikbikMutedForeground)
                    }
                    VStack(spacing: 0) {
                        ForEach(facilities.facilities) { f in
                            HStack(alignment: .top, spacing: HikBikSpacing.sm) {
                                Text(f.icon ?? "•").font(.body)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(f.name).font(HikBikFont.body()).foregroundStyle(Color.hikbikPrimary)
                                    if let d = f.details { Text(d).font(HikBikFont.caption2()).foregroundStyle(Color.hikbikMutedForeground) }
                                }
                                Spacer()
                            }
                            .padding(HikBikSpacing.sm)
                            .background(Color.hikbikCard)
                            Divider().padding(.leading, 32)
                        }
                    }
                    .background(Color.hikbikMuted.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
                }
            }
            if let lodging = lodgingData, (lodging.hasInParkLodging == true), let options = lodging.lodgingOptions, !options.isEmpty {
                VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                    Label("Lodging Options", systemImage: "bed.double.fill")
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.hikbikPrimary)
                    ForEach(options) { opt in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(opt.name).font(HikBikFont.headline()).foregroundStyle(Color.hikbikPrimary)
                            if let d = opt.description { Text(d).font(HikBikFont.caption()).foregroundStyle(Color.hikbikForeground) }
                            if let pr = opt.priceRange { Text(pr).font(HikBikFont.caption()).foregroundStyle(Color.hikbikTabActive) }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(HikBikSpacing.md)
                        .background(Color.hikbikTabActiveTint.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
                    }
                    if let notes = lodging.generalNotes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tips").font(HikBikFont.caption()).fontWeight(.semibold).foregroundStyle(Color.hikbikPrimary)
                            ForEach(notes.prefix(3), id: \.self) { n in Text("• \(n)").font(HikBikFont.caption2()).foregroundStyle(Color.hikbikForeground) }
                        }
                        .padding(HikBikSpacing.sm)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.hikbikMuted.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
                    }
                }
            }

            // Facilities & Amenities 网格（与 NationalParkDetail.tsx 一致）
            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Label("Facilities & Amenities", systemImage: "building.2.fill")
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
                    facilityChip(icon: "tent.fill", name: "Campgrounds", available: true)
                    facilityChip(icon: "info.circle.fill", name: "Visitor Center", available: true)
                    facilityChip(icon: "bag.fill", name: "Gift Shop", available: true)
                    facilityChip(icon: "bed.double.fill", name: "Lodging", available: lodgingData?.hasInParkLodging == true)
                    facilityChip(icon: "location.fill", name: "Trailheads", available: true)
                    facilityChip(icon: "camera.fill", name: "Scenic Viewpoints", available: true)
                }
            }
            .padding(HikBikSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.hikbikCard)
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
        }
    }

    private func facilityChip(icon: String, name: String, available: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(available ? Color.hikbikTabActive : Color.hikbikMutedForeground)
            Text(name)
                .font(HikBikFont.caption())
                .foregroundStyle(available ? Color.hikbikPrimary : Color.hikbikMutedForeground)
        }
        .padding(.horizontal, HikBikSpacing.sm)
        .padding(.vertical, HikBikSpacing.xs)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(available ? Color.hikbikTabActiveTint : Color.hikbikMuted.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
    }

    // 四季信息（与 NationalParkDetail.tsx getSeasonInfo 一致）
    private struct SeasonInfo {
        let name: String
        let icon: String
        let color: Color
        let iconColor: Color
        let description: String
        let activities: [String]
    }
    private var seasonsData: [SeasonInfo] {
        [
            SeasonInfo(name: "Spring", icon: "drop.fill", color: Color(hex: "DCFCE7"), iconColor: Color(hex: "16A34A"), description: "Wildflowers bloom, moderate temperatures", activities: ["Hiking", "Photography", "Wildlife Viewing"]),
            SeasonInfo(name: "Summer", icon: "sun.max.fill", color: Color(hex: "FEF9C3"), iconColor: Color(hex: "CA8A04"), description: "Peak season, all facilities open", activities: ["Camping", "Hiking", "Ranger Programs"]),
            SeasonInfo(name: "Fall", icon: "leaf.fill", color: Color(hex: "FFEDD5"), iconColor: Color(hex: "EA580C"), description: "Colorful foliage, fewer crowds", activities: ["Hiking", "Photography", "Wildlife Watching"]),
            SeasonInfo(name: "Winter", icon: "snowflake", color: Color(hex: "DBEAFE"), iconColor: Color(hex: "2563EB"), description: "Snow activities, peaceful atmosphere", activities: ["Cross-country Skiing", "Snowshoeing", "Photography"])
        ]
    }

    // MARK: - Plan Visit（与设计一致：Best Time + 四季卡片 + Fees + Important）
    private var planContent: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Label("Best Time to Visit", systemImage: "sun.max.fill")
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                if let best = park.bestTime, !best.isEmpty {
                    Text("Recommended: \(best.joined(separator: ", "))").font(HikBikFont.body()).foregroundStyle(Color.hikbikForeground)
                } else {
                    Text("Spring through fall for most activities; winter for snow sports.").font(HikBikFont.body()).foregroundStyle(Color.hikbikForeground)
                }
            }
            .padding(HikBikSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.hikbikCard)
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))

            // 四季卡片（与设计一致）
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
                ForEach(seasonsData, id: \.name) { s in
                    VStack(alignment: .leading, spacing: HikBikSpacing.xs) {
                        HStack(spacing: 6) {
                            Image(systemName: s.icon)
                                .font(.body)
                                .foregroundStyle(s.iconColor)
                            Text(s.name)
                                .font(HikBikFont.headline())
                                .foregroundStyle(Color.hikbikPrimary)
                        }
                        Text(s.description)
                            .font(HikBikFont.caption2())
                            .foregroundStyle(Color.hikbikMutedForeground)
                        FlowLayout(spacing: 4) {
                            ForEach(s.activities, id: \.self) { a in
                                Text(a)
                                    .font(HikBikFont.caption2())
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.white.opacity(0.6))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(HikBikSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(s.color)
                    .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
                }
            }

            if park.entrance != nil || (park.feesDetail != nil && !park.feesDetail!.isEmpty) {
                VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                    Label("Fees & Passes", systemImage: "dollarsign")
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.hikbikPrimary)
                    if let fees = park.feesDetail, !fees.isEmpty {
                        ForEach(Array(fees.enumerated()), id: \.offset) { _, fee in
                            HStack {
                                Text(fee.type).font(HikBikFont.body()).foregroundStyle(Color.hikbikForeground)
                                Spacer()
                                Text(fee.amount).font(HikBikFont.headline()).foregroundStyle(Color.hikbikTabActive)
                            }
                            .padding(HikBikSpacing.sm)
                            .background(Color.hikbikTabActiveTint.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
                        }
                    } else if let e = park.entrance {
                        HStack {
                            Text("Standard Entry").font(HikBikFont.body()).foregroundStyle(Color.hikbikForeground)
                            Spacer()
                            Text(e).font(HikBikFont.headline()).foregroundStyle(Color.hikbikTabActive)
                        }
                        .padding(HikBikSpacing.sm)
                        .background(Color.hikbikTabActiveTint.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.sm))
                    }
                    Text("America the Beautiful Pass ($80) grants access to all National Parks for one year.")
                        .font(HikBikFont.caption2())
                        .foregroundStyle(Color.hikbikMutedForeground)
                        .padding(.top, 4)
                }
                .padding(HikBikSpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.hikbikCard)
                .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
                .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
            }

            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Label("Important Information", systemImage: "exclamationmark.triangle.fill")
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikDestructive)
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Check for any current closures or restrictions before visiting")
                    Text("• Entrance fees may apply — check official website for details")
                    Text("• Cell phone coverage may be limited in remote areas")
                }
                .font(HikBikFont.caption())
                .foregroundStyle(Color.hikbikForeground)
            }
            .padding(HikBikSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.hikbikDestructive.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikDestructive.opacity(0.3), lineWidth: 1))
        }
    }
}

private func ParkInfoRow(_ label: String, _ value: String) -> some View {
    HStack {
        Text(label + ":").foregroundStyle(Color.hikbikMutedForeground)
        Text(value).foregroundStyle(Color.hikbikForeground)
    }
    .font(HikBikFont.callout())
}

#Preview("Denali — NPS 數據填滿效果") {
    NavigationStack {
        NationalParkDetailView(park: NPSMockData.denaliNationalPark)
    }
}
