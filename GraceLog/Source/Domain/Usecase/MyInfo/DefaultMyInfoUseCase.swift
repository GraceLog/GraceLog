//
//  DefaultMyInfoUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 5/23/25.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultMyInfoUseCase: MyInfoUseCase {
    var updateUserResult = PublishRelay<Bool>()
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func updateUser(
        name: String,
        nickname: String,
        profileImage: Data?,
        message: String
    ) { 
        userRepository.updateUser(
            name: name,
            nickname: nickname,
            profileImage: profileImage,
            message: message
        ).subscribe(
            onSuccess: { updatedUser in
                UserManager.shared.saveUserInfo(
                    id: updatedUser.id,
                    name: updatedUser.name,
                    nickname: updatedUser.nickname,
                    message: updatedUser.message,
                    email: updatedUser.email,
                    profileImageURL: updatedUser.profileImageURL
                )
                self.updateUserResult.accept(true)
            },
            onFailure: { error in
                print("❌ 유저 정보 수정 실패: \(error)")
                self.updateUserResult.accept(false)
            }
        )
        .disposed(by: disposeBag)
    }
}
