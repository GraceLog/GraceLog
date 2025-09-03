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
        case setFetchUserResult(Bool)
        case setSignInResult(Bool)
    }
    
    struct State {
        var isLoading: Bool
        @Pulse var isSuccessFetchUser: Bool?
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
            return handleSignIn(provider: .google, token: token)
        case .kakaoLogin(let token):
            return handleSignIn(provider: .google, token: token)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setFetchUserResult(let result):
            newState.isSuccessFetchUser = result
        case .setSignInResult(let result):
            newState.isSuccessSignIn = result
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let signInResultMutation = usecase.isSuccessSignIn
            .flatMap { [weak self] isSuccess -> Observable<Mutation> in
                guard let self else { return .empty() }
                
                if isSuccess { self.usecase.fetchUser() }
                return .just(.setSignInResult(isSuccess))
            }
        
        let fetchUserResultMutation = usecase.isSuccessFetchUser
            .flatMap { [weak self] isSuccess -> Observable<Mutation> in
                guard let self else { return .empty() }
                
                if isSuccess { self.coordinator?.showMainTabFlow() }
                return .just(.setFetchUserResult(isSuccess))
                
            }
        
        return .merge(mutation, signInResultMutation, fetchUserResultMutation)
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
            .just(.setLoading(false))
        ])
    }
}
