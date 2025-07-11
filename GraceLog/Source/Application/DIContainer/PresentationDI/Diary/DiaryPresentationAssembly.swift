//
//  DiaryPresentationAssembly.swift
//  GraceLog
//
//  Created by 이건준 on 7/12/25.
//

import Swinject

struct DiaryPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DiaryViewReactor.self) { resolver in
            let usecase = resolver.resolve(DiaryUseCase.self)!
            return DiaryViewReactor(usecase: usecase)
        }
        
        container.register(DiaryViewController.self) { resolver in
            let reactor = resolver.resolve(DiaryViewReactor.self)!
            return DiaryViewController(reactor: reactor)
        }
    }
}
