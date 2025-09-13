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
    
    var initialState: State
    
    enum Action {
        case didTapBackButton
    }
    
    struct State {
        let announcement: Announcement?
    }
    
    init(
        coordinator: AnnouncementCoordinator,
        announcement: Announcement
    ) {
        self.coordinator = coordinator
        
        self.initialState = State(
            announcement: announcement
        )
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .didTapBackButton:
            coordinator.popViewController()
            return .empty()
        }
    }
}
