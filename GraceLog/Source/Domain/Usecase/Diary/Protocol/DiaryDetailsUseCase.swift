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
    var likeDiaryResult: PublishRelay<(Bool, Int)> { get }
    var unlikeDiaryResult: PublishRelay<(Bool, Int)> { get }
    
    func fetchDiaryDetails(diaryId: Int)
    func fetchDateRangeDiaryList(startDate: String, endDate: String)
    func likeDiary(id: Int)
    func unlikeDiary(id: Int)
}
