import SwiftUI

// MARK: - 卡片主題色枚舉（等高線、圖標、左側裝飾線共用）
enum CardTheme: String, CaseIterable {
    case pink      // My Favorites
    case orange    // National Parks
    case green     // National Forests
    case purple    // National Grasslands
    case blue      // National Recreation
    case gray      // State Parks & Forests

    var color: Color {
        switch self {
        case .pink:   return Color(red: 0.92, green: 0.35, blue: 0.55)
        case .orange: return Color(red: 0.98, green: 0.45, blue: 0.09)
        case .green:  return Color(red: 0.22, green: 0.78, blue: 0.35)
        case .purple: return Color(red: 0.58, green: 0.40, blue: 0.93)
        case .blue:   return Color(red: 0.23, green: 0.51, blue: 0.96)
        case .gray:   return Color(white: 0.55)
        }
    }
}

/// 帶主題色傾向的深灰底（調亮以便等高線更明顯、更有發光感）
private func cardBackgroundTinted(theme: CardTheme) -> some View {
    ZStack {
        Color(red: 0x48/255, green: 0x48/255, blue: 0x4A/255)
        theme.color.opacity(0.22)
    }
}

// MARK: - 等高線底紋（可指定線條顏色，填滿卡片背景）
struct TopoBackgroundView: View {
    var lineColor: Color = .white

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                ForEach(0..<10, id: \.self) { i in
                    let yBase = h * (CGFloat(i) + 1) / 11
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yBase))
                        for x in stride(from: 0, through: w + 40, by: 5) {
                            let wave = sin(x * 0.025) * 8 + sin(x * 0.06) * 4
                            path.addLine(to: CGPoint(x: x, y: yBase + wave))
                        }
                    }
                    .stroke(lineColor, lineWidth: 0.7)
                }
            }
        }
        .clipped()
    }
}

// MARK: - 縮小版粉色等高線按鈕（65×44，愛心、發光邊框、底紋）
private struct FavoritesMiniButton: View {
    private let pink = CardTheme.pink.color

