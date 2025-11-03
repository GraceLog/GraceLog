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

final class DiaryDetailsViewController: GraceLogBaseViewController, View {
    var disposeBag = DisposeBag()
    
    private var isInitialHeightSet = false
    
    private let navigationBar = GLNavigationBar().then {
        $0.backgroundColor = GLColor.backgroundSub.color
        $0.setupTitleLabel(text: "나의 감사일기")
    }
    
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
    }
    
    private lazy var calendarButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "chevron_down")?.withRenderingMode(.alwaysTemplate)
        config.title = DateFormatterFactory.toYearMonthString(from: calendarView.currentPage)
        config.baseForegroundColor = GLColor.textBasic.color
        config.imagePlacement = .trailing
        config.imagePadding = 7
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = GLFont.regular24.font
            return outgoing
        }
        $0.configuration = config
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .leading
    }
    
    private let calendarView = FSCalendar().then {
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
    }
    
    private lazy var diaryDetailsView = DiaryDetailsView()
    
    init(reactor: DiaryDetailsViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayouts()
        setupConstraints()
        setupCalendarView()
    }
    
    private func setupStyles() {
        view.backgroundColor = GLColor.backgroundSub.color
    }
    
    private func setupLayouts() {
        [navigationBar, scrollView].forEach { view.addSubview($0) }
        navigationBar.addLeftItem(backButton)
        
        scrollView.addSubview(containerStackView)
        [calendarButton, calendarView, diaryDetailsView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(20)
            $0.width.equalTo(scrollView.snp.width).offset(-40)
        }
        
        containerStackView.setCustomSpacing(5, after: calendarView)
        
        calendarView.snp.makeConstraints {
            $0.height.equalTo(250)
        }
        
        let totalOffset = 44 + 29 + 67.5 + 25 + 50
        diaryDetailsView.snp.makeConstraints {
            $0.height.equalTo(safeArea.snp.height).offset(-totalOffset)
        }
    }
    
    private func setupCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func fetchDiaryList(for date: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let (startDate, endDate) = DateFormatterFactory.getMonthDateRange(year: year, month: month)
        
        reactor?.action.onNext(.fetchSelectedDateDiaryList(startDate, endDate))
    }
    
    func bind(reactor: DiaryDetailsViewReactor) {
        /// Action
        reactor.action.onNext(.fetchDiary(nil))
        
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
                owner.diaryDetailsView.isExpanded.toggle()
                
                if owner.diaryDetailsView.isExpanded {
                    owner.diaryDetailsView.snp.removeConstraints()
                    owner.diaryDetailsView.updateMoreButton(title: "접기", imageName: "chevron_up")
                } else {
                    let totalOffset: CGFloat = 44 + 29 + 67.5 + 25 + 50
                    owner.diaryDetailsView.snp.updateConstraints {
                        $0.height.equalTo(owner.view.safeAreaLayoutGuide.snp.height).offset(-totalOffset)
                    }
                    owner.diaryDetailsView.updateMoreButton(title: "이어서 더보기", imageName: "chevron_down")
                }
                
            }
            .disposed(by: disposeBag)
        
        diaryDetailsView.likeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .compactMap { reactor.currentState.diary?.id }
            .map { DiaryDetailsViewReactor.Action.didTapLikeButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        diaryDetailsView.commentButton.rx.tap
            .compactMap { reactor.currentState.diary?.id }
            .map { DiaryDetailsViewReactor.Action.didTapCommentButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        /// State
        let diaryObservable = reactor.pulse(\.$diary).share(replay: 1)
        
        diaryObservable
            .compactMap { $0 }
            .map { DateFormatterFactory.toYearMonthString(from: $0.createdAt) }
            .distinctUntilChanged()
            .withLatestFrom(diaryObservable.compactMap { $0 })
            .subscribe(onNext: { [weak self] diary in
                self?.fetchDiaryList(for: diary.createdAt)
            })
            .disposed(by: disposeBag)
        
        diaryObservable
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] diary in
                guard let self = self, let diary = diary else { return }
                
                self.calendarButton.configuration?.title = DateFormatterFactory.toYearMonthString(from: diary.createdAt)
                self.calendarView.select(diary.createdAt)
                
                self.diaryDetailsView.configure(
                    title: diary.title,
                    description: diary.description,
                    backgroundImageURL: diary.imageURLs.first ?? nil,
                    isHideLike: diary.isHideLike,
                    isHideComment: diary.isHideComment,
                    isLiked: diary.isLiked,
                    likeCount: diary.likeCount,
                    commentCount: diary.commentCount
                )
            })
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
        
        var config = calendarButton.configuration
        config?.image = UIImage(named: calendar.scope == .month ? "chevron_up" : "chevron_down")?.withRenderingMode(.alwaysTemplate)
        calendarButton.configuration = config
        
        self.view.layoutIfNeeded()
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
        guard let diaryList = reactor?.currentState.selectedDateDiaryList else { return 0 }
        
        let hasEvent = diaryList.contains(where: {
            Calendar.current.isDate($0.createdAt, inSameDayAs: date)
        })
        
        return hasEvent ? 1 : 0
    }
    
    /// 날짜 선택 가능 여부 결정
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let diaryList = reactor?.currentState.selectedDateDiaryList else { return false }
        
        let hasEvent = diaryList.contains(where: {
            Calendar.current.isDate($0.createdAt, inSameDayAs: date)
        })
        
        return hasEvent
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let selectedDiary = reactor?.currentState.selectedDateDiaryList.first(where: {
            Calendar.current.isDate($0.createdAt, inSameDayAs: date)
        }) {
            reactor?.action.onNext(.fetchDiary(selectedDiary.id))
        }
    }
}
