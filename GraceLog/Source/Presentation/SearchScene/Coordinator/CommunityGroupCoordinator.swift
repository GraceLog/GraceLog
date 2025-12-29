//
//  CommunityGroupCoordinator.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import UIKit

final class CommunityGroupCoordinator: NavigationCoordinator {
    private let id: Int
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.id = id
    }
    
    func start() {
        let viewController = CommunityGroupViewController(reactor: CommunityGroupReactor(usecase: DefaultCommunityGroupUseCase(id: id), coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension CommunityGroupCoordinator {
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
