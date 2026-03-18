// 与 Web 探索入口一致：分类列表；深色背景 + 亮邊質感
import SwiftUI

private let stateParksComingSoonGreen = Color(red: 0.2, green: 0.6, blue: 0.3)
private let exploreDarkBackground = Color(hex: "1A3324")

struct ExploreView: View {
    @State private var showStateParksComingSoon = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        showStateParksComingSoon = true
                    } label: {
                        Label("State Parks", systemImage: "map.fill")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.06))
                    NavigationLink(value: ExploreDestination.nationalParks) {
                        Label("National Parks", systemImage: "mountain.2.fill")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.06))
                    NavigationLink(value: ExploreDestination.forests) {
                        Label("National Forests", systemImage: "tree.fill")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.06))
                    NavigationLink(value: ExploreDestination.grasslands) {
                        Label("National Grasslands", systemImage: "leaf.fill")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.06))
                    NavigationLink(value: ExploreDestination.recreation) {
                        Label("National Recreation", systemImage: "water.waves")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.06))
                } header: {
                    Text("Explore")
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.white.opacity(0.9))
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(exploreDarkBackground.ignoresSafeArea())
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(for: ExploreDestination.self) { dest in
                exploreDestinationView(dest)
            }
            .alert("State Parks & Forests", isPresented: $showStateParksComingSoon) {
                Button("Got it", role: .cancel) {}
            } message: {
                Text("We are hard at work bringing State data to HikBik. Coming soon in a future update!")
            }
            .tint(stateParksComingSoonGreen)
        }
    }

    @ViewBuilder
    private func exploreDestinationView(_ dest: ExploreDestination) -> some View {
        switch dest {
        case .stateParks: StateParksTab()
        case .nationalParks: NationalParksTab()
        case .forests: ForestsTab()
        case .grasslands: GrasslandsTab()
        case .recreation: RecreationTab()
        case .favorites: HomeFavoritesView()
        }
    }
}

#Preview { ExploreView() }
