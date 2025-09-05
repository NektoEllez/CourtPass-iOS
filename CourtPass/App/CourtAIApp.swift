import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct CourtAIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           FileManager.default.fileExists(atPath: path) {
            FirebaseApp.configure()
        } else {
        }
        
        FontService.shared.registerCustomFonts()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator(container: DIContainer.bootstrap())
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                switch coordinator.startRoute {
                case .auth:
                    AuthView(onSignInSuccess: {
                        coordinator.setAuthenticated()
                    })
                case .home:
                    MainTabView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .auth:
                    AuthView(onSignInSuccess: {
                        coordinator.setAuthenticated()
                    })
                case .home:
                    MainTabView()
                }
            }
        }
    }
}


#Preview("App") {
    ContentView()
}

#Preview("Sign In") {
    AuthView(onSignInSuccess: {})
}

#Preview("Main Tabs") {
    MainTabView()
}
