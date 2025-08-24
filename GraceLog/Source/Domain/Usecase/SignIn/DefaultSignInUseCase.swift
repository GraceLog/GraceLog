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
    var isSuccessSignIn = PublishRelay<Bool>()
    var isSuccessFetchUser = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
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
            .do(onSuccess: { result in
                KeychainServiceImpl.shared.accessToken = result.accessToken
                KeychainServiceImpl.shared.refreshToken = result.refreshToken
                self.isSuccessSignIn.accept(true)
                
            },onError: { error in
                self.error.accept(error)
            })
    }
    
    func fetchUser() -> Single<GraceLogUser> {
        return userRepository.fetchUser()
            .do(onSuccess: { result in
                UserManager.shared.saveUserInfo(
                    id: result.id,
                    name: result.name,
                    nickname: result.nickname,
                    message: result.message,
                    email: result.email,
                    profileImageURL: result.profileImageURL
                )
                self.isSuccessFetchUser.accept(true)
            }, onError: { error in
                self.error.accept(error)
            })
    }
}
