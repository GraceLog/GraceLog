//
//  HomeCommunityUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 7/6/25.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeCommunityUseCase {
    var diaryList: BehaviorRelay<[CommunityDiaryPreview]> { get }
    var isLastPage: BehaviorRelay<Bool> { get }
    var communityList: BehaviorRelay<[Community]> { get }
    var toggleDiaryResult: PublishRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    
    func fetchDiaryList(communityId: Int)
    func fetchCommunityList()
    func toggleDiaryLike(id: Int)
    func resetDiaryListWithPagination()
}
