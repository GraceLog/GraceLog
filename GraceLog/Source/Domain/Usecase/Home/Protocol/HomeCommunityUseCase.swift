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
    var diaryList: BehaviorRelay<[Diary]> { get }
    var communityList: BehaviorRelay<[Community]> { get }
    var likeDiaryResult: PublishRelay<Bool> { get }
    var unlikeDiaryResult: PublishRelay<Bool> { get }
    
    func fetchDiaryList(community: Community)
    func fetchCommunityList() 
    func likeDiary(id: String)
    func unlikeDiary(id: String)
}
