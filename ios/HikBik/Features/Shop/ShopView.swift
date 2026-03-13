// 与 Figma Shop 设计一致 + Deep Space Blue 主题
import SwiftUI

// MARK: - Shop Deep Space 主题
private enum ShopTheme {
    static let background = Color.deepSpaceBackground
    static let cardNavy = Color.deepSpaceCard
    static let neonGreen = Color.shopNeonGreen
    static let rentOrange = Color.shopRentOrange
    static let textPrimary = Color.white
    static let textMuted = Color.white.opacity(0.75)
    /// 标题冷色蓝白光晕
    static let titleGlow = Color.white.opacity(0.3)
}

struct ShopView: View {
    @EnvironmentObject var cartStore: CartStore
    @State private var selectedPath: ShopPath? = nil
    @State private var selectedRentalMethod: RentalMethod? = nil
    @State private var selectedCategory: GearCategory? = nil
    @State private var showStoresView = false
    @State private var showCart = false
    
    private let categoryColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    headerSection
                    
                    Rectangle()
                        .fill(ShopTheme.textPrimary.opacity(0.15))
                        .frame(height: 1)
                        .padding(.vertical, 24)
                    
                    // Choose your path
                    choosePathSection
                    
                    // Rental method (显示当选择 Rent 时)
                    if selectedPath == .rent {
                        rentalMethodSection
                            .padding(.top, 32)
                        
                        // 选择 Online rental 后显示 Browse categories
                        if selectedRentalMethod == .online {
                            browseCategoriesSection
                                .padding(.top, 32)
                        }
                    }
                    
                    // Browse categories (显示当选择 Buy 时)
                    if selectedPath == .buy {
                        browseCategoriesSection
                            .padding(.top, 32)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .background(
                ZStack {
                    ShopTheme.background
                    TopoBackgroundView(lineColor: .white)
                        .opacity(0.05)
                }
                .ignoresSafeArea()
            )
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showStoresView) {
                StoresView()
            }
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("HIKBIK Shop")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(ShopTheme.textPrimary)
                    .shadow(color: ShopTheme.titleGlow, radius: 12, x: 0, y: 0)
                    .shadow(color: ShopTheme.titleGlow, radius: 24, x: 0, y: 0)
                
                Text("Outdoor gear rental & shop")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(ShopTheme.textMuted)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                NavigationLink(destination: OrdersView()) {
                    Image(systemName: "shippingbox")
                        .font(.system(size: 24))
                        .foregroundStyle(ShopTheme.textPrimary)
                }
                .buttonStyle(.plain)
                Button(action: { showCart = true }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(ShopTheme.textPrimary)
                        if cartStore.itemCount > 0 {
                            Text("\(cartStore.itemCount)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(ShopTheme.background)
                                .frame(minWidth: 18, minHeight: 18)
                                .background(ShopTheme.neonGreen)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(ShopTheme.background, lineWidth: 2)
                                )
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showCart) {
            CartPlaceholderView()
        }
    }
    
    private var choosePathSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose your path")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(ShopTheme.textPrimary)
            
            Text("How would you like to get your gear?")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(ShopTheme.textMuted)
            
            // Path Options
            HStack(spacing: 16) {
                ShopPathCard(
                    path: .rent,
                    isSelected: selectedPath == .rent,
                    onTap: { 
                        selectedPath = .rent
                        selectedRentalMethod = nil
                    }
                )
                
                ShopPathCard(
                    path: .buy,
                    isSelected: selectedPath == .buy,
                    onTap: { 
                        selectedPath = .buy
                        selectedRentalMethod = nil
                    }
                )
            }
            .padding(.top, 8)
        }
    }
    
    private var rentalMethodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rental method")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(ShopTheme.textPrimary)
            
            Text("Choose how you'd like to rent")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(ShopTheme.textMuted)
            
            VStack(spacing: 12) {
                RentalMethodCard(
                    method: .online,
                    isSelected: selectedRentalMethod == .online,
                    onTap: { selectedRentalMethod = .online }
                )
                
                RentalMethodCard(
                    method: .store,
                    isSelected: selectedRentalMethod == .store,
                    onTap: { 
                        selectedRentalMethod = .store
                        showStoresView = true
                    }
                )
            }
            .padding(.top, 8)
        }
    }
    
    private var browseCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Browse categories")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(ShopTheme.textPrimary)
            
            Text("Explore our collection")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(ShopTheme.textMuted)
            
            LazyVGrid(columns: categoryColumns, spacing: 16) {
                ForEach(GearCategory.allCases, id: \.self) { category in
                    NavigationLink(destination: CategoryProductsView(category: category, isRental: selectedPath == .rent)) {
                        ShopCategoryCardContent(
                            category: category,
                            isSelected: selectedCategory == category
                        )
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        selectedCategory = category
                    })
                }
            }
            .padding(.top, 8)
        }
    }
}

enum ShopPath: String, CaseIterable {
    case rent
    case buy
    
