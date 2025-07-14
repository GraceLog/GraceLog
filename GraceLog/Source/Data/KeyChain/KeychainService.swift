//
//  KeychainService.swift
//  GraceLog
//
//  Created by 이상준 on 5/2/25.
//

import Foundation

protocol KeychainService {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}

final class KeychainServiceImpl: KeychainService {
    static let shared = KeychainServiceImpl()
    private init() {}
    
    struct Key {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
    
    private let keychainAccess = KeyChainAccessImpl()
    
    var accessToken: String? {
        get { keychainAccess.get(Key.accessToken) }
        set {
            keychainAccess.save(Key.accessToken, newValue ?? "")
        }
    }
    
    var refreshToken: String? {
        get { keychainAccess.get(Key.refreshToken) }
        set {
            keychainAccess.save(Key.refreshToken, newValue ?? "")
        }
    }
    
    func isLoggedIn() -> Bool {
        return accessToken != nil
    }
}
