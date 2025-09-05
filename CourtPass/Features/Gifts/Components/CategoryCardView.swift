import SwiftUI
struct CategoryCardView: View {
    let title: String
    let icon: String
    let color: Color
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: DesignTokens.Size.categoryIconSize, height: DesignTokens.Size.categoryIconSize)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            Text(title)
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Text.primary)
                .multilineTextAlignment(.center)
                .lineLimit(DesignTokens.LineLimit.twoLines)
                .frame(width: DesignTokens.Size.categoryCardWidth, height: DesignTokens.Spacing.xxxl, alignment: .top)
        }
        .frame(width: DesignTokens.Size.categoryCardWidth, height: DesignTokens.Size.categoryCardHeight, alignment: .top)
    }
}
#Preview("Category Card View") {
    HStack(spacing: 16) {
        CategoryCardView(
            title: "New Popular Arrivals",
            icon: "image_1",
            color: .yellow
        )
        CategoryCardView(
            title: "Mixed Flowers",
            icon: "image_2",
            color: .red
        )
        CategoryCardView(
            title: "Thank you",
            icon: "image_3",
            color: .blue
        )
    }
    .padding()
}
