import Foundation
import Security

final class TokenManager {
    private enum StorageKeys {
        static let accessToken = "pigeon.accessToken"
        static let refreshToken = "pigeon.refreshToken"
        static let expiresAt = "pigeon.tokenExpiration"
    }
    
    private func saveToKeychain(value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else {
            print("Failed to convert string to data for key: \(key)")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func readFromKeychain(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    private func deleteFromKeychain(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        saveToKeychain(value: accessToken, forKey: StorageKeys.accessToken)
        saveToKeychain(value: refreshToken, forKey: StorageKeys.refreshToken)
        
        let expiresAt = String(Date().timeIntervalSince1970 + (15 * 60))
        saveToKeychain(value: expiresAt, forKey: StorageKeys.expiresAt)
    }
    
    func getAccessToken() -> String? {
        return readFromKeychain(forKey: StorageKeys.accessToken)
    }
    
    func getRefreshToken() -> String? {
        return readFromKeychain(forKey: StorageKeys.refreshToken)
    }
    
    func clearTokens() {
        deleteFromKeychain(forKey: StorageKeys.accessToken)
        deleteFromKeychain(forKey: StorageKeys.refreshToken)
        deleteFromKeychain(forKey: StorageKeys.expiresAt)
    }
    
    func isTokenExpired() -> Bool {
        guard let expirationString = readFromKeychain(forKey: StorageKeys.expiresAt),
              let expirationTime = TimeInterval(expirationString) else {
            return true
        }
        
        return Date().timeIntervalSince1970 + 30 >= expirationTime
    }
} 
