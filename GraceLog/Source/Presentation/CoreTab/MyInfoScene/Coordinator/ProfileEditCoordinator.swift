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
        self.pushProfileEditViewController()
    }
    
    func pushProfileEditViewController() {
        let useCase = DefaultMyInfoUseCase(
            userRepository: DefaultUserRepository(
                userService: UserService()
            )
        )
        
        let reactor = ProfileEditViewReactor(coordinator: self, useCase: useCase)
        let profileEditVC = ProfileEditViewController()
        profileEditVC.view.backgroundColor = .white
        profileEditVC.reactor = reactor
        profileEditVC.title = "프로필 편집"
        
        self.navigationController.pushViewController(profileEditVC, animated: true)
    }
    
    func didFinishProfileEdit() {
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
