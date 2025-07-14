//
//  UserTarget.swift
//  GraceLog
//
//  Created by 이상준 on 4/26/25.
//

import Alamofire

enum AuthAPI {
    case signIn(SignInRequestDTO)
    case refresh(RefreshTokenRequestDTO)
}

extension AuthAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/auth"
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .refresh: return .post
        }
    }
    
    var path: String {
        switch self {
        case .signIn: return "/signin"
        case .refresh: return "/refresh"
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var parameters: RequestParams {
        switch self {
        case .signIn(let request): return .body(request)
        case .refresh(let request): return .body(request)
        }
    }
}
