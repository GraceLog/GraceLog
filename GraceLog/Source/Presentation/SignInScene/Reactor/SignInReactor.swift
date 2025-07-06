//
//  LoginViewModel.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/24.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import GoogleSignIn

final class SignInReactor: Reactor {
    weak var coordinator: SignInCoordinator?
    private let signInUseCase: SignInUseCase
    private var isAgreed: Bool = false
    private let disposeBag = DisposeBag()
    
    init(signInUseCase: SignInUseCase) {
        self.signInUseCase = signInUseCase
    }
    
    enum Action {
        case googleLogin
        case appleLogin
        case kakaoLogin(token: String)
        case toggleAgree
        case showTerms
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setError(Error)
        case setLoginSuccess(GraceLogUser)
        case setAgree(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        var error: Error? = nil
        var user: GraceLogUser? = nil
        var isAgreed: Bool = false
    }
    
    let initialState: State = State()
}

extension SignInReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .googleLogin:
            return .empty()
        case .appleLogin:
            return .empty()
        case .kakaoLogin(let token):
            return handleKakaoLogin(token: token)
        case .toggleAgree:
            isAgreed = !isAgreed
            return .just(.setAgree(isAgreed))
        case .showTerms:
            //             coordinator?.showTerms()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setError(let error):
            newState.error = error
        case .setLoginSuccess(let user):
            newState.user = user
        case .setAgree(let isAgreed):
            newState.isAgreed = isAgreed
        }
        
        return newState
    }
}

extension SignInReactor {
    private func handleKakaoLogin(token: String) -> Observable<Mutation> {
        return Observable.concat([
            Observable.just(Mutation.setLoading(true)),
            signInUseCase.signIn(provider: .kakao, token: token)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, result -> Observable<Mutation> in
                    // TODO: - 상준: 이 부분 Coordinator 리팩토링 이후 수정 필요
//                    owner.coordinator?.didFinishSignIn()
                    return .empty()
                }
                .catch { error in
                    return Observable.just(.setError(error))
                },
            Observable.just(.setLoading(false))
        ])
    }
}
