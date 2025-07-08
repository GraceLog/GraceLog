//
//  DiaryAdditionalSettingsViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 4/21/25.
//

import ReactorKit
import RxSwift

final class DiaryAdditionalSettingsViewReactor: Reactor {
    enum Action {
        case toggleSwitch(IndexPath, Bool)
    }
    
    enum Mutation {
        case updateSwitchState(IndexPath, Bool)
    }
    
    struct State {
        var sections: [DiaryAdditionalSettingsSection]
    }
    
    let initialState: State
    
    init(initialState: State) {
        let sections = [
            DiaryAdditionalSettingsSection(header: "예약 설정", items: [
                DiaryAdditionalSettingSectionItem(title: "감사일기 공유 예약하기", desc: "원하는 시간에 감사일기를 공유할 수 있어요.", isOn: false)
            ]),
            DiaryAdditionalSettingsSection(header: "좋아요 및 댓글설정", items: [
                DiaryAdditionalSettingSectionItem(title: "좋아요 개수 숨기기", desc: "", isOn: false),
                DiaryAdditionalSettingSectionItem(title: "댓글창 숨기기", desc: "", isOn: false)
            ])
        ]
        self.initialState = initialState
    }
}

extension DiaryAdditionalSettingsViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleSwitch(let indexPath, let isOn):
            return .just(.updateSwitchState(indexPath, isOn))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateSwitchState(let indexPath, let isOn):
            newState.sections[indexPath.section].items[indexPath.row].isOn = isOn
        }
        
        return newState
    }
}
