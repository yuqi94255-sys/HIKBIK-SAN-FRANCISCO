// 与 Web 探索入口一致：分类列表
import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(value: ExploreDestination.stateParks) {
                        Label("State Parks", systemImage: "map.fill")
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                    .listRowBackground(Color.hikbikCard)
                    NavigationLink(value: ExploreDestination.nationalParks) {
                        Label("National Parks", systemImage: "mountain.2.fill")
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                    .listRowBackground(Color.hikbikCard)
                    NavigationLink(value: ExploreDestination.forests) {
                        Label("National Forests", systemImage: "tree.fill")
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                    .listRowBackground(Color.hikbikCard)
                    NavigationLink(value: ExploreDestination.grasslands) {
                        Label("National Grasslands", systemImage: "leaf.fill")
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                    .listRowBackground(Color.hikbikCard)
                    NavigationLink(value: ExploreDestination.recreation) {
                        Label("National Recreation", systemImage: "water.waves")
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                    .listRowBackground(Color.hikbikCard)
                } header: {
                    Text("Explore")
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.hikbikBackground)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: ExploreDestination.self) { dest in
                exploreDestinationView(dest)
            }
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
        case .favorites: FavoritesListView()
        }
    }
}

#Preview { ExploreView() }
