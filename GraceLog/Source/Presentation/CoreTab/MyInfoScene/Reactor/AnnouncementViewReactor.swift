//
//  AnnouncementViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import ReactorKit
import RxSwift
import RxCocoa

final class AnnouncementViewReactor: Reactor {
    private let coordinator: AnnouncementCoordinator
    private let usecase: DefaultAnnouncementUseCase
    
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
        usecase: DefaultAnnouncementUseCase
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
        case .didTapAnnouncement(let id):
            print("선택된 공지사항 아이디: \(id)")
            coordinator.showAnnouncementDetail(id: id)
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
