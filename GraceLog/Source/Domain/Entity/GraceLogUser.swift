//
//  GraceLogUser.swift
//  GraceLog
//
//  Created by 이상준 on 1/4/25.
//

import Foundation

struct GraceLogUser: Equatable, Codable {
    let id: Int
    let name: String
    let nickname: String
    let profileImageURL: URL?
    let email: String
    let message: String
}
