//
//  HeaderType.swift
//  GraceLog
//
//  Created by 이상준 on 7/15/25.
//

import Foundation
import Alamofire

enum HeaderType {
    case noAccessToken
    case requireAccessToken
    case formData
}

extension HeaderType {
    var httpHeaders: HTTPHeaders {
        switch self {
        case .noAccessToken:
            var headers = HTTPHeaders.default
            headers.add(.contentType("application/json"))
            return headers
        case .requireAccessToken:
            guard let token = KeychainServiceImpl.shared.accessToken else {
                return HeaderType.noAccessToken.httpHeaders
            }
            
            var headers = HTTPHeaders.default
            headers.add(.contentType("application/json"))
            headers.add(.authorization(bearerToken: token))
            return headers
        case .formData:
            guard let token = KeychainServiceImpl.shared.accessToken else {
                return HeaderType.noAccessToken.httpHeaders
            }
            
            var headers = HTTPHeaders.default
            headers.add(.contentType("application/json"))
            headers.add(.authorization(bearerToken: token))
            headers.add(.contentType("multipart/form-data"))
            return headers
        }
    }
}
