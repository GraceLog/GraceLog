//
//  NetworkResult.swift
//  GraceLog
//
//  Created by 이상준 on 7/16/25.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestError(String)
    case pathError
    case serverError
    case networkError
}

extension NetworkResult {
    var successData: T? {
        switch self {
        case .success(let data):
            return data
        default:
            return nil
        }
    }
    
    func toError() -> Error {
        switch self {
        case .success:
            return NSError(domain: "NetworkResult", code: 0, userInfo: [NSLocalizedDescriptionKey: "No error"])
        case .requestError(let message):
            return NSError(domain: "NetworkResult", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
        case .serverError:
            return NSError(domain: "NetworkResult", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        case .pathError:
            return NSError(domain: "NetworkResult", code: 404, userInfo: [NSLocalizedDescriptionKey: "Path error"])
        case .networkError:
            return NSError(domain: "NetworkResult", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
    }
}
