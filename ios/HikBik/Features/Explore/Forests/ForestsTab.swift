import SwiftUI

private let exploreListDarkBackground = Color(hex: "1A3324")

private let forestHeroImages = [
    "https://images.unsplash.com/photo-1592489499861-c5b598a13f8b?w=1080",
    "https://images.unsplash.com/photo-1659514297099-af33ba8f1df9?w=1080",
    "https://images.unsplash.com/photo-1749661610902-9453f7e343a2?w=1080",
    "https://images.unsplash.com/photo-1645483557206-a61a6840c2c4?w=1080"
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

struct ForestsTab: View {
    @StateObject private var ridbViewModel = ExploreRIDBViewModel()

    private var forests: [NationalForest] { ridbViewModel.forests }

    @State private var currentHeroIndex: Int = 0
    @State private var selectedStateName: String = ""
    @State private var scrollOffset: CGFloat = 0
    @State private var heroTimer: Timer?
    @State private var showStatePicker: Bool = false

    private var availableStates: [String] {
        var set = Set<String>()
        forests.forEach { forest in
            if let states = forest.states, !states.isEmpty {
                states.forEach { set.insert($0) }
            } else {
                set.insert(forest.state)
            }
        }
        return set.sorted()
    }

    /// 每个州在 Forest 类别下的地点数量
    private var stateCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for forest in forests {
            let states = forest.states ?? [forest.state]
            for s in states { counts[s, default: 0] += 1 }
        }
        return counts
    }

    private var filteredForests: [NationalForest] {
        if selectedStateName.isEmpty { return forests }
        return forests.filter { forest in
            if let states = forest.states { return states.contains(selectedStateName) }
            return forest.state == selectedStateName
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                cardsSection
            }
            .background(GeometryReader { geo in
                Color.clear.preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
            })
        }
        .coordinateSpace(name: "scroll")
        .ignoresSafeArea(edges: .top)
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            scrollOffset = value
        }
        .background(exploreListDarkBackground.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(for: NationalForest.self) { forest in
            ForestDetailView(forest: forest)
        }
        .onAppear {
            if selectedStateName.isEmpty, let first = availableStates.first {
                selectedStateName = first
            }
            heroTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                DispatchQueue.main.async {
                    currentHeroIndex = (currentHeroIndex + 1) % forestHeroImages.count
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
                ForEach(Array(forestHeroImages.enumerated()), id: \.offset) { index, urlString in
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
                Text("Explore National Forests in")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                if !forests.isEmpty {
                    Text("\(forests.count) forests · Select a state below")
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
                category: .forest,
                availableStates: availableStates,
                stateCounts: stateCounts,
                themeColor: Color(red: 0.2, green: 0.6, blue: 0.3)
            )
        }
    }

    private var cardsSection: some View {
        Group {
            if forests.isEmpty {
                ContentUnavailableView(
                    "No national forest data",
                    systemImage: "tree.fill",
                    description: Text("Ensure national-forests.json is added to Resources.")
                )
                .padding(.vertical, 40)
            } else if filteredForests.isEmpty {
                ContentUnavailableView(
                    selectedStateName.isEmpty ? "Select a state" : "No national forests in \(selectedStateName)",
                    systemImage: "leaf",
                    description: Text(selectedStateName.isEmpty ? "Tap the state selector above." : "Try another state.")
                )
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 22) {
                    ForEach(filteredForests) { forest in
                        NavigationLink(value: forest) {
                            NationalForestCardView(
                                forest: forest,
                                imageUrl: forest.photos?.first
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, HikBikSpacing.lg)
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview { NavigationStack { ForestsTab() } }
