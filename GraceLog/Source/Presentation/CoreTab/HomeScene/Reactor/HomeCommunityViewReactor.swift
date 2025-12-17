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
        case didTapDiaryDetail(Int)
        case didTapLikeButton(Int)
        case loadMoreDiaries
    }
    
    enum Mutation {
        case setCommunityList([Community])
        case setDiaryList([HomeCommunityDiarySection])
        case setHasMoreDiaries(Bool)
        case setError(Error)
    }
    
    struct State {
        @Pulse var communityList: [Community]
        @Pulse var sectionedDiaryList: [HomeCommunityDiarySection]
        @Pulse var isSuccessLikeDiary: Bool?
        @Pulse var isSuccessUnlikeResult: Bool?
        @Pulse var error: Error?
        var hasMoreDiaries: Bool
    }
    
    init(
        usecase: HomeCommunityUseCase
    ) {
        self.usecase = usecase
        self.initialState = State(
            communityList: [],
            sectionedDiaryList: [],
            hasMoreDiaries: true
        )
        
        usecase.fetchCommunityList()
    }
}

extension HomeCommunityViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSelectCommunity(let community):
            selectedCommunityId = community.id
            usecase.fetchDiaryList(
                communityId: community.id,
                cursorId: nil,
                isLoadMore: false
            )
        case .didTapDiaryDetail(let diaryID):
            coordinator?.showDiaryDetail(diaryId: diaryID)
        case .didTapLikeButton(let diaryID):
            guard let selectedDiary = usecase.diaryList.value.first(where: { $0.id == diaryID }) else {
                return .empty()
            }
            
            if selectedDiary.isLiked {
                usecase.unlikeDiary(id: diaryID)
            } else {
                usecase.likeDiary(id: diaryID)
            }
        case .loadMoreDiaries:
            guard currentState.hasMoreDiaries else {
                return .empty()
            }
            
            let currentDiaries = usecase.diaryList.value
            
            guard let selectedCommunityId = selectedCommunityId,
                  !currentDiaries.isEmpty,
                  let lastCursorId = currentDiaries.last?.id else {
                return .empty()
            }
            
            usecase.fetchDiaryList(
                communityId: selectedCommunityId,
                cursorId: lastCursorId,
                isLoadMore: true
            )
        }
        return .empty()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fetchedCommunityList = usecase.communityList
            .map { Mutation.setCommunityList($0) }
        
        let fetchedDiaryList = usecase.diaryList
            .map { diaries -> [HomeCommunityDiarySection] in
                let grouped = Dictionary(grouping: diaries) {
                    DateFormatterFactory.dateWithShortKorean.string(from: $0.editedDate)
                }
                return grouped.map { key, value in
                    HomeCommunityDiarySection(date: key, items: value.map { CommunityDiaryItem(from: $0) })
                }.sorted { $0.date > $1.date }
            }
            .map { Mutation.setDiaryList($0) }
        
        let hasMoreDiaries = usecase.hasMoreDiaries
            .map { Mutation.setHasMoreDiaries($0) }
        
        let errorMutation = usecase.error
            .map { Mutation.setError($0) }
        
        return Observable.merge(
            mutation,
            fetchedCommunityList,
            hasMoreDiaries,
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
        case .setHasMoreDiaries(let hasMore):
            newState.hasMoreDiaries = hasMore
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}
