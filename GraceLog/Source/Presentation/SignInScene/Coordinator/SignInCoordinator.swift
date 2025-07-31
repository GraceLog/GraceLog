//
//  LoginCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 1/5/25.
//

import UIKit

protocol SignInCoordinatorDelegate {
    func didSignIn(_ coordinator: SignInCoordinator)
}

final class SignInCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var delegate: SignInCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signInViewController = DependencyContainer.shared.injector.resolve(SignInViewController.self)
        if let reactor = signInViewController.reactor {
            reactor.coordinator = self
        }
        navigationController.setViewControllers([signInViewController], animated: true)
    }
}

extension SignInCoordinator {
    func didSignIn() {
        self.delegate?.didSignIn(self)
    }
}