    var title: String {
        switch self {
        case .rent: return "Rent"
        case .buy: return "Buy"
        }
    }
    
    var subtitle: String {
        switch self {
        case .rent: return "Flexible rental options"
        case .buy: return "Own it forever"
        }
    }
    
    var icon: String {
        switch self {
        case .rent: return "shippingbox.fill"
        case .buy: return "cart.fill"
        }
    }
}

enum RentalMethod: String, CaseIterable {
    case online
    case store
    
    var title: String {
        switch self {
        case .online: return "Online rental"
        case .store: return "Find a store"
        }
    }
    
    var subtitle: String {
        switch self {
        case .online: return "Browse our full catalog and have gear delivered to your door"
        case .store: return "Visit one of our locations and talk to our experts in person"
        }
    }
    
    var icon: String {
        switch self {
        case .online: return "globe"
        case .store: return "building.2.fill"
        }
    }
}

enum GearCategory: String, CaseIterable {
    case all
    case camping
    case hiking
    case climbing
    case skiing
    case waterSports
    case cooking
    
    var title: String {
        switch self {
        case .all: return "All Products"
        case .camping: return "Camping"
        case .hiking: return "Hiking"
        case .climbing: return "Climbing"
        case .skiing: return "Skiing"
        case .waterSports: return "Water Sports"
        case .cooking: return "Cooking"
        }
    }
    
    var emoji: String {
        switch self {
        case .all: return "🛒"
        case .camping: return "⛺️"
        case .hiking: return "🥾"
        case .climbing: return "🧗"
        case .skiing: return "⛷️"
        case .waterSports: return "🏄"
        case .cooking: return "🍳"
        }
    }
}

private struct ShopPathCard: View {
    let path: ShopPath
    let isSelected: Bool
    let onTap: () -> Void

