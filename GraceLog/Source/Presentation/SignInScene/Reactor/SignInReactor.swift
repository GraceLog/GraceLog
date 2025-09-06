//
//  LoginViewModel.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/24.
//

import Foundation

import GoogleSignIn
import ReactorKit
import RxSwift
import RxCocoa

final class SignInReactor: Reactor {
    private var disposeBag = DisposeBag()
    weak var coordinator: SignInCoordinator?
    private let usecase: SignInUseCase
    
    init(usecase: SignInUseCase) {
        self.usecase = usecase
        self.initialState = State(
            isLoading: false
        )
    }
    
    enum Action {
        case googleLogin(token: String)
        case appleLogin(token: String)
        case kakaoLogin(token: String)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSignInResult(Bool)
    }
    
    struct State {
        var isLoading: Bool
        @Pulse var isSuccessSignIn: Bool?
    }
    
    let initialState: State
}

extension SignInReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .googleLogin(let token):
            return handleSignIn(provider: .google, token: token)
        case .appleLogin(let token):
            return handleSignIn(provider: .apple, token: token)
        case .kakaoLogin(let token):
            return handleSignIn(provider: .kakao, token: token)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setSignInResult(let result):
            newState.isSuccessSignIn = result
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let signInResultMutation = usecase.isSuccessSignIn
            .flatMapLatest { [weak self] isSuccess -> Observable<Mutation> in
                guard let self else { return .empty() }
                
                if isSuccess { self.coordinator?.showMainTabFlow() }
                return Observable.concat([
                    .just(.setSignInResult(isSuccess)),
                    .just(.setLoading(false))
                ])
            }
        
        return .merge(mutation, signInResultMutation)
    }
}

extension SignInReactor {
    private func handleSignIn(provider: SignInProvider, token: String) -> Observable<Mutation> {
        return Observable.concat([
            .just(.setLoading(true)),
            Observable.create { [weak self] observer in
                self?.usecase.signIn(provider: provider, token: token)
                observer.onCompleted()
                return Disposables.create()
            },
        ])
    }
}
