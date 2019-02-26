import Foundation

class KeyChain {
    
    static func save(_ key: String, _ data: String) -> Bool {
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecValueData : data.data(using: .utf8)!,
            kSecAttrAccessible : kSecAttrAccessibleWhenUnlockedThisDeviceOnly] as CFDictionary
        
        SecItemDelete(query)
        if SecItemAdd(query, nil) == errSecSuccess {
            return true
        }
        return false
    }
    
    static func load(_ key: String) -> String? {
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecReturnData : kCFBooleanTrue,
            kSecMatchLimit : kSecMatchLimitOne] as CFDictionary
        
        var dataTypeRef: AnyObject? = nil
        if SecItemCopyMatching(query, &dataTypeRef) == errSecSuccess {
            if let data = dataTypeRef as? Data {
                if let s = String(data: data, encoding: .utf8) {
                    return s
                }
            }
        }
        return nil
    }
    
    static func delete(_ key: String) -> Bool {
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key] as CFDictionary
        
        if SecItemDelete(query) == errSecSuccess {
            return true
        }
        return false
    }
}
