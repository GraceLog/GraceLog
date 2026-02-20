//
//  DefaultCreateCommunityUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 12/6/25.
//

import RxRelay
import RxSwift

final class DefaultCreateCommunityUseCase: CreateCommunityUseCase {
    var maxImageCount: Int { Constants.updatableMaxImageCount }
    let createCommunityResult = PublishRelay<Result<Void, CreateCommunityError>>()
    
    private let disposeBag = DisposeBag()
    
    private let communityRepository: CommunityRepository
    
    init(communityRepository: CommunityRepository) {
        self.communityRepository = communityRepository
    }
    
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
        
        let images = images.compactMap { diaryImage in
            diaryImage.image.jpegData(compressionQuality: 0.8)
        }
        
        communityRepository.createCommunity(images: images, name: title)
            .subscribe(onSuccess: { _ in
                self.createCommunityResult.accept(.success(()))
            }, onFailure: { _ in
                self.createCommunityResult.accept(.failure(.apiFailure))
            })
            .disposed(by: disposeBag)
    }
}

enum CreateCommunityError: Error {
    case emptyTitle
    case emptyImages
    case exceedMaxImageCount(max: Int)
    case apiFailure
}
