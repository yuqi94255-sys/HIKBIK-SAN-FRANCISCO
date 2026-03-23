import SwiftUI
import MapKit
import UIKit

private let exploreListDarkBackground = Color(hex: "1A3324")

private let recreationHeroImages = [
    "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=1080",
    "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1080",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1080",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1080"
]

/// 州全名 → 两字母代码
private let stateNameToCode: [String: String] = [
    "Alabama": "AL", "Alaska": "AK", "Arizona": "AZ", "Arkansas": "AR", "California": "CA",
    "Colorado": "CO", "Connecticut": "CT", "Delaware": "DE", "Florida": "FL", "Georgia": "GA",
    "Hawaii": "HI", "Idaho": "ID", "Illinois": "IL", "Indiana": "IN", "Iowa": "IA",
    "Kansas": "KS", "Kentucky": "KY", "Louisiana": "LA", "Maine": "ME", "Maryland": "MD",
    "Massachusetts": "MA", "Michigan": "MI", "Minnesota": "MN", "Mississippi": "MS",
    "Missouri": "MO", "Montana": "MT", "Nebraska": "NE", "Nevada": "NV", "New Hampshire": "NH",
    "New Jersey": "NJ", "New Mexico": "NM", "New York": "NY", "North Carolina": "NC",
    "North Dakota": "ND", "Ohio": "OH", "Oklahoma": "OK", "Oregon": "OR", "Pennsylvania": "PA",
    "Rhode Island": "RI", "South Carolina": "SC", "South Dakota": "SD", "Tennessee": "TN",
    "Texas": "TX", "Utah": "UT", "Vermont": "VT", "Virginia": "VA", "Washington": "WA",
    "West Virginia": "WV", "Wisconsin": "WI", "Wyoming": "WY"
]

private enum RecreationSort: String, CaseIterable {
    case name = "Name"
    case size = "Size"
    case visitors = "Visitors"
}

struct RecreationTab: View {
    private let areas = DataLoader.loadNationalRecreation()

    @State private var currentHeroIndex: Int = 0
    @State private var selectedStateName: String = ""
    @State private var scrollOffset: CGFloat = 0
    @State private var heroTimer: Timer?
    @State private var showStatePicker: Bool = false
    @State private var searchQuery: String = ""
    @State private var sortBy: RecreationSort = .name
    @State private var favoriteIds: Set<String> = []

    private var availableStates: [String] {
        var set = Set<String>()
        areas.forEach { area in
            area.location.states.forEach { set.insert($0) }
        }
        return set.sorted()
    }

