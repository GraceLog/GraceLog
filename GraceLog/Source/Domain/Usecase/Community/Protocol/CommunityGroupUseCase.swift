//
//  CommunityGroupUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import RxRelay

protocol CommunityGroupUseCase {
    var latestCommunityDiaryExistenceDate: BehaviorRelay<Date?> { get }
    var diaryExistenceDates: BehaviorRelay<[DiaryExistenceDate]> { get }
    var communityDiaryList: BehaviorRelay<[CommunityDiaryPreview]> { get }
    var isLastPage: BehaviorRelay<Bool> { get }
    var toggleDiaryResult: PublishRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    
    func fetchLatestCommunityDiaryExistenceDate()
    func fetchCommunityDiaryExistenceDates(date: Date)
    func fetchCommunityDiaryList(date: String)
    func loadNextPage()
    func toggleDiaryLike(id: Int)
}
