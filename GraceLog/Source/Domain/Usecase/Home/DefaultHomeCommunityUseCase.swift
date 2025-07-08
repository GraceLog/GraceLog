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
    var homeCommunityData = BehaviorSubject<HomeCommunityContent?>(value: nil)
    var likeDiaryResult = PublishRelay<Bool>()
    var unlikeDiaryResult = PublishRelay<Bool>()
    var error = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchHomeCommunityContent() {
        homeRepository.fetchHomeCommunityContent()
            .subscribe(
                onSuccess: { data in
                    self.homeCommunityData.onNext(data)
                },
                onFailure: { err in
                    self.error.onError(err)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func likeDiary(id: Int) {
        // TODO: - 감사일기 좋아요에 대한 서버 연동
        print("좋아요한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        likeDiaryResult.accept(result)
    }
    
    func unlikeDiary(id: Int) {
        // TODO: - 감사일기 좋아요 해제에 대한 서버 연동
        print("좋아요 해제한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        unlikeDiaryResult.accept(result)
    }
}
