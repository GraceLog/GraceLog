//
//  DiaryDetailsPresentationAssembly.swift
//  GraceLog
//
//  Created by 이상준 on 11/3/25.
//

import Swinject

struct DiaryDetailsPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DiaryDetailsViewReactor.self) { (resolver, coordinator: DiaryDetailsCoordinator, diaryId: Int) in
            let usecase = resolver.resolve(DiaryDetailsUseCase.self, argument: diaryId)!
            return DiaryDetailsViewReactor(
                coordinator: coordinator,
                usecase: usecase
            )
        }
        
        container.register(DiaryDetailsViewController.self) { (resolver, coordinator: DiaryDetailsCoordinator, diaryId: Int) in
            let reactor = resolver.resolve(
                DiaryDetailsViewReactor.self,
                arguments: coordinator,
                diaryId
            )!
            return DiaryDetailsViewController(reactor: reactor)
        }
    }
    
}
