//
//  HomeViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

final class HomeViewController: UIViewController, View {
    weak var coordinator: Coordinator?
    var disposeBag = DisposeBag()
    
    private let headerView = HomeNavBarTableViewHeader()
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
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
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
    
    func bind(reactor: HomeViewReactor) {
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state in
                return state.currentSegment == .user
            }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, isUserSelected in
                owner.headerView.updateUI(isUserSelected: isUserSelected)
                owner.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedCommunity }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                DispatchQueue.main.async {
                    owner.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.user }
            .distinctUntilChanged()
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, user in
                owner.headerView.updateUser(user: user)
            })
            .disposed(by: disposeBag)
        
        headerView.segmentTapped
            .map { isUserSelected in
                return isUserSelected ?
                HomeViewReactor.Action.userButtonTapped :
                HomeViewReactor.Action.groupButtonTapped
            }
            .bind(to: reactor.action)
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
