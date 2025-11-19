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
    func fetchDateRangeDiaryList(startDate: Date, endDate: Date, communityId: Int, memberId: Int) -> Single<[DiaryDetails]>
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
    
    func likeToggle(postId: Int) -> Single<Bool>
}
