import Foundation
import SwiftUI
import Combine

enum AppRoute: Hashable {
    case auth
    case home
}

final class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .auth
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
        // Проверяем сохраненный токен для автоматического входа
        checkAuthenticationState()
    }
    
    func setAuthenticated() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentRoute = .home
        }
    }
    
    func setLoggedOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentRoute = .auth
        }
    }
    
    private func checkAuthenticationState() {
        // TODO: Проверить наличие валидного токена в Keychain
        // Пока всегда показываем auth экран
        currentRoute = .auth
    }
}
