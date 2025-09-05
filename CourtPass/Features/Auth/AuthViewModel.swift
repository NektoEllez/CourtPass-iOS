import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorText: String?
    
    private let api: CourtAPIServicing
    private let auth: AuthService
    private let session: SessionManaging
    private let onSuccess: () -> Void
    
    init(api: CourtAPIServicing, auth: AuthService, onSuccess: @escaping () -> Void) {
        self.api = api
        self.auth = auth
        self.session = SessionManager(tokenStore: KeychainTokenStore())
        self.onSuccess = onSuccess
    }
    
    func signInApple() {
        Task { await signIn(flow: { try await auth.signInWithApple() }) }
    }
    
    func signInGoogle() {
        Task { await signIn(flow: { try await auth.signInWithGoogle() }) }
    }
    
    private func signIn(flow: () async throws -> String) async {
        isLoading = true
        errorText = nil
        
        do {
            let idToken = try await flow()
            let result = try await api.firebaseLogin(idToken: idToken)
            let user = User(id: result.me.id, name: result.me.name, email: result.me.email)
            session.update(accessToken: result.accessToken, me: user)
            onSuccess()
        } catch {
            errorText = (error as? LocalizedError)?.errorDescription ?? "Unexpected error"
        }
        
        isLoading = false
    }
}

