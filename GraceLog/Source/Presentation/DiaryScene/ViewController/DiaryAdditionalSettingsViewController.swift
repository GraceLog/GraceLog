//
//  DiaryAdditionalSettingsViewController.swift
//  GraceLog
//
//  Created by 이상준 on 4/21/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class DiaryAdditionalSettingsViewController: UIViewController, View {
    typealias Reactor = DiaryAdditionalSettingsViewReactor
    var disposeBag = DisposeBag()
    
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<DiaryAdditionalSettingsSection>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryAdditionalSettingsTableViewCell.identifier, for: indexPath) as? DiaryAdditionalSettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.updateUI(title: item.title, desc: item.desc, isOn: item.isOn)
            cell.selectionStyle = .none
            
            return cell
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        
        tableView.register(CommonSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CommonSectionHeaderView.identifier)
        tableView.register(DiaryAdditionalSettingsTableViewCell.self, forCellReuseIdentifier: DiaryAdditionalSettingsTableViewCell.identifier)
    }
    
    func bind(reactor: DiaryAdditionalSettingsViewReactor) {
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension DiaryAdditionalSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommonSectionHeaderView.identifier) as? CommonSectionHeaderView else {
            return nil
        }
        
        let sectionTitle = dataSource.sectionModels[section].header
        headerView.setTitle(sectionTitle, font: GLFont.bold16.font)
        headerView.updateTopOffset(section == 0 ? 4 : 20)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
