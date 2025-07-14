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
        navigationController.setViewControllers([viewController], animated: false)
    }
}
