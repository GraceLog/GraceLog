//
//  AnnouncementAPI.swift
//  GraceLog
//
//  Created by 이상준 on 1/21/26.
//

import Alamofire

enum AnnouncementAPI {
    case fetchAnnouncementList
    case fetchAnnouncement(Int)
}

extension AnnouncementAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/notice"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchAnnouncementList:
            return .get
        case .fetchAnnouncement(let int):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchAnnouncementList:
            return ""
        case .fetchAnnouncement(let id):
            return "/\(id)"
        }
    }
    
    var headers: HeaderType {
        return .requireAccessToken
    }
    
    var parameters: RequestParams {
        switch self {
        default:
            return .none
        }
    }
}
