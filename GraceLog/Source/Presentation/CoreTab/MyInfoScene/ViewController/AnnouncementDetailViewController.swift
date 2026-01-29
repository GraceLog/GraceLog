//
//  AccountmentDetailViewController.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class AnnouncementDetailViewController: GraceLogBaseViewController<AnnouncementDetailViewReactor> {
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left_theme"), for: .normal)
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 20
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold18.font
        $0.textColor = GLColor.textMain.color
        $0.numberOfLines = 2
    }
    
    private let createdAtLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = GLColor.textMain.color
    }
    
    private let contentsLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = GLColor.textMain.color
        $0.numberOfLines = 0
    }
    
    override func setupStyles() {
        super.setupStyles()
        view.backgroundColor = GLColor.backgroundSub.color
        navigationBar.setupTitleLabel(text: "공지사항")
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        contentView.addSubview(scrollView)
        navigationBar.addLeftItem(backButton)
        scrollView.addSubview(containerStackView)
        [titleLabel, createdAtLabel, contentsLabel].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints {
            $0.directionalVerticalEdges.width.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.directionalHorizontalEdges.width.equalToSuperview().inset(30)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        containerStackView.setCustomSpacing(40, after: createdAtLabel)
    }
    
    override func bind(reactor: AnnouncementDetailViewReactor) {
        super.bind(reactor: reactor)
        
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$announcement)
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, announcement in
                guard let announcement else { return }
                owner.titleLabel.text = announcement.title
                owner.createdAtLabel.text = DateFormatterFactory.dateWithDot.string(from: announcement.createdAt!)
                owner.contentsLabel.text = announcement.contents
            }
            .disposed(by: disposeBag)
    }
}
