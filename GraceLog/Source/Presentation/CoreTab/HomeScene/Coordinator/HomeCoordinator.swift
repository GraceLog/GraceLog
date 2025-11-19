//
//  HomeCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit
import Swinject

final class HomeCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = DependencyContainer.shared.injector.resolve(HomeViewController.self)
        viewController.homeMyViewController.reactor?.coordinator = self
        viewController.homeCommunityViewController.reactor?.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showDiaryDetail(diaryId: Int) {
        let diaryDetailsCoordinator = DiaryDetailsCoordinator(self.navigationController, diaryId: diaryId)
        diaryDetailsCoordinator.parentCoordinator = self
        self.childCoordinators.append(diaryDetailsCoordinator)
        diaryDetailsCoordinator.start()
    }
}
