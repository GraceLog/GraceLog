//
//  DiaryDetailsViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 9/28/25.
//

import ReactorKit

final class DiaryDetailsViewReactor: Reactor {
    private let coordinator: DiaryDetailsCoordinator
    private let usecase: DiaryDetailsUseCase
    
    var initialState: State
    
    enum Action {
        case fetchDiary(Int)
        case fetchDateRangeDiaryList(String, String)
        case didTapBackButton
        case didTapLikeButton(Int)
        case didTapCommentButton(Int)
    }
    
    enum Mutation {
        case setDiary(DiaryDetails)
        case setDateRangeDiaryList([DiaryDetails])
        case setDiaryLikeResult(isSuccess: Bool)
        case setDiaryUnlikeResult(isSuccess: Bool)
    }
    struct State {
        @Pulse var diary: DiaryDetails?
        @Pulse var dateRangeDiaries: [DiaryDetails]
        @Pulse var isSuccessLikeResult: Bool?
        @Pulse var isSuccessUnlikeResult: Bool?
    }
    
    init(
        coordinator: DiaryDetailsCoordinator,
        usecase: DiaryDetailsUseCase
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.initialState = State(
            dateRangeDiaries: []
        )
    }
}

extension DiaryDetailsViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchDiary(let diaryId):
            usecase.fetchDiaryDetails(diaryId: diaryId)
        case .fetchDateRangeDiaryList(let startDate, let endDate):
            usecase.fetchDateRangeDiaryList(
                startDate: startDate,
                endDate: endDate
            )
        case .didTapBackButton:
            coordinator.popViewController()
        case .didTapLikeButton(let diaryID):
            guard let diary = currentState.diary,
                  diary.diaryId == diaryID else {
                return .empty()
            }
            
            if diary.likeByMe {
                usecase.unlikeDiary(id: diaryID)
            } else {
                usecase.likeDiary(id: diaryID)
            }
        case .didTapCommentButton:
            coordinator.showCommentBottomSheet()
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDiary(let diary):
            newState.diary = diary
        case .setDateRangeDiaryList(let diaryList):
            newState.dateRangeDiaries = diaryList
        case .setDiaryLikeResult(let isSuccess):
            newState.isSuccessLikeResult = isSuccess
        case .setDiaryUnlikeResult(let isSuccess):
            newState.isSuccessUnlikeResult = isSuccess
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fetchDiaryDetail = usecase.diary
            .map { Mutation.setDiary($0) }
        
        let fetchDateRangeDiaryList = usecase.dateRangeDiaries
            .map { Mutation.setDateRangeDiaryList($0) }
        
        let likeResult = usecase.likeDiaryResult
            .map { result in Mutation.setDiaryLikeResult(isSuccess: result) }
        
        let unlikeResult = usecase.unlikeDiaryResult
            .map { result in Mutation.setDiaryUnlikeResult(isSuccess: result) }
        
        return Observable.merge(
            fetchDiaryDetail,
            fetchDateRangeDiaryList,
            likeResult,
            unlikeResult,
            mutation
        )
    }
}
