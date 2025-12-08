//
//  YoutubeAPI.swift
//  GraceLog
//
//  Created by 이상준 on 12/7/25.
//

import Alamofire

enum YoutubeAPI {
    case fetchVideo
}

extension YoutubeAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchVideo: return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchVideo:
            return "/youtube"
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchVideo:
            return .requireAccessToken
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchVideo:
            return .none
        }
    }
}
