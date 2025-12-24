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
    var likeDiaryResult: PublishRelay<Bool> { get }
    var unlikeDiaryResult: PublishRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    
    func fetchDiaryList(communityId: Int)
    func fetchCommunityList()
    func likeDiary(id: Int)
    func unlikeDiary(id: Int)
}
