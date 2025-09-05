import Foundation

protocol CourtAPIServicing: Sendable {
    func firebaseLogin(idToken: String) async throws -> FirebaseLoginResult
}

struct CourtAPI: CourtAPIServicing {
    private let baseURL = URL(string: "https://api.court360.ai/rpc/client")!
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func firebaseLogin(idToken: String) async throws -> FirebaseLoginResult {
        let body = JSONRPCRequest(
            method: "auth.firebaseLogin",
            params: FirebaseLoginParams(fbIdToken: idToken)
        )
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let error = HTTPErrorMapper.map(response) { 
            throw error 
        }
        
        let envelope = try decoder.decode(JSONRPCResponse<FirebaseLoginResult>.self, from: data)
        if let error = envelope.error { 
            throw AppError.rpc(code: error.code, message: error.message) 
        }
        guard let result = envelope.result else { 
            throw AppError.decodingFailed 
        }
        
        return result
    }
}

