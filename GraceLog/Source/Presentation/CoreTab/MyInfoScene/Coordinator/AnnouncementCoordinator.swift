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
        let announcementVC = AnnouncementViewController(
            reactor: AnnouncementViewReactor(
                coordinator: self,
                usecase: DefaultAnnouncementUseCase()
            )
        )
        self.navigationController.pushViewController(announcementVC, animated: true)
    }
    
    func showAnnouncementDetail(announcement: Announcement) {
        let detailVC = AnnouncementDetailViewController(
            reactor: AnnouncementDetailViewReactor(
                coordinator: self,
                announcement: announcement
            )
        )
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
