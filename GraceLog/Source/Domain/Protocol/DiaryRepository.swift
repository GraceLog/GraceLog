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
        memberId: Int
    ) -> Single<[DiaryDetails]>
    
    func fetchCommunityDiaryList(
        communityId: Int,
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
    ) -> Single<Void>
    
    func deleteDiary(diaryId: Int) -> Single<Bool>
}
