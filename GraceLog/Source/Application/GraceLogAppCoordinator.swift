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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAuthenticationFailure),
            name: .authenticationFailed,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        isLoggedIn ? showMainTabFlow() : showLoginFlow()
    }
    
    @objc private func handleAuthenticationFailure() {
        showLoginFlow()
    }
    
    private func showLoginFlow() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.parentCoordinator = self
        childCoordinators.append(signInCoordinator)
        signInCoordinator.start()
    }
    
    private func showMainTabFlow() {
        let mainTabCoordinator = MainTabCoordinator(navigationController: navigationController)
        mainTabCoordinator.parentCoordinator = self
        childCoordinators.append(mainTabCoordinator)
        mainTabCoordinator.start()
    }
}
