import SwiftUI

/// 5 Tab：Home, Routes, Shop, Community, Profile（Orders 入口移至 Shop 內）
struct ContentView: View {
    @StateObject private var cartStore = CartStore()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            RoutesView()
                .tabItem { Label("Routes", systemImage: "map.fill") }
            ShopView()
                .tabItem { Label("Shop", systemImage: "bag.fill") }
            CommunityDiscoveryView()
                .tabItem { Label("Community", systemImage: "person.2.fill") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
        }
        .environmentObject(cartStore)
        .tint(Color.hikbikTabActive)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            let lineImage = UIGraphicsImageRenderer(size: CGSize(width: 10, height: 1)).image { ctx in
                UIColor.white.withAlphaComponent(0.2).setFill()
                ctx.fill(CGRect(x: 0, y: 0, width: 10, height: 1))
            }
            appearance.shadowColor = .clear
            appearance.shadowImage = lineImage.resizableImage(withCapInsets: .zero, resizingMode: .tile)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.white.opacity(0.5))
        }
    }
}

#Preview {
    ContentView()
}
