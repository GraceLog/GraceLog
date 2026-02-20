//
//  CommunityGroupCoordinator.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import UIKit

final class CommunityGroupCoordinator: NavigationCoordinator {
    private let communityId: Int
    private let memberId: Int
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, communityId: Int, memberId: Int) {
        self.navigationController = navigationController
        self.communityId = communityId
        self.memberId = memberId
    }
    
    func start() {
        let viewController = DependencyContainer.shared.injector
            .resolve(CommunityGroupViewController.self, argument: communityId)
        viewController.reactor?.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension CommunityGroupCoordinator {
    func showCommentBottomSheet(diaryID: Int) {
        let commentBottomSheetVC = CommentBottomSheetViewController(
            reactor: CommentBottomSheetViewReactor(
                usecase: DefaultCommentUseCase(commentRepository: DefaultCommentRepository(network: .init()), postId: diaryID)
            )
        )
        self.navigationController.present(commentBottomSheetVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func showDiaryDetail(diaryId: Int, communityId: Int?, memberId: Int?) {
        let diaryDetailsCoordinator = DiaryDetailsCoordinator(
            self.navigationController,
            diaryId: diaryId,
            communityId: communityId,
            memberId: memberId
        )
        diaryDetailsCoordinator.parentCoordinator = self
        self.childCoordinators.append(diaryDetailsCoordinator)
        diaryDetailsCoordinator.start()
    }
}
