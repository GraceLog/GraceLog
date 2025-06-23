//
//  HomeMyViewController.swift
//  GraceLog
//
//  Created by 이상준 on 6/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

final class HomeMyViewController: GraceLogBaseViewController, View {
    typealias Reactor = HomeMyViewReactor
    var disposeBag = DisposeBag()
    
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
                
                return cell
            case .contentList:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendTableViewCell.identifier, for: indexPath) as! HomeRecommendTableViewCell
                cell.selectionStyle = .none
                
                if let videoItem = item as? HomeVideoItem {
                    let image = UIImage(named: videoItem.imageName) ?? UIImage()
                    cell.configure(title: videoItem.title, image: image)
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = HomeMyViewReactor(homeUsecase: DefaultHomeUseCase(
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(50)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func configureTableView() {
        tableView.register(HomeTableViewHeader.self, forHeaderFooterViewReuseIdentifier: HomeTableViewHeader.identifier)
        tableView.register(HomeDiaryTableViewCell.self, forCellReuseIdentifier: HomeDiaryTableViewCell.identifier)
        tableView.register(HomeRecommendTableViewCell.self, forCellReuseIdentifier: HomeRecommendTableViewCell.identifier)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: HomeMyViewReactor) {
        // Action
        
        
        // State
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension HomeMyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let homeSection = HomeSection(rawValue: section) else { return UIView() }
        
        // FIXME: - 추후 API 연동 - 추천 말씀 및 추천 영상
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
    }
}
