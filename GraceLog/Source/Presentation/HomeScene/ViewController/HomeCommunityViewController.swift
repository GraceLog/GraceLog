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
    
    private let communitySelectedView = HomeCommunityListView()
    private let communityDiaryListView = HomeCommunityDiaryListView()
    
    init(reactor: HomeCommunityViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        scrollView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func bind(reactor: HomeCommunityViewReactor) {
        bindCommunitySelectedCollectionView(reactor: reactor)
        bindCommunityDiaryTableView(reactor: reactor)
        
        communityDiaryListView.diaryTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - Bindings
extension HomeCommunityViewController {
    private func bindCommunitySelectedCollectionView(reactor: HomeCommunityViewReactor) {
        let communityDataSource = RxCollectionViewSectionedReloadDataSource<HomeCommunityListSection>(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCommunityListCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? HomeCommunityListCollectionViewCell ?? HomeCommunityListCollectionViewCell()
                
                let selectedId = self?.reactor?.currentState.selectedCommunityId
                let isSelected = item.community.id == selectedId
                
                cell.updateUI(
                    imageUrl: item.community.imageName,
                    community: item.community.title,
                    isSelected: isSelected
                )
                return cell
            }
        )
        
        reactor.pulse(\.$communitys)
            .map { communities in
                let items = communities.map { community in
                    CommunityItem.community(community)
                }
                return [HomeCommunityListSection.communitySection(items: items)]
            }
            .bind(to: communitySelectedView.communityListCollectionView.rx.items(dataSource: communityDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedCommunityId }
            .distinctUntilChanged()
            .skip(1) // 초기 값 nil이기 때문
            .subscribe(onNext: { [weak self] _ in
                self?.communitySelectedView.communityListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        communitySelectedView.communityListCollectionView.rx.itemSelected
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
                        
                        cell.profileImgView.rx.gestureTap
                            .asDriver()
                            .drive(onNext: { [weak self] _ in
                                guard let self,
                                      let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                                      let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as HomeCommunityDiaryItem else {
                                    return
                                }

                                // TODO: - 선택한 유저 정보로 이동
                                if case .diary(let diaryItem) = selectedItem {
                                    let username = diaryItem.username
                                    print("선택된 유저 이름: \(username)")
                                }
                            })
                            .disposed(by: cell.disposeBag)
                        
                        cell.diaryCardView.rx.gestureTap
                            .asDriver()
                            .drive(onNext: { [weak self] _ in
                                guard let self,
                                      let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                                      let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as HomeCommunityDiaryItem else {
                                    return
                                }
                                
                                // TODO: - 선택한 감사일기 상세로 이동
                                print("선택된 감사일기 정보: \(selectedItem)\n선택된 유저 인덱스: \(indexPath)")
                            })
                            .disposed(by: cell.disposeBag)
                        
                        cell.likeButton.rx.tap
                            .throttle(.seconds(2), scheduler: MainScheduler.instance)
                            .map { HomeCommunityViewReactor.Action.didTapLike(diaryId: diaryItem.id)}
                            .bind(to: reactor.action)
                            .disposed(by: cell.disposeBag)
                        
                        cell.commentButton.rx.tap
                            .asDriver()
                            .drive(onNext: { [weak self] _ in
                                guard let self,
                                      let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                                      let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as HomeCommunityDiaryItem else {
                                    return
                                }
                                print("선택한 댓글 아이템 \(selectedItem)")
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
                        
                        cell.profileImageView.rx.gestureTap
                            .asDriver()
                            .drive(onNext: { [weak self] _ in
                                guard let self,
                                      let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                                      let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as HomeCommunityDiaryItem else {
                                    return
                                }
                                
                                // TODO: - 선택한 유저 정보로 이동
                                if case .diary(let diaryItem) = selectedItem {
                                    let username = diaryItem.username
                                    print("선택된 유저 이름: \(username)")
                                }
                            })
                            .disposed(by: cell.disposeBag)
                        
                        cell.diaryCardView.rx.gestureTap
                            .asDriver()
                            .drive(onNext: { [weak self] _ in
                                guard let self,
                                      let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                                      let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as HomeCommunityDiaryItem else {
                                    return
                                }
                                
                                // TODO: - 선택한 감사일기 상세로 이동
                                print("선택된 감사일기 정보: \(selectedItem)\n선택된 유저 인덱스: \(indexPath)")
                            })
                            .disposed(by: cell.disposeBag)
                        
                        cell.likeButton.rx.tap
                            .throttle(.seconds(2), scheduler: MainScheduler.instance)
                            .map { HomeCommunityViewReactor.Action.didTapLike(diaryId: diaryItem.id)}
                            .bind(to: reactor.action)
                            .disposed(by: cell.disposeBag)
                        
                        cell.commentButton.rx.tap
                            .asDriver()
                            .drive(onNext: { [weak self] _ in
                                guard let self,
                                      let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                                      let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as HomeCommunityDiaryItem else {
                                    return
                                }
                                print("선택한 댓글 아이템 \(selectedItem)")
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
    }
}

extension HomeCommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = reactor?.currentState.communityDiarySections,
              section < sections.count else {
            return nil
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HomeCommunityDateHeaderView.reuseIdentifier
        ) as! HomeCommunityDateHeaderView
        headerView.updateUI(date: sections[section].date)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
