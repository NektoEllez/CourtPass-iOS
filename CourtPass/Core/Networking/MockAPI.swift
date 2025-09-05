import Foundation

struct MockAPI: CourtAPIServicing {
    
    func firebaseLogin(idToken: String) async throws -> FirebaseLoginResult {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        if Int.random(in: 1...100) <= 15 {
            throw AppError.httpStatus(500)
        }
        
        if Int.random(in: 1...100) <= 5 {
            throw AppError.rpc(code: 401, message: "Invalid token")
        }
        
        let isAppleToken = idToken.contains("apple")
        let userName = isAppleToken ? "John Appleseed" : "Jane Google"
        let userEmail = isAppleToken ? "john.appleseed@icloud.com" : "jane.google@gmail.com"
        
        return FirebaseLoginResult(
            accessToken: "mock_access_token_\(UUID().uuidString.prefix(12))",
            me: Me(
                id: "\(Int.random(in: 1000...9999))",
                name: userName,
                email: userEmail
            )
        )
    }
}
