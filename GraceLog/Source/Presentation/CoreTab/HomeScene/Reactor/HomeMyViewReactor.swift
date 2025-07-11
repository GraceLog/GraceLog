//
//  HomeMyViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 6/22/25.
//

import Foundation
import ReactorKit
import RxDataSources

final class HomeMyViewReactor: Reactor {
    private let homeUsecase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
        loadData()
    }
    
    private func loadData() {
        homeUsecase.fetchDiaryList()
        homeUsecase.fetchVideoList()
    }
    
    enum Mutation {
        case setDiaryList([MyDiaryItem])
        case setVideoList([HomeVideoItem])
        case setError(Error)
    }
    
    struct State {
        var videoItems: [HomeVideoItem] = []
        var diaryItems: [MyDiaryItem] = []
        @Pulse var errorMessage: String?
    }
    
    let initialState: State = State()
}

extension HomeMyViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let diaryMutation = homeUsecase.diaryList
            .map { Mutation.setDiaryList($0) }
        
        let videoMutation = homeUsecase.videoList
            .map { Mutation.setVideoList($0) }
        
        return Observable.merge(mutation, diaryMutation, videoMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDiaryList(let diaryList):
            newState.diaryItems = diaryList
        case .setVideoList(let videoList):
            newState.videoItems = videoList
        case .setError(let error):
            newState.errorMessage = error.localizedDescription
        }
        return newState
    }
}
