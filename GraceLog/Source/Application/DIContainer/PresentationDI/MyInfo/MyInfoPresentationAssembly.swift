//
//  MyInfoPresentationAssembly.swift
//  GraceLog
//
//  Created by 이건준 on 7/12/25.
//

import Swinject

struct MyInfoPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MyInfoViewReactor.self) { resolver in
            return MyInfoViewReactor()
        }
        
        container.register(MyInfoViewController.self) { resolver in
            let reactor = resolver.resolve(MyInfoViewReactor.self)!
            return MyInfoViewController(reactor: reactor)
        }
    }
}
