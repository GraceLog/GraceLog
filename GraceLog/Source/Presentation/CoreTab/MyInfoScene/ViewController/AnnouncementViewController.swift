//
//  AnnouncementViewController.swift
//  GraceLog
//
//  Created by 이상준 on 9/11/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class AnnouncementViewController: GraceLogBaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationBar = GLNavigationBar().then {
        $0.setupTitleLabel(text: "공지사항")
    }
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "nav_chevron_left"), for: .normal)
    }
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 48
    }
    
    private let announcementEmptyImageView = UIImageView().then {
        $0.image = UIImage(named: "announcement_empty")
        $0.contentMode = .scaleAspectFit
    }
    
    private let announcementEmptyLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = GLColor.textAccent.color
        $0.text = "등록된 공지사항이 없습니다"
    }
    
    private lazy var annuncementTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorColor = GLColor.textMain.color
        $0.separatorInset = .zero
        $0.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: AnnouncementTableViewCell.reuseIdentifier)
    }
    
    init(reactor: AnnouncementViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    private func setupStyles() {
        view.backgroundColor = GLColor.backgroundSub.color
    }
    
    private func setupLayouts() {
        [navigationBar, containerStackView, annuncementTableView].forEach {
            view.addSubview($0)
        }
        navigationBar.addLeftItem(backButton)
        
        [announcementEmptyImageView, announcementEmptyLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        containerStackView.snp.makeConstraints {
            $0.center.equalTo(safeArea)
        }
        
        annuncementTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: AnnouncementViewReactor) {
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        annuncementTableView.rx.modelSelected(Announcement.self)
            .map { Reactor.Action.didTapAnnouncement($0.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let announcements = reactor.pulse(\.$announcements)
            .asDriver(onErrorJustReturn: [])
        
        announcements
            .drive(annuncementTableView.rx.items(
                cellIdentifier: AnnouncementTableViewCell.reuseIdentifier,
                cellType: AnnouncementTableViewCell.self)
            ) { row, item, cell in
                cell.selectionStyle = .none
                cell.configureUI(
                    title: item.title,
                    createdAt: item.createdAt,
                    contents: item.contents
                )
            }
            .disposed(by: disposeBag)
        
        announcements
            .drive(with: self) { owner, announcements in
                let isEmpty = announcements.isEmpty
                owner.containerStackView.isHidden = !isEmpty
                owner.annuncementTableView.isHidden = isEmpty
            }
            .disposed(by: disposeBag)
    }
}
