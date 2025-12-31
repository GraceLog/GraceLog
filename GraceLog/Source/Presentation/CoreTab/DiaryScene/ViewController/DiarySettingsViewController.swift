//
//  DiarySettingsViewController.swift
//  GraceLog
//
//  Created by 이상준 on 4/21/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class DiarySettingsViewController: GraceLogBaseViewController<DiarySettingsViewReactor> {
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
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(GLColor.textAccent.color, for: .normal)
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(GLColor.textAccent.color, for: .normal)
    }
    
    private let reserveTimeView = DiaryReserveTimeView()
    private let settingsView = DiarySettingsView()
    
    
    override func setupStyles() {
        super.setupStyles()
        view.backgroundColor = GLColor.backgroundSub.color
        navigationBar.setupTitleLabel(text: "추가 설정")
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        navigationBar.addLeftItem(cancelButton)
        navigationBar.addRightItem(saveButton)
        contentView.addSubview(scrollView)
        
        let subViews = [reserveTimeView, settingsView]
        containerStackView.addArrangedDividerSubViews(subViews)
        
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
    }
    
    override func bind(reactor: DiarySettingsViewReactor) {
        super.bind(reactor: reactor)
        
        reserveTimeView.switchControl.rx.isOn
            .skip(1)
            .do(onNext: { [weak self] isOn in
                self?.reserveTimeView.toggleDatePicker(isOn: isOn)
            })
            .map { DiarySettingsViewReactor.Action.toggleReserveTime($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reserveTimeView.datePicker.rx.date
            .skip(1)
            .map { DiarySettingsViewReactor.Action.selectReserveDate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$settings)
            .asDriver(onErrorJustReturn: [])
            .drive(settingsView.settingsTableView.rx.items(
                cellIdentifier: DiaryAdditionalSettingsTableViewCell.identifier,
                cellType: DiaryAdditionalSettingsTableViewCell.self)
            ){ index, item, cell in
                cell.configureUI(title: item.title, isOn: item.isOn)
                cell.onSwitchToggle = { isOn in
                    reactor.action.onNext(.toggleSetting(item.type, isOn))
                }
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .map { DiarySettingsViewReactor.Action.didTapCancelButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map { DiarySettingsViewReactor.Action.didTapCompleteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
