import Foundation
final class DIContainer {
    let api: CourtAPIServicing
    let auth: AuthService
    let hapticManager: HapticManager
    init(api: CourtAPIServicing, auth: AuthService, hapticManager: HapticManager = HapticManager.shared) {
        self.api = api
        self.auth = auth
        self.hapticManager = hapticManager
    }
    static func bootstrap() throws -> DIContainer {
        let auth = FirebaseAuthService()
        let api = try CourtAPI()
        let hapticManager = HapticManager.shared
        return DIContainer(api: api, auth: auth, hapticManager: hapticManager)
    }
    func createSessionManager() -> SessionManaging {
        let tokenStore = KeychainTokenStore()
        return SessionManager(tokenStore: tokenStore)
    }
}
protocol AuthService {
    func signInWithApple() async throws -> String
    func signInWithGoogle() async throws -> String
}
protocol SessionManaging {
    var me: User? { get async }
    var accessToken: String? { get async }
    func update(accessToken: String, me: User)
    func reset()
}
struct User: Codable {
    let id: String
    let name: String
    let email: String
}
struct LoginResponse {
    let accessToken: String
    let me: User
}
final class SessionManager: SessionManaging {
    private let tokenStore: TokenStore
    var me: User? {
        get async { await tokenStore.user }
    }
    var accessToken: String? {
        get async { await tokenStore.accessToken }
    }
    init(tokenStore: TokenStore) {
        self.tokenStore = tokenStore
    }
    func update(accessToken: String, me: User) {
        Task {
            await tokenStore.setAccessToken(accessToken)
            await tokenStore.setUser(me)
        }
    }
    func reset() {
        Task {
            await tokenStore.clear()
        }
    }
}
