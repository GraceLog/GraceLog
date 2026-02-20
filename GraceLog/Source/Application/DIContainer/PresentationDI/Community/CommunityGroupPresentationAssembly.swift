//
//  CommunityGroupPresentationAssembly.swift
//  GraceLog
//
//  Created by 이상준 on 2/3/26.
//

import Swinject

struct CommunityGroupPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CommunityGroupReactor.self) { (resolver, communityId: Int) in
            let usecase = resolver.resolve(CommunityGroupUseCase.self, argument: communityId)!
            return CommunityGroupReactor(usecase: usecase)
        }
        
        container.register(CommunityGroupViewController.self) { (resolver, communityId: Int) in
            let reactor = resolver.resolve(CommunityGroupReactor.self, argument: communityId)!
            return CommunityGroupViewController(reactor: reactor)
        }
    }
}
