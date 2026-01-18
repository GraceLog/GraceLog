//
//  AnnouncementPresentationAssembly.swift
//  GraceLog
//
//  Created by 이상준 on 1/17/26.
//

import Swinject

struct AnnouncementPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnnouncementViewReactor.self) { resolver in
            let usecase = resolver.resolve(AnnouncementListUseCase.self)!
            return AnnouncementViewReactor(usecase: usecase)
        }
        
        container.register(AnnouncementViewController.self) { resolver in
            let reactor = resolver.resolve(AnnouncementViewReactor.self)!
            return AnnouncementViewController(reactor: reactor)
        }
        
        container.register(AnnouncementDetailViewReactor.self) { (resolver, announcementId: Int) in
            let usecase = resolver.resolve(
                AnnouncementDetailUseCase.self,
                argument: announcementId
            )!
            return AnnouncementDetailViewReactor(usecase: usecase)
        }
        
        container.register(AnnouncementDetailViewController.self) { (resolver, announcementId: Int) in
            let reactor = resolver.resolve(
                AnnouncementDetailViewReactor.self,
                argument: announcementId
            )!
            return AnnouncementDetailViewController(reactor: reactor)
        }
    }
}
