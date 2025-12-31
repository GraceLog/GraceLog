//
//  DiaryAPI.swift
//  GraceLog
//
//  Created by 이상준 on 11/6/25.
//

import Alamofire

enum DiaryAPI {
    case createDiary
    case fetchDiary(diaryId: Int)
    case fetchCommunityDiaryList(CommunityDiaryListRequestDTO)
    case fetchMyDiaryList(MyDiaryListRequestDTO)
    case fetchDateRangeDiaryList(DateRangeDiaryListRequestDTO)
    case deleteDiary(diaryId: Int)
}

extension DiaryAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/post"
    }
    
    var method: HTTPMethod {
        switch self {
        case .createDiary: return .post
        case .fetchDiary: return .get
        case .fetchCommunityDiaryList: return .get
        case .fetchMyDiaryList: return .get
        case .fetchDateRangeDiaryList: return .get
        case .deleteDiary: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createDiary, .fetchCommunityDiaryList:
            return ""
        case .fetchDiary(let id):
            return "/\(id)"
        case .fetchMyDiaryList:
            return "/myPostList"
        case .fetchDateRangeDiaryList:
            return "/dateRangePostList"
        case .deleteDiary(let id):
            return "/\(id)"
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .createDiary:
            return .formData
        default:
            return .requireAccessToken
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .createDiary:
            return .none
        case .fetchDiary:
            return .none
        case .fetchCommunityDiaryList(let params):
            return .query(params)
        case .fetchMyDiaryList(let request):
            return .query(request)
        case .fetchDateRangeDiaryList(let params):
            return .body(params)
        case .deleteDiary:
            return .none
        }
    }
}
