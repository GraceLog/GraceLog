//
//  DefaultHomeUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultHomeUseCase: HomeUseCase {
    var dailyVerse = BehaviorRelay<DailyVerse?>(value: nil)
    var diaryList = BehaviorRelay<[MyDiaryPreview]>(value: [])
    var videoList = BehaviorRelay<[RecommendedVideo]>(value: [])
    var videoTagList = BehaviorRelay<[String]>(value: [])
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchDiaryList() {
        homeRepository.fetchMyDiaryList()
            .subscribe(onSuccess: {
                self.diaryList.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchVideoList() {
        homeRepository.fetchVideoList()
            .subscribe(onSuccess: {
                self.videoTagList.accept($0.tags)
                self.videoList.accept($0.videoList)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
        
    }
    
    func fetchDailyVerse() {
        homeRepository.fetchDailyVerse()
            .subscribe(onSuccess: {
                self.dailyVerse.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
