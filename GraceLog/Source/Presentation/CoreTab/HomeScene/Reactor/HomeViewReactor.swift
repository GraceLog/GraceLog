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
    
    enum Action {
        case userButtonTapped
        case groupButtonTapped
    }
    
    enum Mutation {
        case setSegment(State.HomeModeSegment)
        case setError(Error)
    }
    
    struct State {
        
        // FIXME: - 추후 다른 Reactor통해 구분지을 예정, 이후 삭제
        enum HomeModeSegment {
            case user
            case group
        }
        
        var currentSegment: HomeModeSegment
        var error: Error?
        var profileImageUrl: URL?
        var segmentTitles: [String]
    }
    
    let initialState: State
    let user = UserManager.shared
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
        self.initialState = State(
            currentSegment: .user,
            profileImageUrl: URL(string: user.userProfileImageUrl),
            segmentTitles: [user.username, "공동체"]
        )
    }
}

extension HomeViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .userButtonTapped:
            return .just(.setSegment(.user))
        case .groupButtonTapped:
            return .just(.setSegment(.group))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSegment(let segment):
            newState.currentSegment = segment
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}
