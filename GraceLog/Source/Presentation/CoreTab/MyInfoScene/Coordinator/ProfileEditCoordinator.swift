//
//  ProfileEditCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 4/17/25.
//

import UIKit
import YPImagePicker

final class ProfileEditCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileEditVC = DependencyContainer.shared.injector.resolve(ProfileEditViewController.self)
        profileEditVC.reactor?.coordinator = self
        navigationController.pushViewController(profileEditVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func showImagePicker(completion: @escaping (UIImage?) -> Void) {
        ImagePickerManager.showImagePicker(
            from: navigationController,
            completion: completion
        )
    }
}
