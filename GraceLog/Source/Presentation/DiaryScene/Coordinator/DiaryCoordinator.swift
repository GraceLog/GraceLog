//
//  DiaryCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 2/5/25.
//

import UIKit

final class DiaryCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {
        // TODO
    }
    
    func startPush() -> UINavigationController {
        let diaryVC = DiaryViewController()
        diaryVC.view.backgroundColor = .white
        diaryVC.title = "일기작성"
        diaryVC.reactor = DiaryViewReactor(usecase: DefaultDiaryUseCase())
        navigationController.setViewControllers([diaryVC], animated: false)
        return navigationController
    }
}
