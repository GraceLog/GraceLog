//
//  AuthManager.swift
//  GraceLog
//
//  Created by 이상준 on 5/22/25.
//

import UIKit

final class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    @UserDefaultsWrapper(key: .id, defaultValue: nil, storage: .standard)
    var id: Int?
    
    @UserDefaultsWrapper(key: .name, defaultValue: "", storage: .standard)
    var name: String
    
    @UserDefaultsWrapper(key: .nickname, defaultValue: "", storage: .standard)
    var nickname: String
    
    @UserDefaultsWrapper(key: .message, defaultValue: "", storage: .standard)
    var message: String
    
    @UserDefaultsWrapper(key: .email, defaultValue: "", storage: .standard)
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
