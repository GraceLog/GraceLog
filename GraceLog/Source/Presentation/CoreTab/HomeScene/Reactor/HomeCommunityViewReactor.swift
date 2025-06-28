//
//  HomeCommunityViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 6/22/25.
//

import Foundation
import ReactorKit
import RxDataSources

final class HomeCommunityViewReactor: Reactor {
    private let homeUsecase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
        loadData()
    }
    
    private func loadData() {
        homeUsecase.fetchHomeCommunityContent()
    }
    
    enum Action {
        case selectCommunity(id: Int)
    }
    
    enum Mutation {
        case setCommunitys([CommunityItem])
        case setSelectedCommunityId(Int)
    }
    
    struct State {
        @Pulse var communitys: [CommunityItem] = []
    }
    
    let initialState = State()
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
        loadData()
    }
    
    private func loadData() {
        homeUsecase.fetchHomeCommunityContent()
    }
}

extension HomeCommunityViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectCommunity(let id):
            return .just(.setSelectedCommunityId(id))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let communityData = homeUsecase.homeCommunityData
            .compactMap { $0 }
            .map { Mutation.setCommunitys($0.communityList) }
        
        return Observable.merge(mutation, communityData)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCommunitys(let communitys):
            newState.communitys = communitys
            
            if newState.selectedCommunityId == nil && !communitys.isEmpty {
                newState.selectedCommunityId = communitys[0].id
            }
            
        case.setSelectedCommunityId(let id):
            newState.selectedCommunityId = id
        }
        
        return newState
    }
}
