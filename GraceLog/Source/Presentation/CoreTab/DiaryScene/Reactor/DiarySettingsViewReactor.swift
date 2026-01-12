//
//  DiarySettingsViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 4/21/25.
//

import ReactorKit
import RxSwift

final class DiarySettingsViewReactor: Reactor {
    var onComplete: ((Date?, Bool, Bool) -> Void)?
    weak var coordinator: DiaryCoordinator?
    
    private var isReserveTimeEnabled: Bool = false
    private var reserveDate: Date? = nil
    private var isHideLike = false
    private var isHideComment = false
    
    enum Action {
        case toggleReserveTime(Bool)
        case selectReserveDate(Date)
        case toggleSetting(DiarySettingType, Bool)
        case didTapCancelButton
        case didTapCompleteButton
    }
    
    enum Mutation {
        case setReserveTimeEnabled(Bool)
        case setReserveDate(Date)
        case setSettings(DiarySettingType, Bool)
    }
    
    struct State {
        @Pulse var settings: [DiarySettingsState]
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            settings: [
                DiarySettingsState(type: .hideLike, title: "좋아요 개수 숨기기", isOn: false),
                DiarySettingsState(type: .hideComment, title: "댓글창 숨기기", isOn: false)
            ]
        )
    }
}

extension DiarySettingsViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleReserveTime(let isOn):
            return .just(.setReserveTimeEnabled(isOn))
        case .selectReserveDate(let date):
            return .just(.setReserveDate(date))
        case .toggleSetting(let index, let isOn):
            return .just(.setSettings(index, isOn))
        case .didTapCancelButton:
            coordinator?.dismiss()
        case .didTapCompleteButton:
            let reserveTime = isReserveTimeEnabled ? reserveDate : nil
            onComplete?(reserveTime, isHideLike, isHideComment)
            coordinator?.dismiss()
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setReserveTimeEnabled(let isEnabled):
            isReserveTimeEnabled = isEnabled
            if !isEnabled {
                reserveDate = nil
            }
        case .setReserveDate(let date):
            reserveDate = date
        case .setSettings(let type, let isOn):
            switch type {
            case .hideLike:
                isHideLike = isOn
            case .hideComment:
                isHideComment = isOn
            }
            
            if let index = newState.settings.firstIndex(where: { $0.type == type }) {
                newState.settings[index].isOn = isOn
            }
        }
        return newState
    }
}

enum DiarySettingType {
    case hideLike
    case hideComment
}

struct DiarySettingsState {
    let type: DiarySettingType
    let title: String
    var isOn: Bool
}
