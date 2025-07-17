//
//  GLError.swift
//  GraceLog
//
//  Created by 이상준 on 7/17/25.
//

import Foundation

enum GLError: Error {
    case requestError(code: String, message: String)
    case serverError
    case decodedError
    case networkError
}

extension GLError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestError(let code, let message):
            return "\(code)\n\(message)"
        case .serverError:
            return "서버에서 오류가 발생했습니다."
        case .decodedError:
            return "데이터 파싱 중 오류가 발생했습니다."
        case .networkError:
            return "네트워크 오류가 발생했습니다."
        }
    }
}
