//
//  DefaultCreateDiaryUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/28/25.
//

import RxRelay

final class DefaultCreateDiaryUseCase: CreateDiaryUseCase {
    var createDiaryResult = PublishRelay<Bool>()
    
    func createDiary(title: String, content: String, selectedKeywords: [DiaryKeyword], shareOptions: [DiaryShareOption]) {
        // TODO: - 일기장 생성에 따른 등록된 이미지 처리 필요
        
        print("작성된 일기장 제목: \(title)\n작성된 일기장 내용: \(content)\n작성된 일기장 키워드들: \(selectedKeywords)\n작성된 일기장 공유목록: \(shareOptions)")
        
        let result = [true, false].shuffled()[0]
        createDiaryResult.accept(result)
    }
}
