// 与设计一致：Hero 轮播 35vh、视差渐变、底部 Welcome + 州选择器（毛玻璃）、卡片列表；深墨綠質感背景
import SwiftUI

private let exploreListDarkBackground = Color(hex: "1A3324")

private let heroImages = [
    "https://images.unsplash.com/photo-1516687401797-25297ff1462c?w=1080",
    "https://images.unsplash.com/photo-1677116825823-97c47cf7b33c?w=1080",
    "https://images.unsplash.com/photo-1632189437161-a6560af9e232?w=1080",
    "https://images.unsplash.com/photo-1524274165673-750e79bf7e2e?w=1080"
]

/// 州全名 → 两字母代码（与设计 "CALIFORNIA (CA)" 一致）
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

struct NationalParksTab: View {
    private let allParks = DataLoader.loadNationalParks()
    private let gallery: [String: [String]] = DataLoader.loadNationalParksGallery()

    @State private var currentHeroIndex: Int = 0
    @State private var selectedStateName: String = ""
    @State private var scrollOffset: CGFloat = 0
    @State private var heroTimer: Timer?
    @State private var showStatePicker: Bool = false

    /// 有国家公园的州（从数据集 Filter 提取，内存快速完成）
    private var availableStates: [String] {
        var set = Set<String>()
        for park in allParks {
            if let states = park.states, !states.isEmpty {
                states.forEach { set.insert($0) }
            } else {
                set.insert(park.state)
            }
        }
        return set.sorted()
    }

    /// 每个州在 Park 类别下的地点数量，用于网格显示 "9 Parks"
    private var stateCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for park in allParks {
            let states = park.states ?? [park.state]
            for s in states { counts[s, default: 0] += 1 }
        }
        return counts
    }

    private var filteredParks: [NationalPark] {
        if selectedStateName.isEmpty { return allParks }
        return allParks.filter { park in
            if let states = park.states { return states.contains(selectedStateName) }
            return park.state == selectedStateName
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
        .scrollContentBackground(.hidden)
        .background(exploreListDarkBackground.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            scrollOffset = value
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(for: NationalPark.self) { park in
            NationalParkDetailView(park: park)
        }
        .onAppear {
            if selectedStateName.isEmpty, let first = availableStates.first {
                selectedStateName = first
            }
            heroTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                DispatchQueue.main.async {
                    currentHeroIndex = (currentHeroIndex + 1) % heroImages.count
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
                ForEach(Array(heroImages.enumerated()), id: \.offset) { index, urlString in
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
                Text("Explore National Parks in")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                if !allParks.isEmpty {
                    Text("\(allParks.count) parks · Select a state below")
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

    /// 触发按钮 / 列表行显示：与设计一致 "CALIFORNIA (CA)"
    private func stateDisplayTitle(_ name: String) -> String {
        if name.isEmpty { return "Select state..." }
        let code = stateNameToCode[name] ?? ""
        return code.isEmpty ? name.uppercased() : "\(name.uppercased()) (\(code))"
    }

    // 方案1: List + SearchBar（推荐）- 原生吸顶 Section、右侧字母条、搜索实时过滤
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
                category: .park,
                availableStates: availableStates,
                stateCounts: stateCounts,
                themeColor: Color.hikbikTabActive
            )
        }
    }

    private var cardsSection: some View {
        Group {
            if filteredParks.isEmpty {
                ContentUnavailableView(
                    selectedStateName.isEmpty ? "Select a state" : "No national parks in \(selectedStateName)",
                    systemImage: "mountain.2",
                    description: Text(selectedStateName.isEmpty ? "Tap the state selector above." : "Try another state.")
                )
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 22) {
                    ForEach(filteredParks) { park in
                        NavigationLink(value: park) {
                            NationalParkCardView(
                                park: park,
                                imageUrl: gallery[park.id]?.first
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

#Preview {
    NavigationStack { NationalParksTab() }
}
