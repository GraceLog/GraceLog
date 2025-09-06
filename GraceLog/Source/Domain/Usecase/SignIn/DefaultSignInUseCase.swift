//
//  DefaultLoginUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/24.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultSignInUseCase: SignInUseCase {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    var isSuccessSignIn = PublishRelay<Bool>()
    
    init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    func signIn(provider: SignInProvider, token: String) {
        authRepository.signIn(provider: provider, token: token)
            .subscribe(with: self, onSuccess: { owner, result in
                KeychainServiceImpl.shared.accessToken = result.accessToken
                KeychainServiceImpl.shared.refreshToken = result.refreshToken
                owner.fetchUser()
            }, onFailure: { owner, error in
                owner.isSuccessSignIn.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchUser() {
        userRepository.fetchUser()
            .subscribe(with: self, onSuccess: { owner, result in
                UserManager.shared.saveUserInfo(
                    id: result.id,
                    name: result.name,
                    nickname: result.nickname,
                    message: result.message,
                    email: result.email,
                    profileImageURL: result.profileImageURL
                )
                owner.isSuccessSignIn.accept(true)
            }, onFailure: { owner, error in
                owner.isSuccessSignIn.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
