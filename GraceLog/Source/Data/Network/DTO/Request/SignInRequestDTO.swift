//
//  SignInRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 4/26/25.
//

import Foundation

enum SignInProvider: String, Encodable {
    case google = "google"
    case apple = "apple"
    case kakao = "kakao"
}

struct SignInRequestDTO: Encodable {
    let provider: SignInProvider
    let token: String
}

struct RefreshTokenRequestDTO: Encodable {
    let refreshToken: String
}
