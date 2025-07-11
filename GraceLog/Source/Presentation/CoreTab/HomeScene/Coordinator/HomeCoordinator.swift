//
//  HomeCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit

final class HomeCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = HomeViewController(reactor: HomeViewReactor(homeUsecase: DefaultHomeUseCase(homeRepository: DefaultHomeRepository())))
        navigationController.setViewControllers([viewController], animated: false)
    }
}
