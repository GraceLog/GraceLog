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
    private let usecase: DiaryCreatableUseCase
    var coordinator: DiaryCoordinator?
    
    private var maxDiaryImageCount = 5
    private var selectedKeywords: Set<DiaryKeyword> = []
    private var selectedShareOptions: Set<Community> = []
    private var diaryTitle = ""
    private var diaryContent = ""
    private var reserveTime: Date? = nil
    private var isHideLike: Bool = false
    private var isHideComment: Bool = false
    
    var initialState: State
    
    enum Action {
        case didTapCloseButton
        case updateImages([UIImage])
        case deleteImage(at: Int)
        case updateTitle(String)
        case updateContent(String)
        case didTapSettings
        case didTapShareButton
        case didSelectKeyword(DiaryKeywordState)
        case didSelectShareOption(DiaryShareState)
        case executeCreateDiary
    }
    
    enum Mutation {
        case setImages([DiaryImage])
        case setShareStates([DiaryShareState])
        case setCreateDiaryResult(Bool)
        case setError(Error)
    }
    
    struct State {
        @Pulse var images: [DiaryImage]
        @Pulse var keywords: [DiaryKeywordState]
        @Pulse var shareStates: [DiaryShareState]
        @Pulse var isSuccessCreateDiary: Bool?
        @Pulse var error: Error?
    }
    
    init(usecase: DiaryCreatableUseCase) {
        self.usecase = usecase
        self.initialState = State(
            images: [],
            keywords: DiaryKeyword.allCases.map { DiaryKeywordState(keyword: $0, isSelected: false) },
            shareStates: []
        )
        
        usecase.fetchCommunityList()
    }
}

extension DiaryViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCloseButton:
            coordinator?.dismiss()
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
        case .didTapSettings:
            coordinator?.showDiarySettings { [weak self] reserveTime, isHideLike, isHideComment in
                self?.reserveTime = reserveTime
                self?.isHideLike = isHideLike
                self?.isHideComment = isHideComment
            }
        case .didTapShareButton:
            usecase.createDiary(
                images: currentState.images,
                title: diaryTitle,
                content: diaryContent,
                selectedKeywords: Array(selectedKeywords),
                shareOptions: Array(selectedShareOptions),
                reserveTime: reserveTime,
                isHideLike: isHideLike,
                isHideComment: isHideComment
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
        case .executeCreateDiary:
            coordinator?.diaryCreatedEvent()
        }
        return .empty()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fetchCommunitiesMutation = usecase.communityList
            .map { communities in
                let shareStates = communities.map { community in
                    DiaryShareState(diaryOption: community, isSelected: false)
                }
                return Mutation.setShareStates(shareStates)
            }
        
        let createDiaryResultMutation = usecase.createDiaryResult
            .map { Mutation.setCreateDiaryResult($0) }
        
        let errorMutation = usecase.error
            .map { Mutation.setError($0) }
        
        return Observable.merge(
            fetchCommunitiesMutation,
            createDiaryResultMutation,
            errorMutation,
            mutation
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImages(let images):
            newState.images = images
        case .setShareStates(let states):
            newState.shareStates = states
        case .setCreateDiaryResult(let isSuccess):
            newState.isSuccessCreateDiary = isSuccess
        case .setError(let error):
            newState.error = error
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
    let diaryOption: Community
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
