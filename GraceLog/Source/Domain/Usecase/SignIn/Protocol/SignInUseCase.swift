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
    
    func signIn(provider: SignInProvider, token: String)
    func fetchUser()
}
