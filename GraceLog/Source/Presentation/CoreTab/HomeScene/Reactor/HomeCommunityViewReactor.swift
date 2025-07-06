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
        case selectCommunity(item: CommunityItem)
    }
    
    enum Mutation {
        case setCommunityIndex(CommunityItem)
        case setHomeCommunityData(HomeCommunityContent)
    }
    
    struct State {
        var selectedCommunity: CommunityItem?
        var homeCommunityData: HomeCommunityContent?
        var communitySections: [(date: String, items: [CommunityDiaryItem])] = []
        
        var sections: [HomeSectionModel] {
            guard let communityData = homeCommunityData else {
                return []
            }
            
            let communityItems = communityData.communityList.map { item in
                return CommunityItem(
                    imageName: item.imageName,
                    title: item.title,
                    isSelected: item.isSelected
                )
            }
            
            var sections: [HomeSectionModel] = [
                .communityButtons(communityItems)
            ]
            
            for sectionData in communityData.diaryList {
                let items = sectionData.items.map { item in
                    return CommunityDiaryItem(
                        type: item.type,
                        username: item.username,
                        title: item.title,
                        subtitle: item.subtitle,
                        likes: item.likes,
                        comments: item.comments
                    )
                }
                sections.append(.communityPosts(sectionData.date, items))
            }
            return sections
        }
    }
    
    let initialState: State = State()
}

extension HomeCommunityViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectCommunity(let model):
            return .just(.setCommunityIndex(model))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCommunityIndex(let selectedModel):
            newState.selectedCommunity = selectedModel
        case .setHomeCommunityData(let data):
            newState.homeCommunityData = data
        }
        
        return newState
    }
}
