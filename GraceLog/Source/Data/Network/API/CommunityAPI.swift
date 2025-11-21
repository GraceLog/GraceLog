//
//  CommunityAPI.swift
//  GraceLog
//
//  Created by 이상준 on 11/19/25.
//

import Alamofire

enum CommunityAPI {
    case fetchMyCommunityList
    case joinCommunity(communityId: Int)
    case leaveCommunity(communityId: Int)
}

extension CommunityAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/community"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyCommunityList: return .get
        case .joinCommunity: return .post
        case .leaveCommunity: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyCommunityList:
            return ""
        case .joinCommunity(let id):
            return "/\(id)/join"
        case .leaveCommunity(let id):
            return "/\(id)/leave"
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchMyCommunityList, .joinCommunity, .leaveCommunity:
            return .requireAccessToken
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyCommunityList, .joinCommunity, .leaveCommunity:
            return .none
        }
    }
}
