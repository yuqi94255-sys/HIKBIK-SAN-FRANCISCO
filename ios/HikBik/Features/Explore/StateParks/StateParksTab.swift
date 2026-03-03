import SwiftUI

struct StateParksTab: View {
    let states = DataLoader.loadStatesList()
    
    var body: some View {
        List(states) { state in
            NavigationLink(value: state) {
                HStack {
                    Text(state.name)
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.hikbikPrimary)
                    Spacer()
                    Text(state.parksCount)
                        .font(HikBikFont.caption())
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                .padding(.vertical, HikBikSpacing.xs)
            }
            .listRowBackground(Color.hikbikCard)
            .listRowSeparatorTint(Color.hikbikBorder)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.hikbikBackground)
        .navigationTitle("州公园")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: StateListItem.self) { state in
            StateParksListView(state: state)
        }
    }
}

#Preview {
    NavigationStack { StateParksTab() }
}
