//
//  AnnouncementDetailViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 9/14/25.
//

import ReactorKit
import RxSwift

final class AnnouncementDetailViewReactor: Reactor {
    var coordinator: AnnouncementCoordinator?
    private let usecase: AnnouncementDetailUseCase
    
    var initialState: State
    
    enum Action {
        case didTapBackButton
    }
    
    enum Mutation {
        case setAnnouncement(Announcement)
    }
    
    struct State {
        @Pulse var announcement: Announcement?
    }
    
    init(usecase: AnnouncementDetailUseCase) {
        self.usecase = usecase
        self.initialState = State()
        
        usecase.fetchAnnouncementDetail()
    }
}

extension AnnouncementDetailViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            coordinator?.popViewController()
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setAnnouncement(let announcement):
            newState.announcement = announcement
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(
            usecase.announcement
                .compactMap { $0 }
                .map { .setAnnouncement($0) },
            mutation
        )
    }
}
