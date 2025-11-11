//
//  LikeAPI.swift
//  GraceLog
//
//  Created by 이상준 on 11/8/25.
//

import Alamofire

enum LikeAPI {
    case likeToggle(LikeDiaryRequestDTO)
    case fetchLikeCount(LikeCountRequestDTO)
}

extension LikeAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/like"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .likeToggle: return .post
        case .fetchLikeCount: return .get
        }
    }
    
    var path: String {
        switch self {
        case .likeToggle:
            return "/toggle"
        case .fetchLikeCount:
            return "/count"
        }
    }
    
    var headers: HeaderType {
        return .requireAccessToken
    }
    
    var parameters: RequestParams {
        switch self {
        case .likeToggle(let params):
            return .query(params)
        case .fetchLikeCount(let params):
            return .query(params)
        }
    }
}