    private var borderGradient: LinearGradient {
        switch path {
        case .rent:
            return LinearGradient(
                colors: [ShopTheme.rentOrange, Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .buy:
            return LinearGradient(
                colors: [ShopTheme.neonGreen, Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: path.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(ShopTheme.textPrimary)

                Text(path.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(ShopTheme.textPrimary)

                Text(path.subtitle)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(ShopTheme.textMuted)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ShopTheme.cardNavy.opacity(0.82))
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(borderGradient, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct RentalMethodCard: View {
    let method: RentalMethod
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: method.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(ShopTheme.textPrimary)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(method.title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(ShopTheme.textPrimary)

                    Text(method.subtitle)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(ShopTheme.textMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ShopTheme.cardNavy.opacity(0.82))
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ShopTheme.neonGreen.opacity(isSelected ? 0.8 : 0.2), lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct ShopCategoryCardContent: View {
    let category: GearCategory
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category.emoji)
                .font(.system(size: 40))

            Text(category.title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(ShopTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(ShopTheme.cardNavy.opacity(0.82))
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? ShopTheme.neonGreen : Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
    }
}

// MARK: - Stores View

struct StoresView: View {
    @Environment(\.dismiss) private var dismiss
    
    static let allStores: [HikBikStore] = [
        HikBikStore(
            id: "1",
            name: "HIKBIK Fresno",
            distance: "0.5 mi away",
            address: "1234 Shaw Avenue, Fresno, CA 93711",
            rating: 4.8,
            reviewCount: 324,
            hours: "Mon-Fri: 9AM-8PM, Sat-Sun: 10AM-6PM",
            phone: "+1 (559) 555-1234",
            imageUrl: "https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800",
            latitude: 36.7378,
            longitude: -119.7871
        ),
        HikBikStore(
            id: "2",
            name: "HIKBIK San Francisco",
            distance: "1.2 mi away",
            address: "789 Market Street, San Francisco, CA 94103",
            rating: 4.6,
            reviewCount: 512,
            hours: "Mon-Fri: 8AM-9PM, Sat-Sun: 9AM-7PM",
            phone: "+1 (415) 555-5678",
            imageUrl: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800",
            latitude: 37.7749,
            longitude: -122.4194
        ),
        HikBikStore(
            id: "3",
            name: "HIKBIK Seattle",
            distance: "4.2 mi away",
            address: "1500 Pike Place, Seattle, WA 98101",
            rating: 4.9,
            reviewCount: 287,
            hours: "Mon-Fri: 9AM-8PM, Sat-Sun: 10AM-6PM",
            phone: "+1 (206) 555-9012",
            imageUrl: "https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=800",
            latitude: 47.6097,
            longitude: -122.3421
        ),
        HikBikStore(
            id: "4",
            name: "HIKBIK Los Angeles",
            distance: "8.5 mi away",
            address: "456 Hollywood Blvd, Los Angeles, CA 90028",
            rating: 4.7,
            reviewCount: 445,
            hours: "Mon-Fri: 9AM-9PM, Sat-Sun: 10AM-8PM",
            phone: "+1 (323) 555-3456",
            imageUrl: "https://images.unsplash.com/photo-1534430480872-3498386e7856?w=800",
            latitude: 34.0522,
            longitude: -118.2437
        ),
        HikBikStore(
            id: "5",
            name: "HIKBIK Denver",
            distance: "12.3 mi away",
            address: "321 16th Street Mall, Denver, CO 80202",
            rating: 4.5,
            reviewCount: 198,
            hours: "Mon-Fri: 9AM-7PM, Sat-Sun: 10AM-5PM",
            phone: "+1 (303) 555-7890",
            imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
            latitude: 39.7392,
            longitude: -104.9903
        )
    ]
    
    private var stores: [HikBikStore] { Self.allStores }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Our Stores")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    
                    Text("Find a location near you and visit our experts.")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                
                Divider()
                
                // Store Cards
                ForEach(Array(stores.enumerated()), id: \.element.id) { index, store in
                    StoreCard(store: store, index: index + 1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color.hikbikBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                }
            }
        }
    }
}

struct HikBikStore: Identifiable, Hashable {
    let id: String
    let name: String
    let distance: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let hours: String
    let phone: String
    let imageUrl: String
    let latitude: Double
    let longitude: Double
}

private struct StoreCard: View {
    let store: HikBikStore
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image with overlays
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: store.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.hikbikMuted
                    case .empty:
                        Color.hikbikMuted
                            .overlay(ProgressView())
                    @unknown default:
                        Color.hikbikMuted
                    }
                }
                .frame(height: 180)
                .clipped()
                
                // Index badge
                Text("\(index)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.hikbikPrimary)
                    .clipShape(Circle())
                    .padding(12)
                
                // Rating badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", store.rating))
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.hikbikCard)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(12)
            }
            
            // Store info
            VStack(alignment: .leading, spacing: 8) {
                Text(store.name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                
                Text(store.distance)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikMutedForeground)
                
                HStack(alignment: .top, spacing: 8) {
                    Text("📍")
                        .font(.system(size: 14))
                    Text(store.address)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    // Directions - opens Apple Maps
                    Button(action: { openDirections() }) {
                        Text("Directions")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    // Call
                    Button(action: { callStore() }) {
                        Text("Call")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    // Rent - navigates to store detail
                    NavigationLink(destination: StoreDetailView(store: store)) {
                        Text("Rent")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.hikbikPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .background(Color.hikbikCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.hikbikBorder, lineWidth: 1)
        )
    }
    
    private func openDirections() {
        let urlString = "http://maps.apple.com/?daddr=\(store.latitude),\(store.longitude)&dirflg=d"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func callStore() {
        let phoneNumber = store.phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Store Detail View

struct StoreDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let store: HikBikStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header with name and rating
                HStack(alignment: .top) {
                    Text(store.name)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    
                    Spacer()
                    
                    // Rating badge
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", store.rating))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        Text("(\(store.reviewCount))")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.hikbikCard)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.hikbikBorder, lineWidth: 1)
                    )
                }
                
                // Store info
                VStack(alignment: .leading, spacing: 12) {
                    // Address
                    HStack(alignment: .top, spacing: 12) {
                        Text("📍")
                            .font(.system(size: 16))
                        Text(store.address)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                    
                    // Hours
                    HStack(alignment: .top, spacing: 12) {
                        Text("🕐")
                            .font(.system(size: 16))
                        Text(store.hours)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                    
                    // Phone
                    HStack(alignment: .top, spacing: 12) {
                        Text("📞")
                            .font(.system(size: 16))
                        Text(store.phone)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                }
                .padding(.top, 20)
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: { openDirections() }) {
                        Text("Get directions")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { callStore() }) {
                        Text("Call store")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 20)
                
                Divider()
                    .padding(.vertical, 24)
                
                // Available products section
                VStack(alignment: .leading, spacing: 24) {
                    Text("Available products")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    
                    // Empty state
                    VStack(spacing: 16) {
                        Text("📦")
                            .font(.system(size: 48))
                        
                        Text("No products available at this store")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color.hikbikBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                        Text("Back to stores")
                    }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                }
            }
        }
    }
    
    private func openDirections() {
        let urlString = "http://maps.apple.com/?daddr=\(store.latitude),\(store.longitude)&dirflg=d"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func callStore() {
        let phoneNumber = store.phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Category Products View

struct GearProduct: Identifiable {
    let id: String
    let name: String
    let brand: String
    let description: String
    let price: Int
    /// 租賃日租金（美元/天）
    let rentalPricePerDay: Int
    let imageUrl: String
    let category: GearCategory
}

// MARK: - Cart

struct RentalCartItem: Identifiable {
    let id: UUID
    let product: GearProduct
    let startDate: Date
    let rentalDays: Int
    let quantity: Int
    
    var total: Int {
        product.rentalPricePerDay * rentalDays * quantity
    }
    
    init(id: UUID = UUID(), product: GearProduct, startDate: Date, rentalDays: Int, quantity: Int) {
        self.id = id
        self.product = product
        self.startDate = startDate
        self.rentalDays = rentalDays
        self.quantity = quantity
    }
}

struct PurchaseCartItem: Identifiable {
    let id: UUID
    let product: GearProduct
    let quantity: Int
    
    var total: Int {
        product.price * quantity
    }
    
    init(id: UUID = UUID(), product: GearProduct, quantity: Int) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }
}

final class CartStore: ObservableObject {
    @Published private(set) var items: [RentalCartItem] = []
    @Published private(set) var purchaseItems: [PurchaseCartItem] = []
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity } + purchaseItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Int {
        items.reduce(0) { $0 + $1.total } + purchaseItems.reduce(0) { $0 + $1.total }
    }
    
    var rentalTotalPrice: Int {
        items.reduce(0) { $0 + $1.total }
    }
    
    var purchaseTotalPrice: Int {
        purchaseItems.reduce(0) { $0 + $1.total }
    }
    
    func addItem(product: GearProduct, startDate: Date, rentalDays: Int, quantity: Int) {
        items.append(RentalCartItem(product: product, startDate: startDate, rentalDays: rentalDays, quantity: quantity))
    }
    
    func addPurchaseItem(product: GearProduct, quantity: Int) {
        purchaseItems.append(PurchaseCartItem(product: product, quantity: quantity))
    }
    
    func removeItem(at indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func removePurchaseItem(at indexSet: IndexSet) {
        purchaseItems.remove(atOffsets: indexSet)
    }
    
    func removeAll() {
        items.removeAll()
        purchaseItems.removeAll()
    }
    
    func removeAllRentals() {
        items.removeAll()
    }
    
    func removeAllPurchases() {
        purchaseItems.removeAll()
    }
}

struct CategoryProductsView: View {
    @Environment(\.dismiss) private var dismiss
    let category: GearCategory
    var isRental: Bool = false
    
    private var products: [GearProduct] {
        if category == .all {
            return Self.allProducts
        }
        return Self.allProducts.filter { $0.category == category }
    }
    
    static let allProducts: [GearProduct] = [
        // Camping (price, rentalPricePerDay)
        GearProduct(id: "c1", name: "4-Person Family Tent", brand: "Coleman", description: "Waterproof & breathable, quick setup design", price: 3500, rentalPricePerDay: 45, imageUrl: "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=400", category: .camping),
        GearProduct(id: "c2", name: "Hexagonal Tarp Shelter", brand: "Snow Peak", description: "Large coverage area for sun and rain protection", price: 3200, rentalPricePerDay: 38, imageUrl: "https://images.unsplash.com/photo-1478827536114-da961b7f86d2?w=400", category: .camping),
        GearProduct(id: "c3", name: "Down Sleeping Bag -10°C", brand: "Marmot", description: "800-fill down, ultimate warmth for cold weather", price: 2800, rentalPricePerDay: 35, imageUrl: "https://images.unsplash.com/photo-1510672981848-a1c4f1cb5ccf?w=400", category: .camping),
        
        // Hiking
        GearProduct(id: "h1", name: "65L Hiking Backpack", brand: "Osprey", description: "Professional hiking pack with ergonomic design", price: 2200, rentalPricePerDay: 28, imageUrl: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400", category: .hiking),
        GearProduct(id: "h2", name: "Trail Running Shoes", brand: "Salomon", description: "Lightweight trail shoes with excellent grip", price: 1800, rentalPricePerDay: 22, imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400", category: .hiking),
        GearProduct(id: "h3", name: "Trekking Poles (Pair)", brand: "Black Diamond", description: "Adjustable aluminum poles for all terrains", price: 850, rentalPricePerDay: 12, imageUrl: "https://images.unsplash.com/photo-1551632811-561732d1e306?w=400", category: .hiking),
        
        // Climbing
        GearProduct(id: "cl1", name: "Dynamic Climbing Rope 60m", brand: "Petzl", description: "UIAA certified, 9.8mm diameter, perfect for sport climbing", price: 2400, rentalPricePerDay: 35, imageUrl: "https://images.unsplash.com/photo-1522163182402-834f871fd851?w=400", category: .climbing),
        GearProduct(id: "cl2", name: "Sport Climbing Harness", brand: "Black Diamond", description: "Lightweight harness with 4 gear loops", price: 950, rentalPricePerDay: 18, imageUrl: "https://images.unsplash.com/photo-1564769662533-4f00a87b4056?w=400", category: .climbing),
        GearProduct(id: "cl3", name: "Aggressive Climbing Shoes", brand: "La Sportiva", description: "Downturned shoes for advanced climbing", price: 1650, rentalPricePerDay: 25, imageUrl: "https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400", category: .climbing),
        
        // Skiing
        GearProduct(id: "s1", name: "All-Mountain Skis Package", brand: "Rossignol", description: "Skis + Bindings + Poles, perfect for all conditions", price: 6500, rentalPricePerDay: 85, imageUrl: "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400", category: .skiing),
        GearProduct(id: "s2", name: "Ski Boots", brand: "Salomon", description: "Comfortable boots with flex 90", price: 3200, rentalPricePerDay: 45, imageUrl: "https://images.unsplash.com/photo-1605540436563-5bca919ae766?w=400", category: .skiing),
        GearProduct(id: "s3", name: "Ski Goggles", brand: "Oakley", description: "Anti-fog lens with UV protection", price: 1800, rentalPricePerDay: 22, imageUrl: "https://images.unsplash.com/photo-1579912437766-7896df6d3cd3?w=400", category: .skiing),
        
        // Water Sports
        GearProduct(id: "w1", name: "Stand-Up Paddleboard", brand: "Red Paddle Co", description: "Inflatable SUP with paddle and pump", price: 5800, rentalPricePerDay: 72, imageUrl: "https://images.unsplash.com/photo-1526188717906-ab4a2f949f47?w=400", category: .waterSports),
        GearProduct(id: "w2", name: "Touring Kayak", brand: "Perception", description: "Single person kayak with paddle", price: 7200, rentalPricePerDay: 90, imageUrl: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400", category: .waterSports),
        GearProduct(id: "w3", name: "3mm Wetsuit", brand: "O'Neill", description: "Full body wetsuit for cold water", price: 2500, rentalPricePerDay: 32, imageUrl: "https://images.unsplash.com/photo-1530549387789-4c1017266635?w=400", category: .waterSports),
        
        // Cooking
        GearProduct(id: "co1", name: "Dual Burner Gas Stove", brand: "Coleman", description: "Stable flame, perfect for group camping", price: 1280, rentalPricePerDay: 18, imageUrl: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400", category: .cooking),
        GearProduct(id: "co2", name: "Outdoor Cookware Set", brand: "GSI", description: "Complete set with pots, pans, and utensils", price: 980, rentalPricePerDay: 14, imageUrl: "https://images.unsplash.com/photo-1585442245892-60a2c8f11ff4?w=400", category: .cooking),
        GearProduct(id: "co3", name: "50L Hard Cooler", brand: "YETI", description: "Ice retention up to 5 days", price: 3500, rentalPricePerDay: 42, imageUrl: "https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?w=400", category: .cooking)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.title)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    
                    HStack(spacing: 8) {
                        Text("\(products.count) items")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                        Text("•")
                            .foregroundStyle(Color.hikbikMutedForeground)
                        Text(isRental ? "Available for rental" : "Available for purchase")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                }
                
                Divider()
                    .padding(.vertical, 20)
                
                // Product list
                VStack(spacing: 0) {
                    ForEach(products) { product in
                        if isRental {
                            NavigationLink(destination: RentalProductDetailView(product: product)) {
                                ProductCard(product: product, isRental: true)
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink(destination: BuyProductDetailView(product: product)) {
                                ProductCard(product: product, isRental: false)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if product.id != products.last?.id {
                            Divider()
                                .padding(.vertical, 20)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color.hikbikBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                        Text("Back to categories")
                    }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                }
            }
        }
    }
}

private struct ProductCard: View {
    let product: GearProduct
    var isRental: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Product image
            AsyncImage(url: URL(string: product.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.hikbikMuted
                case .empty:
                    Color.hikbikMuted
                        .overlay(ProgressView())
                @unknown default:
                    Color.hikbikMuted
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Product info
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(product.brand)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikMutedForeground)
                
                Text(product.description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikMutedForeground)
                    .lineLimit(2)
                
                Text(isRental ? "$\(product.rentalPricePerDay)/day" : "$\(product.price)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                    .padding(.top, 4)
            }
            
            Spacer()
        }
    }
}

// MARK: - Rental Product Detail View

struct RentalProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartStore: CartStore
    let product: GearProduct
    
    @State private var startDate = Date()
    @State private var rentalDays = 1
    @State private var quantity = 1
    
    private var totalPrice: Int {
        product.rentalPricePerDay * rentalDays * quantity
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Product image
                AsyncImage(url: URL(string: product.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.hikbikMuted
                    case .empty:
                        Color.hikbikMuted
                            .overlay(ProgressView())
                    @unknown default:
                        Color.hikbikMuted
                    }
                }
                .frame(height: 260)
                .frame(maxWidth: .infinity)
                .clipped()
                
                // Brand, name, description
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.brand)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                    
                    Text(product.name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    
                    Text(product.description)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                
                // Rental options card
                VStack(alignment: .leading, spacing: 16) {
                    // Start Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start Date")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    
                    Divider()
                    
                    // Rental Duration
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rental Duration")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        HStack(spacing: 16) {
                            Button(action: { if rentalDays > 1 { rentalDays -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.hikbikMutedForeground)
                            }
                            .buttonStyle(.plain)
                            
                            VStack(spacing: 2) {
                                Text("\(rentalDays)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.hikbikPrimary)
                                Text("days")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundStyle(Color.hikbikMutedForeground)
                            }
                            .frame(minWidth: 60)
                            
                            Button(action: { rentalDays += 1 }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.hikbikMutedForeground)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Divider()
                    
                    // Daily Rate summary
                    HStack {
                        Text("Daily Rate")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                        Spacer()
                        Text("$\(product.rentalPricePerDay)/day")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                    HStack {
                        Text("Duration")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikMutedForeground)
                        Spacer()
                        Text("\(rentalDays) days")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                }
                .padding(20)
                .background(Color.hikbikCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.hikbikBorder, lineWidth: 1)
                )
                
                // Quantity
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quantity")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    HStack(spacing: 16) {
                        Button(action: { if quantity > 1 { quantity -= 1 } }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.hikbikMutedForeground)
                        }
                        .buttonStyle(.plain)
                        
                        Text("\(quantity)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(minWidth: 40)
                        
                        Button(action: { quantity += 1 }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.hikbikMutedForeground)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Total card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Total")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        Spacer()
                        Text("$\(totalPrice)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                    Text("$\(product.rentalPricePerDay)/day × \(rentalDays) days × \(quantity) item")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                .padding(20)
                .background(Color.hikbikCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.hikbikBorder, lineWidth: 1)
                )
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: { /* Rent - to be wired */ }) {
                        Text("Rent")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.hikbikPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        cartStore.addItem(product: product, startDate: startDate, rentalDays: rentalDays, quantity: quantity)
                        dismiss()
                    }) {
                        Text("Add to Cart")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.hikbikCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color.hikbikBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                }
            }
        }
    }
}

// MARK: - Buy Product Detail View

struct BuyProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartStore: CartStore
    let product: GearProduct
    
    @State private var quantity = 1
    
    private var totalPrice: Int {
        product.price * quantity
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Product image
                AsyncImage(url: URL(string: product.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.hikbikMuted
                    case .empty:
                        Color.hikbikMuted
                            .overlay(ProgressView())
                    @unknown default:
                        Color.hikbikMuted
                    }
                }
                .frame(height: 260)
                .frame(maxWidth: .infinity)
                .clipped()
                
                // Brand, name, description
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.brand)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                    
                    Text(product.name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    
                    Text(product.description)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                
                // Quantity
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quantity")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    HStack(spacing: 16) {
                        Button(action: { if quantity > 1 { quantity -= 1 } }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.hikbikMutedForeground)
                        }
                        .buttonStyle(.plain)
                        
                        Text("\(quantity)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(minWidth: 40)
                        
                        Button(action: { quantity += 1 }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.hikbikMutedForeground)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Total
                HStack {
                    Text("Total")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    Spacer()
                    Text("$\(totalPrice)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                }
                .padding(20)
                .background(Color.hikbikCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.hikbikBorder, lineWidth: 1)
                )
                
                // Add to Cart
                Button(action: {
                    cartStore.addPurchaseItem(product: product, quantity: quantity)
                    dismiss()
                }) {
                    Text("Add to Cart")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.hikbikPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color.hikbikBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                }
            }
        }
    }
}

// MARK: - Shopping Cart

enum CartTab: String, CaseIterable {
    case rent
    case buy
}

struct CartPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartStore: CartStore
    @State private var selectedTab: CartTab = .rent
    @State private var showCheckoutRent = false
    @State private var showCheckoutBuy = false
    
    private var totalItemCount: Int {
        cartStore.itemCount
    }
    
    private var rentCount: Int {
        cartStore.items.reduce(0) { $0 + $1.quantity }
    }
    
    private var buyCount: Int {
        cartStore.purchaseItems.reduce(0) { $0 + $1.quantity }
    }
    
    private var isEmpty: Bool {
        cartStore.items.isEmpty && cartStore.purchaseItems.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Shopping Cart")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hikbikPrimary)
                    Text("\(totalItemCount) item\(totalItemCount == 1 ? "" : "s")")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Rent | Buy tabs
                HStack(spacing: 12) {
                    Button(action: { selectedTab = .rent }) {
                        Text("Rent (\(rentCount))")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(selectedTab == .rent ? .white : Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(selectedTab == .rent ? Color.hikbikPrimary : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.hikbikBorder, lineWidth: selectedTab == .rent ? 0 : 1)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { selectedTab = .buy }) {
                        Text("Buy (\(buyCount))")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(selectedTab == .buy ? .white : Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(selectedTab == .buy ? Color.hikbikPrimary : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.hikbikBorder, lineWidth: selectedTab == .buy ? 0 : 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Content
                Group {
                    if selectedTab == .rent {
                        rentContent
                    } else {
                        buyContent
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Checkout button（Rent 與 Buy 分開結帳）
                if selectedTab == .rent && rentCount > 0 {
                    Button(action: { showCheckoutRent = true }) {
                        Text("Checkout - $\(cartStore.rentalTotalPrice)")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.hikbikCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                } else if selectedTab == .buy && buyCount > 0 {
                    Button(action: { showCheckoutBuy = true }) {
                        Text("Checkout - $\(cartStore.purchaseTotalPrice)")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.hikbikCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.hikbikBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                }
            }
            .sheet(isPresented: $showCheckoutRent) {
                CheckoutView(mode: .rent)
                    .environmentObject(cartStore)
            }
            .sheet(isPresented: $showCheckoutBuy) {
                CheckoutView(mode: .buy)
                    .environmentObject(cartStore)
            }
        }
    }
    
    private var rentContent: some View {
        Group {
            if cartStore.items.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.hikbikMutedForeground)
                    Text("No rental items in cart")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(cartStore.items) { item in
                        CartRentalRow(item: item)
                    }
                    .onDelete(perform: cartStore.removeItem)
                }
                .listStyle(.plain)
            }
        }
    }
    
    private var buyContent: some View {
        Group {
            if cartStore.purchaseItems.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.hikbikMutedForeground)
                    Text("No purchase items in cart")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.hikbikMutedForeground)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(cartStore.purchaseItems) { item in
                        CartPurchaseRow(item: item)
                    }
                    .onDelete(perform: cartStore.removePurchaseItem)
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Checkout View

enum CheckoutMode {
    case rent
    case buy
}

enum PaymentMethod: String, CaseIterable {
    case creditCard
    case applePay
    case payPal
}

enum CheckoutCountry: String, CaseIterable {
    case unitedStates = "United States"
    case canada = "Canada"
}

/// 電話國碼選項（顯示用）
private let phoneCountryCodes: [(code: String, label: String)] = [
    ("+1", "US/CA"),
    ("+44", "UK"),
    ("+86", "China"),
    ("+81", "Japan"),
    ("+82", "Korea"),
    ("+61", "Australia"),
    ("+33", "France"),
    ("+49", "Germany"),
    ("+39", "Italy"),
    ("+34", "Spain"),
    ("+55", "Brazil"),
    ("+91", "India"),
    ("+52", "Mexico"),
    ("+7", "Russia"),
    ("+31", "Netherlands"),
    ("+41", "Switzerland"),
    ("+46", "Sweden"),
    ("+47", "Norway"),
    ("+48", "Poland"),
    ("+353", "Ireland"),
]

/// 美國 50 州 + DC（縮寫 + 全名）
private let usStates: [(abbr: String, name: String)] = [
    ("AL", "Alabama"), ("AK", "Alaska"), ("AZ", "Arizona"), ("AR", "Arkansas"),
    ("CA", "California"), ("CO", "Colorado"), ("CT", "Connecticut"), ("DE", "Delaware"),
    ("FL", "Florida"), ("GA", "Georgia"), ("HI", "Hawaii"), ("ID", "Idaho"),
    ("IL", "Illinois"), ("IN", "Indiana"), ("IA", "Iowa"), ("KS", "Kansas"),
    ("KY", "Kentucky"), ("LA", "Louisiana"), ("ME", "Maine"), ("MD", "Maryland"),
    ("MA", "Massachusetts"), ("MI", "Michigan"), ("MN", "Minnesota"), ("MS", "Mississippi"),
    ("MO", "Missouri"), ("MT", "Montana"), ("NE", "Nebraska"), ("NV", "Nevada"),
    ("NH", "New Hampshire"), ("NJ", "New Jersey"), ("NM", "New Mexico"), ("NY", "New York"),
    ("NC", "North Carolina"), ("ND", "North Dakota"), ("OH", "Ohio"), ("OK", "Oklahoma"),
    ("OR", "Oregon"), ("PA", "Pennsylvania"), ("RI", "Rhode Island"), ("SC", "South Carolina"),
    ("SD", "South Dakota"), ("TN", "Tennessee"), ("TX", "Texas"), ("UT", "Utah"),
    ("VT", "Vermont"), ("VA", "Virginia"), ("WA", "Washington"), ("WV", "West Virginia"),
    ("WI", "Wisconsin"), ("WY", "Wyoming"), ("DC", "District of Columbia")
]

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartStore: CartStore
    var mode: CheckoutMode = .buy

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var selectedPhoneCodeIndex = 0
    @State private var phoneNumber = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var selectedStateIndex = 0
    @State private var zipCode = ""
    @State private var country: CheckoutCountry = .unitedStates
    @State private var paymentMethod: PaymentMethod = .creditCard
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact Information")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("First name")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                            TextField("First name", text: $firstName)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.words)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Last name")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                            TextField("Last name", text: $lastName)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.words)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Phone")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                            HStack(spacing: 12) {
                                Picker("Country code", selection: $selectedPhoneCodeIndex) {
                                    ForEach(Array(phoneCountryCodes.enumerated()), id: \.offset) { index, item in
                                        Text("\(item.code) (\(item.label))").tag(index)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color.primary)
                                .labelsHidden()
                                .frame(width: 130)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                TextField("Phone number", text: $phoneNumber)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.phonePad)
                            }
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shipping Address")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Street address")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                            TextField("Street address", text: $streetAddress)
                                .textFieldStyle(.roundedBorder)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("City")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                            TextField("City", text: $city)
                                .textFieldStyle(.roundedBorder)
                        }
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("State")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.hikbikMutedForeground)
                                Picker("State", selection: $selectedStateIndex) {
                                    ForEach(Array(usStates.enumerated()), id: \.offset) { index, state in
                                        Text(state.name).tag(index)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color.primary)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("ZIP / Postal code")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.hikbikMutedForeground)
                                TextField("ZIP code", text: $zipCode)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                            }
                            .frame(width: 120)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Country")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hikbikMutedForeground)
                            Picker("Country", selection: $country) {
                                ForEach(CheckoutCountry.allCases, id: \.self) { c in
                                    Text(c.rawValue).tag(c)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color.primary)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Information")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        ForEach([PaymentMethod.creditCard, .applePay, .payPal], id: \.self) { method in
                            Button(action: { paymentMethod = method }) {
                                HStack(spacing: 12) {
                                    Image(systemName: paymentMethod == method ? "circle.inset.filled" : "circle")
                                        .font(.system(size: 22))
                                        .foregroundStyle(paymentMethod == method ? Color.hikbikPrimary : Color.hikbikMutedForeground)
                                    switch method {
                                    case .creditCard:
                                        Text("Credit Card")
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundStyle(Color.hikbikPrimary)
                                    case .applePay:
                                        HStack(spacing: 8) {
                                            Image(systemName: "apple.logo")
                                                .font(.system(size: 20))
                                                .foregroundStyle(Color.hikbikPrimary)
                                            Text("Apple Pay")
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundStyle(Color.hikbikPrimary)
                                        }
                                    case .payPal:
                                        Text("PayPal")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.hikbikPrimary)
                                    }
                                    Spacer()
                                }
                                .padding(16)
                                .background(Color.hikbikCard)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(paymentMethod == method ? Color.hikbikPrimary : Color.hikbikBorder, lineWidth: paymentMethod == method ? 2 : 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        if paymentMethod == .creditCard {
                            VStack(alignment: .leading, spacing: 10) {
                                TextField("Card Number", text: $cardNumber)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                TextField("Expiry Date (MM/YY)", text: $expiryDate)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                TextField("CVV", text: $cvv)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                    .frame(width: 100)
                            }
                            .padding(.top, 8)
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order Summary")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                        VStack(spacing: 8) {
                            if mode == .rent {
                                ForEach(cartStore.items) { item in
                                    HStack {
                                        Text(item.product.name)
                                            .font(.system(size: 14, weight: .regular, design: .rounded))
                                            .foregroundStyle(Color.hikbikPrimary)
                                        Spacer()
                                        Text("$\(item.total)")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.hikbikPrimary)
                                    }
                                }
                            } else {
                                ForEach(cartStore.purchaseItems) { item in
                                    HStack {
                                        Text(item.product.name)
                                            .font(.system(size: 14, weight: .regular, design: .rounded))
                                            .foregroundStyle(Color.hikbikPrimary)
                                        Spacer()
                                        Text("$\(item.total)")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.hikbikPrimary)
                                    }
                                }
                            }
                            Divider()
                            HStack {
                                Text("Total")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.hikbikPrimary)
                                Spacer()
                                Text("$\(mode == .rent ? cartStore.rentalTotalPrice : cartStore.purchaseTotalPrice)")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.hikbikPrimary)
                            }
                        }
                        .padding(16)
                        .background(Color.hikbikCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.hikbikBorder, lineWidth: 1)
                        )
                    }
                    Button(action: {
                        if mode == .rent { cartStore.removeAllRentals() } else { cartStore.removeAllPurchases() }
                        dismiss()
                    }) {
                        Text("Complete Order - $\(mode == .rent ? cartStore.rentalTotalPrice : cartStore.purchaseTotalPrice)")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.hikbikCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.hikbikBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .background(Color.hikbikBackground)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Text("Back to Cart")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.hikbikPrimary)
                    }
                }
            }
        }
    }
}

