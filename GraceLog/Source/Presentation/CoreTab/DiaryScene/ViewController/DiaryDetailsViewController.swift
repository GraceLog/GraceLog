//
//  DiaryDetailsViewController.swift
//  GraceLog
//
//  Created by 이상준 on 10/6/25.
//

import UIKit
import SnapKit
import Then
import FSCalendar
import ReactorKit
import RxSwift
import RxCocoa

final class DiaryDetailsViewController: GraceLogBaseViewController<DiaryDetailsViewReactor> {
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
    
    lazy var diaryDetailsView = DiaryDetailsView()
    
    override func setupStyles() {
        super.setupStyles()
        view.backgroundColor = GLColor.backgroundSub.color
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        contentView.addSubview(scrollView)
        navigationBar.addLeftItem(backButton)
        
        scrollView.addSubview(containerStackView)
        [calendarButton, calendarView, diaryDetailsView].forEach { containerStackView.addArrangedSubview($0) }
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
    
    private func fetchDiaryList(for date: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let (startDate, endDate) = DateFormatterFactory.getMonthDateRange(year: year, month: month)
        
        reactor?.action.onNext(.fetchDateRangeDiaryList(startDate, endDate))
    }
    
    override func bind(reactor: DiaryDetailsViewReactor) {
        /// Action
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.calendarView.scope = owner.calendarView.scope == .month ? .week : .month
            }
            .disposed(by: disposeBag)
        
        diaryDetailsView.moreButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let willExpand = !owner.diaryDetailsView.isExpanded
                owner.diaryDetailsView.setExpanded(willExpand)
            }
            .disposed(by: disposeBag)
        
        
        diaryDetailsView.likeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .compactMap { reactor.currentState.diary?.diaryId }
            .map { DiaryDetailsViewReactor.Action.didTapLikeButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        diaryDetailsView.commentButton.rx.tap
            .compactMap { reactor.currentState.diary?.diaryId }
            .map { DiaryDetailsViewReactor.Action.didTapCommentButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        /// State
        let diaryObservable = reactor.pulse(\.$diary).share(replay: 1)
        
        diaryObservable
            .compactMap { $0?.createdAt }
            .map { DateFormatterFactory.toYearMonthString(from: $0) }
            .distinctUntilChanged()
            .withLatestFrom(diaryObservable.compactMap { $0?.createdAt })
            .subscribe(onNext: { [weak self] createdAt in
                self?.fetchDiaryList(for: createdAt)
            })
            .disposed(by: disposeBag)
        
        diaryObservable
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, diary in
                
                if let createdAt = diary.createdAt {
                    owner.calendarButton.configuration?.title = DateFormatterFactory.toYearMonthString(from: createdAt)
                    owner.calendarView.select(createdAt)
                }
                
                owner.diaryDetailsView.configure(
                    category: "오늘의 감사일기",
                    title: diary.title,
                    description: diary.description,
                    backgroundImageURL: diary.imageURLs.first ?? nil,
                    isHideLike: diary.isHideLike,
                    isHideComment: diary.isHideComment,
                    isLiked: diary.likeByMe,
                    likeCount: diary.likeCount,
                    commentCount: diary.commentCount
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$dateRangeDiaries)
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, _ in
                owner.calendarView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSuccessLikeResult)
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

extension DiaryDetailsViewController: FSCalendarDelegate, FSCalendarDataSource {
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
        var config = calendarButton.configuration
        config?.title = DateFormatterFactory.toYearMonthString(from: calendar.currentPage)
        calendarButton.configuration = config
        
        fetchDiaryList(for: calendar.currentPage)
    }
    
    /// 감사일기가 작성된 날짜 마커
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let diaryList = reactor?.currentState.dateRangeDiaries else { return 0 }
        
        let hasEvent = diaryList.contains(where: {
            guard let createdAt = $0.createdAt else { return false }
            return Calendar.current.isDate(createdAt, inSameDayAs: date)
        })
        
        return hasEvent ? 1 : 0
    }
    
    /// 날짜 선택 가능 여부 결정
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let diaryList = reactor?.currentState.dateRangeDiaries else { return false }
        
        let hasEvent = diaryList.contains(where: {
            guard let createdAt = $0.createdAt else { return false }
            return Calendar.current.isDate(createdAt, inSameDayAs: date)
        })
        
        return hasEvent
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let selectedDiary = reactor?.currentState.dateRangeDiaries.first(where: {
            guard let createdAt = $0.createdAt else { return false }
            return Calendar.current.isDate(createdAt, inSameDayAs: date)
        }) {
            reactor?.action.onNext(.fetchDiary(selectedDiary.diaryId))
        }
    }
}