    /// 每个州在 RecArea 类别下的地点数量
    private var stateCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for area in areas {
            for s in area.location.states { counts[s, default: 0] += 1 }
        }
        return counts
    }

    private var filteredAreas: [NationalRecreationArea] {
        let stateFiltered: [NationalRecreationArea]
        if selectedStateName.isEmpty {
            stateFiltered = areas
        } else {
            stateFiltered = areas.filter { $0.location.states.contains(selectedStateName) }
        }

        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let searched = query.isEmpty
        ? stateFiltered
        : stateFiltered.filter {
            $0.name.lowercased().contains(query)
            || $0.description.lowercased().contains(query)
            || $0.location.states.contains { $0.lowercased().contains(query) }
        }

        return searched.sorted { lhs, rhs in
            switch sortBy {
            case .name:
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            case .size:
                return lhs.areaAcres > rhs.areaAcres
            case .visitors:
                return (lhs.visitors ?? 0) > (rhs.visitors ?? 0)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                searchSection
                sortSection
                cardsSection
            }
            .background(GeometryReader { geo in
                Color.clear.preference(key: RecreationScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
            })
        }
        .coordinateSpace(name: "scroll")
        .ignoresSafeArea(edges: .top)
        .onPreferenceChange(RecreationScrollOffsetKey.self) { value in
            scrollOffset = value
        }
        .background(exploreListDarkBackground.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(for: NationalRecreationArea.self) { area in
            RecreationDetailView(area: area)
        }
        .onAppear {
            if selectedStateName.isEmpty, let first = availableStates.first {
                selectedStateName = first
            }
            favoriteIds = Set(FavoritesManager.shared.load().filter { $0.id.hasPrefix("nationalrecreation:") }.map { $0.id.replacingOccurrences(of: "nationalrecreation:", with: "") })
            heroTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                DispatchQueue.main.async {
                    currentHeroIndex = (currentHeroIndex + 1) % recreationHeroImages.count
                }
            }
        }
        .onDisappear {
            heroTimer?.invalidate()
            heroTimer = nil
        }
    }

    private var heroHeight: CGFloat { UIScreen.main.bounds.height * 0.35 }

    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentHeroIndex) {
                ForEach(Array(recreationHeroImages.enumerated()), id: \.offset) { index, urlString in
                    ZStack {
                        if let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let img):
                                    img.resizable().scaledToFill()
                                default:
                                    Color.hikbikMuted
                                }
                            }
                            .frame(height: heroHeight)
                            .clipped()
                            .ignoresSafeArea(edges: .top)
                            .offset(y: scrollOffset * 0.25)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: heroHeight)

            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Text("Welcome")
                    .font(.system(size: 28, weight: .ultraLight, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                Text("Explore National Recreation Areas in")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                if !areas.isEmpty {
                    Text("\(areas.count) areas · Select a state below")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                        .shadow(color: .black.opacity(0.25), radius: 1, x: 1, y: 1)
                }
                stateSelectorBar
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, HikBikSpacing.lg)
            .padding(.bottom, HikBikSpacing.lg)
            .padding(.top, HikBikSpacing.xl)
        }
        .frame(height: heroHeight)
    }

    private func stateDisplayTitle(_ name: String) -> String {
        if name.isEmpty { return "Select state..." }
        let code = stateNameToCode[name] ?? ""
        return code.isEmpty ? name.uppercased() : "\(name.uppercased()) (\(code))"
    }

    private var stateSelectorBar: some View {
        Button {
            showStatePicker = true
        } label: {
            HStack {
                Text(stateDisplayTitle(selectedStateName))
                    .font(.system(size: min(24, UIScreen.main.bounds.width * 0.06), weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.horizontal, HikBikSpacing.lg)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.35))
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.white.opacity(0.2), lineWidth: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showStatePicker) {
            StatePickerSheetView(
                selectedStateName: $selectedStateName,
                isPresented: $showStatePicker,
                category: .recArea,
                availableStates: availableStates,
                stateCounts: stateCounts,
                themeColor: recreationThemeColor
            )
        }
    }

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.hikbikMutedForeground)
                TextField("Search recreation areas...", text: $searchQuery)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                if !searchQuery.isEmpty {
                    Button {
                        searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.hikbikCard)
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
        }
        .padding(.horizontal, HikBikSpacing.lg)
        .padding(.top, HikBikSpacing.lg)
    }

    private var sortSection: some View {
        HStack {
            Text("Sort by")
                .font(HikBikFont.caption())
                .foregroundStyle(Color.hikbikMutedForeground)
            Spacer()
            Picker("Sort", selection: $sortBy) {
                ForEach(RecreationSort.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(.cyan)
        }
        .padding(.horizontal, HikBikSpacing.lg)
        .padding(.top, 4)
    }

    private var cardsSection: some View {
        Group {
            if filteredAreas.isEmpty {
                ContentUnavailableView(
                    selectedStateName.isEmpty ? "Select a state" : "No national recreation areas in \(selectedStateName)",
                    systemImage: "tent.fill",
                    description: Text(selectedStateName.isEmpty ? "Tap the state selector above." : "Try another state.")
                )
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 22) {
                    ForEach(filteredAreas) { area in
                        NavigationLink(value: area) {
                            RecreationCardView(
                                area: area,
                                isFavorite: favoriteIds.contains(String(area.id)),
                                onToggleFavorite: { toggleFavorite(area) }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, HikBikSpacing.lg)
            }
        }
    }

    private func toggleFavorite(_ area: NationalRecreationArea) {
        let favId = "nationalrecreation:\(area.id)"
        if FavoritesManager.shared.contains(id: favId) {
            FavoritesManager.shared.remove(favId)
            favoriteIds.remove(String(area.id))
        } else {
            let coord = area.location.coordinates
            let dest = SavedDestination(
                id: favId,
                name: area.name,
                category: .recreationArea,
                agency: area.agency,
                imageUrl: area.photoUrl ?? area.photo,
                latitude: coord.latitude,
                longitude: coord.longitude
            )
            FavoritesManager.shared.save(dest)
            favoriteIds.insert(String(area.id))
        }
    }
}

private struct RecreationScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct RecreationCardView: View {
    let area: NationalRecreationArea
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    private var imageUrl: String {
        area.photoUrl ?? area.photo ?? "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=800"
    }

    private var attributes: [(icon: String, text: String)] {
        var list: [(icon: String, text: String)] = [
            ("square.dashed", "\(area.areaAcres) acres"),
            ("calendar", "Est. \(area.dateEstablished)")
        ]
        if let v = area.visitors {
            list.append(("person.2.fill", "\(v) visitors"))
        }
        return list
    }

    private var locationLabel: String {
        area.location.states.joined(separator: ", ")
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            PanoramaDestinationCard(
                imageUrl: imageUrl,
                title: area.name,
                locationLabel: locationLabel,
                iconAccent: ParkCategoryAccent.recreation.color,
                attributes: attributes
            )

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isFavorite ? .white : Color.hikbikPrimary)
                    .frame(width: 28, height: 28)
                    .background(isFavorite ? Color.hikbikDestructive : Color.white.opacity(0.9), in: Circle())
            }
            .padding(12)
        }
    }
}

// MARK: - Recreation Detail (Map + Sheet, same as Park/Forest)

private let recreationSheetBackgroundColor = Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255)
private let recreationThemeColor = Color.cyan

/// Quick Service Tags by scenario (Data Engineer contract)
private func recreationQuickTags(for scenario: String?) -> [(emoji: String, label: String)] {
    switch scenario ?? "Default" {
    case "Waterfront": return [("🎣", "Fishing"), ("⛵", "Marinas"), ("🛒", "Supplies")]
    case "Leisure": return [("🚲", "Bike Rentals"), ("☕", "Dining")]
    case "Alpine": return [("⛷️", "Skiing"), ("🥾", "Hiking")]
    default: return [("🎣", "Fishing"), ("⛵", "Marinas"), ("🛒", "Supplies")]
    }
}

