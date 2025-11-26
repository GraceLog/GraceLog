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
    var videoTagList = BehaviorRelay<[VideoTag]>(value: [])
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
        videoList.accept([
            RecommendedVideo(
                title: "말씀노트",
                imageURL: URL(string: "https://pimg.mk.co.kr/meet/neds/2017/11/image_readmed_2017_740612_15101228583092607.jpg")
            ),
            RecommendedVideo(
                title: "더메세지 랩The Message LAB",
                imageURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX4sCVSr1te6gasrpW9pSDUrQ46cf9rP7t8w&s")
            )
        ])
        
        videoTagList.accept([
            VideoTag(name: "순종"),
            VideoTag(name: "도전")
        ])
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
