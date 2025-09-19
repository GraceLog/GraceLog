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
        myInfoVC.reactor?.coordinator = self
        navigationController.setViewControllers([myInfoVC], animated: false)
    }
    
    func showProfileEdit() {
        let profileEditCoordinator = ProfileEditCoordinator(self.navigationController)
        profileEditCoordinator.parentCoordinator = self
        self.childCoordinators.append(profileEditCoordinator)
        profileEditCoordinator.start()
    }
    
    func showAnnouncement() {
        let announcementCoordinator = AnnouncementCoordinator(self.navigationController)
        announcementCoordinator.parentCoordinator = self
        self.childCoordinators.append(announcementCoordinator)
        announcementCoordinator.start()
    }
}
