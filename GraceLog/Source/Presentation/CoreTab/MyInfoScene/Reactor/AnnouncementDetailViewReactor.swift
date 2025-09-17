//
//  AnnouncementDetailViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 9/14/25.
//

import ReactorKit
import RxSwift

final class AnnouncementDetailViewReactor: Reactor {
    private let coordinator: AnnouncementCoordinator
    private let usecase: AnnouncementDetailUseCase
    private let announcementId: Int
    
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
    
    init(
        coordinator: AnnouncementCoordinator,
        usecase: AnnouncementDetailUseCase,
        announcementId: Int
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
        self.announcementId = announcementId
        
        self.initialState = State(
            announcement: nil
        )
        
        usecase.fetchAnnouncementDetail(announcementId)
    }
}

extension AnnouncementDetailViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            coordinator.popViewController()
            return .empty()
        }
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
        let announcementMutation = usecase.announcement
            .compactMap { $0 }
            .map { Mutation.setAnnouncement($0) }
        
        return Observable.merge(
            mutation,
            announcementMutation
        )
    }
}
