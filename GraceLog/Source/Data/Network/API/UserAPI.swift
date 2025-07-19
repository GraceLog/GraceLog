//
//  UserTarget.swift
//  GraceLog
//
//  Created by 이상준 on 5/16/25.
//

import Alamofire

enum UserAPI {
    case fetchUser
    case updateUser(UpdateUserRequestDTO)
}

extension UserAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUser: return .get
        case .updateUser: return .put
        }
    }
    
    var path: String {
        switch self {
        case .fetchUser, .updateUser: return "/member"
        }
    }
    
    var headers: HeaderType {
        return .requireAccessToken
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchUser:
            return .none
        case .updateUser(let request):
            return .body(request)
        }
    }
}
