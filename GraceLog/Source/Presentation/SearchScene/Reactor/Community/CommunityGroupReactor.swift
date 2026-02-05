//
//  CommunityGroupReactor.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import ReactorKit

final class CommunityGroupReactor: Reactor {
    var coordinator: CommunityGroupCoordinator?
    private let usecase: CommunityGroupUseCase
    
    let initialState: State
    
    init(
        usecase: CommunityGroupUseCase
    ) {
        self.usecase = usecase
        self.initialState = .init(
            editedDateList: [],
            sectionedDiaryList: []
        )
        
        usecase.fetchLatestCommunityDiaryExistenceDate()
    }
    
    enum Action {
        case fetchEditedDateList(Date)
        case fetchDiaryList(Date)
        case loadNextPage
        case didTapBackButton
        case didTapDiaryDetail(Int, Int?, Int?)
        case didTapLikeButton(Int)
        case didTapCommentButton(Int)
    }
    
    enum Mutation {
        case setLastestPostDate(Date)
        case setDiaryList([CommunityGroupSection])
        case setEditedDateList([DiaryExistenceDate])
    }
    
    struct State {
        @Pulse var latestPostDate: Date?
        @Pulse var editedDateList: [Date]
        @Pulse var sectionedDiaryList: [CommunityGroupSection]
        @Pulse var isSuccessLikeDiary: (Bool, Int)?
        @Pulse var isSuccessUnlikeResult: (Bool, Int)?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchEditedDateList(let date):
            usecase.fetchCommunityDiaryExistenceDates(date: date)
        case .fetchDiaryList(let selectedDate):
            usecase.fetchCommunityDiaryList(date: DateFormatterFactory.toDateOnlyString(from: selectedDate))
        case .loadNextPage:
            usecase.loadNextPage()
        case .didTapBackButton:
            coordinator?.popViewController()
        case .didTapLikeButton(let diaryID):
            usecase.toggleDiaryLike(id: diaryID)
        case let .didTapCommentButton(diaryID):
            coordinator?.showCommentBottomSheet(diaryID: diaryID)
        case .didTapDiaryDetail(let diaryId, let communityId, let memberId):
            coordinator?.showDiaryDetail(
                diaryId: diaryId,
                communityId: communityId,
                memberId: memberId
            )
        }
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLastestPostDate(let date):
            newState.latestPostDate = date
        case .setDiaryList(let model):
            newState.sectionedDiaryList = model
        case .setEditedDateList(let dates):
            newState.editedDateList = dates.map { $0.date }
        }
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let latestPostDateMutation = usecase.latestCommunityDiaryExistenceDate
            .compactMap { $0 }
            .map { Mutation.setLastestPostDate($0) }
        
        let editedDateListMutation = usecase.diaryExistenceDates
            .map { Mutation.setEditedDateList($0) }
        
        let diaryListMutation = usecase.communityDiaryList
            .map { diaries -> [CommunityGroupSection] in
                let datedDiaries: [(date: Date, diary: CommunityDiaryPreview)] = diaries.compactMap { diary in
                    guard let date = diary.editedDate else { return nil }
                    return (date, diary)
                }
                let calendar = Calendar.current
                let grouped = Dictionary(grouping: datedDiaries) { item in
                    calendar.startOfDay(for: item.date)
                }
                
                let sections: [CommunityGroupSection] = grouped.map { (dayStart, items) in
                    CommunityGroupSection(
                        date: dayStart,
                        items: items.map { (_, diary) in
                            CommunityDiaryItem(from: .init(
                                id: diary.id,
                                title: diary.title,
                                content: diary.content,
                                editedDate: diary.editedDate,
                                isLiked: diary.isLiked,
                                likeCount: diary.likeCount,
                                commentCount: diary.commentCount,
                                userId: diary.userId,
                                username: diary.username,
                                profileImageURL: diary.profileImageURL,
                                diaryImageURL: diary.diaryImageURL,
                                isCurrentUser: diary.isCurrentUser,
                                communityId: diary.communityId
                            ))
                        }
                    )
                }.sorted { $0.date > $1.date }
                
                return sections
            }
            .map { Mutation.setDiaryList($0) }
        
        return Observable.merge(
            mutation,
            latestPostDateMutation,
            editedDateListMutation,
            diaryListMutation
        )
    }
}
