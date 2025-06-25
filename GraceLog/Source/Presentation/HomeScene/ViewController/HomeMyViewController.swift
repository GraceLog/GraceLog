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
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let myBibleView = HomeMyBibleView()
    private let myDiaryView = HomeMyDiaryView()
    private let myRecommendVideoView = HomeMyRecommendVideoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = HomeMyViewReactor(homeUsecase: DefaultHomeUseCase(
            userRepository: DefaultUserRepository(
                userService: UserService()
            ),
            homeRepository: DefaultHomeRepository()
        ))
        
        setupUI()
    }
    
    private func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(50)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        scrollView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        let subViews = [myBibleView, myDiaryView, myRecommendVideoView]
        containerStackView.arrangedSubviews(subViews)
    }
    
    func bind(reactor: HomeMyViewReactor) {
        bindHomeMyBibleView(reactor: reactor)
        bindHomeMyDiaryView(reactor: reactor)
        bindHomeMyRecommendVideoView(reactor: reactor)
    }
}

// MARK: Home Bindings
extension HomeMyViewController {
    private func bindHomeMyBibleView(reactor: HomeMyViewReactor) {
        // TODO: 성경데이터 모델링 및 API 연동하여 Reactor의 데이터로 바인딩 필요
        myBibleView.setData(
            title: "오늘의 말씀",
            desc:"순종이 제사보다 낫고\n듣는 것이 숫양의 기름보다 나으니",
            paragraph: "사무엘상 5:22"
        )
    }
    
    private func bindHomeMyDiaryView(reactor: HomeMyViewReactor) {
        myDiaryView.diaryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.homeMyData?.diaryList }
            .asDriver(onErrorJustReturn: [])
            .drive(myDiaryView.diaryCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                
                if index == 0 {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HomeLatestDiaryCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as! HomeLatestDiaryCollectionViewCell
                    cell.setData(item: item)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HomePastDiaryCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as! HomePastDiaryCollectionViewCell
                    cell.setData(item: item)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.homeMyData?.diaryList }
            .map { $0.map { MyDiaryItem(date: $0.date, dateDesc: $0.dateDesc, title: $0.title, desc: $0.desc, tags: $0.tags, image: $0.image) } }
            .subscribe(onNext: { [weak self] items in
                self?.myDiaryView.updateDateLabelsAndLines(with: items)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHomeMyRecommendVideoView(reactor: HomeMyViewReactor) {
        myRecommendVideoView.recommendVideoTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.homeMyData?.videoList }
            .asDriver(onErrorJustReturn: [])
            .drive(myRecommendVideoView.recommendVideoTableView.rx.items(
                cellIdentifier: HomeRecommendVideoTableViewCell.reuseIdentifier,
                cellType: HomeRecommendVideoTableViewCell.self)
            ) { index, item, cell in
                cell.configure(title: item.title, image: item.imageName)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: HomeMyDiaryView CollectionView UICollectionViewDelegateFlowLayout
extension HomeMyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = self.view.bounds.width - 97
        let width = screenWidth
        
        let height: CGFloat = indexPath.item == 0 ?
        screenWidth * 1.0 : screenWidth * (11.0/30.0)
        
        return CGSize(width: width, height: height)
    }
}

// MARK: HomeRecommendVideoView TableView UITableViewDelegate
extension HomeMyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView == myRecommendVideoView.recommendVideoTableView else { return nil }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeRecommendVideoTableViewHeaderView.reuseIdentifier) as! HomeRecommendVideoTableViewHeaderView
        headerView.configure(
            title: "추천영상",
            desc: "#순종 #도전"
        )
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == myRecommendVideoView.recommendVideoTableView ? 60 : 0
    }
}
