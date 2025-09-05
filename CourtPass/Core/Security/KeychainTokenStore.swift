import Foundation
import Security
@MainActor
private enum Keychain {
    static func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
    static func write(_ value: String, service: String, account: String) {
        guard let data = value.data(using: .utf8) else { return }
        let updateQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let updateAttributes: [String: Any] = [
            kSecValueData as String: data
        ]
        let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)
        if updateStatus == errSecItemNotFound {
            let addQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            ]
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }
    static func delete(service: String, account: String) {
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(deleteQuery as CFDictionary)
    }
}
actor TokenVault {
    private let service = "ai.court360.client"
    private let tokenAccount = "accessToken"
    private let userAccount = "user"
    func getToken() async -> String? {
        return await MainActor.run {
            Keychain.read(service: service, account: tokenAccount)
        }
    }
    func setToken(_ value: String?) {
        Task { @MainActor in
            if let value = value {
                Keychain.write(value, service: service, account: tokenAccount)
            } else {
                Keychain.delete(service: service, account: tokenAccount)
            }
        }
    }
    func getUser() async -> User? {
        return await MainActor.run {
            guard let data = Keychain.read(service: service, account: userAccount)?.data(using: .utf8),
                  let user = try? JSONDecoder().decode(User.self, from: data) else {
                return nil
            }
            return user
        }
    }
    func setUser(_ value: User?) {
        Task { @MainActor in
            if let value = value,
               let data = try? JSONEncoder().encode(value),
               let jsonString = String(data: data, encoding: .utf8) {
                Keychain.write(jsonString, service: service, account: userAccount)
            } else {
                Keychain.delete(service: service, account: userAccount)
            }
        }
    }
    func clear() {
        Task { @MainActor in
            Keychain.delete(service: service, account: tokenAccount)
            Keychain.delete(service: service, account: userAccount)
        }
    }
}
struct KeychainTokenStore: TokenStore {
    private let vault = TokenVault()
    var accessToken: String? { 
        get async { await vault.getToken() }
    }
    var user: User? {
        get async { await vault.getUser() }
    }
    func setAccessToken(_ value: String?) async {
        await vault.setToken(value)
    }
    func setUser(_ value: User?) async {
        await vault.setUser(value)
    }
    func clear() async {
        await vault.clear()
    }
}
