import Foundation
protocol CourtAPIServicing: Sendable {
    func firebaseLogin(idToken: String) async throws -> FirebaseLoginResult
}
struct CourtAPI: CourtAPIServicing {
    private let baseURL: URL
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init() throws {
        guard let url = URL(string: "https://api.court360.ai/rpc/client") else {
            throw AppError.invalidURL
        }
        self.baseURL = url
    }
    func firebaseLogin(idToken: String) async throws -> FirebaseLoginResult {
        AppLogger.info("Starting Firebase login", category: .auth)
        
        let body = JSONRPCRequest(
            method: "auth.firebaseLogin",
            params: FirebaseLoginParams(fbIdToken: idToken)
        )
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)
        
        AppLogger.debug("Sending auth request to \(baseURL)", category: .network)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let error = HTTPErrorMapper.map(response) {
                AppLogger.error("HTTP error during login: \(error)", category: .network)
                throw error 
            }
            
            let envelope = try decoder.decode(JSONRPCResponse<FirebaseLoginResult>.self, from: data)
            
            if let error = envelope.error {
                AppLogger.error("RPC error during login: \(error.message)", category: .auth)
                throw AppError.rpc(code: error.code, message: error.message) 
            }
            
            guard let result = envelope.result else {
                AppLogger.error("Missing result in login response", category: .auth)
                throw AppError.decodingFailed 
            }
            
            AppLogger.info("Firebase login successful", category: .auth)
            return result
        } catch {
            AppLogger.error("Login failed: \(error)", category: .auth)
            throw error
        }
    }
}
