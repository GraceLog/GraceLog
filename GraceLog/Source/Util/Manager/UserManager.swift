//
//  AuthManager.swift
//  GraceLog
//
//  Created by 이상준 on 5/22/25.
//

import Foundation

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
    var userId: Int?
    
    @UserDefault(key: "username", defaultValue: "", storage: .standard)
    var username: String
    
    @UserDefault(key: "userNickname", defaultValue: "", storage: .standard)
    var userNickname: String
    
    @UserDefault(key: "userMessage", defaultValue: "", storage: .standard)
    var userMessage: String
    
    @UserDefault(key: "userEmail", defaultValue: "", storage: .standard)
    var userEmail: String
    
    @UserDefault(key: "userProfileImageUrl", defaultValue: "", storage: .standard)
    var userProfileImageUrl: String
    
    func saveUserInfo(
        userId: Int,
        username: String,
        userNickname: String,
        userMessage: String,
        userEmail: String,
        userProfileImageUrl: String
    ) {
        self.userId = userId
        self.username = username
        self.userNickname = userNickname
        self.userMessage = userMessage
        self.userEmail = userEmail
        self.userProfileImageUrl = userProfileImageUrl
    }
    
    func logout() {
        self.userId = nil
        self.username = ""
        self.userNickname = ""
        self.userMessage = ""
        self.userEmail = ""
        self.userProfileImageUrl = ""
    }
}
