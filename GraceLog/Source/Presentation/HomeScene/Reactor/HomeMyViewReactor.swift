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
    
    init(homeUsecase: HomeUseCase) {
        self.homeUsecase = homeUsecase
        loadData()
    }
    
    private func loadData() {
        homeUsecase.fetchHomeMyContent()
        homeUsecase.fetchUser()
    }
    
    enum Action {
        case updateUser(GraceLogUser)
    }
    
    enum Mutation {
        case setHomeMyData(HomeContent)
        case setError(Error)
        case setUser(GraceLogUser)
    }
    
    struct State {
        var homeMyData: HomeContent?
        var error: Error?
        var user: GraceLogUser? = nil
        
        var sections: [HomeSectionModel] {
            guard let myData = homeMyData else {
                return []
            }
            
            let diaryItems = myData.diaryList.map { item in
                return MyDiaryItem(
                    date: item.date,
                    dateDesc: item.dateDesc,
                    title: item.title,
                    desc: item.desc,
                    tags: item.tags,
                    image: item.image
                )
            }
            
            let contentItems = myData.videoList.map { item in
                return HomeVideoItem(
                    title: item.title,
                    imageName: item.imageName
                )
            }
            
            return [
                .diary(diaryItems),
                .contentList(contentItems)
            ]
        }
    }
    
    let initialState: State = State()
}

extension HomeMyViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateUser(let user):
            return .just(.setUser(user))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let data = homeUsecase.homeMyData
            .compactMap { $0 }
            .map { Mutation.setHomeMyData($0) }
        
        return Observable.merge(mutation, data)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setHomeMyData(let data):
            newState.homeMyData = data
        case .setError(let error):
            newState.error = error
        case .setUser(let user):
            newState.user = user
        }
        return newState
    }
}
