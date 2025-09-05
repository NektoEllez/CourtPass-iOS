import Foundation

final class MockAuthService: AuthService {
    
    func signInWithApple() async throws -> String {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        if Int.random(in: 1...10) == 1 {
            throw AppError.unknown
        }
        
        return "mock_apple_id_token_\(UUID().uuidString.prefix(8))"
    }
    
    func signInWithGoogle() async throws -> String {
        try await Task.sleep(nanoseconds: 1_200_000_000)
        
        if Int.random(in: 1...10) == 1 {
            throw AppError.unknown
        }
        
        return "mock_google_id_token_\(UUID().uuidString.prefix(8))"
    }
}
