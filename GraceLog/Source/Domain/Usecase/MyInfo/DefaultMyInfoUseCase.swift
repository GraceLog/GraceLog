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
        profileImage: Data?,
        message: String
    ) -> Single<GraceLogUser> {
        print("유저 정보 수정 데이터: ", name, nickname, profileImage, message)
        
        return userRepository.updateUser(
            name: name,
            nickname: nickname,
            profileImage: profileImage,
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
