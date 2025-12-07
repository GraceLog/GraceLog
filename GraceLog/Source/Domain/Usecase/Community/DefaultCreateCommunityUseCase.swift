//
//  DefaultCreateCommunityUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 12/6/25.
//

import RxRelay

final class DefaultCreateCommunityUseCase: CreateCommunityUseCase {
    var maxImageCount: Int { Constants.updatableMaxImageCount }
    let createCommunityResult = PublishRelay<Result<Void, CreateCommunityError>>()
    
    func createCommunity(title: String, images: [DiaryImage]) {
        guard !title.isEmpty else {
            createCommunityResult.accept(.failure(.emptyTitle))
            return
        }
        
        guard !images.isEmpty else {
            createCommunityResult.accept(.failure(.emptyImages))
            return
        }
        
        guard images.count <= maxImageCount else {
            createCommunityResult.accept(.failure(.exceedMaxImageCount(max: maxImageCount)))
            return
        }
        
        // MARK: - 실제 API 연동 (TODO)
        print("업로드된 이미지: \(images)\n작성한 제목: \(title)")
        
        let apiSucceeded = Bool.random()
        
        if apiSucceeded {
            createCommunityResult.accept(.success(()))
        } else {
            createCommunityResult.accept(.failure(.apiFailure))
        }
    }
}

enum CreateCommunityError: Error {
    case emptyTitle
    case emptyImages
    case exceedMaxImageCount(max: Int)
    case apiFailure                   
}