private struct RecreationStatusBar: View {
    var established: String
    var category: String
    var acres: String
    var agency: String

    /// Use 2×2 grid when any value is long to avoid overlap (Denali-style readability)
    private var useTwoColumnGrid: Bool {
        let threshold = 22
        return category.count > threshold || agency.count > threshold
    }

    var body: some View {
        Group {
            if useTwoColumnGrid {
                twoByTwoGrid
            } else {
                fourColumnRow
            }
        }
        .background(Color.primary.opacity(0.06))
    }

    private var fourColumnRow: some View {
        HStack(spacing: 0) {
            RecreationStatusCell(icon: "calendar", title: "Est.", value: established, compact: true)
            RecreationStatusDivider(vertical: true, length: 56)
            RecreationStatusCell(icon: "tag.fill", title: "Category", value: category, compact: true)
            RecreationStatusDivider(vertical: true, length: 56)
            RecreationStatusCell(icon: "mappin.and.ellipse", title: "Acres", value: acres, compact: true)
            RecreationStatusDivider(vertical: true, length: 56)
            RecreationStatusCell(icon: "building.2.fill", title: "Agency", value: agency, compact: true)
        }
        .frame(height: 76)
    }

    private var twoByTwoGrid: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                RecreationStatusCell(icon: "calendar", title: "Est.", value: established, compact: false)
                RecreationStatusDivider(vertical: true, length: 52)
                RecreationStatusCell(icon: "tag.fill", title: "Category", value: category, compact: false)
            }
            .frame(height: 64)
            RecreationStatusDivider(vertical: false, length: nil)
            HStack(spacing: 0) {
                RecreationStatusCell(icon: "mappin.and.ellipse", title: "Acres", value: acres, compact: false)
                RecreationStatusDivider(vertical: true, length: 52)
                RecreationStatusCell(icon: "building.2.fill", title: "Agency", value: agency, compact: false)
            }
            .frame(height: 64)
        }
        .frame(minHeight: 132)
    }
}

private struct RecreationStatusCell: View {
    let icon: String
    let title: String
    let value: String
    var compact: Bool = true

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Text(value)
                .font(.system(size: compact ? 11 : 12, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(compact ? 1 : 2)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }
}

private struct RecreationStatusDivider: View {
    var vertical: Bool
    var length: CGFloat?

    var body: some View {
        if vertical {
            Rectangle()
                .fill(Color.primary.opacity(0.15))
                .frame(width: 1, height: length ?? 44)
        } else {
            Rectangle()
                .fill(Color.primary.opacity(0.15))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
    }
}

/// NRA 詳情 Sheet 的 ViewModel：RIDB RecArea 全量 + 動態設施
final class RecreationDetailSheetViewModel: ObservableObject {
    @Published var ridbRecArea: RIDBRecArea?
    @Published var ridbFacilities: [RIDBFacility] = []
    @Published var isLoadingRecArea = false
    @Published var isLoadingFacilities = false

    /// 先依名稱解析 RIDB RecAreaID（本地 id 與 RIDB 可能不一致），再拉詳情與設施
    func load(areaName: String, fallbackRecAreaId: String) {
        guard !areaName.isEmpty || !fallbackRecAreaId.isEmpty else { return }
        Task {
            var recAreaId = fallbackRecAreaId
            if let resolved = await RIDBService.shared.resolveRecAreaIDByName(areaName: areaName) {
                recAreaId = resolved
            }
            await MainActor.run { isLoadingRecArea = true }
            do {
                let rec = try await RIDBService.shared.fetchRecArea(recAreaID: recAreaId)
                await MainActor.run { ridbRecArea = rec; isLoadingRecArea = false }
            } catch {
                await MainActor.run { ridbRecArea = nil; isLoadingRecArea = false }
            }
            await MainActor.run { isLoadingFacilities = true }
            do {
                let list = try await RIDBService.shared.fetchFacilities(recAreaId: recAreaId)
                await MainActor.run { ridbFacilities = list; isLoadingFacilities = false }
            } catch {
                await MainActor.run { ridbFacilities = []; isLoadingFacilities = false }
            }
        }
    }
}

struct RecreationDetailSheetContent: View {
    let area: NationalRecreationArea
    @Binding var isFavorite: Bool
    var themeColor: Color = recreationThemeColor

    @StateObject private var recViewModel = RecreationDetailSheetViewModel()
    @State private var activeTab: RecreationDetailTab = .overview
    @State private var selectedRIDBFacility: RIDBFacility?
    
    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: area.location.coordinates.latitude,
            longitude: area.location.coordinates.longitude
        )
    }

    private var agencyDisplayName: String {
        let key = area.agency.split(separator: ",").first.map { String($0).trimmingCharacters(in: .whitespaces) } ?? area.agency
        return [
            "NPS": "National Park Service",
            "USFS": "U.S. Forest Service",
            "BLM": "Bureau of Land Management",
            "USBR": "Bureau of Reclamation",
            "USACE": "U.S. Army Corps of Engineers"
        ][key] ?? area.agency
    }

    private var acresDisplay: String {
        let a = area.areaAcres
        if a >= 1_000_000 { return "\(a / 1_000_000)M" }
        if a >= 1_000 { return "\(a / 1_000)K" }
        return "\(a)"
    }

