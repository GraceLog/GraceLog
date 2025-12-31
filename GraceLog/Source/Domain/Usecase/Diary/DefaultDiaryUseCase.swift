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
    var createDiaryResult = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
    
    private let diaryRepository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(
        diaryRepository: DiaryRepository
    ) {
        self.diaryRepository = diaryRepository
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
        ).subscribe(onSuccess: {
            self.createDiaryResult.accept(true)
        }, onFailure: {
            self.error.accept($0)
        })
        .disposed(by: disposeBag)
    }
}
