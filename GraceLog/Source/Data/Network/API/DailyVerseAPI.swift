//
//  DailyVerseAPI.swift
//  GraceLog
//
//  Created by 이상준 on 11/21/25.
//

import Alamofire

enum DailyVerseAPI {
    case fetchDailyVerse
}

extension DailyVerseAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/verse"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchDailyVerse: return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchDailyVerse:
            return "/today"
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchDailyVerse:
            return .requireAccessToken
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchDailyVerse:
            return .none
        }
    }
}
