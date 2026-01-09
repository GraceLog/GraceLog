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
    var dateRangeDiaries = BehaviorRelay<[DiaryDetails]>(value: [])
    var likeDiaryResult = PublishRelay<(Bool, Int)>()
    var unlikeDiaryResult = PublishRelay<(Bool, Int)>()
    var error = PublishRelay<Error>()
    
    private let communityId: Int
    private let memberId: Int
    
    init(
        /// TODO: - 공동체 아이디, 유저 아이디 추후 주입 필요
        diaryRepository: DiaryRepository,
        communityId: Int,
        memberId: Int
    ) {
        self.diaryRepository = diaryRepository
        self.communityId = communityId
        self.memberId = memberId
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
    
    func fetchDateRangeDiaryList(
        startDate: String,
        endDate: String
    ) {
        let mockUsers: [GraceLogUser] = [
            GraceLogUser(
                id: 1,
                name: "이건준",
                nickname: "geonjun",
                profileImageURL: URL(string: "https://example.com/profile1.png"),
                email: "geonjun@example.com",
                message: "오늘도 기록합니다."
            ),
            GraceLogUser(
                id: 2,
                name: "김지희",
                nickname: "jihui",
                profileImageURL: URL(string: "https://example.com/profile2.png"),
                email: "jihui@example.com",
                message: "소소한 일상의 기록"
            ),
            GraceLogUser(
                id: 3,
                name: "박민수",
                nickname: "minsoo",
                profileImageURL: URL(string: "https://example.com/profile3.png"),
                email: "minsoo@example.com",
                message: "개발과 일상의 균형"
            ),
            GraceLogUser(
                id: 4,
                name: "최서연",
                nickname: "seoyeon",
                profileImageURL: nil,
                email: "seoyeon@example.com",
                message: "비 오는 날을 좋아해요"
            ),
            GraceLogUser(
                id: 5,
                name: "테스트유저",
                nickname: "tester",
                profileImageURL: nil,
                email: "tester@example.com",
                message: "임시 계정입니다"
            )
        ]
        let mockDiaryDetailsList: [DiaryDetails] = [
            DiaryDetails(
                diaryId: 1,
                title: "첫 번째 일기",
                description: "오늘은 날씨가 좋아서 산책을 다녀왔다.",
                user: mockUsers[0],
                imageURLs: [
                    URL(string: "https://example.com/image1.png")
                ],
                likeCount: 12,
                likeByMe: true,
                isHideLike: false,
                isHideComment: false,
                commentCount: 3,
                createdAt: Calendar.current.date(
                    from: DateComponents(year: 2025, month: 3, day: 10, hour: 9)
                )
            ),
            DiaryDetails(
                diaryId: 2,
                title: "두 번째 일기",
                description: "점심에 맛있는 파스타를 먹었다.",
                user: mockUsers[1],
                imageURLs: [
                    URL(string: "https://example.com/image2.png"),
                    URL(string: "https://example.com/image3.png")
                ],
                likeCount: 8,
                likeByMe: false,
                isHideLike: false,
                isHideComment: false,
                commentCount: 1,
                createdAt: Calendar.current.date(
                    from: DateComponents(year: 2025, month: 3, day: 10, hour: 21)
                )
            ),
            DiaryDetails(
                diaryId: 3,
                title: "세 번째 일기",
                description: "프로젝트 마감 때문에 하루 종일 코딩했다.",
                user: mockUsers[2],
                imageURLs: [],
                likeCount: 20,
                likeByMe: true,
                isHideLike: false,
                isHideComment: false,
                commentCount: 5,
                createdAt: Calendar.current.date(
                    from: DateComponents(year: 2025, month: 3, day: 11, hour: 1)
                )
            ),
            DiaryDetails(
                diaryId: 4,
                title: "네 번째 일기",
                description: "비 오는 날이라 집에서 책을 읽었다.",
                user: mockUsers[3],
                imageURLs: [
                    URL(string: "https://example.com/image4.png")
                ],
                likeCount: 5,
                likeByMe: false,
                isHideLike: false,
                isHideComment: true,
                commentCount: 0,
                createdAt: Calendar.current.date(
                    from: DateComponents(year: 2026, month: 2, day: 12, hour: 14)
                )
            ),
            DiaryDetails(
                diaryId: 5,
                title: "날짜 없는 일기",
                description: "임시 저장된 일기라 날짜가 없다.",
                user: mockUsers[4],
                imageURLs: [],
                likeCount: 0,
                likeByMe: false,
                isHideLike: true,
                isHideComment: true,
                commentCount: 0,
                createdAt: Calendar.current.date(
                    from: DateComponents(year: 2026, month: 1, day: 4, hour: 14)
                )
            )
        ]


        dateRangeDiaries.accept(mockDiaryDetailsList)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        guard let start = dateFormatter.date(from: startDate),
//              let end = dateFormatter.date(from: endDate) else {
//            dateRangeDiaries.accept([])
//            return
//        }
//        
//        diaryRepository.fetchDateRangeDiaryList(
//            startDate: start,
//            endDate: end,
//            communityId: communityId,
//            memberId: memberId
//        )
//        .subscribe(onSuccess: { diaryList in
//            self.dateRangeDiaries.accept(diaryList)
//        }, onFailure: { error in
//            self.error.accept(error)
//        })
//        .disposed(by: disposeBag)
    }
    
    func likeDiary(id: Int) {
        likeDiaryResult.accept((true, id))
//        diaryRepository.likeToggle(postId: id)
//            .subscribe(onSuccess: { result in
//                self.likeDiaryResult.accept((result, id))
//            }, onFailure: { error in
//                self.error.accept(error)
//            })
//            .disposed(by: disposeBag)
    }
    
    func unlikeDiary(id: Int) {
        likeDiaryResult.accept((false, id))
//        diaryRepository.likeToggle(postId: id)
//            .subscribe(onSuccess: { result in
//                self.likeDiaryResult.accept((result, id))
//            }, onFailure: { error in
//                self.error.accept(error)
//            })
//            .disposed(by: disposeBag)
    }
}
