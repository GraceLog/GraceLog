//
//  DiaryReadUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 10/4/25.
//

import RxRelay

protocol DiaryDetailsUseCase {
    var diary: PublishRelay<DiaryDetails> { get }
    var postDateList: BehaviorRelay<[DiaryExistenceDate]> { get }
    var toggleDiaryResult: PublishRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
    
    func fetchDiaryDetails(diaryId: Int)
    func fetchDiaryPostDateList(date: Date)
    func fetchDateRangeDiaryList(date: String)
    func toggleDiaryLike(id: Int)
}
