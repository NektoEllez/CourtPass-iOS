import SwiftUI
struct GiftCardView: View {
    let gift: GiftItem?
    @Binding var favorites: Set<UUID>
    let title: String
    let priceText: String
    let imageName: String
    let isFavorite: Bool
    let onFavorite: () -> Void
    init(gift: GiftItem? = nil, favorites: Binding<Set<UUID>> = .constant(Set<UUID>()), title: String = "", priceText: String = "", imageName: String = "", isFavorite: Bool = false, onFavorite: @escaping () -> Void = {}) {
        self.gift = gift
        _favorites = favorites
        self.title = title
        self.priceText = priceText
        self.imageName = imageName
        self.isFavorite = isFavorite
        self.onFavorite = onFavorite
    }
    var body: some View {
        Button {
            HapticManager.shared.buttonTap()
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    let imageSource = gift?.imageName ?? imageName
                    if !imageSource.isEmpty {
                        Image(imageSource)
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(1, contentMode: .fit)
                    } else {
                        Rectangle()
                            .fill(Color.brown.opacity(0.3))
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                VStack(spacing: 4) {
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(Color.yellow)
                                            .frame(width: DesignTokens.IconSize.md, height: DesignTokens.IconSize.md)
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: DesignTokens.IconSize.sm, height: DesignTokens.IconSize.sm)
                                    }
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(width: 30, height: 8)
                                        .cornerRadius(DesignTokens.CornerRadius.xs)
                                    HStack(spacing: 2) {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: DesignTokens.Size.heartIconSize, height: DesignTokens.Size.heartIconSize)
                                        Circle()
                                            .fill(Color.purple)
                                            .frame(width: DesignTokens.Size.heartIconSize, height: DesignTokens.Size.heartIconSize)
                                    }
                                }
                            )
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.lg))
                .overlay(
                    Button {
                        let currentlyFavorite = gift.map { favorites.contains($0.id) } ?? isFavorite
                        HapticManager.shared.favoriteToggle(isFavorite: !currentlyFavorite)
                        withAnimation(DesignTokens.Animation.scale) {
                            onFavorite()
                        }
                    } label: {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: (gift.map { favorites.contains($0.id) } ?? isFavorite) ? DesignTokens.Icons.heartFill : DesignTokens.Icons.heart)
                                    .font(.system(size: 16))
                                    .foregroundColor((gift.map { favorites.contains($0.id) } ?? isFavorite) ? .red : DesignTokens.Text.primary)
                            )
                    }
                    .padding(DesignTokens.Spacing.sm),
                    alignment: .topTrailing
                )
                VStack(alignment: .leading, spacing: 4) {
                    Text(gift?.title ?? title)
                        .font(DesignTokens.Typography.subheadline)
                        .foregroundColor(DesignTokens.Text.primary)
                        .lineLimit(DesignTokens.LineLimit.twoLines)
                        .multilineTextAlignment(.leading)
                    Text(gift?.price ?? priceText)
                        .font(DesignTokens.Typography.headline)
                        .foregroundColor(DesignTokens.Text.primary)
                }
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.vertical, DesignTokens.Spacing.lg)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(DesignTokens.Card.background)
        .cornerRadius(DesignTokens.CornerRadius.lg)
    }
}
#Preview("Gift Card View") {
    GiftCardView(
        gift: GiftItem.mockData[0],
        favorites: .constant(Set<UUID>())
    )
    .padding()
}
