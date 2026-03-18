import SwiftUI

/// 5 Tab：Home, Routes, Shop, Community, Profile（Orders 入口移至 Shop 內）
struct ContentView: View {
    @StateObject private var cartStore = CartStore()
    @StateObject private var communityViewModel = CommunityViewModel()
    @StateObject private var currentUser = CurrentUser()
    @StateObject private var socialManager = SocialManager()
    @ObservedObject private var tabSelection = TabSelectionManager.shared

    var body: some View {
        TabView(selection: $tabSelection.selectedTabIndex) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            RoutesView()
                .tabItem { Label("Routes", systemImage: "map.fill") }
                .tag(1)
            ShopView()
                .tabItem { Label("Shop", systemImage: "bag.fill") }
                .tag(2)
            CommunityDiscoveryView()
                .tabItem { Label("Community", systemImage: "person.2.fill") }
                .tag(3)
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
                .tag(4)
        }
        .environmentObject(cartStore)
        .environmentObject(communityViewModel)
        .environmentObject(currentUser)
        .environmentObject(socialManager)
        .environmentObject(TrackDataManager.shared)
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
        .environmentObject(UserState())
        .environmentObject(CommunityViewModel())
        .environmentObject(CurrentUser())
        .environmentObject(SocialManager())
        .environmentObject(TrackDataManager.shared)
}
