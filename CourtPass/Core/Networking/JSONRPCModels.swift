import Foundation
struct JSONRPCRequest<P: Encodable>: Encodable {
    let jsonrpc = "2.0"
    let method: String
    let params: P
    let id = 1
}
struct JSONRPCResponse<R: Decodable>: Decodable {
    let jsonrpc: String
    let result: R?
    let error: JSONRPCErrorPayload?
    let id: Int
}
struct JSONRPCErrorPayload: Decodable, Error {
    let code: Int
    let message: String
    let data: String?
}
struct FirebaseLoginParams: Encodable {
    let fbIdToken: String
}
struct Me: Codable, Equatable, Sendable {
    let id: String
    let name: String
    let email: String
}
struct FirebaseLoginResult: Decodable, Sendable {
    let accessToken: String
    let me: Me
}
