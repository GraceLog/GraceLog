//
//  UserDefaultsWrapper.swift
//  GraceLog
//
//  Created by 이건준 on 12/9/25.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T> {
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
