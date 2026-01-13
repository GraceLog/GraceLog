//
//  DiaryReadUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 10/4/25.
//

import RxRelay

protocol DiaryDetailsUseCase {
    var diary: PublishRelay<DiaryDetails> { get }
    var dateRangeDiaries: BehaviorRelay<[DiaryDetails]> { get }
    var likeDiaryResult: PublishRelay<Bool> { get }
    var unlikeDiaryResult: PublishRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    
    func fetchDiaryDetails(diaryId: Int)
    func fetchDateRangeDiaryList(date: Date)
    func likeDiary(id: Int)
    func unlikeDiary(id: Int)
}
