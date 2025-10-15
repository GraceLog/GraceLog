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

final class AnnouncementDetailViewController: GraceLogBaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationBar = GLNavigationBar().then {
        $0.setupTitleLabel(text: "공지사항")
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    init(reactor: AnnouncementDetailViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        view.backgroundColor = GLColor.backgroundSub.color
    }
    
    private func setupLayouts() {
        [navigationBar, scrollView].forEach { view.addSubview($0) }
        navigationBar.addLeftItem(backButton)
        scrollView.addSubview(containerStackView)
        [titleLabel, createdAtLabel, contentsLabel].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.directionalHorizontalEdges.width.equalToSuperview().inset(30)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        containerStackView.setCustomSpacing(40, after: createdAtLabel)
    }
    
    func bind(reactor: AnnouncementDetailViewReactor) {
        reactor.action.onNext(.fetchAnnouncement)
        
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$announcement)
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, announcement in
                guard let announcement else { return }
                owner.titleLabel.text = announcement.title
                owner.createdAtLabel.text = DateFormatterFactory.dateWithDot.string(from: announcement.createdAt)
                owner.contentsLabel.text = announcement.contents
            }
            .disposed(by: disposeBag)
    }
}
