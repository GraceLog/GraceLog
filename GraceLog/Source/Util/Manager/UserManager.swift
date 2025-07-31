//
//  AuthManager.swift
//  GraceLog
//
//  Created by 이상준 on 5/22/25.
//

import Foundation
import UIKit

enum UserDefaultKey: String {
    case id
    case name
    case nickname
    case message
    case email
    case profileImageURL
}

@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultKey
    let defaultValue: T
    let storage: UserDefaults
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key.rawValue) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key.rawValue) }
    }
    
    init(key: UserDefaultKey, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

final class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    @UserDefault(key: .id, defaultValue: nil, storage: .standard)
    var id: Int?
    
    @UserDefault(key: .name, defaultValue: "", storage: .standard)
    var name: String
    
    @UserDefault(key: .nickname, defaultValue: "", storage: .standard)
    var nickname: String
    
    @UserDefault(key: .message, defaultValue: "", storage: .standard)
    var message: String
    
    @UserDefault(key: .email, defaultValue: "", storage: .standard)
    var email: String
    
    var profileImageURL: URL? {
        get {
            guard let urlString = UserDefaults.standard.string(forKey: UserDefaultKey.profileImageURL.rawValue) else {
                return nil
            }
            return URL(string: urlString)
        }
        set {
            if let url = newValue {
                UserDefaults.standard.set(url.absoluteString, forKey: UserDefaultKey.profileImageURL.rawValue)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaultKey.profileImageURL.rawValue)
            }
        }
    }
    
    func saveUserInfo(
        id: Int,
        name: String,
        nickname: String,
        message: String,
        email: String,
        profileImageURL: URL?
    ) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.message = message
        self.email = email
        self.profileImageURL = profileImageURL
    }
    
    func clearUserInfo() {
        self.id = nil
        self.name = ""
        self.nickname = ""
        self.message = ""
        self.email = ""
        self.profileImageURL = nil
    }
}
