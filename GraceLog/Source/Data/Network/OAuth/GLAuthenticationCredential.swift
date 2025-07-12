//
//  GraceLogAuthenticationCredential.swift
//  GraceLog
//
//  Created by 이상준 on 4/27/25.
//

import Foundation
import Alamofire

struct GLAuthenticationCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiredAt: Date
    
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiredAt }
}
