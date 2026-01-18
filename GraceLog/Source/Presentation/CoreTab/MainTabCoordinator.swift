//
//  MainTabCoordinator.swift
//  GraceLog
//
//  Created by 이건준 on 7/5/25.
//

import UIKit

final class MainTabCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private weak var tabbarController: MainTabController?
    
    private let diaryCoordinator = DiaryCoordinator(
        navigationController: NavigationController()
    )
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabbarController = MainTabController()
        self.tabbarController = tabbarController
        tabbarController.delegate = self
        
        let homeCoordinator = HomeCoordinator(navigationController: NavigationController())
        let searchCoordinator = SearchCoordinator(navigationController: NavigationController())
        let myInfoCoordinator = MyInfoCoordinator(navigationController: NavigationController())
        
        let dummyDiaryNav = UINavigationController()
        dummyDiaryNav.tabBarItem = UITabBarItem(
            title: "일기작성",
            image: UIImage(named: "tab_edit"),
            selectedImage: UIImage(named: "tab_home_edit")
        )
        
        let viewControllers: [UIViewController] = [
            homeCoordinator.navigationController,
            dummyDiaryNav,
            searchCoordinator.navigationController,
            myInfoCoordinator.navigationController
        ]
        
        viewControllers[0].tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "tab_home"),
            selectedImage: UIImage(named: "tab_home_selected")
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
        
        homeCoordinator.start()
        searchCoordinator.start()
        myInfoCoordinator.start()
        
        tabbarController.viewControllers = viewControllers
        navigationController.setViewControllers([tabbarController], animated: false)
    }
}

extension MainTabCoordinator: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        
        if viewController.tabBarItem.title == "일기작성" {
            presentDiary()
            return false
        }
        
        return true
    }
    
    private func presentDiary() {
        diaryCoordinator.start()
        diaryCoordinator.navigationController.modalPresentationStyle = .fullScreen
        tabbarController?.present(
            diaryCoordinator.navigationController,
            animated: true
        )
    }
}
