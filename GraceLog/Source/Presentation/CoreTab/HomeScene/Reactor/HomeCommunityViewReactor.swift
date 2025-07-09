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
    
    private var likedDiaryIds: Set<Int> = []
    private var diaryLikeStates: [Int: Bool] = [:]
    
    var initialState: State
    
    enum Action {
        case didSelectCommunity(communityId: Int)
        case didTapLikeButton(diaryId: Int)
    }
    
    enum Mutation {
        case setCommunitys([Community])
        case setSelectedCommunityId(Int)
        case setCommunityDiarys([HomeCommunityDiarySection])
        case setDiaryLikeResult(isSuccess: Bool)
        case setDiaryUnlikeResult(isSuccess: Bool)
    }
    
    struct State {
        @Pulse var communitys: [Community]
        @Pulse var communityDiarySections: [HomeCommunityDiarySection]
        @Pulse var selectedCommunityId: Int?
        @Pulse var isSuccessLikeDiary: Bool?
        @Pulse var isSuccessUnlikeResult: Bool?
    }
    
    init(usecase: HomeCommunityUseCase) {
        self.usecase = usecase
        self.initialState = State(
            communitys: [],
            communityDiarySections: []
        )
        
        usecase.fetchHomeCommunityContent()
    }
}

extension HomeCommunityViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSelectCommunity(let communityId):
            return .just(.setSelectedCommunityId(communityId))
        case .didTapLikeButton(let diaryId):
            let isLiked = likedDiaryIds.contains(diaryId)
            
            if isLiked {
                usecase.unlikeDiary(id: diaryId)
            } else {
                usecase.likeDiary(id: diaryId)
            }
            
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let communityData = usecase.homeCommunityData
            .compactMap { $0 }
            .map { Mutation.setCommunitys($0.communityList) }
        
        let diaryData = usecase.homeCommunityData
            .compactMap { $0 }
            .map { homeCommunityContent in
                let diarySections = HomeCommunityDiarySection.makeSections(
                    from: homeCommunityContent.diaryList
                )
                return Mutation.setCommunityDiarys(diarySections)
            }
        
        let likeResult = usecase.likeDiaryResult
            .map { result in Mutation.setDiaryLikeResult(isSuccess: result) }
        
        let unlikeResult = usecase.unlikeDiaryResult
            .map { result in Mutation.setDiaryUnlikeResult(isSuccess: result) }
        
        return Observable.merge(mutation, communityData, diaryData, likeResult, unlikeResult)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCommunitys(let communitys):
            newState.communitys = communitys
            
            if newState.selectedCommunityId == nil && !communitys.isEmpty {
                newState.selectedCommunityId = communitys[0].id
            }
        case .setSelectedCommunityId(let communityId):
            newState.selectedCommunityId = communityId
        case .setCommunityDiarys(let diarySections):
            newState.communityDiarySections = diarySections
            
            likedDiaryIds = Set(diarySections.flatMap { section in
                section.items.compactMap { item in
                    if case .diary(let diaryItem) = item, diaryItem.isLiked {
                        return diaryItem.id
                    }
                    return nil
                }
            })
        case .setDiaryLikeResult(let isSuccess):
            newState.isSuccessLikeDiary = isSuccess
        case .setDiaryUnlikeResult(let isSuccess):
            newState.isSuccessUnlikeResult = isSuccess
        }
        return newState
    }
}
