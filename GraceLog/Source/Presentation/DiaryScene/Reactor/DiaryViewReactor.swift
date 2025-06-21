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
    
    var initialState: State
    
    enum Action {
        case updateImages([UIImage])
        case deleteImage(at: Int)
        case updateTitle(String)
        case updateDescription(String)
        case updateShareOption(index: Int, isOn: Bool)
        case saveDiary
        case didSelectKeyword(DiaryKeywordState)
    }
    
    enum Mutation {
        case setImages([DiaryImage])
        case setTitle(String)
        case setDescription(String)
        case setShareOption(index: Int, isOn: Bool)
        case setSaving(Bool)
        case setSaveResult(Bool)
    }
    
    struct State {
        @Pulse var images: [DiaryImage]
        var keywords: [DiaryKeywordState]
        var title: String
        var description: String
        var shareOptions: [(imageUrl: String, title: String, isOn: Bool)]
        var isSaving: Bool
        var sections: [DiarySection]
    }
    
    init() {
        self.initialState = State(
            images: [], 
            keywords: DiaryKeyword.allCases.map { DiaryKeywordState(keyword: $0, isSelected: false) },
            title: "",
            description: "",
            shareOptions: [
                ("community1", "새롬교회", false),
                ("community1", "Grace_log", false),
                ("community3", "스튜디오306", false),
                ("community4", "스튜디오카페", false),
                ("community1", "홀리파이어", false)
            ],
            isSaving: false,
            sections: []
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
            return .just(.setTitle(title))
        case .updateDescription(let description):
            return .just(.setDescription(description))
        case .updateShareOption(let index, let isOn):
            return .just(.setShareOption(index: index, isOn: isOn))
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImages(let images):
            newState.images = images
        case .setTitle(let title):
            newState.title = title
            newState.sections = createSections(state: newState)
        case .setDescription(let description):
            newState.description = description
            newState.sections = createSections(state: newState)
        case .setShareOption(index: let index, isOn: let isOn):
            if index < newState.shareOptions.count {
                newState.shareOptions[index].isOn = isOn
            }
        case .setSaving(let isSaving):
            newState.isSaving = isSaving
        case .setSaveResult:
            break
        }
        
        return newState
    }
    
    private func createSections(state: State) -> [DiarySection] {
        let imageItems: [DiarySectionItem] = []
        let titleItems: [DiarySectionItem] = [.title(state.title)]
        let descriptionItems: [DiarySectionItem] = [.description(state.description)]
        let keywordItems: [DiarySectionItem] = [.keyword]
        
        var shareItems: [DiarySectionItem] = []
        for option in state.shareOptions {
            shareItems.append(.shareOption(imageUrl: option.imageUrl, title: option.title, isOn: option.isOn))
        }
        
        let settingItems: [DiarySectionItem] = [.settings]
        let buttonItems: [DiarySectionItem] = [.button(title: "공유하기")]
        let dividerItems: [DiarySectionItem] = [.divide(left: 0,right: 0)]
        
        return [
            .images(items: imageItems),
            .title(header: "제목", items: titleItems),
            .description(header: "본문", items: descriptionItems),
            .divide(items: dividerItems),
            .keyword(header: "대표 키워드", desc: "중복 선택할 수 있어요!", items: keywordItems),
            .divide(items: dividerItems),
            .shareOptions(header: "공동체에게 공유", items: shareItems),
            .divide(items: dividerItems),
            .settings(items: settingItems),
            .divide(items: dividerItems),
            .button(items: buttonItems)
        ]
    }
}

// MARK: - Diary Keyword State/Model

struct DiaryKeywordState {
    let keyword: DiaryKeyword
    let isSelected: Bool
}

enum DiaryKeyword: String, CaseIterable {
    case obedience        = "순종"
        case faith        = "믿음"
        case love         = "사랑"
        case vision       = "비전"
        case guidance     = "인내"
        case peace        = "평안"
        case suffering    = "고난"
        case perseverance = "끈기"
}
