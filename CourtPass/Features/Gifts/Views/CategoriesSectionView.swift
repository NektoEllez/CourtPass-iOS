import SwiftUI


struct CategoriesSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.block) {
            HStack {
                Text("New Popular Arrivals")
                    .font(DesignTokens.Typography.title)
                    .foregroundColor(DesignTokens.Text.primary)
                
                Spacer()
                
                Button("Show all") {
                    Task {
                        await UIEventActor.shared.presentToast("Show all tapped")
                    }
                }
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Text.primary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.block) {
                    CategoryCardView(
                        title: "New Popular Arrivals",
                        icon: "gift.fill",
                        color: .yellow
                    )
                    
                    CategoryCardView(
                        title: "Mixed Flowers",
                        icon: "heart.fill",
                        color: .red
                    )
                    
                    CategoryCardView(
                        title: "Thank you",
                        icon: "hand.thumbsup.fill",
                        color: .blue
                    )
                }
                .padding(.horizontal, DesignTokens.Spacing.screenH)
            }
            .padding(.horizontal, -DesignTokens.Spacing.screenH)
        }
        .padding(.horizontal, DesignTokens.Spacing.screenH)
        .padding(.top, DesignTokens.Spacing.block)
    }
}


#Preview("Categories Section View") {
    CategoriesSectionView()
        .padding()
}
