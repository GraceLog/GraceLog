//
//  HomeViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 2/23/25.
//

import Foundation
import ReactorKit
import RxDataSources

final class HomeViewReactor: Reactor {
    private let homeUsecase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
    }
    
    enum Action {
        case userButtonTapped
        case groupButtonTapped
        case updateUser(GraceLogUser)
    }
    
    enum Mutation {
        case setSegment(State.HomeModeSegment)
        case setError(Error)
        case setUser(GraceLogUser)
    }
    
    struct State {
        
        // FIXME: - 추후 다른 Reactor통해 구분지을 예정, 이후 삭제
        enum HomeModeSegment {
            case user
            case group
        }
        
        var currentSegment: HomeModeSegment = .user
        var error: Error?
        var user: GraceLogUser? = nil
    }
    
    let initialState: State = State()
}

extension HomeViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .userButtonTapped:
            return .just(.setSegment(.user))
        case .groupButtonTapped:
            return .just(.setSegment(.group))
        case .updateUser(let user):
            return .just(.setUser(user))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSegment(let segment):
            newState.currentSegment = segment
        case .setError(let error):
            newState.error = error
        case .setUser(let user):
            newState.user = user
        }
        return newState
    }
}
