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
    var profileImageData = PublishRelay<Data?>()
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func loadProfileImageData() {
        guard let profileImageURL = UserManager.shared.profileImageURL else {
            profileImageData.accept(nil)
            return
        }
        
        GLImageUtil.shared.loadImageData(from: profileImageURL)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?.profileImageData.accept(data)
                },
                onFailure: { [weak self] _ in
                    self?.profileImageData.accept(nil)
                }
            )
            .disposed(by: disposeBag)
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
