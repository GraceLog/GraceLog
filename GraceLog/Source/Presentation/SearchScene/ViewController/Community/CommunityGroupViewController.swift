//
//  CommunityGroupViewController.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import UIKit

import FSCalendar
import RxSwift
import ReactorKit
import RxDataSources
import SnapKit
import Then

final class CommunityGroupViewController: GraceLogBaseViewController<CommunityGroupReactor> {
    private var diaryDataSource: RxTableViewSectionedAnimatedDataSource<CommunityGroupSection>!
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left_theme"), for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.backgroundColor = GLColor.backgroundMain.color
    }
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 20
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    private lazy var calendarButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "chevron_down")?.withRenderingMode(.alwaysTemplate)
        config.title = DateFormatterFactory.toYearMonthString(from: calendarView.currentPage)
        config.baseForegroundColor = GLColor.textBasic.color
        config.imagePlacement = .trailing
        config.imagePadding = 7
        config.contentInsets = .zero
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = GLFont.regular24.font
            return outgoing
        }
        $0.configuration = config
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .leading
    }
    
    private lazy var calendarView = FSCalendar().then {
        $0.tintColor = .white
        $0.scrollDirection = .horizontal
        $0.scope = .week
        $0.today = nil
        $0.locale = Locale(identifier: "ko_KR")
        $0.headerHeight = 0
        $0.appearance.weekdayFont = GLFont.regular12.font
        $0.appearance.weekdayTextColor = GLColor.textBasic.color
        $0.appearance.titleFont = GLFont.regular18.font
        $0.appearance.titleDefaultColor = GLColor.textBasic.color
        $0.appearance.todaySelectionColor = GLColor.textAccent.color
        $0.appearance.selectionColor = GLColor.textAccent.color
        $0.appearance.titleTodayColor = UIColor.white
        $0.appearance.eventDefaultColor = GLColor.textAccent.color
        $0.appearance.eventSelectionColor = .clear
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let communityDiaryListView = HomeCommunityDiaryListView()
    
    override func setupStyles() {
        super.setupStyles()
        navigationBar.addLeftItem(backButton)
        navigationBar.setupTitleLabel(text: "공동체")
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(containerStackView)
        [calendarButton, calendarView, communityDiaryListView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(5, after: calendarView)
        
        calendarView.snp.makeConstraints {
            $0.height.equalTo(250)
        }
    }
    
    override func bind(reactor: CommunityGroupReactor) {
        let latestPostDate = reactor.pulse(\.$latestPostDate)
            .compactMap { $0 }
            .share()
        
        latestPostDate
            .subscribe(with: self) { owner, date in
                reactor.action.onNext(.fetchEditedDateList(date))
                reactor.action.onNext(.fetchDiaryList(date))
            }
            .disposed(by: disposeBag)
        
        latestPostDate
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, date in
                owner.calendarView.select(date)
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.calendarView.scope = owner.calendarView.scope == .month ? .week : .month
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$editedDateList)
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, _ in
                owner.calendarView.reloadData()
            }
            .disposed(by: disposeBag)
        
        bindCommunityDiaryTableView(reactor: reactor)
        bindScrollViewPagination(reactor: reactor)
    }
    
    private func bindCommunityDiaryTableView(reactor: CommunityGroupReactor) {
        diaryDataSource = RxTableViewSectionedAnimatedDataSource<CommunityGroupSection>(
            animationConfiguration: .init(
                insertAnimation: .none,
                reloadAnimation: .none,
                deleteAnimation: .none
            ),
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
                
                cell.profileImageView.rx.tapGesture().when(.recognized)
                    .asDriver(onErrorDriveWith: .empty())
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
                
                cell.cardImageView.rx.tapGesture().when(.recognized)
                    .asDriver(onErrorDriveWith: .empty())
                    .drive(onNext: { [weak self] _ in
                        guard let self,
                              let indexPath = self.communityDiaryListView.diaryTableView.indexPath(for: cell),
                              let selectedItem = try? self.communityDiaryListView.diaryTableView.rx.model(at: indexPath) as CommunityDiaryItem else {
                            return
                        }
                        
                        reactor.action.onNext(.didTapDiaryDetail(
                            selectedItem.id,
                            selectedItem.communityId,
                            selectedItem.userId
                        ))
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.likeButton.rx.tap
                    .do(onNext: { _ in
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    })
                    .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
                    .map { CommunityGroupReactor.Action.didTapLikeButton(item.id)}
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
    }
    
    private func bindScrollViewPagination(reactor: CommunityGroupReactor) {
        scrollView.rx.didEndDragging
            .filter { [weak self] _ in
                guard let self = self else { return false }
                let offsetY = self.scrollView.contentOffset.y
                let contentHeight = self.scrollView.contentSize.height
                let height = self.scrollView.frame.height
                
                return offsetY > contentHeight - height
            }
            .map { _ in CommunityGroupReactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension CommunityGroupViewController: FSCalendarDelegate, FSCalendarDataSource, UIScrollViewDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.03,
            options: [.curveEaseInOut]
        ) { self.view.layoutIfNeeded() }
        
        var config = calendarButton.configuration
        config?.image = UIImage(named: calendar.scope == .month ? "chevron_up" : "chevron_down")?.withRenderingMode(.alwaysTemplate)
        calendarButton.configuration = config
    }
    
    /// 캘린더 뷰의 년도 및 월이 바뀌는 경우
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        
        let nextMonthDate = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: currentPage
        ) ?? currentPage
        
        var config = calendarButton.configuration
        config?.title = DateFormatterFactory.toYearMonthString(from: nextMonthDate)
        calendarButton.configuration = config
        
        reactor?.action.onNext(.fetchEditedDateList(nextMonthDate))
    }
    
    /// 감사일기가 작성된 날짜 마커
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let currentEditedDateList = reactor?.currentState.editedDateList else { return 0 }
        let hasEvent = currentEditedDateList.contains(where: { return Calendar.current.isDate($0, inSameDayAs: date) })
        return hasEvent ? 1 : 0
    }
    
    /// 날짜 선택 가능 여부 결정
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let currentEditedDateList = reactor?.currentState.editedDateList else { return false }
        let hasEvent = currentEditedDateList.contains(where: { return Calendar.current.isDate($0, inSameDayAs: date) })
        return hasEvent
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        reactor?.action.onNext(.fetchDiaryList(date))
    }
}
