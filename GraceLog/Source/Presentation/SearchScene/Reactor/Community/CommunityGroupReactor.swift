//
//  CommunityGroupReactor.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import ReactorKit

final class CommunityGroupReactor: Reactor {
    private let coordinator: CommunityGroupCoordinator
    private let diaryDetailUseCase: DiaryDetailsUseCase
    
    let initialState: State
    
    init(diaryDetailUseCase: DiaryDetailsUseCase, coordinator: CommunityGroupCoordinator) {
        self.diaryDetailUseCase = diaryDetailUseCase
        self.coordinator = coordinator
        self.initialState = .init(editedDateList: [], sectionedDiaryList: [])
    }
    
    enum Action {
        case didTapBackButton
        case fetchDiaryList(Date)
        case didTapDiaryDetail(Int)
        case didTapLikeButton(Int)
        case didTapCommentButton(Int)
    }
    
    enum Mutation {
        case setDiaryList([CommunityGroupSection])
        case setEditedDateList([Date])
        case setLikedStateResult((Bool, Int))
        case setUnLikedStateResult((Bool, Int))
    }
    
    struct State {
        @Pulse var editedDateList: [Date]
        @Pulse var sectionedDiaryList: [CommunityGroupSection]
        @Pulse var isSuccessLikeDiary: (Bool, Int)?
        @Pulse var isSuccessUnlikeResult: (Bool, Int)?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            coordinator.popViewController()
        case let .fetchDiaryList(selectedDate):
            let calendar = Calendar.current
            let year = calendar.component(.year, from: selectedDate)
            let month = calendar.component(.month, from: selectedDate)
            let (startDate, endDate) = DateFormatterFactory.getMonthDateRange(year: year, month: month)
            diaryDetailUseCase.fetchDateRangeDiaryList(startDate: startDate, endDate: endDate)
        case .didTapLikeButton(let diaryID):
            guard let selectedDiary = currentState.sectionedDiaryList.flatMap { $0.items }.first(where: { $0.id == diaryID }) else { return .empty() }
            if selectedDiary.isLiked {
                diaryDetailUseCase.unlikeDiary(id: diaryID)
            } else {
                diaryDetailUseCase.likeDiary(id: diaryID)
            }
        case let .didTapCommentButton(diaryID):
            coordinator.showCommentBottomSheet(diaryID: diaryID)
        case .didTapDiaryDetail(_):
            return .empty()
        }
        return .empty()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let diaryMutation = diaryDetailUseCase.dateRangeDiaries.share(replay: 1)
        let editedDiaryMutation = diaryMutation.map { $0.compactMap { $0.createdAt } }
            .map { Mutation.setEditedDateList($0) }
        let fetchedDiaryMutation = diaryMutation
            .map { diaries -> [CommunityGroupSection] in
                let datedDiaries: [(date: Date, diary: DiaryDetails)] = diaries.compactMap { diary in
                    guard let date = diary.createdAt else { return nil }
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
                                id: diary.diaryId,
                                title: diary.title,
                                content: diary.description,
                                editedDate: diary.createdAt,
                                isLiked: !diary.isHideLike,
                                likeCount: diary.likeCount,
                                commentCount: diary.commentCount,
                                username: diary.user.name,
                                profileImageURL: diary.user.profileImageURL,
                                diaryImageURL: diary.imageURLs.first ?? nil,
                                isCurrentUser: diary.likeByMe
                            ))
                        }
                    )
                }
                .sorted { $0.date > $1.date }

                return sections
            }
            .map { Mutation.setDiaryList($0) }
        
        let diaryLikedToggleResult = diaryDetailUseCase.likeDiaryResult.map { Mutation.setLikedStateResult(($0.0, $0.1)) }
        let diaryUnLikedToggleResult = diaryDetailUseCase.unlikeDiaryResult.map { Mutation.setUnLikedStateResult($0) }
        return Observable.merge(mutation, fetchedDiaryMutation, editedDiaryMutation, diaryLikedToggleResult, diaryUnLikedToggleResult)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDiaryList(let model):
            newState.sectionedDiaryList = model
        case .setEditedDateList(let model):
            newState.editedDateList = model
        case let .setLikedStateResult(result):
            let (isSuccess, diaryID) = result
            guard isSuccess else { return newState }
            newState.sectionedDiaryList = newState.sectionedDiaryList.map { section in
                var section = section
                section.items = section.items.map { item in
                    guard item.id == diaryID else { return item }
                    var newItem = item
                    newItem.isLiked = true
                    newItem.likeCount = max(0, item.likeCount + 1)
                    return newItem
                }
                return section
            }
        case let .setUnLikedStateResult(result):
            let (isSuccess, diaryID) = result
            guard isSuccess else { return newState }
            newState.sectionedDiaryList = newState.sectionedDiaryList.map { section in
                var section = section
                section.items = section.items.map { item in
                    guard item.id == diaryID else { return item }
                    var newItem = item
                    newItem.isLiked = false
                    newItem.likeCount = max(0, item.likeCount - 1)
                    return newItem
                }
                return section
            }
        }
        
        return newState
    }
}
