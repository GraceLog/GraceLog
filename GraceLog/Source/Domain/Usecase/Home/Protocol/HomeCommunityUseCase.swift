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
    var homeCommunityData: BehaviorSubject<HomeCommunityContent?> { get }
    var likeDiaryResult: PublishRelay<Bool> { get }
    var unlikeDiaryResult: PublishRelay<Bool> { get }
    
    func fetchHomeCommunityContent()
    func likeDiary(id: Int)
    func unlikeDiary(id: Int)
}
