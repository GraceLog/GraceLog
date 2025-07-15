//
//  AuthPresentationAssembly.swift
//  GraceLog
//
//  Created by 이상준 on 7/15/25.
//

import Swinject

struct AuthPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SignInReactor.self) { resolver in
            let signInUsecase = resolver.resolve(SignInUseCase.self)!
            return SignInReactor(signInUseCase: signInUsecase)
        }
        
        container.register(SignInViewController.self) { resolver in
            let reactor = resolver.resolve(SignInReactor.self)!
            return SignInViewController(reactor: reactor)
        }
    }
}
