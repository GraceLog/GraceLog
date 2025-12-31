//
//  DiaryCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 2/5/25.
//

import UIKit

final class DiaryCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let diaryVC = DependencyContainer.shared.injector.resolve(DiaryViewController.self)
        diaryVC.reactor?.coordinator = self
        navigationController.setViewControllers([diaryVC], animated: false)
    }
    
    func showDiarySettings(completion: @escaping (Date?, Bool, Bool) -> Void) {
        let diarySettingsVC = DependencyContainer.shared.injector.resolve(DiarySettingsViewController.self)
        diarySettingsVC.reactor?.coordinator = self
        diarySettingsVC.reactor?.onComplete = completion
        navigationController.present(diarySettingsVC, animated: true)
    }
    
    func dismissDiarySettings() {
        navigationController.dismiss(animated: true)
    }
}
