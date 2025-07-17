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
    private let homeUsecase: HomeUseCase
    private let disposeBag = DisposeBag()
    let initialState: State
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
        self.initialState = State()
        loadData()
    }
    
    private func loadData() {
        homeUsecase.fetchDiaryList()
        homeUsecase.fetchVideoList()
        homeUsecase.fetchDailyVerse()
    }
    
    enum Mutation {
        case setDiaryList([MyDiary])
        case setVideoList([RecommendedVideo])
        case setVideoTagList([VideoTag])
        case setDailyVerse(DailyVerse)
        case setError(Error)
    }
    
    struct State {
        @Pulse var videoItems: [RecommendedVideo] = []
        @Pulse var isVideoItemsEmpty: Bool = true
        @Pulse var diaryItems: [MyDiary] = []
        @Pulse var videoTagItems: [VideoTag] = []
        @Pulse var dailyVerse: DailyVerse?
        @Pulse var errorMessage: String?
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
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDiaryList(let diaryItems):
            newState.diaryItems = diaryItems
        case .setVideoList(let videoItems):
            newState.videoItems = videoItems
            newState.isVideoItemsEmpty = videoItems.isEmpty
        case .setError(let error):
            newState.errorMessage = error.localizedDescription
        case .setDailyVerse(let dailyVerse):
            newState.dailyVerse = dailyVerse
        case .setVideoTagList(let videoTagItems):
            newState.videoTagItems = videoTagItems
        }
        return newState
    }
}
