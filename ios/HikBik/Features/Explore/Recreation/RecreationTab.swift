import SwiftUI
import MapKit

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
    @State private var stateSearchText: String = ""
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

    private var statesByLetter: [(letter: String, states: [String])] {
        let grouped = Dictionary(grouping: availableStates) { state in
            String(state.prefix(1)).uppercased()
        }
        return grouped.keys.sorted().map { letter in
            (letter: letter, states: (grouped[letter] ?? []).sorted())
        }
    }

    private var filteredStatesByLetter: [(letter: String, states: [String])] {
        let query = stateSearchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty { return statesByLetter }
        let filtered = availableStates.filter { state in
            state.lowercased().contains(query) || (stateNameToCode[state] ?? "").lowercased().contains(query)
        }
        let grouped = Dictionary(grouping: filtered) { String($0.prefix(1)).uppercased() }
        return grouped.keys.sorted().map { letter in
            (letter: letter, states: (grouped[letter] ?? []).sorted())
        }
    }

    private var allLetters: [String] {
        (65...90).map { String(Unicode.Scalar($0)) }
    }

    private func hasStatesInFiltered(forLetter letter: String) -> Bool {
        filteredStatesByLetter.contains { $0.letter == letter }
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
        .background(Color.hikbikBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: NationalRecreationArea.self) { area in
            RecreationDetailView(area: area)
        }
        .onAppear {
            if selectedStateName.isEmpty, let first = availableStates.first {
                selectedStateName = first
            }
            favoriteIds = Set(FavoritesStore.loadIds(.nationalrecreation))
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
            .background(.ultraThinMaterial)
            .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.white.opacity(0.5), lineWidth: 2))
            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showStatePicker) {
            statePickerSheet
        }
        .onChange(of: showStatePicker) { _, show in
            if !show { stateSearchText = "" }
        }
    }

    private var statePickerSheet: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                HStack(spacing: 0) {
                    List {
                        ForEach(filteredStatesByLetter, id: \.letter) { group in
                            Section(header: Text(group.letter).id(group.letter)) {
                                ForEach(group.states, id: \.self) { state in
                                    Button {
                                        selectedStateName = state
                                        showStatePicker = false
                                    } label: {
                                        HStack {
                                            Text(state)
                                                .font(.body)
                                                .foregroundStyle(Color.hikbikPrimary)
                                            Spacer()
                                            Text(stateNameToCode[state] ?? "")
                                                .font(.caption)
                                                .foregroundStyle(Color.hikbikMutedForeground)
                                            if selectedStateName == state {
                                                Image(systemName: "checkmark")
                                                    .font(.caption.weight(.semibold))
                                                    .foregroundStyle(Color.cyan)
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $stateSearchText, prompt: "Search states...")
                    .navigationTitle("Select State")
                    .navigationBarTitleDisplayMode(.inline)

                    VStack(spacing: 1) {
                        ForEach(allLetters, id: \.self) { letter in
                            Button {
                                guard hasStatesInFiltered(forLetter: letter) else { return }
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            } label: {
                                Text(letter)
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundStyle(hasStatesInFiltered(forLetter: letter) ? Color.hikbikMutedForeground : Color.hikbikMutedForeground.opacity(0.5))
                                    .frame(width: 18, height: 14)
                            }
                            .buttonStyle(.plain)
                            .disabled(!hasStatesInFiltered(forLetter: letter))
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 5)
                    .background(Color.hikbikSecondary.opacity(0.5))
                }
            }
            .background(Color.hikbikBackground)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showStatePicker = false
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.cyan)
                    .buttonStyle(.borderless)
                }
            }
        }
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(16)
        .presentationDetents([.height(320), .medium])
        .presentationDragIndicator(.visible)
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: HikBikSpacing.md) {
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
                    .padding(.horizontal, HikBikSpacing.lg)
                    .padding(.vertical, HikBikSpacing.lg)
                }
            }
        }
    }

    private func toggleFavorite(_ area: NationalRecreationArea) {
        let id = String(area.id)
        if favoriteIds.contains(id) {
            FavoritesStore.remove(.nationalrecreation, id: id)
            favoriteIds.remove(id)
        } else {
            FavoritesStore.add(.nationalrecreation, id: id, stateName: area.location.states.first)
            favoriteIds.insert(id)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    default:
                        Color.hikbikMuted
                    }
                }
                .frame(height: 140)
                .clipped()
                LinearGradient(colors: [.clear, .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)

                HStack {
                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(isFavorite ? Color.white : Color.hikbikPrimary)
                            .frame(width: 28, height: 28)
                            .background(isFavorite ? Color.hikbikDestructive : Color.white.opacity(0.9), in: Circle())
                    }
                    Spacer()
                    Text(area.location.states.joined(separator: ", "))
                        .font(HikBikFont.caption2())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .padding(8)
            }
            .frame(height: 140)

            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Text(area.name)
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                    .lineLimit(2)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption)
                            .foregroundStyle(Color.cyan)
                        Text("\(area.areaAcres) acres")
                            .font(HikBikFont.caption())
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundStyle(Color.cyan)
                        Text("Est. \(area.dateEstablished)")
                            .font(HikBikFont.caption())
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                    if let visitors = area.visitors {
                        HStack(spacing: 6) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.caption)
                                .foregroundStyle(Color.cyan)
                            Text("\(visitors) visitors")
                                .font(HikBikFont.caption())
                                .foregroundStyle(Color.hikbikMutedForeground)
                        }
                    }
                }

                Text(area.categoryName)
                    .font(HikBikFont.caption())
                    .foregroundStyle(Color.cyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.cyan.opacity(0.1))
                    .clipShape(Capsule())

                HStack {
                    Text("View Details")
                        .font(HikBikFont.caption())
                        .foregroundStyle(Color.cyan)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.cyan)
                }
            }
            .padding(HikBikSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.hikbikCard)
        }
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.xl).stroke(Color.hikbikBorder, lineWidth: 1))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .frame(width: 240)
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

