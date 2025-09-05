import SwiftUI
import Foundation
import Combine

@MainActor
class GiftsViewModel: ObservableObject {
    
    
    @Published var searchText = ""
    @Published var selectedFilter: String? = nil
    @Published var selectedCurrency = "USD"
    @Published var promoIndex: Int? = 0
    @Published var favorites: Set<UUID> = []
    
    
    let bannerCards = BannerCard.mockData
    let miniCategories = MiniCategory.mockData
    let filterItems = ["Giftboxes", "For Her", "Popular"]
    let giftItems = GiftItem.mockData
    
    
    let hPadding: CGFloat = DesignTokens.Spacing.screenH
    let vBlock: CGFloat = DesignTokens.Spacing.block
    let gridCol: CGFloat = DesignTokens.Spacing.inner
    let gridRow: CGFloat = DesignTokens.Spacing.inner
    let searchH: CGFloat = DesignTokens.Spacing.controls
    let searchW: CGFloat = 110
    let pillH: CGFloat = DesignTokens.Spacing.controls
    let bannerCorner: CGFloat = DesignTokens.CornerRadius.r16
    let miniCardSize: CGFloat = 96
    let cardWidth: CGFloat = 160
    let cardHeight: CGFloat = 240
    
    
    var filteredGifts: [GiftItem] {
        var gifts = giftItems
        
        if let category = selectedFilter, !category.isEmpty {
            gifts = gifts.filter { $0.category.lowercased().contains(category.lowercased()) }
        }
        
        if !searchText.isEmpty {
            gifts = gifts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        return gifts
    }
    
    var currencyDisplayText: String {
        "Deliver to [🇺🇸] \(selectedCurrency) ⌄"
    }
    
    
    func onCurrencyTap() async {
        await UIEventActor.shared.presentCurrencyPicker()
    }
    
    func onSearchChange(_ query: String) async {
        await SearchActor.shared.setQuery(query)
    }
    
    func onBannerCardTap(_ banner: BannerCard) async {
        await UIEventActor.shared.presentToast("Banner: \(banner.title)")
    }
    
    func onMiniCategoryTap(_ category: MiniCategory) async {
        await UIEventActor.shared.presentToast("Category: \(category.title)")
    }
    
    func onShowAllCategories() async {
        await UIEventActor.shared.showAllCategories()
    }
    
    func onViewAllCategories() async {
        selectedFilter = nil
        await UIEventActor.shared.showAllCategories()
    }
    
    func onFilterSelect(_ filter: String) async {
        selectedFilter = filter
        await FilterActor.shared.select(category: filter)
    }
    
    func onGiftTap(_ gift: GiftItem) async {
        await UIEventActor.shared.presentToast("Gift: \(gift.title)")
    }
    
    func onGiftFavorite(_ gift: GiftItem) async {
        if favorites.contains(gift.id) {
            favorites.remove(gift.id)
        } else {
            favorites.insert(gift.id)
        }
        
        await FavoritesActor.shared.toggle(id: gift.id)
    }
    
    func isGiftFavorite(_ gift: GiftItem) -> Bool {
        favorites.contains(gift.id)
    }
}
