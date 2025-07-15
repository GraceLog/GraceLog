//
//  NetworkError.swift
//  GraceLog
//
//  Created by 이상준 on 6/4/25.
//

import Foundation
import Alamofire

enum APIError: Error {
    case clientError(statusCode: Int, message: String)
    case serverError(statusCode: Int, message: String)
    case decodingError
    case network(message: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .clientError(let statusCode, let message):
            return "클라이언트 에러 (\(statusCode)): \(message)"
        case .serverError(let statusCode, let message):
            return "서버 에러 (\(statusCode)): \(message)"
        case .decodingError:
            return "디코딩 에러"
        case .network(let message):
            return message
        case .unknown:
            return "알 수 없는 에러"
        }
    }
}
