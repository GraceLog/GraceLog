//
//  DiaryCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 2/5/25.
//

import UIKit
import RxSwift

final class DiaryCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.modalPresentationStyle = .overFullScreen
    }
    
    func start() {
        let diaryVC = DependencyContainer.shared.injector.resolve(DiaryViewController.self)
        diaryVC.reactor?.coordinator = self
        navigationController.setViewControllers([diaryVC], animated: false)
    }
    
    func showDiarySettings() -> Observable<(Date?, Bool, Bool)> {
        let reactor = DependencyContainer.shared.injector.resolve(
            DiarySettingsViewReactor.self
        )
        reactor.coordinator = self
        
        let diarySettingsVC = DependencyContainer.shared.injector.resolve(
            DiarySettingsViewController.self,
            argument: reactor
        )
        navigationController.present(diarySettingsVC, animated: true)
        
        return reactor.onComplete.take(1)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func diaryCreatedEvent() {
        navigationController.dismiss(animated: true) {
            NotificationCenterManager.reloadHomeMyDiaryList.post()
        }
    }
}
