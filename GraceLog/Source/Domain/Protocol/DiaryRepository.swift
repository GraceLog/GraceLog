//
//  DiaryRepository.swift
//  GraceLog
//
//  Created by 이상준 on 11/8/25.
//

import Foundation
import RxSwift

protocol DiaryRepository {
    func fetchDiary(diaryId: Int) -> Single<DiaryDetails>
    
    func fetchMyDiaryList() -> Single<[MyDiaryPreview]>
    
    func fetchDateRangeDiaryList(
        startDate: String,
        endDate: String,
        communityId: Int?,
        memberId: Int,
        cursorId: Int?,
        size: Int?
    ) -> Single<[DiaryDetails]>
    
    func fetchCommunityDiaryList(
        communityId: Int,
        cursorId: Int?,
        size: Int
    ) -> Single<CommunityDiaryPreViewInfo>
    
    func fetchDateRangeMemberDiaryList(
        startDate: String,
        endDate: String,
        memberId: Int,
        communityId: Int?,
        cursorId: Int?,
        size: Int?
    ) -> Single<[DiaryDetails]>
    
    func fetchDateRangeCommunityDiaryList(
        startDate: String,
        endDate: String,
        communityId: Int,
        memberId: Int?,
        cursorId: Int?,
        size: Int
    ) -> Single<CommunityDiaryPreViewInfo>
    
    func createDiary(
        images: [Data],
        title: String,
        description: String,
        keywordList: [String]?,
        selectedCommunityIdList: [Int]?,
        reserveTime: Date?,
        isHideLike: Bool,
        isHideComment: Bool
    ) -> Single<GLEmptyResponse>
    
    func fetchMyActivityDiaryList(
        cursorId: Int,
        size: Int
    ) -> Single<CommunityDiaryPreViewInfo>
    
    func fetchDiaryLastPostDate(
        communityId: Int
    ) -> Single<Date?>
    
    func fetchDiaryExistenceDates(
        startDate: String,
        endDate: String,
        communityId: Int?,
        memberId: Int?,
        cursorId: Int?,
        size: Int?
    ) -> Single<[DiaryExistenceDate]>
    
    func deleteDiary(diaryId: Int) -> Single<Bool>
}
