//
//  HomePresentationAssembly.swift
//  GraceLog
//
//  Created by 이건준 on 7/12/25.
//

import Swinject

struct HomePresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewReactor.self) { resolver in
            let homeUsecase = resolver.resolve(HomeUseCase.self)!
            return HomeViewReactor(homeUsecase: homeUsecase)
        }
        
        container.register(HomeViewController.self) { resolver in
            let reactor = resolver.resolve(HomeViewReactor.self)!
            return HomeViewController(reactor: reactor)
        }
        
        container.register(HomeMyViewReactor.self) { resolver in
            let homeUsecase = resolver.resolve(HomeUseCase.self)!
            return HomeMyViewReactor(homeUsecase: homeUsecase)
        }
        
        container.register(HomeMyViewController.self) { resolver in
            return HomeMyViewController()
        }
        
        container.register(HomeCommunityViewReactor.self) { resolver in
            let usecase = resolver.resolve(HomeCommunityUseCase.self)!
            return HomeCommunityViewReactor(usecase: usecase)
        }
        
        container.register(HomeCommunityViewController.self) { resolver in
            let reactor = container.resolve(HomeCommunityViewReactor.self)!
            return HomeCommunityViewController(reactor: reactor)
        }
    }
}
