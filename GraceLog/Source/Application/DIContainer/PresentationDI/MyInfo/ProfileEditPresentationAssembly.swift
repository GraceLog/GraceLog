//
//  ProfileEditPresentationAssembly.swift
//  GraceLog
//
//  Created by 이상준 on 1/16/26.
//

import Swinject

struct ProfileEditPresentationAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ProfileEditViewReactor.self) { resolver in
            let usecase = resolver.resolve(MyInfoUseCase.self)!
            return ProfileEditViewReactor(usecase: usecase)
        }
        
        container.register(ProfileEditViewController.self) { resolver in
            let reactor = resolver.resolve(ProfileEditViewReactor.self)!
            return ProfileEditViewController(reactor: reactor)
        }
        
    }
}

