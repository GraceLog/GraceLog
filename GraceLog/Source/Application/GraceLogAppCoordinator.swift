//
//  GraceLogAppCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 12/7/24.
//

import UIKit
import RxSwift

final class GraceLogAppCoordinator: NavigationCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let disposeBag = DisposeBag()
    
    private var isLoggedIn: Bool {
        TokenManager.shared.isLoggedIn()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        NotificationCenter.default.rx
            .notification(NotificationCenterManager.authenticationDidFail.name)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.handleAuthenticationFailure()
            }
            .disposed(by: disposeBag)
    }
    
    func start() {
        isLoggedIn ? showMainTabFlow() : showLoginFlow()
    }
    
    @objc private func handleAuthenticationFailure() {
        childCoordinators.removeAll()
        showLoginFlow()
    }
    
    private func showLoginFlow() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.parentCoordinator = self
        childCoordinators.append(signInCoordinator)
        signInCoordinator.delegate = self
        signInCoordinator.start()
    }
    
    private func showMainTabFlow() {
        let mainTabCoordinator = MainTabCoordinator(navigationController: navigationController)
        mainTabCoordinator.parentCoordinator = self
        childCoordinators.append(mainTabCoordinator)
        mainTabCoordinator.start()
    }
}

extension GraceLogAppCoordinator: SignInCoordinatorDelegate {
    func didSignIn(_ coordinator: SignInCoordinator) {
        removeChildCoordinator(coordinator)
        self.showMainTabFlow()
    }
}
