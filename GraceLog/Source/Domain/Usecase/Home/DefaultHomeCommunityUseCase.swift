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
    private let homeRepository: HomeRepository
    
    private let pageSize = 10
    private var currentCursorId: Int?
    private var currentCommunityId: Int?
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchDiaryList(communityId: Int) {
        if currentCommunityId != communityId {
            resetDiaryList(communityId: communityId)
        }
        
        guard !isLastPage.value else { return }
        
        let isFirstPage = currentCursorId == nil
        
        homeRepository.fetchHomeCommunityDiaryList(
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
        homeRepository.fetchMyCommunityList()
            .subscribe(onSuccess: {
                self.communityList.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleDiaryLike(id: Int) {
        updateDiaryLikeStatusByToggle(id: id)
        
        homeRepository.likeToggle(postId: id)
            .subscribe(onSuccess: { _ in
                self.toggleDiaryResult.accept(true)
            }, onFailure: {
                self.updateDiaryLikeStatusByToggle(id: id)
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}

extension DefaultHomeCommunityUseCase {
    private func resetDiaryList(communityId: Int) {
        diaryList.accept([])
        isLastPage.accept(false)
        currentCursorId = nil
        currentCommunityId = communityId
    }
    
    private func updateDiaryLikeStatusByToggle(id: Int) {
        var updatedList = diaryList.value
        if let index = updatedList.firstIndex(where: { $0.id == id }) {
            var diary = updatedList[index]
            let currentStatus = diary.isLiked
            
            diary.isLiked = !currentStatus
            diary.likeCount += diary.isLiked ? 1 : -1
            
            updatedList[index] = diary
            diaryList.accept(updatedList)
        }
    }
}
