//
//  HomeMyViewController.swift
//  GraceLog
//
//  Created by 이상준 on 6/22/25.
//

import UIKit

import RxSwift
import RxGesture
import RxCocoa
import RxDataSources
import ReactorKit

final class HomeMyViewController: GraceLogBaseViewController<HomeMyViewReactor> {
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
    
    override func setupStyles() {
        super.setupStyles()
        showNavigationBar = false
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        view.addSubview(scrollView)
        scrollView.addSubview(containerStackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        scrollView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        let subViews = [myBibleView, myDiaryView, myRecommendVideoView]
        containerStackView.arrangedSubviews(subViews)
    }
    
    override func bind(reactor: HomeMyViewReactor) {
        super.bind(reactor: reactor)
        bindHomeMyBibleView(reactor: reactor)
        bindHomeMyDiaryView(reactor: reactor)
        bindHomeMyRecommendVideoView(reactor: reactor)
    }
}

// MARK: Home Bindings
extension HomeMyViewController {
    private func bindHomeMyBibleView(reactor: HomeMyViewReactor) {
        reactor.pulse(\.$dailyVerse)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, dailyVerse in
                owner.myBibleView.setData(
                    content: dailyVerse.content,
                    reference: dailyVerse.reference
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func bindHomeMyDiaryView(reactor: HomeMyViewReactor) {
        myDiaryView.diaryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.pulse(\.$username),
            reactor.pulse(\.$diaryItems)
        )
        .asDriver(onErrorJustReturn: ("사용자", []))
        .drive(with: self) { owner, data in
            let (username, diaryItems) = data
            if diaryItems.isEmpty {
                owner.myDiaryView.greetingLabel.text = "Grace Log와 함께 감사일기를 시작해요!"
            } else {
                owner.myDiaryView.greetingLabel.text = "\(username)님, 오늘도 하나님과 동행하세요"
            }
        }
        .disposed(by: disposeBag)
        
        reactor.pulse(\.$diaryItems)
            .map { $0.isEmpty ? [MyDiaryPreview.empty] : $0 }
            .asDriver(onErrorJustReturn: [])
            .drive(myDiaryView.diaryCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let diaryCount = reactor.currentState.diaryItems.count
                
                guard diaryCount > 0 else {
                    let emptyCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: EmptyDiaryCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as! EmptyDiaryCollectionViewCell
                    
                    emptyCell.configureUI(
                        backgroundImageURL: item.imageURL,
                        editedDate: item.editedDate,
                        hideTopLine: true,
                        hideBottomLine: true
                    )
                    
                    return emptyCell
                }
                
                let isFirst = index == 0
                let isLast = index == diaryCount - 1
                let isSingleItem = diaryCount == 1
                let hideTop = true
                let hideBottom = isSingleItem
                
                let cell: DiaryTimelineCollectionViewCell
                
                if isSingleItem || isFirst {
                    let latestCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HomeLatestDiaryCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as! HomeLatestDiaryCollectionViewCell
                    
                    latestCell.setData(
                        backgroundImageURL: item.imageURL,
                        title: item.title,
                        content: item.content,
                        editedDate: item.editedDate,
                        hideTopLine: hideTop,
                        hideBottomLine: hideBottom
                    )
                    cell = latestCell
                } else {
                    let pastCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HomePastDiaryCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as! HomePastDiaryCollectionViewCell
                    
                    pastCell.setData(
                        backgroundImageURL: item.imageURL,
                        title: item.title,
                        content: item.content,
                        editedDate: item.editedDate,
                        hideTopLine: false,
                        hideBottomLine: isLast
                    )
                    cell = pastCell
                }
                
                cell.overlayBackgroundView.rx.tapGesture().when(.recognized)
                    .asDriver(onErrorDriveWith: .empty())
                    .drive(onNext: { [weak self] _ in
                        guard let self,
                              let indexPath = self.myDiaryView.diaryCollectionView.indexPath(for: cell),
                              let selectedItem = try? self.myDiaryView.diaryCollectionView.rx.model(at: indexPath) as MyDiaryPreview else {
                            return
                        }
                        reactor.action.onNext(.didTapDiaryDetail(selectedItem.id))
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func bindHomeMyRecommendVideoView(reactor: HomeMyViewReactor) {
        reactor.pulse(\.$videoItems)
            .asDriver(onErrorJustReturn: [])
            .drive(myRecommendVideoView.recommendVideoTableView.rx.items(
                cellIdentifier: HomeRecommendVideoTableViewCell.reuseIdentifier,
                cellType: HomeRecommendVideoTableViewCell.self)
            ) { index, item, cell in
                cell.configureUI(title: item.title, thumbnailImageURL: item.imageURL)
                cell.thumbnailImageView.rx.tapGesture().when(.recognized)
                    .asDriver(onErrorDriveWith: .empty())
                    .drive(with: self) { owner, isOn in
                        guard let indexPath = owner.myRecommendVideoView.recommendVideoTableView.indexPath(for: cell),
                              let selectedItem = try? owner.myRecommendVideoView.recommendVideoTableView.rx.model(at: indexPath) as RecommendedVideo else {
                            return
                        }
                        print("선택된 비디오 정보: \(selectedItem)\n선택된 비디오 인덱스: \(indexPath)")
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$videoTagItems)
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, videoTagItems in
                let recommendedTag = videoTagItems.map { "#\($0)" }.joined(separator: " ")
                owner.myRecommendVideoView.configureUI(recommendedText: recommendedTag)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isVideoItemsEmpty)
            .asDriver(onErrorJustReturn: true)
            .filter { $0 }
            .map { _ in "#앗! 아직 일기가 없어요" }
            .drive(with: self) { owner, recommendedText in
                owner.myRecommendVideoView.configureUI(isEmpty: true, recommendedText: recommendedText)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: HomeMyDiaryView CollectionView UICollectionViewDelegateFlowLayout
extension HomeMyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = indexPath.row == 0 ? 300 + 26 : 110 + 26
        return CGSize(width: collectionView.frame.width, height: height)
    }
}
