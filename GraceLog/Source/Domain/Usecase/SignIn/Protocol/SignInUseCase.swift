//
//  LoginUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/24.
//

import Foundation
import RxSwift
import RxRelay

protocol SignInUseCase {
    var isSuccessSignIn: PublishRelay<Bool> { get }
    var isSuccessFetchUser: PublishRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    
    func signIn(provider: SignInProvider, token: String) -> Single<SignInResult>
    func fetchUser() -> Single<GraceLogUser>
}
