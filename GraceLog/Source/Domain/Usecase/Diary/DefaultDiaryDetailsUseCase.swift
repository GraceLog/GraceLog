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
    var postDateList = BehaviorRelay<[DiaryExistenceDate]>(value: [])
    var toggleDiaryResult = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
    
    private let diaryId: Int
    private var communityId: Int?
    private var memberId: Int?
    
    init(
        diaryRepository: DiaryRepository,
        likeRepository: LikeRepository,
        diaryId: Int,
        communityId: Int?,
        memberId: Int?
    ) {
        self.diaryRepository = diaryRepository
        self.likeRepository = likeRepository
        self.diaryId = diaryId
        self.communityId = communityId
        self.memberId = memberId
        
        fetchDiaryDetails(diaryId: diaryId)
    }
    
    /// 일기 상세 정보를 조회하고 해당 월의 일기 목록을 자동으로 로드합니다.
    ///
    /// **동작 순서:**
    /// 1. 일기 ID로 단일 일기 상세 정보 조회
    /// 2. 조회한 일기의 생성날짜를 통해 해달 달에 유저가 해당 공동체에 공유한 날짜들을 조회(자신인 경우 공동체에 공유한 일기뿐 아니라 전체 조회)
    /// 4. 캘린더에 마커된 날짜 클릭시 해당 날짜에 작성한 일기 리스트 조회(현재는 하루에 한개만 작성 가능하므로 first값)
    func fetchDiaryDetails(diaryId: Int) {
        diaryRepository.fetchDiary(diaryId: diaryId)
            .subscribe(onSuccess: { diary in
                self.diary.accept(diary)
            }, onFailure: { error in
                self.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchDiaryPostDateList(date: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let (startDate, endDate) = DateFormatterFactory.getMonthDateRange(year: year, month: month)
        
        diaryRepository.fetchDiaryExistenceDates(
            startDate: startDate,
            endDate: endDate,
            communityId: communityId,
            memberId: memberId,
            cursorId: nil,
            size: nil
        )
        .subscribe(onSuccess: {
            self.postDateList.accept($0)
        }, onFailure: {
            self.error.accept($0)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchDateRangeDiaryList(date: String) {
        guard let memberId = memberId else { return }
        
        diaryRepository.fetchDateRangeMemberDiaryList(
            startDate: date,
            endDate: date,
            memberId: memberId, communityId: communityId,
            cursorId: nil,
            size: 1
        )
        .subscribe(onSuccess: { diaryList in
            guard let diary = diaryList.first else { return }
            self.diary.accept(diary)
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
