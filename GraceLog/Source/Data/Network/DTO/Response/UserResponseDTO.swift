//
//  UserDTO.swift
//  GraceLog
//
//  Created by 이상준 on 12/30/24.
//

import Foundation

struct UserResponseDTO: Decodable {
    let memberId: Int
    let name: String
    let nickname: String
    let profileImage: String?
    let email: String
    let message: String
}
