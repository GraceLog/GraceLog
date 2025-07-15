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
    
    init(reactor: HomeMyViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
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
            content:"순종이 제사보다 낫고\n듣는 것이 숫양의 기름보다 나으니",
            reference: "사무엘상 5:22"
        )
    }
    
    private func bindHomeMyDiaryView(reactor: HomeMyViewReactor) {
        myDiaryView.diaryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.diaryItems }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, diaryList in
                Observable.just(diaryList)
                    .bind(to: owner.myDiaryView.diaryCollectionView.rx.items) { collectionView, index, item in
                        let indexPath = IndexPath(item: index, section: 0)
                        let diaryCount = diaryList.count

                        guard diaryCount > 0 else {
                            // TODO: - 일기장 목록이 없을 경우 처리 필요
                            return UICollectionViewCell()
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
                                backgroundImageURL: URL(string: "https://img.freepik.com/free-photo/grunge-black-concrete-textured-background_53876-124541.jpg"),
                                title: item.title,
                                content: item.desc,
                                relativeDate: "오늘",
                                exactDate: "2/14",
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
                                backgroundImageURL: URL(string: "https://img.freepik.com/free-photo/grunge-black-concrete-textured-background_53876-124541.jpg"),
                                date: item.dateDesc,
                                content: item.title,
                                relativeDate: "지난주",
                                exactDate: "2/7",
                                hideTopLine: false,
                                hideBottomLine: isLast
                            )
                            cell = pastCell
                        }

                        cell.backgroundImageView.rx.gestureTap
                            .asDriver()
                            .drive(onNext: { [weak self] _ in
                                guard let self,
                                      let indexPath = self.myDiaryView.diaryCollectionView.indexPath(for: cell),
                                      let selectedItem = try? self.myDiaryView.diaryCollectionView.rx.model(at: indexPath) as MyDiaryItem else {
                                    return
                                }
                                print("선택된 일기장 정보: \(selectedItem)\n선택된 일기장 인덱스: \(indexPath)")
                            })
                            .disposed(by: cell.disposeBag)

                        return cell
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)

    }
    
    private func bindHomeMyRecommendVideoView(reactor: HomeMyViewReactor) {
        reactor.state
            .map { $0.videoItems }
            .asDriver(onErrorJustReturn: [])
            .drive(myRecommendVideoView.recommendVideoTableView.rx.items(
                cellIdentifier: HomeRecommendVideoTableViewCell.reuseIdentifier,
                cellType: HomeRecommendVideoTableViewCell.self)
            ) { index, item, cell in
                cell.configureUI(title: item.title, thumbnailImageURL: URL(string: "https://pimg.mk.co.kr/meet/neds/2017/11/image_readmed_2017_740612_15101228583092607.jpg"))
                cell.thumbnailImageView.rx.gestureTap
                    .asDriver()
                    .drive(with: self) { owner, isOn in
                        guard let indexPath = owner.myRecommendVideoView.recommendVideoTableView.indexPath(for: cell),
                              let selectedItem = try? owner.myRecommendVideoView.recommendVideoTableView.rx.model(at: indexPath) as HomeVideoItem else {
                            return
                        }
                        print("선택된 비디오 정보: \(selectedItem)\n선택된 비디오 인덱스: \(indexPath)")
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        myRecommendVideoView.recommendedTagLabel.text = "#순종 #도전"
    }
}

// MARK: HomeMyDiaryView CollectionView UICollectionViewDelegateFlowLayout
extension HomeMyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = indexPath.row == 0 ? 300 + 26 : 110 + 26
        return CGSize(width: collectionView.frame.width, height: height)
    }
}
