//
//  SearchViewReactor.swift
//  GraceLog
//
//  Created by 이건준 on 9/21/25.
//

import ReactorKit

final class SearchViewReactor: Reactor {
    private(set) var isSearching = false
    private let usecase: SearchCommunityUseCase
    private let coordinator: SearchCoordinator
    let initialState: State
    
    init(usecase: SearchCommunityUseCase, coordinator: SearchCoordinator) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State(
            sections: []
        )
        
        usecase.fetchProfileList()
        usecase.fetchChattingList()
        usecase.fetchPopularCommunity()
        
    }
    
    enum Action {
        case didSearchCommunity(String)
        case didTapProfile(IndexPath)
        case didTapCommunity(IndexPath)
        case didTapChattingRoom(IndexPath)
    }
    
    enum Mutation {
        case setCommunities([Community])
        case setProfiles([ProfileItem])
        case setChattings([CommunityChatting])
    }
    
    struct State {
        @Pulse var sections: [SearchCommunitySection]
        var communities: [Community] = []
        var profiles: [ProfileItem] = []
        var chattings: [CommunityChatting] = []
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let communityMutation = usecase.popularCommunityList.map { Mutation.setCommunities($0) }
        let chattingMutation = usecase.chattingList.map { Mutation.setChattings($0) }
        let profileMutation = usecase.profileList.map { Mutation.setProfiles($0) }
        
        return .merge(mutation, communityMutation, chattingMutation, profileMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSearchCommunity(query):
            isSearching = true
            usecase.searchCommunity(query: query)
        case let .didTapProfile(indexPath):
            let id = currentState.profiles[indexPath.row].id
            coordinator.showProfileViewController(id: id)
        case let .didTapCommunity(indexPath):
            let id = currentState.communities[indexPath.row].id
            coordinator.showCommunityViewController(id: id)
        case let .didTapChattingRoom(indexPath):
            let id = currentState.chattings[indexPath.row].id
            coordinator.showCommunityChattingViewController(id: id)
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setCommunities(communities):
            newState.communities = communities
        case let .setProfiles(profiles):
            newState.profiles = profiles
        case let .setChattings(chattings):
            newState.chattings = chattings
        }
        newState.sections = makeSections(isSearching: isSearching, communities: newState.communities, chattings: newState.chattings, profiles: newState.profiles)
        return newState
    }
}

extension SearchViewReactor {
    private func makeSections(
        isSearching: Bool,
        communities: [Community],
        chattings: [CommunityChatting],
        profiles: [ProfileItem]
    ) -> [SearchCommunitySection] {
        let primaryItems = isSearching ? profiles.map { SearchCommunityItem.profile($0) } : communities.map { SearchCommunityItem.community($0) }
        let secondaryItems = chattings.map { SearchCommunityItem.chatting($0) }
        
        return [
            .primary(isSearching: isSearching, items: primaryItems),
            .secondary(isSearching: isSearching, items: secondaryItems)
        ]
    }
}
