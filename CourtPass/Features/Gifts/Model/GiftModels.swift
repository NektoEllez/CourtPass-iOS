import Foundation
struct GiftItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let price: String
    let deliveryDays: Int
    let isPopular: Bool
    let isNew: Bool
    let category: String
    let imageName: String
}
extension GiftItem {
    static let mockData: [GiftItem] = [
        GiftItem(title: "Premium Gift Box", price: "355 USD", deliveryDays: 2, isPopular: true, isNew: false, category: "Giftboxes", imageName: "gift_0"),
        GiftItem(title: "Luxury Perfume Set", price: "189 USD", deliveryDays: 3, isPopular: true, isNew: true, category: "For Her", imageName: "gift_1"),
        GiftItem(title: "Designer Watch", price: "599 USD", deliveryDays: 1, isPopular: true, isNew: false, category: "For Him", imageName: "gift_0"),
        GiftItem(title: "Artisan Chocolate Box", price: "89 USD", deliveryDays: 2, isPopular: true, isNew: true, category: "Giftboxes", imageName: "gift_1"),
        GiftItem(title: "Silk Scarf Collection", price: "125 USD", deliveryDays: 4, isPopular: false, isNew: true, category: "For Her", imageName: "gift_0"),
        GiftItem(title: "Leather Wallet", price: "75 USD", deliveryDays: 3, isPopular: false, isNew: false, category: "For Him", imageName: "gift_1"),
        GiftItem(title: "Flower Bouquet", price: "45 USD", deliveryDays: 1, isPopular: false, isNew: false, category: "Flowers", imageName: "gift_0"),
        GiftItem(title: "Coffee Bean Set", price: "35 USD", deliveryDays: 2, isPopular: false, isNew: true, category: "Giftboxes", imageName: "gift_1"),
        GiftItem(title: "Jewelry Box", price: "159 USD", deliveryDays: 3, isPopular: false, isNew: false, category: "For Her", imageName: "gift_0"),
        GiftItem(title: "Wine Selection", price: "289 USD", deliveryDays: 5, isPopular: false, isNew: true, category: "For Him", imageName: "gift_1"),
        GiftItem(title: "Spa Package", price: "199 USD", deliveryDays: 7, isPopular: false, isNew: false, category: "For Her", imageName: "gift_0"),
        GiftItem(title: "Tech Gadget Bundle", price: "399 USD", deliveryDays: 2, isPopular: false, isNew: true, category: "Electronics", imageName: "gift_1")
    ]
}
struct FilterCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let value: String?
    static let all = FilterCategory(name: "All", value: nil)
    static let giftboxes = FilterCategory(name: "Giftboxes", value: "Giftboxes")
    static let forHer = FilterCategory(name: "For Her", value: "For Her")
    static let forHim = FilterCategory(name: "For Him", value: "For Him")
    static let flowers = FilterCategory(name: "Flowers", value: "Flowers")
    static let electronics = FilterCategory(name: "Electronics", value: "Electronics")
    static let popular = FilterCategory(name: "Popular", value: "Popular")
    static let categories: [FilterCategory] = [.all, .giftboxes, .forHer, .forHim, .flowers, .electronics, .popular]
}
struct BannerCard: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let buttonTitle: String
    let imageName: String
    static let mockData: [BannerCard] = [
        BannerCard(title: "UPCOMING\nHOLIDAYS SOON", buttonTitle: "Call to action", imageName: "banner-flowers"),
        BannerCard(title: "SPECIAL\nOFFERS", buttonTitle: "Shop now", imageName: "banner-flowers"),
        BannerCard(title: "NEW\nCOLLECTION", buttonTitle: "Discover", imageName: "banner-flowers")
    ]
}
struct PromoBanner: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    static let mockData: [PromoBanner] = [
        PromoBanner(title: "Upcoming Holidays soon", imageName: "banner_1"),
        PromoBanner(title: "Special Offers", imageName: "banner_2"),
        PromoBanner(title: "New Collection", imageName: "banner_3")
    ]
}
struct MiniCategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    static let mockData: [MiniCategory] = [
        MiniCategory(title: "Next Day Delivery", imageName: "image_0"),
        MiniCategory(title: "New Popular Arrivals", imageName: "image_1"),
        MiniCategory(title: "Mixed Flowers", imageName: "image_2"),
        MiniCategory(title: "Thank you", imageName: "image_3")
    ]
}
struct Currency: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    static let usd = Currency(code: "USD", name: "US Dollar")
    static let eur = Currency(code: "EUR", name: "Euro")
    static let gbp = Currency(code: "GBP", name: "British Pound")
    static let jpy = Currency(code: "JPY", name: "Japanese Yen")
    static let currencies: [Currency] = [.usd, .eur, .gbp, .jpy]
}
struct CategoryFilterItem: Identifiable, Hashable {
    let id = UUID()
    let category: String
    let options: [String]
    init(category: String, options: [String]) {
        self.category = category
        self.options = options
    }
}
extension CategoryFilterItem {
    static let defaultFilters: [CategoryFilterItem] = [
        CategoryFilterItem(category: "Giftboxes", options: ["Giftboxes", "Flowers", "Electronics"]),
        CategoryFilterItem(category: "For Her", options: ["For Her", "For Him"]),
        CategoryFilterItem(category: "Popular", options: ["Popular", "New"])
    ]
    static func getOptions(for category: String) -> [String] {
        let filter = defaultFilters.first { $0.category == category }
        return filter?.options ?? [category]
    }
}
struct FilterDropdownItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let options: [String]
}
extension FilterDropdownItem {
    static let mockData: [FilterDropdownItem] = [
        FilterDropdownItem(title: "For Her", options: ["For Her", "For Him"]),
        FilterDropdownItem(title: "Giftboxes", options: ["Giftboxes", "Flowers", "Electronics"])
    ]
}
