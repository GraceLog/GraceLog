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
    private let createDiaryUseCase: CreateDiaryUseCase
    
    private var maxDiaryImageCount = 5
    private var selectedKeywords: Set<DiaryKeyword> = []
    private var selectedShareOptions: Set<DiaryShareOption> = []
    private var diaryTitle = ""
    private var diaryContent = ""
    
    var initialState: State
    
    enum Action {
        case updateImages([UIImage])
        case deleteImage(at: Int)
        case updateTitle(String)
        case updateContent(String)
        case didTapShareButton
        case didSelectKeyword(DiaryKeywordState)
        case didSelectShareOption(DiaryShareState)
    }
    
    enum Mutation {
        case setImages([DiaryImage])
        case setCreateDiaryResult(Bool)
    }
    
    struct State {
        @Pulse var images: [DiaryImage]
        @Pulse var keywords: [DiaryKeywordState]
        @Pulse var shareStates: [DiaryShareState]
        @Pulse var isSuccessCreateDiary: Bool?
    }
    
    init(createDiaryUseCase: CreateDiaryUseCase) {
        self.createDiaryUseCase = createDiaryUseCase
        self.initialState = State(
            images: [], 
            keywords: DiaryKeyword.allCases.map { DiaryKeywordState(keyword: $0, isSelected: false) },
            shareStates: DiaryShareOption.allCases.map { DiaryShareState(diaryOption: $0, isSelected: false) }
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
            diaryTitle = title
        case .updateContent(let content):
            diaryContent = content
        case .didTapShareButton:
            createDiaryUseCase.createDiary(
                title: diaryTitle,
                content: diaryContent,
                selectedKeywords: Array(selectedKeywords),
                shareOptions: Array(selectedShareOptions)
            )
        case .didSelectKeyword(let state):
            if state.isSelected {
                selectedKeywords.insert(state.keyword)
            } else {
                selectedKeywords.remove(state.keyword)
            }
        case .didSelectShareOption(let state):
            if state.isSelected {
                selectedShareOptions.insert(state.diaryOption)
            } else {
                selectedShareOptions.remove(state.diaryOption)
            }
        }
        return .empty()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        Observable.merge(
            createDiaryUseCase.createDiaryResult.map { .setCreateDiaryResult($0) },
            mutation
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImages(let images):
            newState.images = images
        case .setCreateDiaryResult(let isSuccess):
            newState.isSuccessCreateDiary = isSuccess
        }
        
        return newState
    }
}

// MARK: - Diary Model

struct DiaryKeywordState {
    let keyword: DiaryKeyword
    let isSelected: Bool
}

struct DiaryShareState {
    let diaryOption: DiaryShareOption
    let isSelected: Bool
}

enum DiarySettingMenu: CaseIterable {
    case setting
    
    var title: String {
        return "추가 설정"
    }
    
    var imageNamed: String {
        return "diary_\(self)"
    }
}
