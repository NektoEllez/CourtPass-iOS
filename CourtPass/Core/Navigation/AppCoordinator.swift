import Foundation
import SwiftUI
import Combine

enum AppRoute: Hashable {
    case auth
    case home
}

final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    private let container: DIContainer
    
    var startRoute: AppRoute {
        .auth
    }
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func setAuthenticated() {
        path.removeLast(path.count)
        path.append(AppRoute.home)
    }
    
    func setLoggedOut() {
        path.removeLast(path.count)
        path.append(AppRoute.auth)
    }
}
