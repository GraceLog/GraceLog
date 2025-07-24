//
//  GraceLogAppCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 12/7/24.
//

import UIKit

final class GraceLogAppCoordinator: NavigationCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var isLoggedIn: Bool {
        KeychainServiceImpl.shared.isLoggedIn()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        isLoggedIn ? showMainTabFlow() : showLoginFlow()
    }
    
    @objc private func handleAuthenticationFailure() {
        showLoginFlow()
    }
    
    func showLoginFlow() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.parentCoordinator = self
        childCoordinators.append(signInCoordinator)
        signInCoordinator.delegate = self
        signInCoordinator.start()
    }
    
    func showMainTabFlow() {
        let mainTabCoordinator = MainTabCoordinator(navigationController: navigationController)
        mainTabCoordinator.parentCoordinator = self
        childCoordinators.append(mainTabCoordinator)
        mainTabCoordinator.start()
    }
}

extension GraceLogAppCoordinator: SignInCoordinatorDelegate {
    func didSignIn(_ coordinator: SignInCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMainTabFlow()
    }
}
