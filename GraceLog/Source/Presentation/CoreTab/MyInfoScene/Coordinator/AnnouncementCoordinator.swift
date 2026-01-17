//
//  AnnouncementCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 9/12/25.
//

import UIKit


final class AnnouncementCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let announcementVC = DependencyContainer.shared.injector.resolve(AnnouncementViewController.self)
        announcementVC.reactor?.coordinator = self
        navigationController.pushViewController(announcementVC, animated: true)
    }
    
    func showAnnouncementDetail(announcementId: Int) {
        let announcementDetailVC = DependencyContainer.shared.injector.resolve(
            AnnouncementDetailViewController.self,
            argument: announcementId
        )
        announcementDetailVC.reactor?.coordinator = self
        navigationController.pushViewController(announcementDetailVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
