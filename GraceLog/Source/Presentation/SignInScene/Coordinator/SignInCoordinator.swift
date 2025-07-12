//
//  LoginCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 1/5/25.
//

import UIKit

final class SignInCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signInViewController = DependencyContainer.shared.injector.resolve(SignInViewController.self)
        navigationController.setViewControllers([signInViewController], animated: true)
    }
}
