//
//  AuthManager.swift
//  GraceLog
//
//  Created by 이상준 on 5/22/25.
//

import Foundation
import UIKit

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

final class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    @UserDefault(key: "userId", defaultValue: nil, storage: .standard)
    var id: Int?
    
    @UserDefault(key: "username", defaultValue: "", storage: .standard)
    var name: String
    
    @UserDefault(key: "userNickname", defaultValue: "", storage: .standard)
    var nickname: String
    
    @UserDefault(key: "userMessage", defaultValue: "", storage: .standard)
    var message: String
    
    @UserDefault(key: "userEmail", defaultValue: "", storage: .standard)
    var email: String
    
    @UserDefault(key: "userProfileImageUrl", defaultValue: nil, storage: .standard)
    var profileImageURL: URL?
    
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
