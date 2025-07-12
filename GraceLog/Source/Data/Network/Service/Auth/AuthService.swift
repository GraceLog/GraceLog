//
//  UserService.swift
//  GraceLog
//
//  Created by 이상준 on 4/26/25.
//

import Foundation
import Alamofire
import RxSwift

struct AuthService {
    func signIn(request: SignInRequestDTO) -> Single<SignInResponseDTO> {
        return NetworkManager.shared
            .authenticatedRequest(AuthTarget.signIn(request))
    }
}
