import Foundation
protocol TokenStore: Sendable {
    var accessToken: String? { get async }
    var user: User? { get async }
    func setAccessToken(_ value: String?) async
    func setUser(_ value: User?) async
    func clear() async
}
