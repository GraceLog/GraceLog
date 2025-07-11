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
    var disposeBag = DisposeBag()
    private var diaryDataSource: RxTableViewSectionedReloadDataSource<HomeCommunityDiarySection>!
    
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
        let communitySelectionEvent = communitySelectedView.communityListCollectionView.rx.itemSelected.asObservable()
        let selectedCommunityModels = communitySelectedView.communityListCollectionView.rx.modelSelected(Community.self).asObservable()
        let collectionView = communitySelectedView.communityListCollectionView
        
        Observable.zip(communitySelectionEvent, selectedCommunityModels)
            .subscribe(with: self) { owner, state in
                let (indexPath, model) = state
                guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCommunityListCollectionViewCell else {
                    return
                }
                
                if cell.isSelected {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                    reactor.action.onNext(HomeCommunityViewReactor.Action.didSelectCommunity(model))
                }
                
            }.disposed(by: disposeBag)
        
        let communityObservable = reactor.pulse(\.$communityList).share(replay: 1)
        
        communityObservable
            .asDriver(onErrorJustReturn: [])
            .drive(communitySelectedView.communityListCollectionView.rx.items(
                cellIdentifier: HomeCommunityListCollectionViewCell.reuseIdentifier,
                cellType: HomeCommunityListCollectionViewCell.self)
            ) { index, item, cell in
                cell.updateUI(
                    imageNamed: item.logoImageNamed,
                    communityName: item.title
                )
            }
            .disposed(by: disposeBag)
        
        communityObservable
            .compactMap { $0.first }
            .take(1)
            .map { HomeCommunityViewReactor.Action.didSelectCommunity($0) }
            .subscribe(with: self) { owner, selectFirstCommunityAction in
                let indexPath = IndexPath(item: 0, section: 0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                
                reactor.action.onNext(selectFirstCommunityAction)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCommunityDiaryTableView(reactor: HomeCommunityViewReactor) {
        diaryDataSource = RxTableViewSectionedReloadDataSource<HomeCommunityDiarySection>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeCommunityDiaryTableViewCell.reuseIdentifier, for: indexPath) as! HomeCommunityDiaryTableViewCell

                cell.updateUI(
                    username: item.username,
                    title: item.title,
                    content: item.content,
                    likeCount: item.likeCount,
                    commentCount: item.commentCount,
                    isLiked: item.isLiked, 
                    isCurrentUser: item.isCurrentUser,
                    profileImageURL: item.profileImageURL,
                    cardImageURL: item.cardImageURL
                )
                
                cell.profileImageView.rx.gestureTap
                    .asDriver()
                    .drive(onNext: { [weak self] _ in
                        guard let self,
                              let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                              let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as CommunityDiaryItem else {
                            return
                        }
                        
                        // TODO: - 선택한 유저 정보로 이동
                        print("선택된 유저 이름: \(selectedItem)")
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.cardImageView.rx.gestureTap
                    .asDriver()
                    .drive(onNext: { [weak self] _ in
                        guard let self,
                              let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                              let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as CommunityDiaryItem else {
                            return
                        }
                        
                        // TODO: - 선택한 감사일기 상세로 이동
                        print("선택된 감사일기 정보: \(selectedItem)\n선택된 유저 인덱스: \(indexPath)")
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.likeButton.rx.tap
                    .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
                    .map { HomeCommunityViewReactor.Action.didTapLikeButton(item.id)}
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                cell.commentButton.rx.tap
                    .asDriver()
                    .drive(onNext: { [weak self] _ in
                        guard let self,
                              let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                              let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as CommunityDiaryItem else {
                            return
                        }
                        print("선택한 댓글 아이템 \(selectedItem)")
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        )
        reactor.pulse(\.$sectionedDiaryList)
            .asDriver(onErrorJustReturn: [])
            .drive(communityDiaryListView.diaryTableView.rx.items(dataSource: diaryDataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSuccessLikeDiary)
            .compactMap { $0 }
            .subscribe(with: self) { owner, isSuccess in
                // TODO: - 좋아요 성공여부에 따른 로직 구현
                if isSuccess {
                    print("좋아요 성공!")
                } else {
                    print("좋아요 실패!")
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSuccessUnlikeResult)
            .compactMap { $0 }
            .subscribe(with: self) { owner, isSuccess in
                // TODO: - 좋아요 성공여부에 따른 로직 구현
                if isSuccess {
                    print("좋아요 해제 성공!")
                } else {
                    print("좋아요 해제 실패!")
                }
            }
            .disposed(by: disposeBag)
    }
}

extension HomeCommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HomeCommunityDateHeaderView.reuseIdentifier
        ) as! HomeCommunityDateHeaderView
        let sectionModel = diaryDataSource.sectionModels[section]
        headerView.updateUI(editedDate: sectionModel.date)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
