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
        navigationController.setViewControllers([diaryVC], animated: false)
    }
}
