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
    
    enum Action {
        case selectCommunity(id: Int)
    }
    
    enum Mutation {
        case setCommunitys([CommunityItem])
        case setSelectedCommunityId(Int)
        case setCommunityDiarys([HomeCommunityDiarySection])
    }
    
    struct State {
        @Pulse var communitys: [CommunityItem] = []
        @Pulse var communityDiarySections: [HomeCommunityDiarySection] = []
        var selectedCommunityId: Int?
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
        
        let diaryData = homeUsecase.homeCommunityData
            .compactMap { $0 }
            .map { homeCommunityContent in
                let diarySections = HomeCommunityDiarySection.makeSections(
                    from: homeCommunityContent.diaryList
                )
                return Mutation.setCommunityDiarys(diarySections)
            }
        
        return Observable.merge(mutation, communityData, diaryData)
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
        case .setCommunityDiarys(let diarySections):
            newState.communityDiarySections = diarySections
        }
        
        return newState
    }
}
