//
//  CreateCommunityCoordinator.swift
//  GraceLog
//
//  Created by 이건준 on 12/28/25.
//

import UIKit

final class CreateCommunityCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = CreateCommunityViewController(reactor: CreateCommunityReactor(usecase: DefaultCreateCommunityUseCase(), coordinator: CreateCommunityCoordinator(navigationController: self.navigationController)))
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension CreateCommunityCoordinator {
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
