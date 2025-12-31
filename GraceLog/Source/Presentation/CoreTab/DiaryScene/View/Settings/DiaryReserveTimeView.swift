//
//  DiaryReserveTimeView.swift
//  GraceLog
//
//  Created by 이상준 on 12/31/25.
//

import UIKit
import SnapKit
import Then

final class DiaryReserveTimeView: UIView {
    private let headerTitleLabel = UILabel().then {
        $0.font = GLFont.bold16.font
        $0.textColor = GLColor.textAccent.color
        $0.text = "예약 설정"
    }
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.regular16.font
        $0.textColor = GLColor.textBasic.color
        $0.text = "감사일기 공유 예약하기"
    }
    
    private let descLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = .gray200
        $0.text = "원하는 시간에 감사일기를 공유할 수 있어요."
    }
    
    let switchControl = UISwitch().then {
        $0.onTintColor = .themeColor
    }
    
    let datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .dateAndTime
        $0.tintColor = .themeColor
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        addSubview(switchControl)
        addSubview(containerStackView)
        
        [headerTitleLabel, titleLabel, descLabel, datePicker].forEach { containerStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        switchControl.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalTo(switchControl.snp.leading).offset(20)
            $0.bottom.equalToSuperview().inset(34)
        }
        
        containerStackView.setCustomSpacing(2, after: titleLabel)
        containerStackView.setCustomSpacing(24, after: descLabel)
    }
    
    func toggleDatePicker(isOn: Bool) {
        datePicker.isHidden = !isOn
    }
}
