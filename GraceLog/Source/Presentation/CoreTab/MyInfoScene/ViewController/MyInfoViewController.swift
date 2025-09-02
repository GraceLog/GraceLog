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

final class MyInfoViewController: GraceLogBaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationBar = GLNavigationBar().then {
        $0.backgroundColor = .white
        $0.setupTitleLabel(text: "내 계정")
    }
    
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
            case .pushNotification:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoSwitchTableViewCell.identifier, for: indexPath) as! MyInfoSwitchTableViewCell
                cell.updateUI(imageName: myInfoItem.icon, title: myInfoItem.title, isOn: false)
                return cell
            case .logout:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoButtonTableViewCell.identifier, for: indexPath) as! MyInfoButtonTableViewCell
                cell.updateUI(title: myInfoItem.title, textColor: .black)
                return cell
            case .withdrawal:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoButtonTableViewCell.identifier, for: indexPath) as! MyInfoButtonTableViewCell
                cell.updateUI(title: myInfoItem.title, textColor: .themeColor)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifier, for: indexPath) as! MyInfoTableViewCell
                cell.selectionStyle = .none
                cell.separatorInset = .init(top: 0, left: 61, bottom: 0, right: 0)
                cell.updateUI(imageName: myInfoItem.icon, title: myInfoItem.title)
                return cell
            }
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
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    private func setupStyles() {
        view.backgroundColor = .white
    }
    
    private func setupLayouts() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        
        let subviews = [profileView, tableView]
        containerStackView.arrangedSubviews(subviews)
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func bind(reactor: MyInfoViewReactor) {
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
        case .withdrawal:
            return .leastNonzeroMagnitude
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = dataSource[indexPath.section]
        
        switch sectionModel {
        case .pushNotification:
            return 45.0
        default:
            return 40
        }
    }
}
