//
//  HomeRepository.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import RxSwift

protocol HomeRepository {
    func fetchHomeMyContent() -> Single<HomeContent>
    func fetchHomeCommunityContent() -> Single<HomeCommunityContent>
//    func fetchCommunityDiary(communityID: Int) -> Single<CommunityDiary>
}
