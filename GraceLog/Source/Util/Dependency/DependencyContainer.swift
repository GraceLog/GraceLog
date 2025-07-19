//
//  DependencyContainer.swift
//  GraceLog
//
//  Created by 이건준 on 7/12/25.
//

import Swinject

final class DependencyContainer {
    static let shared = DependencyContainer()
    private init() {}
    
    let injector: Injector = {
        let container = Container()
        let injector = DependencyInjector(container: container)
        injector.assemble([
            DataAssembly(),
            DomainAssembly(),
            AuthPresentationAssembly(),
            HomePresentationAssembly(),
            DiaryPresentationAssembly(),
            MyInfoPresentationAssembly()
        ])
        return injector
    }()
}
