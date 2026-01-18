//
//  MyInfoViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit
import RxDataSources
import ReactorKit
import RxSwift
import Kingfisher

final class MyInfoViewController: GraceLogBaseViewController<MyInfoViewReactor> {
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = GLColor.backgroundMain.lightModeColor
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let profileView = MyInfoProfileView()
    private lazy var tableView = AutoSizingTableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = GLColor.backgroundMain.lightModeColor
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        $0.register(MyInfoSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MyInfoSectionHeaderView.identifier)
        $0.register(MyInfoTableViewCell.self, forCellReuseIdentifier: MyInfoTableViewCell.identifier)
        $0.register(MyInfoSwitchTableViewCell.self, forCellReuseIdentifier: MyInfoSwitchTableViewCell.identifier)
        $0.register(MyInfoButtonTableViewCell.self, forCellReuseIdentifier: MyInfoButtonTableViewCell.identifier)
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MyInfoSection>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
            guard let myInfoItem = item as? MyInfoItem else {
                return UITableViewCell()
            }
            
            let section = dataSource[indexPath.section]
            
            switch section {
            case .notificationSettings:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoSwitchTableViewCell.identifier, for: indexPath) as! MyInfoSwitchTableViewCell
                cell.updateUI(imageName: myInfoItem.icon, title: myInfoItem.title, isOn: false)
                return cell
            case .accountSettings:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoButtonTableViewCell.identifier, for: indexPath) as! MyInfoButtonTableViewCell
                cell.updateUI(title: myInfoItem.title, textColor: .black)
                return cell
            case .withdrawal:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoButtonTableViewCell.identifier, for: indexPath) as! MyInfoButtonTableViewCell
                cell.updateUI(title: myInfoItem.title, textColor: .themeColor)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifier, for: indexPath) as! MyInfoTableViewCell
                cell.updateUI(imageName: myInfoItem.icon, title: myInfoItem.title)
                return cell
            }
        }
    )
    
    override func setupStyles() {
        super.setupStyles()
        view.backgroundColor = GLColor.backgroundSub.color
        navigationBar.setupTitleLabel(text: "내 계정")
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        contentView.addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        
        let subviews = [profileView, tableView]
        containerStackView.arrangedSubviews(subviews)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        scrollView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func bind(reactor: MyInfoViewReactor) {
        bindMyInfoProfileView(reactor: reactor)
        
        // Action
        Observable.just(Reactor.Action.viewDidLoad)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { Reactor.Action.itemSelected(at: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        NotificationCenterManager.reloadMyInfo.addObserver()
            .map { _ in Reactor.Action.updateUser }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Bindings
extension MyInfoViewController {
    func bindMyInfoProfileView(reactor: MyInfoViewReactor) {
        reactor.pulse(\.$user)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, user in
                owner.profileView.updateUI(
                    imageURL: user.profileImageURL,
                    name: user.name,
                    email: user.email
                )
            }
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
        case .accountSettings:
            return 22 + 60
        case .withdrawal:
            return 15
        default:
            return 22 + 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == dataSource.sectionModels.count - 1 else { return nil }
        
        let footerView = UIView()
        let versionLabel = UILabel().then {
            $0.text = "Ver 0.0.1"
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = GLFont.regular12.font
            $0.textColor = .graceGray
        }
        
        footerView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(70)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == dataSource.sectionModels.count - 1 ? 110 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = dataSource[indexPath.section]
        
        switch sectionModel {
        case .notificationSettings:
            return 45.0
        default:
            return 40
        }
    }
}
