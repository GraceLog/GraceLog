//
//  NetworkError.swift
//  GraceLog
//
//  Created by 이상준 on 6/4/25.
//

import Foundation
import Alamofire

enum APIError: Error {
    case network(statusCode: Int, message: String)
    case notToken
    case decodingError
    case doNotRetryWithError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .network(let statusCode, let message):
            return "Error Code: \(statusCode) \nmessage: \(message)"
        case .notToken:
            return "유저 토큰이 존재하지 않습니다. 로그아웃됩니다."
        case .decodingError:
            return "디코딩 에러"
        case .doNotRetryWithError:
            return "토큰 재발급에 실패했습니다. 로그인을 다시 시도해주세요"
        case .unknown:
            return "알 수 없는 에러"
        }
    }
}
