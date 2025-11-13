//
//  DiaryReadUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 10/4/25.
//

import RxRelay

protocol DiaryDetailsUseCase {
    var diary: PublishRelay<DiaryDetails> { get }
    var selectedDateDiaryList: BehaviorRelay<[DiaryDetails]> { get }
    var likeDiaryResult: PublishRelay<Bool> { get }
    var unlikeDiaryResult: PublishRelay<Bool> { get }
    
    func fetchDiaryDetails(diaryId: Int)
    func fetchSelectedDateDiaryDetails(startDate: String, endDate: String)
    func likeDiary(id: Int)
    func unlikeDiary(id: Int)
}
