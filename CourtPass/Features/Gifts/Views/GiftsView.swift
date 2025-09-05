import SwiftUI

@MainActor
struct GiftsView: View {
    @StateObject private var viewModel = GiftsViewModel()
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            topBar
            headerRow
            scrollableContent
        }
        .background(DesignTokens.Background.primary)
    }
}

private extension GiftsView {
    var topBar: some View {
        HStack(spacing: 8) {
            Spacer(minLength: 0)
            Text("Deliver to")
                .font(.body)
                .foregroundStyle(.secondary)
            
            Text("🇺🇸")
            Text(viewModel.selectedCurrency)
                .font(.body.weight(.semibold))
            
            Image(systemName: "chevron.down")
                .font(.system(size: 13, weight: .semibold))
        }
        .padding(.horizontal, viewModel.hPadding)
        .padding(.vertical, DesignTokens.Spacing.md)
        .contentShape(Rectangle())
        .onTapGesture { 
            HapticManager.shared.buttonTap()
            Task { await viewModel.onCurrencyTap() } 
        }
    }
    
    
    var headerRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("GIFTS")
                .font(DesignTokens.Typography.display)
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: DesignTokens.IconSize.search))
                    .foregroundStyle(DesignTokens.Text.secondary)
                TextField("Search", text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.body)
                    .onChange(of: viewModel.searchText) { _, q in
                        Task { await viewModel.onSearchChange(q) }
                    }
            }
            .frame(maxWidth: viewModel.searchW, maxHeight: viewModel.searchH)
            .padding(.horizontal, 12)
            .background(Color(.secondarySystemFill), in: Capsule())
        }
        .padding(.horizontal, viewModel.hPadding)
    }
    
    
    var promoCarouselBlock: some View {
        SnapCarousel(
            selectedIndex: $viewModel.promoIndex,
            parentViewWidth: UIScreen.main.bounds.width,
            horizontalPadding: 32,
            models: viewModel.bannerCards,
            pageIndicatorHidden: true
        ) { model in
            BannerCardView(
                title: model.title,
                buttonTitle: model.buttonTitle,
                imageName: model.imageName
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.card))
            .onTapGesture { Task { await viewModel.onBannerCardTap(model) } }
        }
        .frame(height: DesignTokens.Spacing.bannerHeight)
    }
        
    
    
    var miniCategoriesBlock: some View {
        HStack(alignment: .top, spacing: .zero) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .zero) {
                    ForEach(viewModel.miniCategories) { item in
                        CategoryCardView(
                            title: item.title,
                            icon: item.imageName,
                            color: .blue
                        )
                        .padding(.horizontal, DesignTokens.Spacing.sm)
                        .onTapGesture { Task { await viewModel.onMiniCategoryTap(item) } }
                    }
                    
                    Button {
                        Task { await viewModel.onShowAllCategories() }
                    } label: {
                        VStack(spacing: 0) {
                            Text("Show all")
                                .font(DesignTokens.Typography.subheadlineFallback)
                                .foregroundColor(DesignTokens.Text.primary)
                        }
                    }
                        }
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.card))
        .padding(.horizontal, viewModel.hPadding)
    }
        }
    }
    
    
    var viewAllCategoriesPill: some View {
        Button {
            Task { await viewModel.onViewAllCategories() }
        } label: {
            Text("View all categories")
                .font(.body.weight(.semibold))
                .foregroundColor(DesignTokens.Text.primary)
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.vertical, DesignTokens.Spacing.xs)
                .overlay(
                    Capsule()
                        .stroke(DesignTokens.Background.primary, lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity)
    }
    
    var filtersBlock: some View {
        CategoryFiltersView(
            filters: CategoryFilterItem.defaultFilters,
            showsChevron: true,
            onSelect: { key in
                Task { await viewModel.onFilterSelect(key) }
            }
        )
    }
    
    var gridBlock: some View {
        LazyVGrid(
            columns: [
                GridItem(.fixed(viewModel.cardWidth), spacing: viewModel.gridCol, alignment: .top),
                GridItem(.fixed(viewModel.cardWidth), spacing: viewModel.gridCol, alignment: .top)
            ],
            alignment: .center,
            spacing: viewModel.gridRow
        ) {
            ForEach(viewModel.filteredGifts, id: \.id) { gift in
                ZStack {
                    GiftCardView(
                        gift: gift,
                        favorites: Binding(
                            get: { viewModel.favorites },
                            set: { viewModel.favorites = $0 }
                        ),
                        title: gift.title,
                        priceText: gift.price,
                        imageName: gift.imageName,
                        isFavorite: viewModel.isGiftFavorite(gift),
                        onFavorite: { Task { await viewModel.onGiftFavorite(gift) } }
                    )
                }
                .frame(width: viewModel.cardWidth, height: viewModel.cardHeight, alignment: .top)
                .clipped()
                .contentShape(Rectangle())
                .onTapGesture { Task { await viewModel.onGiftTap(gift) } }
            }
        }
        .transaction { $0.animation = nil }
    }
    
    
    var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                promoCarouselBlock
                miniCategoriesBlock
                    .padding(.top, DesignTokens.Spacing.sm)
                mainContentCard
                    .padding(.top, DesignTokens.Spacing.sm)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
            }
        }
    }
    
    
    var mainContentCard: some View {
        VStack(spacing: viewModel.vBlock) {
            viewAllCategoriesPill
            filtersBlock
            gridBlock
        }
        .padding(.top, DesignTokens.Spacing.sm)
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.bottom, DesignTokens.Spacing.xxl)
        .background(DesignTokens.Card.contentBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.r16))
    }
}

#Preview("Gifts View") {
    GiftsView()
}

#Preview("Gifts View - Dark") {
    GiftsView()
        .preferredColorScheme(.dark)
}

