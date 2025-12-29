//
//  CommunityGroupViewController.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import UIKit

import SnapKit
import Then

final class CommunityGroupViewController: GraceLogBaseViewController<CommunityGroupReactor> {
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left_theme"), for: .normal)
    }
    
    override func setupStyles() {
        super.setupStyles()
        navigationBar.addLeftItem(backButton)
        navigationBar.setupTitleLabel(text: "공동체")
    }
    override func bind(reactor: CommunityGroupReactor) {
        /// Action
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
}
}
