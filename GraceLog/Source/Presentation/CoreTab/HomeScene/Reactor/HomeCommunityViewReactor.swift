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
    private let usecase: HomeCommunityUseCase
    var coordinator: HomeCoordinator?
    
    var initialState: State
    
    private var selectedCommunityId: Int? = nil
    
    enum Action {
        case didSelectCommunity(Community)
        case didTapDiaryDetail(Int, Int?, Int?)
        case didTapLikeButton(Int)
        case loadMoreDiaries
    }
    
    enum Mutation {
        case setCommunityList([Community])
        case setDiaryList([HomeCommunityDiarySection])
        case setError(Error)
    }
    
    struct State {
        @Pulse var communityList: [Community]
        @Pulse var sectionedDiaryList: [HomeCommunityDiarySection]
        @Pulse var error: Error?
    }
    
    init(
        usecase: HomeCommunityUseCase
    ) {
        self.usecase = usecase
        self.initialState = State(
            communityList: [],
            sectionedDiaryList: []
        )
        
        usecase.fetchCommunityList()
    }
}

extension HomeCommunityViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSelectCommunity(let community):
            usecase.resetDiaryListWithPagination()
            usecase.fetchDiaryList(
                communityId: community.id
            )
        case .didTapDiaryDetail(let diaryId, let communityId, let memberId):
            coordinator?.showDiaryDetail(
                diaryId: diaryId,
                communityId: communityId,
                memberId: memberId
            )
        case .didTapLikeButton(let diaryID):
            usecase.toggleDiaryLike(id: diaryID)
        case .loadMoreDiaries:
            guard let selectedCommunityId = selectedCommunityId else {
                return .empty()
            }
            
            usecase.fetchDiaryList(
                communityId: selectedCommunityId
            )
        }
        return .empty()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fetchedCommunityList = usecase.communityList
            .map { Mutation.setCommunityList($0) }
        
        let fetchedDiaryList = usecase.diaryList
            .map { diaries -> [HomeCommunityDiarySection] in
                let validDiaries = diaries.filter { $0.editedDate != nil }
                let grouped = Dictionary(grouping: validDiaries) {
                    DateFormatterFactory.dateWithShortKorean.string(from: $0.editedDate!)
                }
                return grouped.map { key, value in
                    HomeCommunityDiarySection(date: key, items: value.map { CommunityDiaryItem(from: $0) })
                }.sorted { $0.date > $1.date }
            }
            .map { Mutation.setDiaryList($0) }
        
        let errorMutation = usecase.error
            .map { Mutation.setError($0) }
        
        return Observable.merge(
            mutation,
            fetchedCommunityList,
            fetchedDiaryList,
            errorMutation
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCommunityList(let communityList):
            newState.communityList = communityList
        case .setDiaryList(let diaryList):
            newState.sectionedDiaryList = diaryList
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}
