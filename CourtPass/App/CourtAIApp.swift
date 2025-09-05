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
    @StateObject private var coordinator: AppCoordinator = {
        do {
            return AppCoordinator(container: try DIContainer.bootstrap())
        } catch {
            fatalError("Failed to bootstrap DIContainer: \(error)")
        }
    }()
    var body: some View {
        Group {
            switch coordinator.currentRoute {
            case .auth:
                AuthView(onSignInSuccess: {
                    coordinator.setAuthenticated()
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
            case .home:
                MainTabView()
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing), 
                    removal: .move(edge: .leading)
                ))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: coordinator.currentRoute)
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
