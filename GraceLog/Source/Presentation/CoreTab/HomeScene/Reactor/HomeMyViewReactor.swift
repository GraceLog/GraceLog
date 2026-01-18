//
//  HomeMyViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 6/22/25.
//

import Foundation
import ReactorKit
import RxDataSources

final class HomeMyViewReactor: Reactor {
    private let homeUsecase: HomePersonalUseCase
    var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    let initialState: State
    
    init(
        homeUsecase: HomePersonalUseCase
    ) {
        self.homeUsecase = homeUsecase
        self.initialState = State()
        loadData()
    }
    
    private func loadData() {
        homeUsecase.fetchDiaryList()
        homeUsecase.fetchVideoList()
        homeUsecase.fetchDailyVerse()
    }
    
    enum Action {
        case didTapDiaryDetail(Int)
        case refreshDiaryList
    }
    
    enum Mutation {
        case setDiaryList([MyDiaryPreview])
        case setVideoList([RecommendedVideo])
        case setVideoTagList([String])
        case setDailyVerse(DailyVerse)
        case setError(Error)
        case showToast(String)
    }
    
    struct State {
        @Pulse var videoItems: [RecommendedVideo] = []
        @Pulse var isVideoItemsEmpty: Bool = true
        @Pulse var username: String = UserManager.shared.name
        @Pulse var diaryItems: [MyDiaryPreview] = []
        @Pulse var videoTagItems: [String] = []
        @Pulse var dailyVerse: DailyVerse?
        @Pulse var error: Error?
        @Pulse var toastMessage: String?
    }
}

extension HomeMyViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let diaryMutation = homeUsecase.diaryList
            .map { diaryList in
                let sortedList = diaryList.sorted {
                    guard let firstDate = $0.editedDate, let secondDate = $1.editedDate else {
                        return false
                    }
                    return firstDate > secondDate
                }
                return Mutation.setDiaryList(sortedList)
            }
        
        let videoMutation = homeUsecase.videoList
            .map { Mutation.setVideoList($0) }
        
        let videoTagMutation = homeUsecase.videoTagList
            .map { Mutation.setVideoTagList($0) }
        
        let dailyVerseMutation = homeUsecase.dailyVerse
            .compactMap { $0 }
            .map { Mutation.setDailyVerse($0) }
        
        return Observable.merge(mutation, diaryMutation, videoMutation, videoTagMutation, dailyVerseMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDiaryDetail(let id):
            coordinator?.showDiaryDetail(diaryId: id)
        case .refreshDiaryList:
            homeUsecase.fetchDiaryList()
            return .just(.showToast("일기가 성공적으로 공유되었습니다!"))
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDiaryList(let diaryItems):
            newState.diaryItems = diaryItems
        case .setVideoList(let videoItems):
            newState.videoItems = videoItems
            newState.isVideoItemsEmpty = videoItems.isEmpty
        case .setError(let error):
            newState.error = error
        case .setDailyVerse(let dailyVerse):
            newState.dailyVerse = dailyVerse
        case .setVideoTagList(let videoTagItems):
            newState.videoTagItems = videoTagItems
        case .showToast(let message):
            newState.toastMessage = message
        }
        return newState
    }
}
