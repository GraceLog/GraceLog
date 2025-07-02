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
        setupStyles()
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
    
    private func setupStyles() {
        communityDiaryListView.diaryTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: HomeCommunityViewReactor) {
        bindCommunitySelectedCollectionView(reactor: reactor)
        bindCommunityDiaryTableView(reactor: reactor)
    }
}

// MARK: - Bindings
extension HomeCommunityViewController {
    private func bindCommunitySelectedCollectionView(reactor: HomeCommunityViewReactor) {
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
    
    private func bindCommunityDiaryTableView(reactor: HomeCommunityViewReactor) {
        let diaryDataSource = RxTableViewSectionedReloadDataSource<HomeCommunityDiarySection>(
            configureCell: { _, tableView, indexPath, item in
                switch item {
                case .diary(let diaryItem):
                    switch diaryItem.type {
                    case .my:
                        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCommunityMyDiaryTableViewCell.reuseIdentifier, for: indexPath) as! HomeCommunityMyDiaryTableViewCell
                        
                        cell.updateUI(
                            title: diaryItem.title,
                            subtitle: diaryItem.subtitle,
                            likes: diaryItem.likes,
                            comments: diaryItem.comments,
                            isLiked: diaryItem.isLiked
                        )
                        
                        cell.likeButton.rx.tap
                            .map { HomeCommunityViewReactor.Action.didTapLike(diaryId: diaryItem.id)}
                            .bind(to: reactor.action)
                            .disposed(by: cell.disposeBag)
                        
                        cell.commentButton.rx.tap
                            .asDriver()
                            .drive(onNext: {
                                print("댓글 달기로 이동")
                            })
                            .disposed(by: cell.disposeBag)
                        
                        return cell
                    case .regular:
                        let cell = tableView.dequeueReusableCell(
                            withIdentifier: HomeCommunityUserDiaryTableViewCell.reuseIdentifier,
                            for: indexPath
                        ) as! HomeCommunityUserDiaryTableViewCell
                        
                        cell.updateUI(
                            username: diaryItem.username,
                            title: diaryItem.title,
                            subtitle: diaryItem.subtitle,
                            likes: diaryItem.likes,
                            comments: diaryItem.comments,
                            isLiked: diaryItem.isLiked
                        )
                        
                        cell.likeButton.rx.tap
                            .map { HomeCommunityViewReactor.Action.didTapLike(diaryId: diaryItem.id)}
                            .bind(to: reactor.action)
                            .disposed(by: cell.disposeBag)
                        
                        cell.commentButton.rx.tap
                            .asDriver()
                            .drive(onNext: {
                                print("댓글 달기로 이동")
                            })
                            .disposed(by: cell.disposeBag)
                        
                        return cell
                    }
                }
            }
        )
        
        reactor.pulse(\.$communityDiarySections)
            .asDriver(onErrorJustReturn: [])
            .drive(communityDiaryListView.diaryTableView.rx.items(dataSource: diaryDataSource))
            .disposed(by: disposeBag)
        
        communityDiaryListView.diaryTableView.rx.modelSelected(HomeCommunityDiaryItem.self)
            .asDriver()
            .drive(with: self) { owner, selectedItem in
                switch selectedItem {
                case .diary(let diaryItem):
                    print("감사일기 상세로 이동")
                case .dateHeader:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension HomeCommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let reactor = reactor else { return nil }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HomeCommunityDateHeaderView.reuseIdentifier
        ) as! HomeCommunityDateHeaderView
        
        let sections = reactor.currentState.communityDiarySections
        headerView.updateUI(date: sections[section].date)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
