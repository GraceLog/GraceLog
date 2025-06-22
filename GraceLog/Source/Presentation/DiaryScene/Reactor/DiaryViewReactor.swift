//
//  DiaryViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 3/28/25.
//

import ReactorKit
import RxSwift
import RxCocoa

final class DiaryViewReactor: Reactor {
    private var maxDiaryImageCount = 5
    private var selectedKeywords: Set<DiaryKeyword> = []
    private var selectedShareOptions: Set<DiaryShareOption> = []
    
    var initialState: State
    
    enum Action {
        case updateImages([UIImage])
        case deleteImage(at: Int)
        case updateTitle(String)
        case updateDescription(String)
        case saveDiary
        case didSelectKeyword(DiaryKeywordState)
        case didSelectShareOption(DiaryShareState)
    }
    
    enum Mutation {
        case setImages([DiaryImage])
        case setSaving(Bool)
        case setSaveResult(Bool)
    }
    
    struct State {
        @Pulse var images: [DiaryImage]
        var keywords: [DiaryKeywordState]
        var shareStates: [DiaryShareState]
        var isSaving: Bool
    }
    
    init() {
        self.initialState = State(
            images: [], 
            keywords: DiaryKeyword.allCases.map { DiaryKeywordState(keyword: $0, isSelected: false) },
            shareStates: DiaryShareOption.allCases.map { DiaryShareState(diaryOption: $0, isSelected: false) },
            isSaving: false
        )
    }
}

extension DiaryViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateImages(let newImages):
            let currentImages = currentState.images
            let convertedImages = newImages.map { DiaryImage(id: UUID(), image: $0) }
            let uploadImages = currentImages + convertedImages
            
            guard uploadImages.count <= maxDiaryImageCount else {
                print("Diary Upload Image 최대 제한 개수 초과")
                return .empty()
            }
            
            return .just(.setImages(uploadImages))
        case .deleteImage(let index):
            var updatedImages = currentState.images
            if index < updatedImages.count {
                updatedImages.remove(at: index)
            }
            return .just(.setImages(updatedImages))
        case .updateTitle(let title):
            return .empty()
        case .updateDescription(let description):
            return .empty()
        case .saveDiary:
            return Observable.concat([
                .just(.setSaving(true)),
            ])
        case .didSelectKeyword(let state):
            if state.isSelected {
                selectedKeywords.insert(state.keyword)
            } else {
                selectedKeywords.remove(state.keyword)
            }
            return .empty()
            
        case .didSelectShareOption(let state):
            if state.isSelected {
                selectedShareOptions.insert(state.diaryOption)
            } else {
                selectedShareOptions.remove(state.diaryOption)
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImages(let images):
            newState.images = images
        case .setSaving(let isSaving):
            newState.isSaving = isSaving
        case .setSaveResult:
            break
        }
        
        return newState
    }
}

// MARK: - Diary Keyword State/Model

struct DiaryKeywordState {
    let keyword: DiaryKeyword
    let isSelected: Bool
}

enum DiaryKeyword: String, CaseIterable {
    case obedience    = "순종"
    case faith        = "믿음"
    case love         = "사랑"
    case vision       = "비전"
    case guidance     = "인내"
    case peace        = "평안"
    case suffering    = "고난"
    case perseverance = "끈기"
}

// MARK: - Diary Share State/Model

struct DiaryShareState {
    let diaryOption: DiaryShareOption
    let isSelected: Bool
}

enum DiaryShareOption: String, CaseIterable {
    case saeromchurch
    case gracelog
    case studio306
    case studiocafe
    case holyfire
    
    var title: String {
        switch self {
        case .saeromchurch:
            return "새롬교회"
        case .gracelog:
            return "Grace_log"
        case .studio306:
            return "스튜디오306"
        case .studiocafe:
            return "스튜디오카페"
        case .holyfire:
            return "홀리파이어"
        }
    }
    
    var logoImageNamed: String {
        return "diary_share_\(self)"
    }
}

// MARK: - Diary Setting

enum DiarySettingMenu: CaseIterable {
    case setting
    
    var title: String {
        return "추가 설정"
    }
    
    var imageNamed: String {
        return "diary_\(self)"
    }
}
