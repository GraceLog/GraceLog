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
    func fetchMyDiaryList(startDate: Date, endDate: Date) -> Single<[DiaryDetails]>
    func fetchCommunityDiaryList(startDate: Date, endDate: Date, communityId: Int) -> Single<[DiaryDetails]>
    func postDiary(
        title: String,
        description: String,
        keywordList: [String],
        selectedCommunityIdList: [Int],
        reserveTime: Date,
        isHideLike: Bool,
        isHideComment: Bool,
        images: [Data]
    ) -> Single<Void>
    
    func likeToggle(postId: Int, memberId: Int) -> Single<Bool>
}