    /// 介紹文字：優先 RIDB 描述（HTML 清洗），否則本地 area.description
    private var recDescriptionText: String {
        if let desc = recViewModel.ridbRecArea?.recAreaDescription, !desc.isEmpty {
            return RIDBAdapter.stripHTMLViaAttributedString(desc)
        }
        return area.description
    }

    /// 方向指南：RIDB RecAreaDirection
    private var recDirectionsText: String? {
        let s = recViewModel.ridbRecArea?.recAreaDirection?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (s != nil && !s!.isEmpty) ? s : nil
    }

    /// RIDB 解析出的地址字串（首筆 RECAREAADDRESS：StreetAddress1, City, StateCode, PostalCode）
    private var recAddressLine: String? {
        guard let addr = recViewModel.ridbRecArea?.recAreaAddresses?.first else { return nil }
        let parts = [addr.streetAddress1, addr.streetAddress2, addr.city, addr.stateCode, addr.postalCode].compactMap { $0 }.filter { !$0.isEmpty }
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }

    /// 始終有可顯示的地址/位置：RIDB 有則用，否則用州名 + 座標說明，方便用戶打開地圖
    private var recAddressOrLocationLine: String {
        if let line = recAddressLine, !line.isEmpty { return line }
        let states = area.location.states.joined(separator: ", ")
        return "\(area.name) · \(states) (\(String(format: "%.4f", coordinate.latitude)), \(String(format: "%.4f", coordinate.longitude)))"
    }