struct RecreationDetailSheetContent: View {
    let area: NationalRecreationArea
    var themeColor: Color = recreationThemeColor

    @State private var activeTab: RecreationDetailTab = .overview
    @State private var isFavorite: Bool = false

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

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.primary.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 40)
                .padding(.bottom, 24)
            sheetHeader
            RecreationStatusBar(
                established: area.dateEstablished,
                category: area.categoryName,
                acres: acresDisplay,
                agency: agencyDisplayName
            )
            quickTagsRow
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    RecreationAccessView(area: area, coordinate: coordinate, themeColor: themeColor)
                    StartNavigationButton(coordinate: coordinate, themeColor: themeColor)
                    recTabBar
                    recContentSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(recreationSheetBackgroundColor)
        .onAppear {
            isFavorite = FavoritesStore.contains(.nationalrecreation, id: String(area.id))
        }
    }

    private var sheetHeader: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(area.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text("National Recreation Area")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            Button {
                let id = String(area.id)
                if isFavorite {
                    FavoritesStore.remove(.nationalrecreation, id: id)
                    isFavorite = false
                } else {
                    FavoritesStore.add(.nationalrecreation, id: id, stateName: area.location.states.first)
                    isFavorite = true
                }
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(isFavorite ? Color.red : .secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
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
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            quickActionsSection
            quickStatsSection
            RecreationSectionCard(title: "About This Recreation Area", icon: "camera.fill") {
                Text(area.description)
                    .font(HikBikFont.body())
                    .foregroundStyle(Color.hikbikForeground)
                    .fixedSize(horizontal: false, vertical: true)
            }
            RecreationSectionCard(title: "Details", icon: "info.circle.fill") {
                VStack(alignment: .leading, spacing: 8) {
                    RecreationInfoRow("Category", area.categoryName)
                    RecreationInfoRow("Agency", agencyDisplayName)
                    RecreationInfoRow("Established", area.dateEstablished)
                    RecreationInfoRow("Total Area", "\(area.areaAcres) acres")
                    if let v = area.visitors {
                        RecreationInfoRow("Annual Visitors", "\(v)")
                    }
                }
            }
        }
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
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            let activities = recExtractActivities(from: area.description)
            if !activities.isEmpty {
                RecreationSectionCard(title: "Popular Activities", icon: "figure.hiking") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
                        ForEach(activities, id: \.self) { activity in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color.cyan)
                                Text(activity)
                                    .font(HikBikFont.caption())
                                    .foregroundStyle(Color.hikbikPrimary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.hikbikMuted.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.md))
                        }
                    }
                }
            }
            RecreationSectionCard(title: "Activity Tips", icon: "lightbulb.fill", tint: .orange) {
                VStack(alignment: .leading, spacing: 8) {
                    RecreationBullet(text: "Check weather conditions before heading out")
                    RecreationBullet(text: "Bring plenty of water and sun protection")
                    RecreationBullet(text: "Follow Leave No Trace principles")
                    RecreationBullet(text: "Respect wildlife and maintain safe distances")
                }
            }
        }
    }

    private var recFacilitiesSection: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            RecreationSectionCard(title: "Facilities & Amenities", icon: "building.2.fill") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
                    ForEach(recDerivedFacilities, id: \.name) { facility in
                        HStack(spacing: 8) {
                            Image(systemName: facility.icon)
                                .foregroundStyle(facility.available ? Color.green : Color.hikbikMutedForeground)
                            Text(facility.name)
                                .font(HikBikFont.caption())
                                .foregroundStyle(facility.available ? Color.hikbikPrimary : Color.hikbikMutedForeground)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(facility.available ? Color.green.opacity(0.1) : Color.hikbikMuted.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.md))
                    }
                }
            }
        }
    }

    private var recPlanSection: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.lg) {
            RecreationSectionCard(title: "Best Time to Visit", icon: "sun.max.fill") {
                Text(recBestTimeToVisit)
                    .font(HikBikFont.body())
                    .foregroundStyle(Color.hikbikForeground)
            }
            RecreationSectionCard(title: "Seasonal Highlights", icon: "sparkles") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: HikBikSpacing.sm) {
                    ForEach(RecreationSeasonInfo.defaults) { season in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: season.icon)
                                    .foregroundStyle(season.tint)
                                Text(season.name)
                                    .font(HikBikFont.caption())
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.hikbikPrimary)
                            }
                            Text(season.description)
                                .font(HikBikFont.caption2())
                                .foregroundStyle(Color.hikbikMutedForeground)
                            FlowLayout(spacing: 4) {
                                ForEach(season.activities, id: \.self) { act in
                                    Text(act)
                                        .font(HikBikFont.caption2())
                                        .foregroundStyle(Color.hikbikPrimary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(season.tint.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(HikBikSpacing.sm)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(season.tint.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.md))
                    }
                }
            }
            RecreationSectionCard(title: "Important Information", icon: "exclamationmark.triangle.fill", tint: .red) {
                VStack(alignment: .leading, spacing: 8) {
                    RecreationBullet(text: "Check for any current closures or restrictions before visiting")
                    RecreationBullet(text: "Entrance fees may apply — check official website for details")
                    RecreationBullet(text: "Cell phone coverage may be limited in remote areas")
                }
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
                    fixedHeight: fullScreenHeight
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .background(Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255))
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showDetailSheet) {
            RecreationDetailSheetContent(area: area, themeColor: recreationThemeColor)
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
