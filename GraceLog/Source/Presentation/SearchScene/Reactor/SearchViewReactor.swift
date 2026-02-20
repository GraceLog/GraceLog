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
        usecase.fetchRoomList()
        usecase.fetchPopularCommunity()
        
    }
    
    enum Action {
        case didSearchCommunity(String)
        case didTapProfile(IndexPath)
        case didTapCommunity(IndexPath)
        case didTapChattingRoom(IndexPath)
        case didTapAddCommunityButton
    }
    
    enum Mutation {
        case setCommunities([Community])
        case setProfiles([ProfileItem])
        case setRooms([CommunityRoom])
    }
    
    struct State {
        @Pulse var sections: [SearchCommunitySection]
        var communities: [Community] = []
        var profiles: [ProfileItem] = []
        var rooms: [CommunityRoom] = []
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let communityMutation = usecase.popularCommunityList.map { Mutation.setCommunities($0) }
        let roomMutation = usecase.roomList.map { Mutation.setRooms($0) }
        let profileMutation = usecase.profileList.map { Mutation.setProfiles($0) }
        
        return .merge(mutation, communityMutation, roomMutation, profileMutation)
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
            let communityId = currentState.communities[indexPath.row].id
//            guard let memberId = UserManager.shared.id else { return .empty() }
            coordinator.showCommunityViewController(communityId: communityId, memberId: 0)
        case let .didTapChattingRoom(indexPath):
            let id = currentState.rooms[indexPath.row].id
            coordinator.showCommunityChattingViewController(id: id)
        case .didTapAddCommunityButton:
            coordinator.showCreateCommunityViewController()
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
        case let .setRooms(rooms):
            newState.rooms = rooms
        }
        newState.sections = makeSections(isSearching: isSearching, communities: newState.communities, rooms: newState.rooms, profiles: newState.profiles)
        return newState
    }
}

extension SearchViewReactor {
    private func makeSections(
        isSearching: Bool,
        communities: [Community],
        rooms: [CommunityRoom],
        profiles: [ProfileItem]
    ) -> [SearchCommunitySection] {
        let primaryItems = isSearching ? profiles.map { SearchCommunityItem.profile($0) } : communities.map { SearchCommunityItem.community($0) }
        let secondaryItems = rooms.map { SearchCommunityItem.room($0) }
        
        return [
            .primary(isSearching: isSearching, items: primaryItems),
            .secondary(isSearching: isSearching, items: secondaryItems)
        ]
    }
}
