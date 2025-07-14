//
//  AuthRepository.swift
//  GraceLog
//
//  Created by 이상준 on 4/27/25.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func signIn(provider: SignInProvider, token: String) -> Single<SignInResult>
    func refresh(refreshToken: String) -> Single<SignInResult>
}
