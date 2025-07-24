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
    var isSuccessSignIn = BehaviorRelay<Bool>(value: false)
    var user = BehaviorRelay<GraceLogUser?>(value: nil)
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    func signIn(provider: SignInProvider, token: String) -> Single<SignInResult> {
        return authRepository.signIn(provider: provider, token: token)
            .do(onSuccess: { [weak self] result in
                KeychainServiceImpl.shared.accessToken = result.accessToken
                KeychainServiceImpl.shared.refreshToken = result.refreshToken
                self?.isSuccessSignIn.accept(true)
            },onError: { error in
                print(error.localizedDescription)
            })
    }
    
    func fetchUser() -> Single<GraceLogUser> {
        return userRepository.fetchUser()
            .do(onSuccess: { [weak self] result in
                UserManager.shared.saveUserInfo(
                    userId: result.id,
                    username: result.name,
                    userNickname: result.nickname,
                    userMessage: result.message,
                    userEmail: result.email,
                    userProfileImageUrl: result.profileImage
                )
                self?.user.accept(result)
            })
    }
}
