//
//  DiarySettingsPresentationAssembly.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/25.
//

import Swinject

struct DiarySettingsPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DiarySettingsViewReactor.self) { (resolver, completion: @escaping (Date?, Bool, Bool) -> Void) in
            return DiarySettingsViewReactor(onComplete: completion)
        }
        
        container.register(DiarySettingsViewController.self) { (resolver, reactor: DiarySettingsViewReactor) in
            return DiarySettingsViewController(reactor: reactor)
        }
    }
}
