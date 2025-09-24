//
//  DiaryShareOption.swift
//  GraceLog
//
//  Created by 이건준 on 7/5/25.
//

import Foundation

struct Community: Hashable {
    let id: Int
    let name: String
    let logoImageURL: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
