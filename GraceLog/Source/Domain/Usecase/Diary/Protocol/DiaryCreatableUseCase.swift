//
//  CreateDiaryUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/30/25.
//

import RxRelay

protocol DiaryCreatableUseCase {
    var communityList: BehaviorRelay<[Community]> { get }
    var createDiaryResult: PublishRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    
    func fetchCommunityList()
    func createDiary(
        images: [DiaryImage],
        title: String,
        content: String,
        selectedKeywords: [DiaryKeyword]?,
        shareOptions: [Community]?,
        reserveTime: Date?,
        isHideLike: Bool,
        isHideComment: Bool
    )
}
