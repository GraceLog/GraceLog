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
        homeUsecase.fetchHomeMyContent()
    }
    
    enum Mutation {
        case setHomeMyData(HomeContent)
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
        let data = homeUsecase.homeMyData
            .compactMap { $0 }
            .map { Mutation.setHomeMyData($0) }
        
        return Observable.merge(mutation, data)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setHomeMyData(let data):
            newState.videoItems = data.videoList
            newState.diaryItems = data.diaryList
        case .setError(let error):
            newState.errorMessage = error.localizedDescription
        }
        return newState
    }
}