    private var recQuickInfoGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Management")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                Text(agencyDisplayName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 4) {
                Text("Last Updated")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                Text(recViewModel.ridbRecArea?.lastUpdatedDate ?? "—")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.primary.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 40)
                .padding(.bottom, 16)
            recHeroHeader
            recInfoStrip
            recDivider
            quickTagsRow
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    recTabBar
                    recContentSection
                    recMetadataSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(recreationSheetBackgroundColor)
        .overlay(alignment: .topTrailing) {
            FavoriteButton(
                id: "nationalrecreation:\(area.id)",
                name: area.name,
                category: .recreationArea,
                agency: area.agency,
                imageUrl: area.photoUrl ?? area.photo,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                isFavorite: $isFavorite
            )
            .padding(.top, 52)
            .padding(.trailing, 20)
        }
        .onAppear { recViewModel.load(areaName: area.name, fallbackRecAreaId: String(area.id)) }
        .sheet(item: $selectedRIDBFacility) { facility in
            NRAFacilityDetailSheet(areaId: area.id, areaAgency: area.agency, facility: facility, themeColor: themeColor)
        }
    }

    /// Hero：大標題 + Agency 與 RecAreaID，去框化
    private var recHeroHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(area.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    Image(systemName: "building.2.fill")
                        .font(.caption)
                        .foregroundStyle(themeColor)
                    Text(agencyDisplayName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                Text("RecArea ID: \(recViewModel.ridbRecArea.map { String($0.recAreaID) } ?? String(area.id))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            Spacer(minLength: 8)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    /// 橫向資訊長廊：圖標 + 標題 + 數值，極細豎線分隔
    private var recInfoStrip: some View {
        HStack(spacing: 0) {
            recInfoStripItem(icon: "calendar", title: "Est.", value: area.dateEstablished)
            recInfoStripDivider
            recInfoStripItem(icon: "mappin.and.ellipse", title: "Area", value: acresDisplay + " ac")
            recInfoStripDivider
            recInfoStripItem(icon: "star.fill", title: "Region", value: area.location.states.first ?? area.categoryName)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    private func recInfoStripItem(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(themeColor)
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                Text(value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var recInfoStripDivider: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.15))
            .frame(width: 1, height: 32)
    }

    private var recDivider: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.12))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }

    private var quickTagsRow: some View {
        let tags = recreationQuickTags(for: area.activeScenario)
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(tags.enumerated()), id: \.offset) { _, t in
                    Text("\(t.emoji) \(t.label)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.primary.opacity(0.12), in: Capsule())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }

    private var recTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(RecreationDetailTab.allCases, id: \.self) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: tab.icon)
                                .font(.caption)
                            Text(tab.title)
                                .font(HikBikFont.caption())
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(activeTab == tab ? themeColor : Color.hikbikMutedForeground)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(activeTab == tab ? themeColor.opacity(0.2) : Color.clear, in: Capsule())
                        .overlay(Capsule().stroke(activeTab == tab ? themeColor : Color.hikbikBorder, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var recContentSection: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            switch activeTab {
            case .overview:
                recOverviewSection
            case .activities:
                recActivitiesSection
            case .facilities:
                recFacilitiesSection
            case .plan:
                recPlanSection
            }
        }
    }

    private var recOverviewSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let directions = recDirectionsText, !directions.isEmpty {
                recDirectionsBlock(directions)
            } else {
                recDirectionsBlock("Use the map below or tap \"Navigate\" in the Location section to get directions.")
            }
            recAddressBlock(recAddressOrLocationLine)
            recAboutBlock
            WeatherInfoView()
                .padding(.vertical, 4)
            recDivider
                .padding(.vertical, 8)
            recFacilitiesBlock
            recDivider
                .padding(.vertical, 8)
            recCommunityFeedbackBlock
        }
    }

    /// Community Feedback 預留區：RIDB API 目前未提供 Rating/Review/TotalReviews，顯示佔位文案
    private var recCommunityFeedbackBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "star.leadinghalf.filled")
                    .font(.subheadline)
                    .foregroundStyle(themeColor)
                Text("Community Feedback")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            Text("No official reviews available yet. Be the first to visit!")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }

    /// 方向指南區塊：解析出的 RecAreaDirections 短句 + 大按鈕 Start Navigation
    private func recDirectionsBlock(_ directions: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(themeColor)
                Text("Directions")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            Text(directions)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            StartNavigationButton(coordinate: coordinate, themeColor: themeColor)
        }
        .padding(.top, 4)
    }

    /// 地址/位置：始終顯示；RIDB 有則用完整地址，否則用州名+座標，並可點擊開啟地圖
    private func recAddressBlock(_ addressLine: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(themeColor)
                Text("Location & Address")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            Text(addressLine)
                .font(.body)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                if let q = addressLine.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: "https://maps.apple.com/?q=\(q)") {
                    Link(destination: url) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            Text("Open in Maps")
                                .font(.caption.weight(.semibold))
                        }
                        .foregroundStyle(themeColor)
                    }
                }
                Link(destination: URL(string: "maps://?ll=\(coordinate.latitude),\(coordinate.longitude)&q=\(area.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? area.name)") ?? URL(string: "https://maps.apple.com")!) {
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                        Text("Navigate")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(themeColor)
                }
            }
        }
    }

    /// About：非對稱排版，無白卡
    private var recAboutBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            Text(recDescriptionText)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(6)
                .padding(.leading, 0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// 設施列表：始終顯示；RIDB 有則列 RIDB（含地圖連結），否則列衍生設施 + 區塊位置說明
    private var recFacilitiesBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "building.2.fill")
                    .font(.subheadline)
                    .foregroundStyle(themeColor)
                Text("Facilities")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.bottom, 10)
            if !recFilteredRIDBFacilities.isEmpty {
                VStack(spacing: 0) {
                    ForEach(recFilteredRIDBFacilities) { facility in
                        Button {
                            selectedRIDBFacility = facility
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(recFilterFacilityTitle(facility.facilityName ?? "Facility"))
                                            .font(.subheadline.weight(.medium))
                                            .foregroundStyle(.primary)
                                        if let type = facility.facilityType, !type.isEmpty {
                                            Text(type.replacingOccurrences(of: "-", with: " ").uppercased())
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer(minLength: 8)
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.tertiary)
                                }
                                if let lat = facility.facilityLatitude, let lon = facility.facilityLongitude {
                                    Link(destination: URL(string: "https://maps.apple.com/?ll=\(lat),\(lon)&q=\(recFilterFacilityTitle(facility.facilityName ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") ?? URL(string: "https://maps.apple.com")!) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "mappin")
                                                .font(.caption2)
                                            Text("View on map · \(String(format: "%.4f", lat)), \(String(format: "%.4f", lon))")
                                                .font(.caption2)
                                        }
                                        .foregroundStyle(themeColor)
                                    }
                                }
                            }
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        if facility.id != recFilteredRIDBFacilities.last?.id {
                            recDivider
                                .padding(.leading, 0)
                        }
                    }
                }
            } else {
                Text("Typical facilities in this area. Location: \(area.location.states.joined(separator: ", ")) — use \"Open in Maps\" or \"Navigate\" above to see the area.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
                VStack(spacing: 0) {
                    ForEach(recDerivedFacilities, id: \.name) { f in
                        HStack(spacing: 12) {
                            Image(systemName: f.icon)
                                .foregroundStyle(f.available ? themeColor : .secondary)
                            Text(f.name)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        if f.name != recDerivedFacilities.last?.name {
                            recDivider
                        }
                    }
                }
            }
        }
    }

    /// 頁底 Metadata：RIDB 提煉的 Last Updated、電話（可撥打）、Email（可寄信）、官網/預訂連結
    private var recMetadataSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            recDivider
                .padding(.vertical, 16)
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 24) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Last Updated")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text(recViewModel.ridbRecArea?.lastUpdatedDate ?? "—")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    if let phoneNum = recViewModel.ridbRecArea?.recAreaPhone?.trimmingCharacters(in: .whitespacesAndNewlines), !phoneNum.isEmpty, let url = URL(string: "tel:\(phoneNum.replacingOccurrences(of: " ", with: ""))") {
                        Link(destination: url) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Phone")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                HStack(spacing: 4) {
                                    Image(systemName: "phone.fill")
                                        .font(.caption2)
                                    Text(phoneNum)
                                        .font(.caption.weight(.medium))
                                }
                                .foregroundStyle(themeColor)
                            }
                        }
                    }
                }
                if let email = recViewModel.ridbRecArea?.recAreaEmail?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty, let mailUrl = URL(string: "mailto:\(email)") {
                    Link(destination: mailUrl) {
                        HStack(spacing: 6) {
                            Image(systemName: "envelope.fill")
                                .font(.caption)
                            Text(email)
                                .font(.caption.weight(.medium))
                        }
                        .foregroundStyle(themeColor)
                    }
                }
                if let web = recViewModel.ridbRecArea?.recAreaURL?.trimmingCharacters(in: .whitespacesAndNewlines), !web.isEmpty, let webUrl = URL(string: web) {
                    Link(destination: webUrl) {
                        HStack(spacing: 6) {
                            Image(systemName: "link")
                                .font(.caption)
                            Text("Official Website")
                                .font(.caption.weight(.medium))
                        }
                        .foregroundStyle(themeColor)
                    }
                }
                if let reserve = recViewModel.ridbRecArea?.recAreaReservationURL?.trimmingCharacters(in: .whitespacesAndNewlines), !reserve.isEmpty, let reserveUrl = URL(string: reserve) {
                    Button {
                        AuthGuard.run(message: AuthGuardMessages.travelBooking) {
                            UIApplication.shared.open(reserveUrl)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.caption)
                            Text("Reserve / Book")
                                .font(.caption.weight(.medium))
                        }
                        .foregroundStyle(themeColor)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
    }

    private var quickActionsSection: some View {
        FlowLayout(spacing: HikBikSpacing.sm) {
            if let mapsUrl = URL(string: "maps://?ll=\(coordinate.latitude),\(coordinate.longitude)&q=\((area.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? area.name))") {
                Link(destination: mapsUrl) {
                    Label("Directions", systemImage: "location.fill")
                        .font(HikBikFont.caption())
                        .fontWeight(.medium)
                        .foregroundStyle(themeColor)
                }
                .padding(.horizontal, HikBikSpacing.md)
                .padding(.vertical, 10)
                .background(themeColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
            }
            ShareLink(item: area.name, subject: Text(area.name), message: Text(area.description)) {
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
        }
    }

    private var quickStatsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
            RecreationStatCard(icon: "mappin.and.ellipse", label: "Total Area", value: "\(String(format: "%.1f", Double(area.areaAcres) / 1000))K")
            RecreationStatCard(icon: "calendar", label: "Established", value: area.dateEstablished)
            if let v = area.visitors {
                RecreationStatCard(icon: "person.2.fill", label: "Annual Visitors", value: "\(String(format: "%.1f", Double(v) / 1_000_000))M")
            }
            RecreationStatCard(icon: "star.fill", label: "Popularity", value: recPopularityLabel)
        }
    }

    private var recPopularityLabel: String {
        guard let v = area.visitors else { return "Moderate" }
        if v > 5_000_000 { return "High" }
        if v > 2_000_000 { return "Medium" }
        return "Moderate"
    }

    private var recActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            let activities = recExtractActivities(from: area.description)
            if !activities.isEmpty {
                Text("Popular Activities")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                FlowLayout(spacing: 8) {
                    ForEach(activities, id: \.self) { activity in
                        Text(activity)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(themeColor.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                recDivider.padding(.vertical, 4)
            }
            Text("Activity Tips")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            VStack(alignment: .leading, spacing: 8) {
                RecreationBullet(text: "Check weather conditions before heading out")
                RecreationBullet(text: "Bring plenty of water and sun protection")
                RecreationBullet(text: "Follow Leave No Trace principles")
                RecreationBullet(text: "Respect wildlife and maintain safe distances")
            }
        }
    }

    private var recFacilitiesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            recFacilitiesBlock
        }
    }

    /// RIDB 設施列表，過濾標題中 (REC AREA) 等冗餘字樣
    private var recFilteredRIDBFacilities: [RIDBFacility] {
        recViewModel.ridbFacilities
    }

    /// 移除 "(REC AREA)" 等冗餘字樣
    private func recFilterFacilityTitle(_ name: String) -> String {
        var s = name
            .replacingOccurrences(of: "(REC AREA)", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "(RECAREA)", with: "", options: .caseInsensitive)
        while s.contains("  ") { s = s.replacingOccurrences(of: "  ", with: " ") }
        return s.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: " ,"))
    }

    private var recPlanSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Best Time to Visit")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            Text(recBestTimeToVisit)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
            recDivider.padding(.vertical, 4)
            Text("Seasonal Highlights")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            VStack(alignment: .leading, spacing: 12) {
                ForEach(RecreationSeasonInfo.defaults) { season in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: season.icon)
                                .foregroundStyle(season.tint)
                            Text(season.name)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary)
                        }
                        Text(season.description)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        FlowLayout(spacing: 4) {
                            ForEach(season.activities, id: \.self) { act in
                                Text(act)
                                    .font(.caption2)
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(season.tint.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(season.tint.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            recDivider.padding(.vertical, 4)
            Text("Important Information")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            VStack(alignment: .leading, spacing: 8) {
                RecreationBullet(text: "Check for any current closures or restrictions before visiting")
                RecreationBullet(text: "Entrance fees may apply — check official website for details")
                RecreationBullet(text: "Cell phone coverage may be limited in remote areas")
            }
        }
    }

    private var recBestTimeToVisit: String {
        if area.categoryName.contains("Lake") || area.categoryName.contains("Reservoir") {
            return "Late spring to early fall (May–September) for water activities."
        }
        if area.categoryName.contains("Mountain") {
            return "Summer (June–August) for hiking; winter for snow sports."
        }
        if area.categoryName.contains("River") {
            return "Spring to fall (April–October) for rafting and fishing."
        }
        return "Spring through fall (April–October) for most activities."
    }

    private var recDerivedFacilities: [RecreationFacility] {
        var items: [RecreationFacility] = [
            RecreationFacility(icon: "tent.fill", name: "Campgrounds", available: true),
            RecreationFacility(icon: "car.fill", name: "Parking", available: true),
            RecreationFacility(icon: "info.circle.fill", name: "Visitor Center", available: (area.visitors ?? 0) > 1_000_000)
        ]
        let desc = area.description.lowercased()
        if desc.contains("boat") || desc.contains("boating") {
            items.append(RecreationFacility(icon: "wave.3.forward.circle.fill", name: "Boat Ramps", available: true))
        }
        if area.areaAcres > 50_000 {
            items.append(RecreationFacility(icon: "fork.knife.circle.fill", name: "Dining", available: true))
            items.append(RecreationFacility(icon: "bed.double.fill", name: "Lodging", available: true))
        }
        return items
    }

    private func recExtractActivities(from text: String) -> [String] {
        let keywords = [
            "boating", "fishing", "swimming", "hiking", "camping", "kayaking",
            "rafting", "rock climbing", "mountain biking", "horseback riding",
            "wildlife viewing", "photography", "scuba diving", "skiing", "snowboarding",
            "cross-country skiing", "snowmobiling", "canoeing", "picnicking"
        ]
        let lower = text.lowercased()
        var result: [String] = []
        for keyword in keywords where lower.contains(keyword) {
            let words = keyword.split(separator: " ")
            let capitalized = words.map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined(separator: " ")
            result.append(capitalized)
        }
        return Array(Set(result)).sorted()
    }
}

// MARK: - Recreation Detail View (Map + Sheet, same as Park/Forest/Grassland)

struct RecreationDetailView: View {
    let area: NationalRecreationArea
    @Environment(\.dismiss) private var dismiss

    @State private var showDetailSheet = true
    @State private var selectedDetent: PresentationDetent = .fraction(0.6)
    @State private var recAreaMarkerSelected = false
    @State private var isFavorite = false

    private var coordinate: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(
            latitude: area.location.coordinates.latitude,
            longitude: area.location.coordinates.longitude
        )
    }

    var body: some View {
        GeometryReader { geo in
            let fullScreenHeight = geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom
            ZStack {
                MapHeaderView(
                    coordinate: coordinate,
                    facilityAnnotation: nil,
                    viewpoints: nil,
                    dangerZones: nil,
                    themeColor: recreationThemeColor,
                    fixedHeight: fullScreenHeight,
                    recAreaStyle: true,
                    isRecAreaMarkerSelected: recAreaMarkerSelected,
                    onRecAreaMarkerTap: { recAreaMarkerSelected.toggle() }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .background(Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255))
        }
        .ignoresSafeArea(.all)
        .onAppear { isFavorite = FavoritesManager.shared.contains(id: "nationalrecreation:\(area.id)") }
        .sheet(isPresented: $showDetailSheet) {
            RecreationDetailSheetContent(area: area, isFavorite: $isFavorite, themeColor: recreationThemeColor)
                .presentationDetents([.height(200), .fraction(0.6), .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.6)))
                .interactiveDismissDisabled()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
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
                    .foregroundStyle(recreationThemeColor)
                    .padding(.horizontal, HikBikSpacing.md)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                }
            }
        }
    }
}

