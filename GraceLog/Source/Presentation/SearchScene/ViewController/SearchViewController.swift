//
//  SearchViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit

import RxSwift
import RxDataSources
import ReactorKit

final class SearchViewController: GraceLogBaseViewController<SearchViewReactor> {
    enum Section: Int, Hashable {
        case primary
        case secondary
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<SearchCommunitySection>!

    private let searchContainerView = UIView().then {
        $0.backgroundColor = GLColor.backgroundSub.color
    }
    private let communitySearchBar = UISearchBar().then {
        $0.placeholder = "Search"
        $0.searchBarStyle = .minimal
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { index, env -> NSCollectionLayoutSection? in
        guard let section = Section(rawValue: index) else { return nil }
        switch section {
        case .primary:
            return NSCollectionLayoutSection.primary
        case .secondary:
            return NSCollectionLayoutSection.secondary
        }
    }).then {
        $0.register(HomeCommunityListCollectionViewCell.self, forCellWithReuseIdentifier: HomeCommunityListCollectionViewCell.reuseIdentifier)
        $0.register(CommunityRoomCollectionViewCell.self, forCellWithReuseIdentifier: CommunityRoomCollectionViewCell.identifier)
        $0.register(SearchResultCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultCollectionHeaderView.identifier)
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.backgroundColor = GLColor.backgroundMain.color
        $0.contentInset = .init(top: 20, left: .zero, bottom: .zero, right: .zero)
    }
    
    private let addCommunityButton = UIButton().then {
        $0.tintColor = GLColor.iconAccent.color
        $0.setImage(.plus, for: .normal)
    }
    
    override func setupStyles() {
        super.setupStyles()
        view.backgroundColor = GLColor.backgroundSub.color
        navigationBar.setupTitleLabel(text: "공동체")
        navigationBar.addRightItem(addCommunityButton)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        [searchContainerView, searchResultCollectionView].forEach { contentView.addSubview($0) }
        searchContainerView.addSubview(communitySearchBar)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        searchContainerView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.searchBarHeight)
        }
        
        communitySearchBar.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(15)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        searchResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchContainerView.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func bind(reactor: SearchViewReactor) {
        super.bind(reactor: reactor)
        setupDataSource()
        
        reactor.pulse(\.$sections)
            .asDriver(onErrorJustReturn: [])
            .drive(searchResultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        communitySearchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .filter { !$0.isEmpty }
            .map { SearchViewReactor.Action.didSearchCommunity($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchResultCollectionView.rx.itemSelected
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, selectedIndexPath in
                let section = Section(rawValue: selectedIndexPath.section)
                switch section {
                case .primary:
                    if reactor.isSearching {
                        reactor.action.onNext(SearchViewReactor.Action.didTapProfile(selectedIndexPath))
                    } else {
                        reactor.action.onNext(SearchViewReactor.Action.didTapCommunity(selectedIndexPath))
                    }
                case .secondary:
                    reactor.action.onNext(SearchViewReactor.Action.didTapChattingRoom(selectedIndexPath))
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        addCommunityButton.rx.tap
            .map { SearchViewReactor.Action.didTapAddCommunityButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func setupDataSource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource<SearchCommunitySection>(configureCell: { _, collectionView, indexPath, item in
            switch item {
            case .community(let community):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCommunityListCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? HomeCommunityListCollectionViewCell ?? HomeCommunityListCollectionViewCell()
                cell.updateUI(
                    imageURL: community.logoImageURL,
                    communityName: community.name
                )
                return cell
            case .room(let room):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommunityRoomCollectionViewCell.identifier,
                    for: indexPath
                ) as? CommunityRoomCollectionViewCell ?? CommunityRoomCollectionViewCell()
                cell.configureUI(
                    title: room.title,
                    description: room.description,
                    editedDate: room.recentEditedDate,
                    peopleCount: room.peopleCount,
                    imageURL: room.imageURL
                )
                return cell
            case .profile(let item):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCommunityListCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? HomeCommunityListCollectionViewCell ?? HomeCommunityListCollectionViewCell()
                cell.updateUI(
                    imageURL: item.imageURL,
                    communityName: item.name
                )
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let title = dataSource.sectionModels[indexPath.section].title
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SearchResultCollectionHeaderView.identifier,
                for: indexPath
            ) as? SearchResultCollectionHeaderView ?? SearchResultCollectionHeaderView()
            header.configureUI(title: title)
            return header
        })
    }
}

private extension NSCollectionLayoutSection {
    static var primary: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(87)
            ),
            subitem: item,
            count: 3
        ).with {
            $0.interItemSpacing = .fixed(35)
            $0.contentInsets = .init(top: .zero, leading: 20, bottom: .zero, trailing: 20)
        }
        
        let section = NSCollectionLayoutSection(group: group).with {
            $0.interGroupSpacing = 14
            $0.contentInsets = .init(top: 20, leading: 30, bottom: 33.15, trailing: 30)
            $0.boundarySupplementaryItems = [.headerItem]
        }
        return section
    }
    
    static var secondary: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            subitems: [item]
        ).with {
            $0.contentInsets = .init(top: 33, leading: .zero, bottom: .zero, trailing: .zero)
        }
        
        let section = NSCollectionLayoutSection(group: group).with {
            $0.interGroupSpacing = 27.31
            $0.boundarySupplementaryItems = [.headerItem]
        }.with {
            $0.contentInsets = .init(top: .zero, leading: 30, bottom: 30, trailing: 30)
        }
        return section
    }
}

private extension NSCollectionLayoutBoundarySupplementaryItem {
    static var headerItem: NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension SearchViewController {
    enum Constants {
        static let searchBarHeight: CGFloat = 36 + 15 + 15
        static let navigationBarHeight: CGFloat = 44
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let isTop = scrollView.contentOffset.y <= -scrollView.contentInset.top/2
        let isDragUp = velocity.y < 0
        self.animateTopApperance(isAppear: isTop || isDragUp)
    }
    
    private func animateTopApperance(isAppear: Bool) {
        self.searchContainerView.snp.updateConstraints {
            $0.height.equalTo(isAppear ? Constants.searchBarHeight : .zero)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
