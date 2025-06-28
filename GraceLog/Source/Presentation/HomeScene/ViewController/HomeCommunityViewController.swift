//
//  HomeNextViewController.swift
//  GraceLog
//
//  Created by 이상준 on 2/8/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

final class HomeCommunityViewController: GraceLogBaseViewController, View {
    typealias Reactor = HomeCommunityViewReactor
    
    var disposeBag = DisposeBag()
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let communitySelectedView = HomeCommunitySelectedView()
    private let communityDiaryListView = HomeCommunityDiaryListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = HomeCommunityViewReactor(homeUsecase: DefaultHomeUseCase(
            userRepository: DefaultUserRepository(
                userService: UserService()
            ),
            homeRepository: DefaultHomeRepository()
        ))
        
        setupLayouts()
        setupConstraints()
    }
    
    private func setupLayouts() {
        view.addSubview(scrollView)
        
        let subviews = [communitySelectedView, communityDiaryListView]
        containerStackView.arrangedSubviews(subviews)
        
        scrollView.addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(50)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func bind(reactor: HomeCommunityViewReactor) {
        bindCommunitySelectedView(reactor: reactor)
        bindCommunityDiaryListView(reactor: reactor)
    }
}

// MARK: - Bindings
extension HomeCommunityViewController {
    private func bindCommunitySelectedView(reactor: HomeCommunityViewReactor) {
        let communityDataSource = RxCollectionViewSectionedReloadDataSource<HomeCommunitySelectedSection>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCommunitySelectedCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? HomeCommunitySelectedCollectionViewCell ?? HomeCommunitySelectedCollectionViewCell()
                cell.updateUI(
                    imageUrl: item.imageName,
                    community: item.title,
                    isSelected: item.isSelected
                )
                return cell
            }
        )
        
        Observable.combineLatest(
            reactor.pulse(\.$communitys),
            reactor.state.map { $0.selectedCommunityId }
        )
        .map { communitys, selectedId in
            let section = HomeCommunitySelectedSection.makeSection(
                from: communitys,
                selectedId: selectedId
            )
            return [section]
        }
        .bind(to: communitySelectedView.collectionView.rx.items(dataSource: communityDataSource))
        .disposed(by: disposeBag)
        
        communitySelectedView.collectionView.rx.itemSelected
            .withLatestFrom(reactor.pulse(\.$communitys)) { indexPath, communitys in
                return communitys[indexPath.item].id
            }
            .map { HomeCommunityViewReactor.Action.selectCommunity(id: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindCommunityDiaryListView(reactor: HomeCommunityViewReactor) {
        
    }
}
