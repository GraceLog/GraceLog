//
//  DefaultCommunityGroupUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import RxSwift
import RxRelay

final class DefaultCommunityGroupUseCase: CommunityGroupUseCase {
    var latestCommunityDiaryExistenceDate = BehaviorRelay<Date?>(value: nil)
    var diaryExistenceDates = BehaviorRelay<[DiaryExistenceDate]>(value: [])
    var communityDiaryList = BehaviorRelay<[CommunityDiaryPreview]>(value: [])
    var isLastPage = BehaviorRelay<Bool>(value: false)
    var toggleDiaryResult = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let diaryRepository: DiaryRepository
    private let likeRepository: LikeRepository
    private let communityId: Int
    private let pageSize = 3
    private var currentCursorId: Int?
    private var lastFetchedDate: String?
    
    init(
        diaryRepository: DiaryRepository,
        likeRepository: LikeRepository,
        communityId: Int
    ) {
        self.diaryRepository = diaryRepository
        self.likeRepository = likeRepository
        self.communityId = communityId
    }
    
    func fetchLatestCommunityDiaryExistenceDate() {
        diaryRepository.fetchDiaryLastPostDate(communityId: communityId)
            .subscribe(onSuccess: {
                self.latestCommunityDiaryExistenceDate.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchCommunityDiaryExistenceDates(date: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let (startDate, endDate) = DateFormatterFactory.getMonthDateRange(year: year, month: month)
        
        diaryRepository.fetchDiaryExistenceDates(
            startDate: startDate,
            endDate: endDate,
            communityId: communityId,
            memberId: nil,
            cursorId: nil,
            size: nil
        )
        .subscribe(onSuccess: {
            self.diaryExistenceDates.accept($0)
        }, onFailure: {
            self.error.accept($0)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchCommunityDiaryList(date: String) {
        if lastFetchedDate != date {
            resetDiaryList()
            lastFetchedDate = date
        }
        loadNextPage()
    }
    
    func loadNextPage() {
        guard !isLastPage.value, let currentDate = lastFetchedDate else { return }
        
        let isFirstPage = currentCursorId == nil
        
        diaryRepository.fetchDateRangeCommunityDiaryList(
            startDate: currentDate,
            endDate: currentDate,
            communityId: communityId,
            memberId: nil,
            cursorId: currentCursorId,
            size: pageSize
        )
        .subscribe(onSuccess: {
            self.isLastPage.accept($0.isLastPage)
            
            if !$0.isLastPage {
                self.currentCursorId = $0.diaryList.last?.id
            }
            
            if isFirstPage {
                self.communityDiaryList.accept($0.diaryList)
            } else {
                var currentList = self.communityDiaryList.value
                currentList.append(contentsOf: $0.diaryList)
                self.communityDiaryList.accept(currentList)
            }
        }, onFailure: {
            self.error.accept($0)
        })
        .disposed(by: disposeBag)
    }
    
    func toggleDiaryLike(id: Int) {
        likeRepository.likeToggle(postId: id)
            .subscribe(onSuccess: { _ in
                self.toggleDiaryResult.accept(true)
                self.updateDiaryLikeStatus(id: id)
            }, onFailure: {
                self.toggleDiaryResult.accept(false)
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}

extension DefaultCommunityGroupUseCase {
    func resetDiaryList() {
        communityDiaryList.accept([])
        isLastPage.accept(false)
        currentCursorId = nil
    }
    
    private func updateDiaryLikeStatus(id: Int) {
        var updatedList = communityDiaryList.value
        if let index = updatedList.firstIndex(where: { $0.id == id }) {
            var diary = updatedList[index]
            diary.isLiked.toggle()
            diary.likeCount = diary.isLiked ? diary.likeCount + 1 : max(0, diary.likeCount - 1)
            
            updatedList[index] = diary
            communityDiaryList.accept(updatedList)
        }
    }
}
