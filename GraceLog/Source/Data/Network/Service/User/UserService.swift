//
//  UserService.swift
//  GraceLog
//
//  Created by 이상준 on 5/16/25.
//

import Foundation
import Alamofire
import RxSwift

struct UserService {
    func fetchUser() -> Single<UserResponseDTO> {
        return NetworkManager.shared
            .authenticatedRequest(UserTarget.fetchUser)
    }
    
    func updateUser(request: UserRequestDTO) -> Single<UserResponseDTO> {
        return NetworkManager.shared
            .authenticatedRequest(UserTarget.updateUser(request))
    }
}
