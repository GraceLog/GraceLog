//
//  MyInfoViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit
import RxDataSources
import ReactorKit

final class MyInfoViewController: GraceLogBaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationBar = GLNavigationBar().then {
        $0.backgroundColor = UIColor(hex: 0xF4F4F4)
        $0.setupTitleLabel(text: "내 계정")
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = UIColor(hex: 0xF4F4F4)
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MyInfoSection>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
            if let profileItem = item as? ProfileItem {
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.selectionStyle = .none
                cell.updateUI(with: profileItem)
                return cell
            } else if let myInfoItem = item as? MyInfoItem {
                let section = dataSource[indexPath.section]
                
                if case .logout = section, let myInfoItem = item as? MyInfoItem {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoButtonTableViewCell.identifier, for: indexPath) as! MyInfoButtonTableViewCell
                    cell.updateUI(title: myInfoItem.title, textColor: .black)
                    return cell
                } else if case .withdrawal = section, let myInfoItem = item as? MyInfoItem {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoButtonTableViewCell.identifier, for: indexPath) as! MyInfoButtonTableViewCell
                    cell.updateUI(title: myInfoItem.title, textColor: .themeColor)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifier, for: indexPath) as! MyInfoTableViewCell
                    cell.selectionStyle = .none
                    cell.separatorInset = .init(top: 0, left: 61, bottom: 0, right: 0)
                    cell.updateUI(imgName: myInfoItem.icon, title: myInfoItem.title)
                    return cell
                }
            }
            return UITableViewCell()
        }
    )
    
    init(reactor: MyInfoViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(hex: 0xF4F4F4)
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func configureTableView() {
        tableView.register(MyInfoSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MyInfoSectionHeaderView.identifier)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.register(MyInfoTableViewCell.self, forCellReuseIdentifier: MyInfoTableViewCell.identifier)
        tableView.register(MyInfoButtonTableViewCell.self, forCellReuseIdentifier: MyInfoButtonTableViewCell.identifier)
        
        tableView.delegate = self
    }
    
    override func onUserProfileUpdated(_ user: GraceLogUser) {
        reactor?.action.onNext(.refreshData)
    }
    
    func bind(reactor: MyInfoViewReactor) {
        // Action
        Observable.just(Reactor.Action.viewDidLoad)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { Reactor.Action.itemSelected(at: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.selectedItem }
            .withUnretained(self)
            .subscribe(onNext: { owner, itemType in
                switch itemType {
                case .myProfile:
                    reactor.pushMyInfoEdit()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension MyInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let title = dataSource[section].title {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyInfoSectionHeaderView.identifier) as? MyInfoSectionHeaderView
            headerView?.setTitle(title)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataSource[section]
        
        switch sectionModel {
        case .profile, .withdrawal:
            return .leastNonzeroMagnitude
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = dataSource[indexPath.section]
        
        switch sectionModel {
        case .profile:
            return UITableView.automaticDimension
        default:
            return 40
        }
    }
}
