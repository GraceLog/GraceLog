//
//  Coordinator.swift
//  GraceLog
//
//  Created by 이상준 on 12/7/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func removeChildCoordinator(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}

/// UINavigation에 속한 ViewController에서 사용할 Coordinator
protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}
