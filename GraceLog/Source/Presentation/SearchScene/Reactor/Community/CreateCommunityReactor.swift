//
//  CreateCommunityReactor.swift
//  GraceLog
//
//  Created by 이건준 on 11/14/25.
//

import ReactorKit

final class CreateCommunityReactor: Reactor {
    let initialState: State
    
    init() {
        self.initialState = State()
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
        return state
    }
}
