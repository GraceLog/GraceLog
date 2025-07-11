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
    
    var initialState: State
    
    enum Action {
        case didSelectCommunity(Community)
        case didTapLikeButton(String)
    }
    
    enum Mutation {
        case setCommunityList([Community])
        case setDiaryList([HomeCommunityDiarySection])
        case setDiaryLikeResult(isSuccess: Bool)
        case setDiaryUnlikeResult(isSuccess: Bool)
    }
    
    struct State {
        @Pulse var communityList: [Community]
        @Pulse var sectionedDiaryList: [HomeCommunityDiarySection]
        @Pulse var isSuccessLikeDiary: Bool?
        @Pulse var isSuccessUnlikeResult: Bool?
    }
    
    init(usecase: HomeCommunityUseCase) {
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
            usecase.fetchDiaryList(community: community)
        case .didTapLikeButton(let diaryID):
            guard let selectedDiary = usecase.diaryList.value.first(where: { $0.id == diaryID }) else {
                return .empty()
            }
            
            if selectedDiary.isLiked {
                usecase.unlikeDiary(id: diaryID)
            } else {
                usecase.likeDiary(id: diaryID)
            }
        }
        return .empty()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fetchedCommunityList = usecase.communityList
            .map { Mutation.setCommunityList($0) }
        
        let fetchedDiaryList = usecase.diaryList
            .map { diaries -> [HomeCommunityDiarySection] in
                let grouped = Dictionary(grouping: diaries) {
                    DateformatterFactory.dateWithShortKorean.string(from: $0.editedDate)
                }
                return grouped.map { key, value in
                    HomeCommunityDiarySection(date: key, items: value.map { CommunityDiaryItem(from: $0) })
                }.sorted { $0.date > $1.date }
            }
            .map { Mutation.setDiaryList($0) }
        
        let likeResult = usecase.likeDiaryResult
            .map { result in Mutation.setDiaryLikeResult(isSuccess: result) }
        
        let unlikeResult = usecase.unlikeDiaryResult
            .map { result in Mutation.setDiaryUnlikeResult(isSuccess: result) }
        
        return Observable.merge(mutation, fetchedCommunityList, fetchedDiaryList, likeResult, unlikeResult)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCommunityList(let communityList):
            newState.communityList = communityList
        case .setDiaryList(let diaryList):
            newState.sectionedDiaryList = diaryList
        case .setDiaryLikeResult(let isSuccess):
            newState.isSuccessLikeDiary = isSuccess
        case .setDiaryUnlikeResult(let isSuccess):
            newState.isSuccessUnlikeResult = isSuccess
        }
        return newState
    }
}
