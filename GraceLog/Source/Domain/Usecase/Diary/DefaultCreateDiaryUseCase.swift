//
//  DefaultCreateDiaryUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/28/25.
//

import RxRelay

final class DefaultCreateDiaryUseCase: CreateDiaryUseCase {
    var createDiaryResult = PublishRelay<Bool>()
    
    func createDiary() {
        let result = [true, false].shuffled()[0]
        createDiaryResult.accept(result)
    }
}
