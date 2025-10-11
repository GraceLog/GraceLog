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
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {}
    
    func start(diaryId: Int) {
        let diaryDetailsVC = DiaryDetailsViewController(
            reactor: DiaryDetailsViewReactor(
                coordinator: self,
                usecase: DefaultDiaryDetailsUseCase(
                    diaryId: diaryId
                )
            )
        )
        self.navigationController.pushViewController(diaryDetailsVC, animated: true)
    }
    
    func showCommentBottomSheet() {
        let commentBottomSheetVC = CommentBottomSheetViewController(
            reactor: CommentBottomSheetViewReactor(
                usecase: DefaultCommentUseCase()
            )
        )
        self.navigationController.present(commentBottomSheetVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
