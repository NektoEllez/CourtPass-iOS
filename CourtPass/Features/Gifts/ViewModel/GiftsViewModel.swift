import SwiftUI
import Foundation
@MainActor
@Observable
class GiftsViewModel {
    var searchText = ""
    var selectedFilters: Set<String> = []
    var selectedCurrency = "USD"
    var promoIndex: Int? = 0
    var favorites: Set<UUID> = []
    private var searchTask: Task<Void, Never>?
    private var cachedFilterDisplayText: [String: String] = [:]
    private var lastEffectiveFilters: Set<String> = []
    let bannerCards = BannerCard.mockData
    let miniCategories = MiniCategory.mockData
    let filterItems = ["Giftboxes", "For Her", "For Him", "Flowers", "Electronics", "Popular"]
    let giftItems = GiftItem.mockData
    init() {
    }
    deinit {
    }
    let hPadding: CGFloat = DesignTokens.Spacing.lg
    let vBlock: CGFloat = DesignTokens.Spacing.md
    let gridCol: CGFloat = DesignTokens.Spacing.lg
    let gridRow: CGFloat = DesignTokens.Spacing.lg
    let searchH: CGFloat = DesignTokens.Spacing.controlMinSize
    let searchW: CGFloat = 110
    let pillH: CGFloat = DesignTokens.Spacing.controlMinSize
    let bannerCorner: CGFloat = DesignTokens.CornerRadius.lg
    let miniCardSize: CGFloat = 96
    let cardWidth: CGFloat = 160
    let cardHeight: CGFloat = 240
    var filteredGifts: [GiftItem] {
        var gifts = giftItems
        let activeFilters = effectiveFilters
        let effectiveSearch = effectiveSearchText
        if !activeFilters.isEmpty {
            gifts = applyMultipleFiltersToGifts(gifts, categories: activeFilters)
        }
        if !effectiveSearch.isEmpty {
            gifts = applySearchToGifts(gifts, searchText: effectiveSearch)
        }
        return gifts
    }
    private var effectiveFilters: Set<String> {
        var filters = selectedFilters
        if filters.isEmpty, let autoFilter = autoDetectedFilter {
            filters.insert(autoFilter)
        }
        return filters
    }
    private var stableEffectiveFilters: Set<String> {
        return effectiveFilters
    }
    private var effectiveSearchText: String {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return autoDetectedFilter != nil ? "" : trimmed
    }
    private func applyFilterToGifts(_ gifts: [GiftItem], category: String) -> [GiftItem] {
        switch category.lowercased() {
        case "popular":
            return gifts.filter { $0.isPopular }
        default:
            return gifts.filter { $0.category.lowercased().contains(category.lowercased()) }
        }
    }
    private func applyMultipleFiltersToGifts(_ gifts: [GiftItem], categories: Set<String>) -> [GiftItem] {
        return gifts.filter { gift in
            return categories.allSatisfy { category in
                switch category.lowercased() {
                case "popular":
                    return gift.isPopular
                case "new":
                    return gift.isNew
                default:
                    return gift.category.lowercased().contains(category.lowercased())
                }
            }
        }
    }
    private func applySearchToGifts(_ gifts: [GiftItem], searchText: String) -> [GiftItem] {
        return gifts.filter { 
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    var currencyDisplayText: String {
        "Deliver to [🇺🇸] \(selectedCurrency) ⌄"
    }
    var hasActiveFilters: Bool {
        return !effectiveFilters.isEmpty || !effectiveSearchText.isEmpty
    }
    var activeFiltersCount: Int {
        var count = effectiveFilters.count
        if !effectiveSearchText.isEmpty { count += 1 }
        return count
    }
    private var autoDetectedFilter: String? {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearch.isEmpty else { return nil }
        
        let detected = detectFilterFromInput(trimmedSearch)
        
        if let filter = detected {
            AppLogger.debug("Auto-detected filter: '\(trimmedSearch)' → '\(filter)'", category: .search)
        }
        
        return detected
    }
    private func detectFilterFromInput(_ input: String) -> String? {
        let searchLower = input.lowercased()
        for category in filterItems {
            if matchesCategory(searchLower, category: category) {
                return category
            }
        }
        return nil
    }
    private func matchesCategory(_ searchTerm: String, category: String) -> Bool {
        let categoryLower = category.lowercased()
        if searchTerm == categoryLower || categoryLower.contains(searchTerm) {
            return true
        }
        return matchesCategoryPattern(searchTerm, category: categoryLower)
    }
    private func matchesCategoryPattern(_ searchTerm: String, category: String) -> Bool {
        let patterns: [String: [String]] = [
            "for him": ["him", "men", "male", "man", "masculine", "boys", "guys"],
            "for her": ["her", "women", "female", "woman", "feminine", "girls", "ladies"],
            "popular": ["popular", "best", "top", "trending", "hot", "favorite"],
            "giftboxes": ["gift", "box", "boxes", "package", "bundle"],
            "flowers": ["flower", "flowers", "bloom", "bouquet", "floral"],
            "electronics": ["tech", "gadget", "electronics", "electronic", "device"]
        ]
        guard let synonyms = patterns[category] else { return false }
        return synonyms.contains { synonym in
            searchTerm == synonym || searchTerm.contains(synonym) || synonym.contains(searchTerm)
        }
    }
    func getFilterDisplayText(for originalCategory: String) -> String {
        let activeFilters = effectiveFilters
        if activeFilters != lastEffectiveFilters {
            cachedFilterDisplayText.removeAll()
            lastEffectiveFilters = activeFilters
        }
        if let cached = cachedFilterDisplayText[originalCategory] {
            return cached
        }
        let displayText: String
        if activeFilters.contains(originalCategory) {
            displayText = originalCategory
        } else {
            let options = CategoryFilterItem.getOptions(for: originalCategory)
            let activeSubcategories = activeFilters.filter { options.contains($0) }
            if !activeSubcategories.isEmpty {
                let priorityOrder = ["New", "Popular", "For Him", "For Her", "Giftboxes", "Flowers", "Electronics"]
                var result = originalCategory
                for priorityFilter in priorityOrder {
                    if activeSubcategories.contains(priorityFilter) {
                        result = priorityFilter
                        break
                    }
                }
                if result == originalCategory {
                    result = activeSubcategories.sorted().first ?? originalCategory
                }
                displayText = result
            } else {
                displayText = originalCategory
            }
        }
        cachedFilterDisplayText[originalCategory] = displayText
        return displayText
    }
    func isFilterActive(for category: String) -> Bool {
        let activeFilters = effectiveFilters
        if activeFilters.contains(category) {
            return true
        }
        let options = CategoryFilterItem.getOptions(for: category)
        return activeFilters.contains { activeFilter in
            options.contains(activeFilter)
        }
    }
    func onCurrencyTap() async {
        await UIEventActor.shared.presentCurrencyPicker()
    }
    func onSearchChange(_ query: String) async {
        await SearchActor.shared.setQuery(query)
    }
    private func performSearch(_ query: String) async {
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
        selectedFilters.removeAll()
        searchText = ""
        await UIEventActor.shared.showAllCategories()
    }
    func clearSearch() {
        searchText = ""
    }
    func clearFilters() {
        selectedFilters.removeAll()
    }
    func onFilterSelect(_ filter: String) async {
        let wasActive = selectedFilters.contains(filter)
        
        if wasActive {
            selectedFilters.remove(filter)
            AppLogger.debug("Filter '\(filter)' removed. Active filters: \(selectedFilters)", category: .filters)
        } else {
            selectedFilters.insert(filter)
            AppLogger.debug("Filter '\(filter)' added. Active filters: \(selectedFilters)", category: .filters)
        }
        
        searchText = ""
        await FilterActor.shared.select(category: filter)
    }
    func onGiftTap(_ gift: GiftItem) async {
        await UIEventActor.shared.presentToast("Gift: \(gift.title)")
    }
    func onGiftFavorite(_ gift: GiftItem) async {
        let isFavorite = await FavoritesActor.shared.toggle(id: gift.id)
        if isFavorite {
            favorites.insert(gift.id)
        } else {
            favorites.remove(gift.id)
        }
    }
    func isGiftFavorite(_ gift: GiftItem) -> Bool {
        favorites.contains(gift.id)
    }
}
