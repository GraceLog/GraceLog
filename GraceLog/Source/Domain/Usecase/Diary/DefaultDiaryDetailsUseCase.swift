//
//  DefaultDiaryDetailsUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 10/5/25.
//

import RxRelay
import RxSwift

final class DefaultDiaryDetailsUseCase: DiaryDetailsUseCase {
    private let diaryRepository: DiaryRepository
    
    private let disposeBag = DisposeBag()
    
    var diary = PublishRelay<DiaryDetails>()
    var selectedDateDiaryList = BehaviorRelay<[DiaryDetails]>(value: [])
    var likeDiaryResult = PublishRelay<Bool>()
    var unlikeDiaryResult = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
    
    private let diaryId: Int
    private let communityId: Int
    private let memberId: Int
    
    init(
        diaryRepository: DiaryRepository,
        diaryId: Int,
        communityId: Int,
        memberId: Int
    ) {
        self.diaryRepository = diaryRepository
        self.diaryId = diaryId
        self.communityId = communityId
        self.memberId = memberId
        
        fetchDiaryDetails(diaryId: diaryId)
    }
    
    func fetchDiaryDetails(diaryId: Int) {
        diaryRepository.fetchDiary(diaryId: diaryId)
            .subscribe(onSuccess: { diary in
                self.diary.accept(diary)
            }, onFailure: { error in
                self.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchDateRangeDiaryList(
        startDate: String,
        endDate: String
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            selectedDateDiaryList.accept([])
            return
        }
        
        diaryRepository.fetchDateRangeDiaryList(
            startDate: start,
            endDate: end,
            communityId: communityId,
            memberId: memberId
        )
        .subscribe(onSuccess: { diaryList in
            self.selectedDateDiaryList.accept(diaryList)
        }, onFailure: { error in
            self.error.accept(error)
        })
        .disposed(by: disposeBag)
    }
    
    func likeDiary(id: Int) {
        diaryRepository.likeToggle(postId: id)
            .subscribe(onSuccess: { result in
                self.likeDiaryResult.accept(result)
            }, onFailure: { error in
                self.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func unlikeDiary(id: Int) {
        diaryRepository.likeToggle(postId: id)
            .subscribe(onSuccess: { result in
                self.likeDiaryResult.accept(result)
            }, onFailure: { error in
                self.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
