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
        let myInfoVC = MyInfoViewController(reactor: MyInfoViewReactor())
        navigationController.setViewControllers([myInfoVC], animated: false)
    }
    
    func showProfileEditVC() {
        let profileEditCoordinator = ProfileEditCoordinator(self.navigationController)
        profileEditCoordinator.parentCoordinator = self
        self.childCoordinators.append(profileEditCoordinator)
        profileEditCoordinator.start()
    }
}
