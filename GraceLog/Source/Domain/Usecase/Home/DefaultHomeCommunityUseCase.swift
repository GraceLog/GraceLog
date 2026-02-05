//
//  DefaultHomeCommunityUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 7/6/25.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultHomeCommunityUseCase: HomeCommunityUseCase {
    var diaryList = BehaviorRelay<[CommunityDiaryPreview]>(value: [])
    var isLastPage = BehaviorRelay<Bool>(value: false)
    var communityList = BehaviorRelay<[Community]>(value: [])
    var toggleDiaryResult = PublishRelay<Bool>()
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let diaryRepository: DiaryRepository
    private let communityRepository: CommunityRepository
    private let likeRepository: LikeRepository
    
    private let pageSize = 10
    private var currentCursorId: Int?
    
    init(
        diaryRepository: DiaryRepository,
        communityRepository: CommunityRepository,
        likeRepository: LikeRepository
    ) {
        self.diaryRepository = diaryRepository
        self.communityRepository = communityRepository
        self.likeRepository = likeRepository
    }
    
    func fetchDiaryList(communityId: Int) {
        guard !isLastPage.value else { return }
        
        let isFirstPage = currentCursorId == nil
        
        diaryRepository.fetchCommunityDiaryList(
            communityId: communityId,
            cursorId: currentCursorId,
            size: pageSize
        )
        .subscribe(onSuccess: {
            self.isLastPage.accept($0.isLastPage)
            
            if !$0.isLastPage {
                self.currentCursorId = $0.diaryList.last?.id
            }
            
            if isFirstPage {
                self.diaryList.accept($0.diaryList)
            } else {
                var currentList = self.diaryList.value
                currentList.append(contentsOf: $0.diaryList)
                self.diaryList.accept(currentList)
            }
        }, onFailure: { [weak self] error in
            self?.error.accept(error)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchCommunityList() {
        communityRepository.fetchMyCommunityList()
            .subscribe(onSuccess: {
                self.communityList.accept($0)
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

extension DefaultHomeCommunityUseCase {
    func resetDiaryListWithPagination() {
        diaryList.accept([])
        isLastPage.accept(false)
        currentCursorId = nil
    }
    
    private func updateDiaryLikeStatus(id: Int) {
        var updatedList = diaryList.value
        if let index = updatedList.firstIndex(where: { $0.id == id }) {
            var diary = updatedList[index]
            diary.isLiked.toggle()
            diary.likeCount = diary.isLiked ? diary.likeCount + 1 : max(0, diary.likeCount - 1)
            
            updatedList[index] = diary
            diaryList.accept(updatedList)
        }
    }
}
