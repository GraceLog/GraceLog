//
//  DiaryAdditionalSettingsTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 4/21/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class DiaryAdditionalSettingsTableViewCell: UITableViewCell {
    static let identifier = "DiaryAdditionalSettingsTableViewCell"
    
    var disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.regular16.font
        $0.textColor = .black
    }
    
    private let descLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = .gray200
    }
    
    private let switchControl = UISwitch().then {
        $0.onTintColor = .themeColor
        $0.setDimensions(width: 27, height: 27)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        
        [titleLabel, descLabel, switchControl].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(30)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(23.5)
        }
        
        switchControl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().inset(29)
        }
    }
    
    func updateUI(title: String, desc: String, isOn: Bool) {
        titleLabel.text = title
        descLabel.text = desc
        switchControl.isOn = isOn
    }
}
