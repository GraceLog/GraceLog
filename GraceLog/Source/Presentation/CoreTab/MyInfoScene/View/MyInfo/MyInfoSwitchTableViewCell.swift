//
//  MyInfoSwitchTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 8/29/25.
//

import UIKit
import SnapKit
import Then

final class MyInfoSwitchTableViewCell: UITableViewCell {
    static let identifier = String(describing: MyInfoSwitchTableViewCell.self)
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let iconImageView = UIImageView().then {
        $0.setDimensions(width: 20, height: 20)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = GLFont.regular15.font
    }
    
    let alarmSwitch = UISwitch().then {
        $0.onTintColor = .themeColor
        $0.setDimensions(width: 51, height: 31)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 15))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        alarmSwitch.isOn = false
    }
    
    private func setupStyles() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func setupLayouts() {
        contentView.addSubview(containerStackView)
        [iconImageView, titleLabel, alarmSwitch].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.centerY.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(20, after: iconImageView)
    }
    
    func updateUI(
        imageName: String,
        title: String,
        isOn: Bool
    ) {
        iconImageView.image = UIImage(named: imageName)
        titleLabel.text = title
        alarmSwitch.isOn = isOn
    }
}
