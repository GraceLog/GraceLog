//
//  DefaultHomePersonalUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultHomePersonalUseCase: HomePersonalUseCase {
    var dailyVerse = BehaviorRelay<DailyVerse?>(value: nil)
    var diaryList = BehaviorRelay<[MyDiaryPreview]>(value: [])
    var videoList = BehaviorRelay<[RecommendedVideo]>(value: [])
    var videoTagList = BehaviorRelay<[String]>(value: [])
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let dailyVerseRepository: DailyVerseRepository
    private let diaryRepository: DiaryRepository
    private let videoRepository: VideoRepository
    
    init(
        dailyVerseRepository: DailyVerseRepository,
        diaryRepository: DiaryRepository,
        videoRepository: VideoRepository
    ) {
        self.dailyVerseRepository = dailyVerseRepository
        self.diaryRepository = diaryRepository
        self.videoRepository = videoRepository
    }
    
    func fetchDiaryList() {
        diaryRepository.fetchMyDiaryList()
            .subscribe(onSuccess: {
                self.diaryList.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchVideoList() {
        videoRepository.fetchVideoList()
            .subscribe(onSuccess: {
                self.videoTagList.accept($0.tags)
                self.videoList.accept($0.videoList)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
        
    }
    
    func fetchDailyVerse() {
        dailyVerseRepository.fetchDailyVerse()
            .subscribe(onSuccess: {
                self.dailyVerse.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
