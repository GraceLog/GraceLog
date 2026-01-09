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
        let viewController = CommunityGroupViewController(reactor: CommunityGroupReactor(diaryDetailUseCase: DefaultDiaryDetailsUseCase(diaryRepository: DefaultDiaryRepository(network: .init()), communityId: communityId, memberId: memberId), coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension CommunityGroupCoordinator {
    func showCommentBottomSheet(diaryID: Int) {
        let commentBottomSheetVC = CommentBottomSheetViewController(
            reactor: CommentBottomSheetViewReactor(
                usecase: DefaultCommentUseCase(diaryID: diaryID)
            )
        )
        self.navigationController.present(commentBottomSheetVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