private struct CartRentalRow: View {
    let item: RentalCartItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: item.product.imageUrl)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    Color.hikbikMuted
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                Text("$\(item.product.rentalPricePerDay)/day × \(item.rentalDays) days × \(item.quantity)")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikMutedForeground)
                Text("$\(item.total)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

private struct CartPurchaseRow: View {
    let item: PurchaseCartItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: item.product.imageUrl)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    Color.hikbikMuted
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
                Text("$\(item.product.price) × \(item.quantity)")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.hikbikMutedForeground)
                Text("$\(item.total)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hikbikPrimary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview { ShopView().environmentObject(CartStore()) }
#Preview("Stores") { 
    NavigationStack {
        StoresView()
    }
}
#Preview("Store Detail") {
    NavigationStack {
        StoreDetailView(store: StoresView.allStores[0])
    }
}
#Preview("Category Products") {
    NavigationStack {
        CategoryProductsView(category: .climbing)
    }
}
#Preview("Rental Product Detail") {
    NavigationStack {
        RentalProductDetailView(product: CategoryProductsView.allProducts[0])
            .environmentObject(CartStore())
    }
}
#Preview("Buy Product Detail") {
    NavigationStack {
        BuyProductDetailView(product: CategoryProductsView.allProducts[0])
            .environmentObject(CartStore())
    }
}
