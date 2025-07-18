//
//  ChattingBottomSheetViewReactor.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import ReactorKit

final class ChattingBottomSheetViewReactor: Reactor {
    let initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    init() {
        self.initialState = State()
    }
}

extension ChattingBottomSheetViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        return newState
    }
}
