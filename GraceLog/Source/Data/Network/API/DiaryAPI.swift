//
//  DiaryAPI.swift
//  GraceLog
//
//  Created by 이상준 on 11/6/25.
//

import Alamofire

enum DiaryAPI {
    case createDiary(CreateDiaryRequestDTO)
    case fetchDiary(diaryId: Int)
    case fetchCommunityDiaryList(CommunityDiaryListRequestDTO)
    case fetchMyActivityDiaryList(MyActivityDiaryListRequestDTO)
    case fetchMyDiaryList(MyDiaryListRequestDTO)
    case fetchDateRangeDiaryList(DateRangeDiaryListRequestDTO)
    case fetchLastPostDate(DiaryLastPostDateRequestDTO)
    case fetchDiaryExistenceDates(DiaryExistenceDatesRequestDTO)
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
        case .fetchMyActivityDiaryList: return .get
        case .fetchMyDiaryList: return .get
        case .fetchDateRangeDiaryList: return .get
        case .fetchLastPostDate: return .get
        case .fetchDiaryExistenceDates: return .get
        case .deleteDiary: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createDiary, .fetchCommunityDiaryList:
            return ""
        case .fetchDiary(let id):
            return "/\(id)"
        case .fetchMyActivityDiaryList:
            return "/myActivity"
        case .fetchMyDiaryList:
            return "/myPostList"
        case .fetchDateRangeDiaryList:
            return "/dateRangePostList"
        case .fetchLastPostDate:
            return "/lastPostDate"
        case .fetchDiaryExistenceDates:
            return "/dateRangePostExistence"
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
        case .createDiary(let request):
            return .body(request)
        case .fetchDiary:
            return .none
        case .fetchCommunityDiaryList(let params):
            return .query(params)
        case .fetchMyActivityDiaryList(let params):
            return .query(params)
        case .fetchMyDiaryList(let params):
            return .query(params)
        case .fetchDateRangeDiaryList(let params):
            return .query(params)
        case .fetchLastPostDate(let params):
            return .query(params)
        case .fetchDiaryExistenceDates(let params):
            return .query(params)
        case .deleteDiary:
            return .none
        }
    }
}
