//
//  DiaryDetailsCoordinator.swift
//  GraceLog
//
//  Created by 이상준 on 9/21/25.
//

import UIKit

final class DiaryDetailsCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let diaryId: Int
    private let communityId: Int?
    private let memberId: Int?
    
    init(
        _ navigationController: UINavigationController,
        diaryId: Int,
        communityId: Int?,
        memberId: Int?
    ) {
        self.navigationController = navigationController
        self.diaryId = diaryId
        self.communityId = communityId
        self.memberId = memberId
    }
    
    func start() {
        let diaryDetailsVC = DependencyContainer.shared.injector.resolve(
            DiaryDetailsViewController.self,
            arguments: self as DiaryDetailsCoordinator,
            diaryId, communityId, memberId
        )
        self.navigationController.pushViewController(diaryDetailsVC, animated: true)
    }
    
    func showCommentBottomSheet() {
        let commentBottomSheetVC = CommentBottomSheetViewController(
            reactor: CommentBottomSheetViewReactor(
                usecase: DefaultCommentUseCase(commentRepository: DefaultCommentRepository(network: .init()), postId: diaryId)
            )
        )
        self.navigationController.present(commentBottomSheetVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
