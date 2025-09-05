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
        // TODO: Check for valid token in Keychain
        currentRoute = .auth
    }
}
