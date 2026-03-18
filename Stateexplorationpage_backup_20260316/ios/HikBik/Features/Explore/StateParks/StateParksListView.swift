import SwiftUI

struct StateParksListView: View {
    let state: StateListItem
    private var stateData: StateData? {
        DataLoader.loadStateParks()[state.code]
    }
    
    var body: some View {
        Group {
            if let data = stateData, !data.parks.isEmpty {
                List(data.parks) { park in
                    NavigationLink(value: park) {
                        ParkRowView(park: park)
                    }
                    .listRowBackground(Color.hikbikCard)
                    .listRowSeparatorTint(Color.hikbikBorder)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.hikbikBackground)
            } else {
                ContentUnavailableView(
                    "No park data",
                    systemImage: "leaf",
                    description: Text("Add states-parks.json to the project with data for this state, or export full data from the web app.")
                )
            }
        }
        .navigationTitle(state.name)
        .navigationDestination(for: Park.self) { park in
            ParkDetailView(park: park)
        }
    }
}

struct ParkRowView: View {
    let park: Park
    
    var body: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.xs) {
            Text(park.name)
                .font(HikBikFont.headline())
                .foregroundStyle(Color.hikbikPrimary)
            if !park.activities.isEmpty {
                Text(park.activities.prefix(3).joined(separator: " · "))
                    .font(HikBikFont.caption())
                    .foregroundStyle(Color.hikbikMutedForeground)
            }
        }
        .padding(.vertical, HikBikSpacing.xs)
    }
}

#Preview {
    NavigationStack {
        StateParksListView(state: StateListItem(id: 5, name: "California", code: "CA", parksCount: "280+ Parks"))
    }
}
