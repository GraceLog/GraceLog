//
//  CreateCommunityPresentationAssembly.swift
//  GraceLog
//
//  Created by 이상준 on 1/21/26.
//

import Swinject

struct CreateCommunityPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CreateCommunityReactor.self) { resolver in
            let usecase = resolver.resolve(CreateCommunityUseCase.self)!
            return CreateCommunityReactor(usecase: usecase)
        }
        
        container.register(CreateCommunityViewController.self) { resolver in
            let reactor = resolver.resolve(CreateCommunityReactor.self)!
            return CreateCommunityViewController(reactor: reactor)
        }
    }
}
