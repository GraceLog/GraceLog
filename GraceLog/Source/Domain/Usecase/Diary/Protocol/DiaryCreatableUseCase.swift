//
//  CreateDiaryUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/30/25.
//

import RxRelay

protocol DiaryCreatableUseCase {
    var createDiaryResult: PublishRelay<Bool> { get }
    
    func createDiary(title: String, content: String, selectedKeywords: [DiaryKeyword], shareOptions: [DiaryShareOption])
}