private enum RecreationDetailTab: CaseIterable {
    case overview
    case activities
    case facilities
    case plan

    var title: String {
        switch self {
        case .overview: return "Overview"
        case .activities: return "Activities"
        case .facilities: return "Facilities"
        case .plan: return "Plan Visit"
        }
    }

    var icon: String {
        switch self {
        case .overview: return "info.circle.fill"
        case .activities: return "figure.hiking"
        case .facilities: return "building.2.fill"
        case .plan: return "calendar"
        }
    }
}

/// NRA 設施二級彈窗：Hero + 預定 CTA + 屬性條 + 描述 + 聯繫 + 天氣，去卡片化
struct NRAFacilityDetailSheet: View {
    let areaId: Int
    let areaAgency: String
    let facility: RIDBFacility
    var themeColor: Color

    @State private var isFavorite = false

    private var facilityTitle: String {
        (facility.facilityName ?? "Facility")
            .replacingOccurrences(of: "(REC AREA)", with: "", options: .caseInsensitive)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var descriptionText: String {
        guard let raw = facility.facilityDescription, !raw.isEmpty else { return "" }
        return RIDBAdapter.stripHTMLViaAttributedString(raw)
    }
    private var coordinate: CLLocationCoordinate2D? {
        guard let lat = facility.facilityLatitude, let lon = facility.facilityLongitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    private var phoneURL: URL? {
        guard let num = facility.facilityPhone?.trimmingCharacters(in: .whitespacesAndNewlines), !num.isEmpty else { return nil }
        return URL(string: "tel:\(num.replacingOccurrences(of: " ", with: ""))")
    }
    private var attributeBarItems: [(icon: String, label: String)] {
        var list: [(icon: String, label: String)] = []
        if let v = facility.checkInOutTime, !v.isEmpty { list.append(("clock.fill", v)) }
        if let v = facility.petsAllowed, !v.isEmpty { list.append(("pawprint.fill", v)) }
        if let v = facility.maxVehicleLength, !v.isEmpty { list.append(("car.fill", v)) }
        return list
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                nraFacilityHero
                FacilityReservationCTA(
                    reservationURL: facility.reservationURL,
                    isCampground: facility.isCampgroundType,
                    themeColor: themeColor
                )
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 4)
                nraFacilityQuickActions
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !descriptionText.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                Text(descriptionText)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                        }
                        FacilityAttributesBar(items: attributeBarItems, themeColor: themeColor)
                            .padding(.horizontal, 20)
                        WeatherInfoView()
                            .padding(.horizontal, 20)
                        if facility.facilityPhone != nil || facility.facilityEmail != nil {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contact")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                if let url = phoneURL {
                                    Link(destination: url) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "phone.fill")
                                            Text(facility.facilityPhone ?? "Call")
                                        }
                                        .foregroundStyle(themeColor)
                                    }
                                }
                                if let email = facility.facilityEmail, !email.isEmpty, let mailto = URL(string: "mailto:\(email)") {
                                    Link(destination: mailto) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "envelope.fill")
                                            Text(email)
                                        }
                                        .foregroundStyle(themeColor)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255))
            .overlay(alignment: .topTrailing) {
                FavoriteButton(
                    id: "nationalrecreation:\(areaId):facility:\(facility.facilityID)",
                    name: facilityTitle,
                    category: .recreationArea,
                    agency: areaAgency,
                    imageUrl: nil,
                    latitude: coordinate?.latitude ?? 0,
                    longitude: coordinate?.longitude ?? 0,
                    isFavorite: $isFavorite
                )
                .padding(.top, 52)
                .padding(.trailing, 20)
            }
            .onAppear { isFavorite = FavoritesManager.shared.contains(id: "nationalrecreation:\(areaId):facility:\(facility.facilityID)") }
            .navigationTitle(facilityTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var nraFacilityHero: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [themeColor.opacity(0.35), themeColor.opacity(0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "tent.2.fill")
                .font(.system(size: 80))
                .foregroundStyle(themeColor.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 24)
                .padding(.trailing, 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(facilityTitle)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                Text(facility.facilityType?.replacingOccurrences(of: "-", with: " ").uppercased() ?? "FACILITY")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(themeColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .frame(height: 140)
    }

    private var nraFacilityQuickActions: some View {
        HStack(spacing: 30) {
            if phoneURL != nil {
                Button {
                    if let url = phoneURL { UIApplication.shared.open(url) }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                        Text("Call")
                            .font(.caption.weight(.medium))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
            if coordinate != nil {
                Button {
                    guard let c = coordinate else { return }
                    let item = MKMapItem(placemark: MKPlacemark(coordinate: c))
                    item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "map.fill")
                            .font(.title2)
                        Text("Directions")
                            .font(.caption.weight(.medium))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
            if facility.reservationURL != nil {
                Button {
                    guard let s = facility.reservationURL, let url = URL(string: s) else { return }
                    UIApplication.shared.open(url)
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "link.circle.fill")
                            .font(.title2)
                        Text("Reserve")
                            .font(.caption.weight(.medium))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
    }
}

private struct RecreationFacility {
    let icon: String
    let name: String
    let available: Bool
}

private struct RecreationSeasonInfo: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let tint: Color
    let description: String
    let activities: [String]

    static let defaults: [RecreationSeasonInfo] = [
        RecreationSeasonInfo(
            name: "Spring",
            icon: "drop.fill",
            tint: .green,
            description: "Wildflowers bloom, moderate temperatures",
            activities: ["Hiking", "Photography", "Wildlife Viewing"]
        ),
        RecreationSeasonInfo(
            name: "Summer",
            icon: "sun.max.fill",
            tint: .yellow,
            description: "Peak season, all facilities open",
            activities: ["Swimming", "Boating", "Camping"]
        ),
        RecreationSeasonInfo(
            name: "Fall",
            icon: "leaf.fill",
            tint: .orange,
            description: "Colorful foliage, fewer crowds",
            activities: ["Hiking", "Photography", "Fishing"]
        ),
        RecreationSeasonInfo(
            name: "Winter",
            icon: "snowflake",
            tint: .blue,
            description: "Snow activities, peaceful atmosphere",
            activities: ["Skiing", "Snowshoeing", "Ice Fishing"]
        )
    ]
}

private struct RecreationSectionCard<Content: View>: View {
    let title: String
    let icon: String
    var tint: Color = Color.cyan
    let content: Content

    init(title: String, icon: String, tint: Color = Color.cyan, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.tint = tint
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
            Label(title, systemImage: icon)
                .font(HikBikFont.headline())
                .foregroundStyle(tint)
            content
        }
        .padding(HikBikSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
    }
}

private struct RecreationStatCard: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.cyan)
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
}

private struct RecreationInfoRow: View {
    let label: String
    let value: String

    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(HikBikFont.caption())
                .foregroundStyle(Color.hikbikMutedForeground)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(HikBikFont.caption())
                .foregroundStyle(Color.hikbikForeground)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct RecreationBullet: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.hikbikTabActive)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            Text(text)
                .font(HikBikFont.caption())
            .foregroundStyle(Color.hikbikForeground)
        }
    }
}

private extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool { self?.isEmpty ?? true }
}

#Preview { NavigationStack { RecreationTab() } }
