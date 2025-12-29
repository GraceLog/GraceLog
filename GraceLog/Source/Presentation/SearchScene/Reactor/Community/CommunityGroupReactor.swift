//
//  CommunityGroupReactor.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import ReactorKit

final class CommunityGroupReactor: Reactor {
    private let coordinator: CommunityGroupCoordinator
    private let usecase: CommunityGroupUseCase
    let initialState: State
    
    init(usecase: CommunityGroupUseCase, coordinator: CommunityGroupCoordinator) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = .init()
    }
    
    enum Action {

    }
    
    enum Mutation {

    }
    
    struct State {

    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
