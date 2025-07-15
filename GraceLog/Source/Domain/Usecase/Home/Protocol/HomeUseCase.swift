//
//  HomeUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeUseCase {
    var diaryList: BehaviorRelay<[MyDiary]> { get }
    var videoList: BehaviorRelay<[RecommendedVideo]> { get }
    var error: PublishSubject<Error> { get }
        
    func fetchDiaryList()
    func fetchVideoList()
}
