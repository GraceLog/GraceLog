//
//  CommentAPI.swift
//  GraceLog
//
//  Created by 이건준 on 1/29/26.
//

import Alamofire

enum CommentAPI {
    case fetchCommentList(postId: Int)
    case createComment(postId: Int, request: CreateCommentRequestDTO)
    case fetchReplyList(parentId: Int)
}

extension CommentAPI: TargetType {
    var baseURL: String {
        return "http://\(Const.baseURL)/comment"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCommentList, .fetchReplyList: return .get
        case .createComment: return .post
        }
    }
    
    var path: String {
        switch self {
        case let .fetchCommentList(postId):
            return "/post/\(postId)"
        case let .createComment(postId, _):
            return "/post/\(postId)"
        case let .fetchReplyList(parentId):
            return "/parent/\(parentId)"
        }
    }
    
    var headers: HeaderType {
        return .requireAccessToken
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchCommentList, .fetchReplyList:
            return .none
        case let .createComment(_, request):
            return .body(request)
        }
    }
}

