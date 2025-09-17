//
//  AnnouncementViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import ReactorKit
import RxSwift

final class AnnouncementViewReactor: Reactor {
    private let coordinator: AnnouncementCoordinator
    private let usecase: AnnouncementListUseCase
    
    var initialState: State
    
    enum Action {
        case didTapAnnouncement(Int)
        case didTapBackButton
    }
    
    enum Mutation {
        case setAnnouncements([Announcement])
    }
    
    struct State {
        @Pulse var announcements: [Announcement]
    }
    
    init(
        coordinator: AnnouncementCoordinator,
        usecase: AnnouncementListUseCase
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.initialState = State(
            announcements: []
        )
        
        usecase.fetchAnnouncementList()
    }
}

extension AnnouncementViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAnnouncement(let announcementId):
            print("선택된 공지사항 아이디: \(announcementId)")
            coordinator.showAnnouncementDetail(announcementId: announcementId)
        case .didTapBackButton:
            coordinator.popViewController()
        }
        
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setAnnouncements(let announcements):
            newState.announcements = announcements
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let announcementMutation = usecase.announcementList
            .map { Mutation.setAnnouncements($0) }
        
        return Observable.merge(
            mutation,
            announcementMutation
        )
    }
}
