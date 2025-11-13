//
//  DiaryAPI.swift
//  GraceLog
//
//  Created by 이상준 on 11/6/25.
//

import Alamofire

enum DiaryAPI {
    case postDiary(PostDiaryRequestDTO)
    case fetchDiary(diaryId: Int)
    case fetchMyDiaryList(MyDiaryListRequestDTO)
    case fetchCommunityDiaryList(CommunityDiaryListRequestDTO)
    case deleteDiary(diaryId: Int)
}

extension DiaryAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/post"
    }
    
    var method: HTTPMethod {
        switch self {
        case .postDiary: return .post
        case .fetchDiary: return .get
        case .fetchMyDiaryList: return .get
        case .fetchCommunityDiaryList: return .get
        case .deleteDiary: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .postDiary:
            return ""
        case .fetchDiary(let id):
            return "/\(id)"
        case .fetchMyDiaryList:
            return "/myPost"
        case .fetchCommunityDiaryList:
            return ""
        case .deleteDiary(let id):
            return "/\(id)"
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .postDiary:
            return .formData
        default:
            return .requireAccessToken
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .postDiary(let request):
            return .body(request)
        case .fetchDiary:
            return .none
        case .fetchMyDiaryList(let request):
            return .body(request)
        case .fetchCommunityDiaryList(let params):
            return .query(params)
        case .deleteDiary(let id):
            return .none
        }
    }
}
