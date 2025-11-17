//
//  CreateCommunityReactor.swift
//  GraceLog
//
//  Created by 이건준 on 11/14/25.
//

import ReactorKit

final class CreateCommunityReactor: Reactor {
    let initialState: State
    private var maxCommunityImageCount = 5
    
    init() {
        self.initialState = State(images: [])
    }
    
    enum Action {
        case updateImages([UIImage])
        case deleteImage(at: Int)
    }
    
    enum Mutation {
        case setImages([DiaryImage])
    }
    
    struct State {
        @Pulse var images: [DiaryImage]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateImages(let newImages):
            let currentImages = currentState.images
            let convertedImages = newImages.map { DiaryImage(id: UUID(), image: $0) }
            let uploadImages = currentImages + convertedImages
            
            guard uploadImages.count <= maxCommunityImageCount else {
                print("Community Upload Image 최대 제한 개수 초과")
                return .empty()
            }
            
            return .just(.setImages(uploadImages))
        case .deleteImage(let index):
            var updatedImages = currentState.images
            if index < updatedImages.count {
                updatedImages.remove(at: index)
            }
            return .just(.setImages(updatedImages))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImages(let images):
            newState.images = images
        }
        
        return newState
    }
}
