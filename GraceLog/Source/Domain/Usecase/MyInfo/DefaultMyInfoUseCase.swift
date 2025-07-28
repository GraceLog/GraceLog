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
        profileImageURL: URL?,
        message: String
    ) -> Single<GraceLogUser> {
        return userRepository.updateUser(
            name: name,
            nickname: nickname,
            profileImageURL: profileImageURL,
            message: message
        )
        .map { updatedUser in
            UserManager.shared.saveUserInfo(
                id: updatedUser.id,
                name: updatedUser.name,
                nickname: updatedUser.nickname,
                message: updatedUser.message,
                email: updatedUser.email,
                profileImageURL: updatedUser.profileImageURL
            )
            return updatedUser
        }
    }
}
