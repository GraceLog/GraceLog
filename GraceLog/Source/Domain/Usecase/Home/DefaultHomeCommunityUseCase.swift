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
    var communityList = BehaviorRelay<[Community]>(value: [])
    var likeDiaryResult = PublishRelay<Bool>()
    var unlikeDiaryResult = PublishRelay<Bool>()
    var hasMoreDiaries = BehaviorRelay<Bool>(value: true)
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    private let homeRepository: HomeRepository
    private let pageSize = 10
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchDiaryList(communityId: Int, cursorId: Int?, isLoadMore: Bool = false) {
        if !isLoadMore {
            diaryList.accept([])
            hasMoreDiaries.accept(true)
        }
        
        homeRepository.fetchHomeCommunityDiaryList(communityId: communityId, cursorId: cursorId, size: pageSize)
            .subscribe(onSuccess: { [weak self] newDiaries in
                guard let self = self else { return }
                
                let hasMore = newDiaries.count >= self.pageSize
                self.hasMoreDiaries.accept(hasMore)
                
                if isLoadMore {
                    var currentList = self.diaryList.value
                    currentList.append(contentsOf: newDiaries)
                    self.diaryList.accept(currentList)
                } else {
                    self.diaryList.accept(newDiaries)
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
    
    func likeDiary(id: Int) {
        updateDiaryLikeStatus(id: id, isLiked: true)
        
        homeRepository.likeToggle(postId: id)
            .subscribe(onSuccess: {
                self.likeDiaryResult.accept($0)
            }, onFailure: {
                self.updateDiaryLikeStatus(id: id, isLiked: false)
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func unlikeDiary(id: Int) {
        self.updateDiaryLikeStatus(id: id, isLiked: false)
        
        homeRepository.likeToggle(postId: id)
            .subscribe(onSuccess: {
                self.unlikeDiaryResult.accept($0)
            }, onFailure: {
                self.updateDiaryLikeStatus(id: id, isLiked: true)
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateDiaryLikeStatus(id: Int, isLiked: Bool) {
        var updatedList = diaryList.value
        if let index = updatedList.firstIndex(where: { $0.id == id }) {
            var diary = updatedList[index]
            diary.isLiked = isLiked
            diary.likeCount += isLiked ? 1 : -1
            updatedList[index] = diary
            diaryList.accept(updatedList)
        }
    }
}
