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
import RxSwift

final class DiaryDetailsViewController: GraceLogBaseViewController {
    var disposeBag = DisposeBag()
    
    private var diaryHeightConstraint: Constraint?
    
    private let navigationBar = GLNavigationBar().then {
        $0.backgroundColor = .white
        $0.setupTitleLabel(text: "나의 감사일기")
    }
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "nav_chevron_left"), for: .normal)
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
        config.title = calendarView.currentPage.toYearMonthString()
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
        $0.locale = Locale(identifier: "ko_KR")
        $0.headerHeight = 0
        $0.appearance.weekdayFont = GLFont.regular12.font
        $0.appearance.weekdayTextColor = GLColor.textBasic.color
        $0.appearance.titleFont = GLFont.regular18.font
        $0.appearance.titleDefaultColor = GLColor.textBasic.color
        $0.appearance.todaySelectionColor = GLColor.textAccent.color
        $0.appearance.titleTodayColor = UIColor.white
    }
    
    private let diaryDetailsView = DiaryDetailsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupConstraints()
        setupCalendarView()
        bind()
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
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(20)
            $0.width.equalTo(scrollView.snp.width).offset(-40)
        }
        
        containerStackView.setCustomSpacing(5, after: calendarView)
        
        calendarView.snp.makeConstraints {
            $0.height.equalTo(250)
        }
    }
    
    private func setupCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func bind() {
        calendarButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.calendarView.scope = owner.calendarView.scope == .month ? .week : .month
            }
            .disposed(by: disposeBag)
        
        diaryDetailsView.moreButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.diaryDetailsView.toggleExpansion()
                
                UIView.animate(withDuration: 0.3) {
                    owner.view.layoutIfNeeded()
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        var config = calendarButton.configuration
        config?.title = calendar.currentPage.toYearMonthString()
        calendarButton.configuration = config
    }
}
