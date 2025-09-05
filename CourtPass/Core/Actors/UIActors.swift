import SwiftUI
import Foundation



actor NavigationActor {
    static let shared = NavigationActor()
    
    private init() {}
    
    func goToGifts() async {
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        await MainActor.run {
        }
    }
}


actor SignInActor {
    static let shared = SignInActor()
    
    enum Provider {
        case apple
        case google
    }
    
    private init() {}
    
    func signIn(provider: Provider) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}


actor SearchActor {
    static let shared = SearchActor()
    
    private var currentTask: Task<Void, Never>?
    private let debounceDelay: UInt64 = 400_000_000
    
    private init() {}
    
    func setQuery(_ query: String) async {
        currentTask?.cancel()
        
        currentTask = Task {
            try? await Task.sleep(nanoseconds: debounceDelay)
            
            if !Task.isCancelled {
                await MainActor.run {
                }
            }
        }
        
        await currentTask?.value
    }
}


actor FilterActor {
    static let shared = FilterActor()
    
    private init() {}
    
    func select(category: String?) async {
        try? await Task.sleep(nanoseconds: 200_000_000)
    }
}


actor FavoritesActor {
    static let shared = FavoritesActor()
    
    private var favorites: Set<UUID> = []
    
    private init() {}
    
    func toggle(id: UUID) async -> Bool {
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if favorites.contains(id) {
            favorites.remove(id)
            await MainActor.run {
            }
            return false
        } else {
            favorites.insert(id)
            await MainActor.run {
            }
            return true
        }
    }
    
    func isFavorite(id: UUID) async -> Bool {
        return favorites.contains(id)
    }
}


actor UIEventActor {
    static let shared = UIEventActor()
    
    private init() {}
    
    func presentToast(_ message: String) async {
        try? await Task.sleep(nanoseconds: 150_000_000)
    }
    
    func presentCurrencyPicker() async {
        try? await Task.sleep(nanoseconds: 200_000_000)
    }
    
    func showAllCategories() async {
        try? await Task.sleep(nanoseconds: 200_000_000)
    }
}

