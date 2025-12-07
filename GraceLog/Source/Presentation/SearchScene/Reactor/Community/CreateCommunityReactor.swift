//
//  CreateCommunityReactor.swift
//  GraceLog
//
//  Created by 이건준 on 11/14/25.
//

import ReactorKit

final class CreateCommunityReactor: Reactor {
    let initialState: State
    private let usecase: CreateCommunityUseCase
    
    private var maxCommunityImageCount: Int {
        usecase.maxImageCount
    }
    
    init(usecase: CreateCommunityUseCase) {
        self.usecase = usecase
        self.initialState = State(
            images: [],
            editedTitle: "",
            errorMessage: nil
        )
    }
    
    enum Action {
        case updateImages([UIImage])
        case deleteImage(at: Int)
        case editTitle(String)
        case didTapCreateButton
    }
    
    enum Mutation {
        case setImages([DiaryImage])
        case setTitle(String)
        case setErrorMessage(String?)
    }
    
    struct State {
        @Pulse var images: [DiaryImage]
        var editedTitle: String
        var errorMessage: String?
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateImages(let newImages):
            let currentImages = currentState.images
            let convertedImages = newImages.map { DiaryImage(id: UUID(), image: $0) }
            let uploadImages = currentImages + convertedImages
            
            guard uploadImages.count <= maxCommunityImageCount else {
                return .just(.setErrorMessage("이미지는 최대 \(maxCommunityImageCount)장까지 업로드할 수 있습니다."))
            }
            
            return .just(.setImages(uploadImages))
            
        case .deleteImage(let index):
            var updatedImages = currentState.images
            if index < updatedImages.count {
                updatedImages.remove(at: index)
            }
            return .just(.setImages(updatedImages))
            
        case let .editTitle(title):
            return .just(.setTitle(title))
            
        case .didTapCreateButton:
            usecase.createCommunity(
                title: currentState.editedTitle,
                images: currentState.images
            )
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let resultMutation = usecase.createCommunityResult
            .asObservable()
            .flatMap { result -> Observable<Mutation> in
                switch result {
                case .success:
                    return .just(.setErrorMessage(nil))
                    
                case .failure(let error):
                    let message: String
                    
                    switch error {
                    case .emptyTitle:
                        message = "제목을 입력해주세요."
                    case .emptyImages:
                        message = "이미지를 1개 이상 업로드해주세요."
                    case .exceedMaxImageCount(let max):
                        message = "이미지는 최대 \(max)장까지 업로드할 수 있습니다."
                    case .apiFailure:
                        message = "서버 통신에 실패했습니다. 잠시 후 다시 시도해주세요."
                    }
                    
                    return .just(.setErrorMessage(message))
                }
            }
        
        return Observable.merge(mutation, resultMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImages(let images):
            newState.images = images
            
        case .setTitle(let title):
            newState.editedTitle = title
            
        case .setErrorMessage(let message):
            newState.errorMessage = message
        }
        
        return newState
    }
}
