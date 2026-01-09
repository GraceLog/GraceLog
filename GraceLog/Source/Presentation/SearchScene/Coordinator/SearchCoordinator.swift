//
//  SearchCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit

final class SearchCoordinator: NavigationCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController(reactor: SearchViewReactor(usecase: DefaultSearchCommunityUseCase(), coordinator: SearchCoordinator(navigationController: self.navigationController)))
        navigationController.setViewControllers([searchViewController], animated: false)
    }
}

extension SearchCoordinator {
    func showProfileViewController(id: Int) {
        print("선택한 프로필 아이디: \(id)")
    }
    
    func showCommunityChattingViewController(id: Int) {
        print("선택한 채팅방 아이디: \(id)")
    }
    
    func showCommunityViewController(communityId: Int, memberId: Int) {
        let coordinator = CommunityGroupCoordinator(navigationController: self.navigationController, communityId: communityId, memberId: memberId)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showCreateCommunityViewController() {
        let coordinator = CreateCommunityCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
