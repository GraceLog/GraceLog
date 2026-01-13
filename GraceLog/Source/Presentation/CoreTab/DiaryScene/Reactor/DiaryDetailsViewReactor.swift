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
        case fetchDateRangeDiaryList(Date)
        case didTapBackButton
        case didTapLikeButton(Int)
        case didTapCommentButton(Int)
    }
    
    enum Mutation {
        case setDiary(DiaryDetails)
        case setDateRangeDiaryList([DiaryDetails])
        case toggleLike
        case setError(Error)
    }
    struct State {
        @Pulse var diary: DiaryDetails?
        @Pulse var dateRangeDiaries: [DiaryDetails]
        @Pulse var error: Error?
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
        case .fetchDateRangeDiaryList(let date):
            usecase.fetchDateRangeDiaryList(
                date: date
            )
        case .didTapBackButton:
            coordinator.popViewController()
        case .didTapLikeButton(let diaryID):
            usecase.toggleDiaryLike(id: diaryID)
            return .just(.toggleLike)
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
        case .toggleLike:
            if var diary = newState.diary {
                diary.likeByMe.toggle()
                diary.likeCount += diary.likeByMe ? 1 : -1
                diary.likeCount = max(0, diary.likeCount)
                newState.diary = diary
            }
        case .setError(let error):
            newState.error = error
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fetchDiaryDetail = usecase.diary
            .map { Mutation.setDiary($0) }
        
        let fetchDateRangeDiaryList = usecase.dateRangeDiaries
            .map { Mutation.setDateRangeDiaryList($0) }
        
        let errorMuataion = usecase.error
            .map { Mutation.setError($0) }
        
        return Observable.merge(
            fetchDiaryDetail,
            fetchDateRangeDiaryList,
            errorMuataion,
            mutation
        )
    }
}
