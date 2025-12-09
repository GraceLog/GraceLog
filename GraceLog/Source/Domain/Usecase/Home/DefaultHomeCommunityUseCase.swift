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
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchDiaryList(communityId: Int, cursorId: Int?) {
        diaryList.accept([])
        
        homeRepository.fetchHomeCommunityDiaryList(communityId: communityId, cursorId: cursorId, size: 10)
            .subscribe(onSuccess: {
                self.diaryList.accept($0)
            }, onFailure: {
                self.error.accept($0)
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
        homeRepository.likeToggle(postId: id)
            .subscribe(onSuccess: {
                self.likeDiaryResult.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func unlikeDiary(id: Int) {
        homeRepository.likeToggle(postId: id)
            .subscribe(onSuccess: {
                self.unlikeDiaryResult.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
