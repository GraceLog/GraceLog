//
//  HomeViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 2/23/25.
//

import Foundation
import ReactorKit
import RxDataSources

final class HomeViewReactor: Reactor {
    private let homeUsecase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
        loadData()
    }
    
    private func loadData() {
        homeUsecase.fetchHomeMyContent()
        homeUsecase.fetchHomeCommunityContent()
        homeUsecase.fetchUser()
    }
    
    enum Action {
        case userButtonTapped
        case groupButtonTapped
        case selectCommunity(item: CommunityItem)
        case updateUser(GraceLogUser)
    }
    
    enum Mutation {
        case setSegment(State.HomeModeSegment)
        case setCommunityIndex(CommunityItem)
        case setHomeMyData(HomeContent)
        case setHomeCommunityData(HomeCommunityContent)
        case setError(Error)
        case setUser(GraceLogUser)
    }
    
    struct State {
        
        // FIXME: - 추후 다른 Reactor통해 구분지을 예정, 이후 삭제
        enum HomeModeSegment {
            case user
            case group
        }
        
        var currentSegment: HomeModeSegment = .user
        var selectedCommunity: CommunityItem?
        var homeMyData: HomeContent?
        var homeCommunityData: HomeCommunityContent?
        var communitySections: [(date: String, items: [CommunityDiaryItem])] = []
        var communityButtons: [String] = []
        var error: Error?
        var user: GraceLogUser? = nil
        
        var sections: [HomeSectionModel] {
            switch currentSegment {
            case .user:
                guard let myData = homeMyData else {
                    return []
                }
                
                let diaryItems = myData.diaryList.map { item in
                    return MyDiaryItem(
                        date: item.date,
                        dateDesc: item.dateDesc,
                        title: item.title,
                        desc: item.desc,
                        tags: item.tags,
                        image: item.image
                    )
                }
                
                let contentItems = myData.videoList.map { item in
                    return HomeVideoItem(
                        title: item.title,
                        imageName: item.imageName
                    )
                }
                
                return [
                    .diary(diaryItems),
                    .contentList(contentItems)
                ]
                
            case .group:
                guard let communityData = homeCommunityData else {
                    return []
                }
                
                let buttonItems = communityData.communityList.map { item in
                    return CommunityItem(
                        imageName: item.imageName, title: item.title, isSelected: item.isSelected
                    )
                }
                
                var sections: [HomeSectionModel] = [
                    .communityButtons(buttonItems)
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
    }
    let initialState: State = State()
}

extension HomeViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let myDataMutation = homeUsecase.homeMyData
            .compactMap { $0 }
            .map { Mutation.setHomeMyData($0) }
        
        let communityDataMutation = homeUsecase.homeCommunityData
            .compactMap { $0 }
            .map { Mutation.setHomeCommunityData($0) }
        
        let userMutation = homeUsecase.user
            .compactMap { $0 }
            .map { Mutation.setUser($0) }
        
        let errorMutation = homeUsecase.error
            .map { Mutation.setError($0) }
        
        return Observable.merge(
            mutation,
            myDataMutation,
            communityDataMutation,
            userMutation,
            errorMutation
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .userButtonTapped:
            return .just(.setSegment(.user))
        case .groupButtonTapped:
            return .just(.setSegment(.group))
        case .selectCommunity(let model):
            return .just(.setCommunityIndex(model))
        case .updateUser(let user):
            return .just(.setUser(user))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSegment(let segment):
            newState.currentSegment = segment
        case .setCommunityIndex(let selectedModel):
            newState.selectedCommunity = selectedModel
            newState = updateCommunitySelectionState(in: newState, with: selectedModel)
        case .setHomeMyData(let data):
            newState.homeMyData = data
        case .setHomeCommunityData(let data):
            newState.homeCommunityData = data
            
            if let firstCommunity = data.communityList.first {
                newState.selectedCommunity = firstCommunity
                newState = updateCommunitySelectionState(in: newState, with: firstCommunity)
            }
        case .setError(let error):
            newState.error = error
        case .setUser(let user):
            newState.user = user
        }
        return newState
    }
     
    private func updateCommunitySelectionState(in state: State, with selectedModel: CommunityItem) -> State {
        var newState = state
        
        if var communityData = newState.homeCommunityData {
            let updatedList = communityData.communityList.map { item -> CommunityItem in
                var updatedItem = item
                updatedItem.isSelected = (item.title == selectedModel.title)
                return updatedItem
            }
            
            communityData.communityList = updatedList
            newState.homeCommunityData = communityData
        }
        return newState
    }
}
