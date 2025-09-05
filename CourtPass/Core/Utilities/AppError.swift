import Foundation
enum AppError: Error, LocalizedError {
    case httpStatus(Int)
    case rpc(code: Int, message: String)
    case firebaseUserNil
    case firebaseTokenMissing
    case cancelled
    case decodingFailed
    case invalidURL
    case unknown
    var errorDescription: String? {
        switch self {
        case .httpStatus(let code): 
            return "HTTP \(code)"
        case .rpc(_, let message): 
            return message
        case .firebaseUserNil: 
            return "Firebase user is nil"
        case .firebaseTokenMissing: 
            return "ID token missing"
        case .cancelled: 
            return "Cancelled"
        case .decodingFailed: 
            return "Decoding failed"
        case .invalidURL: 
            return "Invalid URL configuration"
        case .unknown: 
            return "Unknown error"
        }
    }
}
enum HTTPErrorMapper {
    static func map(_ response: URLResponse?) -> AppError? {
        guard let http = response as? HTTPURLResponse else { return .unknown }
        guard (200..<300).contains(http.statusCode) else { return .httpStatus(http.statusCode) }
        return nil
    }
}
