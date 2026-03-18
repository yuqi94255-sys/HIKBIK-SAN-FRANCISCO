import SwiftUI

private let grasslandHeroImages = [
    "https://images.unsplash.com/photo-1595147389795-37094173bfd8?w=1080",
    "https://images.unsplash.com/photo-1633813128468-7f53a60f3cd7?w=1080",
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1080",
    "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=1080"
]

/// 州全名 → 两字母代码（与国家公园一致）
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

struct GrasslandsTab: View {
    @StateObject private var ridbViewModel = ExploreRIDBViewModel()

    private var grasslands: [NationalGrassland] { ridbViewModel.grasslands }

    @State private var currentHeroIndex: Int = 0
    @State private var selectedStateName: String = ""
    @State private var scrollOffset: CGFloat = 0
    @State private var heroTimer: Timer?
    @State private var showStatePicker: Bool = false
    @State private var searchQuery: String = ""

    private var availableStates: [String] {
        var set = Set<String>()
        grasslands.forEach { grassland in
            if let states = grassland.states, !states.isEmpty {
                states.forEach { set.insert($0) }
            } else {
                grassland.state
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .forEach { set.insert($0) }
            }
        }
        return set.sorted()
    }

    /// 每个州在 Grassland 类别下的地点数量
    private var stateCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for g in grasslands {
            let states: [String] = g.states ?? grasslandStateList(g.state)
            for s in states { counts[s, default: 0] += 1 }
        }
        return counts
    }

    private func grasslandStateList(_ state: String) -> [String] {
        state.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    private var filteredGrasslands: [NationalGrassland] {
        let stateFiltered: [NationalGrassland]
        if selectedStateName.isEmpty {
            stateFiltered = grasslands
        } else {
            stateFiltered = grasslands.filter { grassland in
                if let states = grassland.states {
                    return states.contains(selectedStateName)
                }
                return grassland.state
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .contains(selectedStateName)
            }
        }

        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty { return stateFiltered }
        return stateFiltered.filter { grassland in
            grassland.name.lowercased().contains(query)
            || grassland.description.lowercased().contains(query)
            || grassland.state.lowercased().contains(query)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                searchSection
                cardsSection
            }
            .background(GeometryReader { geo in
                Color.clear.preference(key: GrasslandsScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
            })
        }
        .coordinateSpace(name: "scroll")
        .ignoresSafeArea(edges: .top)
        .onPreferenceChange(GrasslandsScrollOffsetKey.self) { value in
            scrollOffset = value
        }
        .background(Color.hikbikBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: NationalGrassland.self) { g in
            GrasslandDetailView(grassland: g)
        }
        .onAppear {
            if selectedStateName.isEmpty, let first = availableStates.first {
                selectedStateName = first
            }
            heroTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                DispatchQueue.main.async {
                    currentHeroIndex = (currentHeroIndex + 1) % grasslandHeroImages.count
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
                ForEach(Array(grasslandHeroImages.enumerated()), id: \.offset) { index, urlString in
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
                Text("Explore National Grasslands in")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                if !grasslands.isEmpty {
                    Text("\(grasslands.count) grasslands · Select a state below")
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
        .fullScreenCover(isPresented: $showStatePicker) {
            StatePickerSheetView(
                selectedStateName: $selectedStateName,
                isPresented: $showStatePicker,
                category: .grassland,
                availableStates: availableStates,
                stateCounts: stateCounts,
                themeColor: Color(red: 0.55, green: 0.45, blue: 0.2)
            )
        }
    }

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.hikbikMutedForeground)
                TextField("Search grasslands...", text: $searchQuery)
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

    private var cardsSection: some View {
        Group {
            if filteredGrasslands.isEmpty {
                ContentUnavailableView(
                    selectedStateName.isEmpty ? "Select a state" : "No national grasslands in \(selectedStateName)",
                    systemImage: "leaf",
                    description: Text(selectedStateName.isEmpty ? "Tap the state selector above." : "Try another state.")
                )
                .padding(.vertical, 40)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: HikBikSpacing.md) {
                        ForEach(filteredGrasslands) { grassland in
                            NavigationLink(value: grassland) {
                                GrasslandCardView(grassland: grassland)
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
}

private struct GrasslandsScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct GrasslandCardView: View {
    let grassland: NationalGrassland

    private var imageUrl: String {
        grassland.photos?.first ?? "https://images.unsplash.com/photo-1595147389795-37094173bfd8?w=800"
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
                Text(grassland.state)
                    .font(HikBikFont.caption2())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(8)
            }
            .frame(height: 140)

            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Text(grassland.name)
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                    .lineLimit(2)
                Text(grassland.region)
                    .font(HikBikFont.caption())
                    .foregroundStyle(Color.hikbikMutedForeground)
                if let activities = grassland.activities, !activities.isEmpty {
                    FlowLayout(spacing: 4) {
                        ForEach(activities.prefix(3), id: \.self) { a in
                            Text(a)
                                .font(HikBikFont.caption2())
                                .foregroundStyle(Color.hikbikTabActive)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.hikbikTabActiveTint)
                                .clipShape(Capsule())
                        }
                    }
                }
                HStack {
                    Text("View Details")
                        .font(HikBikFont.caption())
                        .foregroundStyle(Color.hikbikTabActive)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.hikbikTabActive)
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

#Preview { NavigationStack { GrasslandsTab() } }
