//
//  HomeViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit
import RxDataSources
import ReactorKit

enum HomeMenuItem: CaseIterable {
    case user
    case group
    
    var title: String {
        switch self {
        case .user:
            // TODO: - User관련 정보 처리 필요
            return "승렬"
        case .group:
            return "공동체"
        }
    }
}

final class HomeViewController: GraceLogBaseViewController, View {
    weak var coordinator: Coordinator?
    var disposeBag = DisposeBag()
    
    private let navigationBar = GLNavigationBar().then {
        $0.backgroundColor = .white
    }
    
    private let homeMenuView = GLUnderlineSegmentedControl(items: HomeMenuItem.allCases.map { $0.title }).then {
        $0.setHeight(50)
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: GLFont.bold18.font], for: .normal)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.themeColor, .font: GLFont.bold18.font], for: .selected)
    }
    
    private let bellButton = UIButton().then {
        $0.setImage(UIImage(named: "bell"), for: .normal)
        $0.tintColor = .black
        $0.setDimensions(width: 32, height: 32)
    }
    
    private let profileButton = UIButton().then {
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.setBackgroundImage(UIImage(named: "profile"), for: .normal)
        $0.setDimensions(width: 32, height: 32)
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = UIColor(hex: 0xF4F4F4)
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
        $0.sectionFooterHeight = 0
        $0.estimatedSectionHeaderHeight = 100
        $0.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
            switch dataSource[indexPath.section] {
            case .diary:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeDiaryTableViewCell.identifier, for: indexPath) as! HomeDiaryTableViewCell
                cell.selectionStyle = .none
                
                if let diaryItem = item as? [MyDiaryItem] {
                    cell.configure(with: diaryItem)
                }
                
                if let username = self?.reactor?.currentState.user?.name {
                    cell.setTitle(username: username)
                }
                
                return cell
            case .contentList:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendTableViewCell.identifier, for: indexPath) as! HomeRecommendTableViewCell
                cell.selectionStyle = .none
                
                if let videoItem = item as? HomeVideoItem {
                    let image = UIImage(named: videoItem.imageName) ?? UIImage()
                    cell.configure(title: videoItem.title, image: image)
                }
                return cell
            case .communityButtons:
                let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier, for: indexPath) as! CommunityTableViewCell
                cell.selectionStyle = .none
                
                if let communityItem = item as? [CommunityItem] {
                    cell.configure(with: communityItem)
                    return cell
                }
                return cell
            case .communityPosts:
                let diaryItem = item as! CommunityDiaryItem
                switch diaryItem.type {
                case .my:
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeCommunityMyTableViewCell.identifier, for: indexPath) as! HomeCommunityMyTableViewCell
                    cell.selectionStyle = .none
                    cell.configure(title: diaryItem.title, subtitle: diaryItem.subtitle, likes: diaryItem.likes, comments: diaryItem.comments)
                    return cell
                case .regular:
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeCommunityUserTableViewCell.identifier, for: indexPath) as! HomeCommunityUserTableViewCell
                    cell.selectionStyle = .none
                    cell.configure(username: diaryItem.username, title: diaryItem.title, subtitle: diaryItem.subtitle, likes: diaryItem.likes, comments: diaryItem.comments)
                    return cell
                }
            }
        }
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = HomeViewReactor(homeUsecase: DefaultHomeUseCase(
            userRepository: DefaultUserRepository(
                userService: UserService()
            ),
            homeRepository: DefaultHomeRepository()
        ))
        configureUI()
        configureTableView()
        configureNavBar()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func configureNavBar() {
        navigationBar.addLeftItem(homeMenuView)
        navigationBar.addRightItem(bellButton)
        navigationBar.addRightItem(profileButton)
    }
    
    private func configureTableView() {
        // User
        tableView.register(HomeTableViewHeader.self, forHeaderFooterViewReuseIdentifier: HomeTableViewHeader.identifier)
        tableView.register(HomeDiaryTableViewCell.self, forCellReuseIdentifier: HomeDiaryTableViewCell.identifier)
        tableView.register(HomeRecommendTableViewCell.self, forCellReuseIdentifier: HomeRecommendTableViewCell.identifier)
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
        
        // Community
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
        tableView.register(HomeCommunityDateHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeCommunityDateHeaderView.identifier)
        tableView.register(HomeCommunityUserTableViewCell.self, forCellReuseIdentifier: HomeCommunityUserTableViewCell.identifier)
        tableView.register(HomeCommunityMyTableViewCell.self, forCellReuseIdentifier: HomeCommunityMyTableViewCell.identifier)
    }
    
    // MARK: - 유저 업데이트 시 NOTI
    override func onUserProfileUpdated(_ user: GraceLogUser) {
        reactor?.action.onNext(.updateUser(user))
    }
    
    func bind(reactor: HomeViewReactor) {
        // Action
        homeMenuView.rx.value
            .map { HomeMenuItem.allCases[$0] }
            .bind(with: self) { owner, selectedMenu in
                switch selectedMenu {
                case .user:
                    reactor.action.onNext(HomeViewReactor.Action.userButtonTapped)
                case .group:
                    reactor.action.onNext(HomeViewReactor.Action.groupButtonTapped)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Any.self)
            .subscribe(onNext: { item in
                if let communityItem = item as? CommunityItem {
                    reactor.action.onNext(.selectCommunity(item: communityItem))
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self, let reactor = self.reactor else { return }
                
                if let communityCell = cell as? CommunityTableViewCell {
                    communityCell.communityButtonTapped
                        .take(1)
                        .map { HomeViewReactor.Action.selectCommunity(item: $0) }
                        .bind(to: reactor.action)
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.currentSegment }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, selectedSegment in
                let selectedSegmentIndex = selectedSegment == .user ? 0 : 1
                owner.homeMenuView.selectedSegmentIndex = selectedSegmentIndex
                owner.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedCommunity }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, _ in
                DispatchQueue.main.async {
                    owner.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.user }
            .distinctUntilChanged()
            .compactMap { $0 }
            .subscribe(with: self) { owner, user in
                // TODO: - 상준 네비게이션바 사용자 이름 및 프로필 이미지 등록
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.error }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, error in
                owner.view.makeToast(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let reactor = reactor else { return nil }
        
        switch reactor.currentState.currentSegment {
        case .user:
            guard let homeSection = HomeSection(rawValue: section) else { return UIView() }
            
            switch homeSection {
            case .diary:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewHeader.identifier) as! HomeTableViewHeader
                header.configure(
                    title: "오늘의 말씀",
                    desc: "순종이 제사보다 낫고 듣는 것이 숫양의 기름보다 나으니",
                    paragraph: "사무엘상 5:22"
                )
                return header
            case .contentList:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewHeader.identifier) as! HomeTableViewHeader
                header.configure(title: "추천영상", desc: "#순종 #도전", paragraph: nil)
                return header
            }
            
        case .group:
            if section == 0 {
                return nil
            } else {
                let sectionModel = reactor.currentState.sections[section]
                
                if case let .communityPosts(date, _) = sectionModel {
                    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeCommunityDateHeaderView.identifier) as! HomeCommunityDateHeaderView
                    header.configure(date: date)
                    return header
                }
                
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let reactor = reactor else { return 0 }
        
        switch reactor.currentState.currentSegment {
        case .user:
            return UITableView.automaticDimension
        case .group:
            if section == 0 {
                return .leastNonzeroMagnitude
            } else {
                return UITableView.automaticDimension
            }
        }
    }
}
