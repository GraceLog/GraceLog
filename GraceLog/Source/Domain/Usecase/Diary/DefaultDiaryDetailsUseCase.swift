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
    
    init(
        diaryRepository: DiaryRepository,
        diaryId: Int
    ) {
        self.diaryRepository = diaryRepository
        self.diaryId = diaryId
        
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
    
    func fetchSelectedDateDiaryDetails(startDate: String, endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            selectedDateDiaryList.accept([])
            return
        }
        
        diaryRepository.fetchMyDiaryList(startDate: start, endDate: end)
            .subscribe(onSuccess: { diaryList in
                self.selectedDateDiaryList.accept(diaryList)
            }, onFailure: { error in
                self.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func likeDiary(id: Int) {
        print("좋아요한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        likeDiaryResult.accept(result)
    }
    
    func unlikeDiary(id: Int) {
        print("좋아요 해제한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        unlikeDiaryResult.accept(result)
    }
}
