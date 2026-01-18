//
//  DefaultDiaryUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/28/25.
//

import RxSwift
import RxRelay

typealias DiaryUseCase = DiaryCreatableUseCase & DiaryDeletableUseCase

final class DefaultDiaryUseCase: DiaryUseCase {
    var communityList = BehaviorRelay<[Community]>(value: [])
    var createDiaryResult = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
    
    private let communityRepository: CommunityRepository
    private let diaryRepository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(
        communityRepository: CommunityRepository,
        diaryRepository: DiaryRepository
    ) {
        self.communityRepository = communityRepository
        self.diaryRepository = diaryRepository
    }
    
    func fetchCommunityList() {
        communityRepository.fetchMyCommunityList()
            .subscribe(onSuccess: {
                self.communityList.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func createDiary(
        images: [DiaryImage],
        title: String,
        content: String,
        selectedKeywords: [DiaryKeyword]?,
        shareOptions: [Community]?,
        reserveTime: Date?,
        isHideLike: Bool,
        isHideComment: Bool
    ) {
        let images = images.compactMap { diaryImage in
            diaryImage.image.jpegData(compressionQuality: 0.8)
        }
        
        let keywords = selectedKeywords?.map { $0.rawValue }
        let communityIds = shareOptions?.map { $0.id }
        
        diaryRepository.createDiary(
            images: images,
            title: title,
            description: content,
            keywordList: keywords,
            selectedCommunityIdList: communityIds,
            reserveTime: reserveTime,
            isHideLike: isHideLike,
            isHideComment: isHideComment
        ).subscribe(onSuccess: { _ in 
            self.createDiaryResult.accept(true)
        }, onFailure: {
            self.error.accept($0)
        })
        .disposed(by: disposeBag)
    }
}
