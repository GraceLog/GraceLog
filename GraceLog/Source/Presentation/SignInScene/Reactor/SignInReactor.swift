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
    private let usecase: SignInUseCase
    private var isAgreed: Bool = false
    private let disposeBag = DisposeBag()
    
    init(usecase: SignInUseCase) {
        self.usecase = usecase
        self.initialState = State(
            isLoading: false,
            isAgreed: false,
            error: nil
        )
    }
    
    enum Action {
        case googleLogin(token: String)
        case appleLogin(token: String)
        case kakaoLogin(token: String)
        case toggleAgree
        case showTerms
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setAgree(Bool)
        case setError(Error)
    }
    
    struct State {
        var isLoading: Bool
        var isAgreed: Bool
        @Pulse var error: Error?
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
        case .toggleAgree:
            isAgreed = !isAgreed
            return .just(.setAgree(isAgreed))
        case .showTerms:
            // TODO: - 등록되지 않은 유저(회원가입)인 경우 가입 약관으로 이동 처리
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
        case .setAgree(let isAgreed):
            newState.isAgreed = isAgreed
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let userMutation = usecase.user
            .compactMap { $0 }
            .do(onNext: { [weak self] _ in
                self?.coordinator?.didSignIn()
            })
            .flatMap { _ in Observable<Mutation>.empty() }
        
        let errorMutation = usecase.error
            .map { error in Mutation.setError(error) }
        
        return .merge(mutation, userMutation, errorMutation)
    }
}

extension SignInReactor {
    private func handleSignIn(provider: SignInProvider, token: String) -> Observable<Mutation> {
        return Observable.concat([
            Observable.just(Mutation.setLoading(true)),
            usecase.signIn(provider: provider, token: token)
                .flatMap { _ in
                    return self.usecase.fetchUser()
                }
                .asObservable()
                .flatMap { _ in Observable<Mutation>.empty() }
                .catch { _ in Observable<Mutation>.empty() },
            Observable.just(.setLoading(false))
        ])
    }
}
