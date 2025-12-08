//
//  HomeRepository.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import RxSwift

protocol HomeRepository {
    func fetchDailyVerse() -> Single<DailyVerse>
    func fetchMyDiaryList() -> Single<[MyDiaryPreview]>
    func fetchMyCommunityList() -> Single<[Community]>
    func fetchHomeCommunityDiaryList(
        communityId: Int,
        cursorId: Int,
        size: Int
    ) -> Single<[CommunityDiaryPreview]>
    func likeToggle(postId: Int) -> Single<Bool>
    func fetchVideoList() -> Single<VideoInfo>
}
