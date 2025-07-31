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
    var isSuccessSignIn: BehaviorRelay<Bool> { get }
    var user: BehaviorRelay<GraceLogUser?> { get } 
    
    func signIn(provider: SignInProvider, token: String) -> Single<SignInResult>
    func fetchUser() -> Single<GraceLogUser>
}