    var body: some View {
        NavigationLink(value: ExploreDestination.favorites) {
            ZStack {
                cardBackgroundTinted(theme: .pink)
                TopoBackgroundView(lineColor: pink)
                    .opacity(0.45)
                    .blendMode(.screen)
                Image(systemName: "heart.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(pink)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(pink.opacity(0.75), lineWidth: 1)
            )
            .shadow(color: pink.opacity(0.4), radius: 6, x: 0, y: 0)
            .shadow(color: pink.opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct HomeView: View {
    @State private var selectedCountry: Country = .unitedStates

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HeroSection(selectedCountry: $selectedCountry)

                    VStack(spacing: 24) {
                        HStack(alignment: .center, spacing: 0) {
                            Spacer(minLength: 0)
                            HStack(alignment: .center, spacing: 20) {
                                Text("Choose Your Adventure")
                                    .font(.system(size: 25, weight: .semibold))
                                    .foregroundColor(.white)
                                FavoritesMiniButton()
                                    .padding(.leading, 6)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.top, 36)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 20)

                        VStack(spacing: 16) {
                            GeometryReader { geo in
                                let cardWidth = geo.size.width * 0.6
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(AdventureCardData.placeCards) { model in
                                            ThemedAdventureCard(model: model, cardWidth: cardWidth, cardHeight: 145)
                                        }
                                    }
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                                }
                                .frame(height: 145)
                            }
                            .frame(height: 145)
                        }
                        .padding(.horizontal, 0)
                    }
                    .padding(.bottom, 110)
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(Color(red: 0.16, green: 0.28, blue: 0.20))
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

// MARK: - Hero Section
struct HeroSection: View {
    @Binding var selectedCountry: Country
    @State private var showCountryPicker = false

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1639152960846-02c023c8b745")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(height: UIScreen.main.bounds.height * 0.30)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.4),
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            VStack(spacing: 12) {
                Text("Adventure, Simplified")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 3)

                Text("Explore North America's Natural Wonders")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 2)

                Button {
                    showCountryPicker.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Text(selectedCountry.flag)
                            .font(.system(size: 24))
                        Text(selectedCountry.name)
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .rotationEffect(.degrees(showCountryPicker ? 180 : 0))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .animation(.spring(response: 0.3), value: showCountryPicker)
                .padding(.bottom, 24)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.30)
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerSheet(selectedCountry: $selectedCountry)
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - 縱向大卡片（主題色 + 等高線 + 左側色條 + HStack 內容 + 按壓反饋）
struct AdventureCardModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let iconName: String
    let theme: CardTheme
    let destination: ExploreDestination
}

enum AdventureCardData {
    static let allCards: [AdventureCardModel] = [
        AdventureCardModel(title: "My Favorites", subtitle: "12 Places", iconName: "heart.fill", theme: .pink, destination: .favorites),
        AdventureCardModel(title: "National Parks", subtitle: "Iconic landscapes and wildlife", iconName: "mountain.2.fill", theme: .orange, destination: .nationalParks),
        AdventureCardModel(title: "National Forests", subtitle: "Vast wilderness adventures", iconName: "tree.fill", theme: .green, destination: .forests),
        AdventureCardModel(title: "National Grasslands", subtitle: "Open prairie exploration", iconName: "location.circle.fill", theme: .purple, destination: .grasslands),
        AdventureCardModel(title: "National Recreation", subtitle: "Lakes, rivers & outdoor fun", iconName: "tent.fill", theme: .blue, destination: .recreation),
        AdventureCardModel(title: "State Parks & State Forests", subtitle: "3,583+ parks across all 50 states", iconName: "tree.fill", theme: .gray, destination: .stateParks)
    ]
    /// 單獨一塊：My Favorites
    static var favoritesCard: AdventureCardModel { allCards[0] }
    /// 橫向滾動：五個地點分類
    static var placeCards: [AdventureCardModel] { Array(allCards.dropFirst()) }
}

struct ThemedAdventureCard: View {
    let model: AdventureCardModel
    var cardWidth: CGFloat? = nil
    var cardHeight: CGFloat = 96

    var body: some View {
        NavigationLink(value: model.destination) {
            ZStack {
                cardBackgroundTinted(theme: model.theme)
                LinearGradient(
                    colors: [
                        model.theme.color.opacity(0.2),
                        model.theme.color.opacity(0.05),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                TopoBackgroundView(lineColor: model.theme.color)
                    .opacity(0.45)
                    .blendMode(.screen)
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(model.theme.color)
                        .frame(width: 3)
                        .padding(.leading, 0)
                        .padding(.vertical, 18)

                    HStack(spacing: 12) {
                        Image(systemName: model.iconName)
                            .font(.system(size: 21, weight: .medium))
                            .foregroundColor(model.theme.color)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(model.title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text(model.subtitle)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(white: 0.6))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                }
            }
            .frame(width: cardWidth ?? .infinity, height: cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(model.theme.color.opacity(0.75), lineWidth: 1)
            )
            .shadow(color: model.theme.color.opacity(0.4), radius: 8, x: 0, y: 0)
            .shadow(color: model.theme.color.opacity(0.18), radius: 14, x: 0, y: 0)
            .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Country Picker Sheet
struct CountryPickerSheet: View {
    @Binding var selectedCountry: Country
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ForEach([Country.unitedStates, Country.canada], id: \.self) { country in
                Button {
                    selectedCountry = country
                    dismiss()
                } label: {
                    HStack(spacing: 16) {
                        Text(country.flag)
                            .font(.system(size: 32))
                        Text(country.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)

                        Spacer()

                        if selectedCountry == country {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(selectedCountry == country ? Color.green.opacity(0.1) : Color.clear)
                }

                if country != .canada {
                    Divider()
                }
            }
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - Custom Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Data Models
struct CategoryItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let gradientColors: [Color]
    let destination: ExploreDestination
}

struct CategoryData {
    static let categories = [
        CategoryItem(
            title: "National Parks",
            description: "Iconic landscapes and wildlife",
            iconName: "mountain.2.fill",
            gradientColors: [
                Color(red: 0.98, green: 0.45, blue: 0.09),
                Color(red: 0.76, green: 0.25, blue: 0.05)
            ],
            destination: .nationalParks
        ),
        CategoryItem(
            title: "National Forests",
            description: "Vast wilderness adventures",
            iconName: "tree.fill",
            gradientColors: [
                Color(red: 0.09, green: 0.64, blue: 0.29),
                Color(red: 0.09, green: 0.40, blue: 0.20)
            ],
            destination: .forests
        ),
        CategoryItem(
            title: "National Grasslands",
            description: "Open prairie exploration",
            iconName: "location.circle.fill",
            gradientColors: [
                Color(red: 0.96, green: 0.62, blue: 0.04),
                Color(red: 0.71, green: 0.33, blue: 0.04)
            ],
            destination: .grasslands
        ),
        CategoryItem(
            title: "National Recreation",
            description: "Lakes, rivers & outdoor fun",
            iconName: "tent.fill",
            gradientColors: [
                Color(red: 0.23, green: 0.51, blue: 0.96),
                Color(red: 0.11, green: 0.31, blue: 0.85)
            ],
            destination: .recreation
        )
    ]
}

enum ExploreDestination: Hashable {
    case stateParks
    case nationalParks
    case forests
    case grasslands
    case recreation
    case favorites
}

enum Country: String {
    case unitedStates = "United States"
    case canada = "Canada"

    var flag: String {
        switch self {
        case .unitedStates: return "🇺🇸"
        case .canada: return "🇨🇦"
        }
    }

    var name: String { rawValue }
}

#Preview { HomeView() }
