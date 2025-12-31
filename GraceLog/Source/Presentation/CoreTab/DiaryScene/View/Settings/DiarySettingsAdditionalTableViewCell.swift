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
    
    private let disposeBag = DisposeBag()
    var onSwitchToggle: ((Bool) -> Void)?
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.regular16.font
        $0.textColor = GLColor.textBasic.color
    }
    
    let switchControl = UISwitch().then {
        $0.onTintColor = .themeColor
    }
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyles()
        setupLayouts()
        setupConstraints()
        
        switchControl.rx.controlEvent(.valueChanged)
            .subscribe(with: self) { owner, _ in
                owner.onSwitchToggle?(owner.switchControl.isOn)
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        switchControl.isOn = false
        onSwitchToggle = nil
    }
    
    private func setupStyles() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setupLayouts() {
        contentView.addSubview(containerStackView)
        [titleLabel, switchControl].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(30)
            $0.directionalVerticalEdges.equalToSuperview()
        }
    }
    
    func configureUI(title: String, isOn: Bool) {
        titleLabel.text = title
        switchControl.isOn = isOn
    }
}
