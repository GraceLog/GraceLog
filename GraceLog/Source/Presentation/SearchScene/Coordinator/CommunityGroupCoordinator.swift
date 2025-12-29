//
//  CommunityGroupCoordinator.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import UIKit

final class CommunityGroupCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}
