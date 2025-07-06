//
//  MainTabCoordinator.swift
//  GraceLog
//
//  Created by 이건준 on 7/5/25.
//

import UIKit

final class MainTabCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabbarController: MainTabController = MainTabController()
        let homeCoordinator = HomeCoordinator(navigationController: NavigationController())
        let diaryCoordinator = DiaryCoordinator(navigationController: NavigationController())
        let searchCoordinator = SearchCoordinator(navigationController: NavigationController())
        let myInfoCoordinator = MyInfoCoordinator(navigationController: NavigationController())
        
        let tabCoordinators: [NavigationCoordinator] = [
            homeCoordinator,
            diaryCoordinator,
            searchCoordinator,
            myInfoCoordinator
        ]
        let viewControllers = tabCoordinators.map { $0.navigationController }
        
        viewControllers[0].tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "tab_home"),
            selectedImage: UIImage(named: "tab_home_selected")
        )
        viewControllers[1].tabBarItem = UITabBarItem(
            title: "일기작성",
            image: UIImage(named: "tab_edit"),
            selectedImage: UIImage(named: "tab_home_edit")
        )
        viewControllers[2].tabBarItem = UITabBarItem(
            title: "찾기",
            image: UIImage(named: "tab_search"),
            selectedImage: UIImage(named: "tab_search_selected")
        )
        
        viewControllers[3].tabBarItem = UITabBarItem(
            title: "계정",
            image: UIImage(named: "tab_user"),
            selectedImage: UIImage(named: "tab_user_selected")
        )
        
        tabCoordinators.forEach { coordinator in
            coordinator.start()
        }
        
        tabbarController.viewControllers = viewControllers
        
        navigationController.setViewControllers([tabbarController], animated: true)
    }
}
