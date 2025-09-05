import SwiftUI
@MainActor
struct GiftsView: View {
    @State private var viewModel = GiftsViewModel()
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            topBar
            headerRow
            scrollableContent
        }
        .background(DesignTokens.Background.primary)
        .task(id: viewModel.searchText) {
            let trimmedText = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedText.isEmpty else { return }
            do {
                try await Task.sleep(for: .milliseconds(300))
                await viewModel.onSearchChange(trimmedText)
            } catch {
                AppLogger.debug("Search task cancelled", category: .search)
            }
        }
    }
}
private extension GiftsView {
    var topBar: some View {
        HStack(spacing: 8) {
            Spacer(minLength: 0)
            Button {
                HapticManager.shared.buttonTap()
                Task { await viewModel.onCurrencyTap() }
            } label: {
                HStack(spacing: 4) {
                    Text("Deliver to")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Text("🇺🇸")
                    Text(viewModel.selectedCurrency)
                        .font(.body.weight(.semibold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, viewModel.hPadding)
        .padding(.vertical, DesignTokens.Spacing.md)
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
                ZStack(alignment: .leading) {
                    if viewModel.searchText.isEmpty {
                        Text("Search")
                            .foregroundStyle(DesignTokens.Text.secondary)
                            .font(.body)
                    }
                    TextField("", text: $viewModel.searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .font(.body)
                        .foregroundStyle(DesignTokens.Text.primary)
                        .submitLabel(.search)
                        .onSubmit {
                            Task { await viewModel.onSearchChange(viewModel.searchText) }
                        }
                }
                if !viewModel.searchText.isEmpty {
                    Button {
                        HapticManager.shared.buttonTap()
                        viewModel.searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(DesignTokens.Text.secondary)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: viewModel.searchText.isEmpty ? viewModel.searchW : viewModel.searchW + 30, maxHeight: viewModel.searchH)
            .animation(.easeInOut(duration: 0.2), value: viewModel.searchText.isEmpty)
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
            .onTapGesture { 
                HapticManager.shared.buttonTap()
                Task { await viewModel.onBannerCardTap(model) } 
            }
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
                        .onTapGesture { 
                            HapticManager.shared.buttonTap()
                            Task { await viewModel.onMiniCategoryTap(item) } 
                        }
                    }
                    Button {
                        HapticManager.shared.buttonTap()
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
            HapticManager.shared.buttonTap()
            Task {
                await viewModel.onViewAllCategories()
            }
        } label: {
            HStack(spacing: 8) {
                Text("View all categories")
                    .font(.body.weight(.semibold))
                    .foregroundColor(DesignTokens.Text.primary)
                if viewModel.hasActiveFilters {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(DesignTokens.Text.secondary)
                        if viewModel.activeFiltersCount > 1 {
                            Text("\(viewModel.activeFiltersCount)")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color.blue, in: Circle())
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .overlay(
                Capsule()
                    .stroke(
                        viewModel.hasActiveFilters 
                        ? Color.blue.opacity(0.6) 
                        : DesignTokens.Background.primary, 
                        lineWidth: 1
                    )
            )
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: viewModel.hasActiveFilters)
    }
    var filtersBlock: some View {
        SmartCategoryFiltersView(
            viewModel: viewModel,
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
                .onTapGesture { 
                    HapticManager.shared.buttonTap()
                    Task { await viewModel.onGiftTap(gift) } 
                }
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
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.lg))
    }
}
#Preview("Gifts View") {
    GiftsView()
}
#Preview("Gifts View - Dark") {
    GiftsView()
        .preferredColorScheme(.dark)
}
