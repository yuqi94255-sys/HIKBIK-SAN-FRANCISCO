import SwiftUI
import MapKit

struct ForestDetailView: View {
    let forest: NationalForest
    @Environment(\.dismiss) private var dismiss

    private var forestThemeColor: Color { Color(red: 0.2, green: 0.6, blue: 0.3) }
    @State private var showDetailSheet = true
    @State private var selectedDetent: PresentationDetent = .fraction(0.6)

    private var coordinate: CLLocationCoordinate2D? {
        forest.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
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
                    themeColor: forestThemeColor,
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
            ForestDetailSheetContent(forest: forest, themeColor: forestThemeColor)
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
                    .foregroundStyle(forestThemeColor)
                    .padding(.horizontal, HikBikSpacing.md)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                }
            }
        }
    }
}

private struct ForestSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let outerHorizontalPadding: CGFloat
    @ViewBuilder let content: Content
    
    init(title: String, icon: String, outerHorizontalPadding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.outerHorizontalPadding = outerHorizontalPadding
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
            Label(title, systemImage: icon)
                .font(HikBikFont.headline())
                .foregroundStyle(Color.hikbikPrimary)
            content
        }
        .padding(HikBikSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
        .padding(.horizontal, outerHorizontalPadding)
    }
}

private struct ForestStatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String?
    let labelWidth: CGFloat
    
    var body: some View {
        GeometryReader { proxy in
            let dynamicLabelWidth = min(labelWidth, proxy.size.width * 0.42)
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: icon)
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(Color.hikbikTabActive)
                        Text(title)
                            .font(.caption)
                            .foregroundStyle(Color.hikbikMutedForeground)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .frame(width: dynamicLabelWidth, alignment: .trailing)

                    Text(value)
                        .font(HikBikFont.headline())
                        .foregroundStyle(Color.hikbikPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(Color.hikbikMutedForeground)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
            }
        }
        .padding(HikBikSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
    }
}

private struct FacilityStatPill: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .font(.callout.weight(.semibold))
                .foregroundStyle(Color.hikbikTabActive)
            Text(title)
                .font(.caption2)
                .foregroundStyle(Color.hikbikMutedForeground)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            Text(value)
                .font(HikBikFont.headline())
                .foregroundStyle(Color.hikbikPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(Color.hikbikMutedForeground)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .padding(HikBikSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.lg).stroke(Color.hikbikBorder, lineWidth: 1))
    }
}

struct ForestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForestDetailView(forest: longTextForest)
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("SE - Small")
            ForestDetailView(forest: longTextForest)
                .previewDevice("iPhone 15 Pro")
                .previewDisplayName("Pro - Standard")
            ForestDetailView(forest: longTextForest)
                .previewDevice("iPhone 15 Pro Max")
                .previewDisplayName("Pro Max - Large")
        }
    }

    private static let longTextForest = NationalForest(
        id: "test",
        name: "Very Long National Forest Name That May Be Truncated in the UI",
        state: "California",
        states: nil,
        region: "Pacific Southwest Region with extra long text",
        description: String(repeating: "Long description to test layout and truncation. ", count: 5),
        established: "1908",
        acres: 123456789,
        visitors: "1.2M annually",
        highlights: ["Long highlight example 1", "Long highlight example 2"],
        activities: ["Hiking", "Camping", "Fishing", "Birding", "Mountain Biking", "Wildlife", "Stargazing", "Botany"],
        bestTime: ["Spring", "Summer"],
        coordinates: nil,
        websiteUrl: "https://www.fs.usda.gov",
        phone: "123-456-7890",
        address: "123 Test Road",
        campgrounds: 12,
        trailMiles: 120,
        peakElevation: 12000,
        terrain: ["Mountains", "Lakes"],
        difficulty: "Moderate",
        crowdLevel: "Low",
        nearestCity: "Test City",
        photos: ["https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"]
    )
}
