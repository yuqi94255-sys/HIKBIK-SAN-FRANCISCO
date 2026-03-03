import SwiftUI
import MapKit

struct GrasslandDetailView: View {
    let grassland: NationalGrassland
    @Environment(\.dismiss) private var dismiss

    private var grasslandThemeColor: Color { Color(red: 0.55, green: 0.45, blue: 0.2) }
    @State private var showDetailSheet = true
    @State private var selectedDetent: PresentationDetent = .fraction(0.6)

    private var coordinate: CLLocationCoordinate2D? {
        grassland.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
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
                    themeColor: grasslandThemeColor,
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
            GrasslandDetailSheetContent(grassland: grassland, themeColor: grasslandThemeColor)
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
                    .foregroundStyle(grasslandThemeColor)
                    .padding(.horizontal, HikBikSpacing.md)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                }
            }
        }
    }
}
