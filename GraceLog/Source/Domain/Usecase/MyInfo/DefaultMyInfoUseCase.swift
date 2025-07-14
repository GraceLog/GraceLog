//
//  DefaultMyInfoUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 5/23/25.
//

import Foundation
import RxSwift

final class DefaultMyInfoUseCase: MyInfoUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func updateUser(
        name: String,
        nickname: String,
        profileImage: String,
        message: String
    ) -> Single<GraceLogUser> {
        return userRepository.updateUser(
            name: name,
            nickname: nickname,
            profileImage: profileImage,
            message: message
        )
        .map { updatedUser in
            AuthManager.shared.saveUser(updatedUser)
            return updatedUser
        }
    }
}
