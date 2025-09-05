import SwiftUI

struct TabBarItem {
    let title: String
    let icon: String
    let tag: Int
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    let tabItems: [TabBarItem] = [
        TabBarItem(title: "Gifts", icon: DesignTokens.Icons.tabGift, tag: 0),
        TabBarItem(title: "Gifts", icon: DesignTokens.Icons.tabGift1, tag: 1),
        TabBarItem(title: "Events", icon: DesignTokens.Icons.tabCalendar, tag: 2),
        TabBarItem(title: "Cart", icon: DesignTokens.Icons.tabCart, tag: 3),
        TabBarItem(title: "Profile", icon: DesignTokens.Icons.tabProfile, tag: 4)
    ]

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                GiftsView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack(spacing: 0) {
                ForEach(tabItems, id: \.tag) { item in
                    Button {
                        withAnimation(DesignTokens.Animation.tabSelection) {
                            selectedTab = item.tag
                            HapticManager.shared.tabSelection()
                        }
                    } label: {
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            Image(item.icon)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DesignTokens.IconSize.tab)
                                .foregroundColor(selectedTab == item.tag ? DesignTokens.TabBar.selected : DesignTokens.TabBar.unselected)
                                .scaleEffect(selectedTab == item.tag ? DesignTokens.Scale.selectedTab : DesignTokens.Scale.none)
                            
                            Text(item.title)
                                .font(DesignTokens.Typography.caption)
                                .foregroundColor(selectedTab == item.tag ? DesignTokens.TabBar.selected : DesignTokens.TabBar.unselected)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignTokens.Spacing.md)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(DesignTokens.TabBar.background)
            .shadow(
                color: DesignTokens.Shadow.tabBar.color,
                radius: DesignTokens.Shadow.tabBar.radius,
                x: DesignTokens.Shadow.tabBar.x,
                y: DesignTokens.Shadow.tabBar.y
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

}


#Preview("Main Tab View") {
    MainTabView()
}

#Preview("Main Tab View - Dark") {
    MainTabView().preferredColorScheme(.dark)
}
