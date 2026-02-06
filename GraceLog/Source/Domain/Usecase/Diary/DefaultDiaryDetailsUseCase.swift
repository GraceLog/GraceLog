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
    private let likeRepository: LikeRepository
    
    private let disposeBag = DisposeBag()
    
    var diary = PublishRelay<DiaryDetails>()
    var dateRangeDiaries = BehaviorRelay<[DiaryDetails]>(value: [])
    var toggleDiaryResult = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
    
    private let diaryId: Int
    private var communityId: Int?
    private var memberId: Int?
    
    init(
        diaryRepository: DiaryRepository,
        likeRepository: LikeRepository,
        diaryId: Int
    ) {
        self.diaryRepository = diaryRepository
        self.likeRepository = likeRepository
        self.diaryId = diaryId
        
        fetchDiaryDetails(diaryId: diaryId)
    }
    
    /// 일기 상세 정보를 조회하고 해당 월의 일기 목록을 자동으로 로드합니다.
    ///
    /// **동작 순서:**
    /// 1. 일기 ID로 단일 일기 상세 정보 조회
    /// 2. communityId와 memberId 저장
    /// 3. 작성 날짜(createdAt)를 기준으로 해당 월의 모든 일기 목록 조회(캘린더 마커 표시용)
    /// 4. 일기 상세 정보를 Relay로 전달
    func fetchDiaryDetails(diaryId: Int) {
        diaryRepository.fetchDiary(diaryId: diaryId)
            .subscribe(onSuccess: { diary in
                self.communityId = diary.communityId
                self.memberId = diary.user.id
                self.diary.accept(diary)
            }, onFailure: { error in
                self.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchDateRangeDiaryList(date: Date) {
        guard let memberId = memberId else { return }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let (startDate, endDate) = DateFormatterFactory.getMonthDateRange(year: year, month: month)
        
        diaryRepository.fetchDateRangeDiaryList(
            startDate: startDate,
            endDate: endDate,
            communityId: communityId,
            memberId: memberId
        )
        .subscribe(onSuccess: { diaryList in
            self.dateRangeDiaries.accept(diaryList)
        }, onFailure: { error in
            self.error.accept(error)
        })
        .disposed(by: disposeBag)
    }
    
    func toggleDiaryLike(id: Int) {
        likeRepository.likeToggle(postId: id)
            .subscribe(onSuccess: { _ in
                self.toggleDiaryResult.accept(true)
            }, onFailure: {
                self.toggleDiaryResult.accept(false)
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
