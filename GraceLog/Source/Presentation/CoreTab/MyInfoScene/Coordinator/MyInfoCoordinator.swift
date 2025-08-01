//
//  MyInfoViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit

final class MyInfoCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let myInfoVC = DependencyContainer.shared.injector.resolve(MyInfoViewController.self)
        
        if let reactor = myInfoVC.reactor {
            reactor.coordinator = self
        }
        
        navigationController.setViewControllers([myInfoVC], animated: false)
    }
    
    func showProfileEditVC() {
        let profileEditCoordinator = ProfileEditCoordinator(self.navigationController)
        profileEditCoordinator.parentCoordinator = self
        self.childCoordinators.append(profileEditCoordinator)
        profileEditCoordinator.start()
    }
}
