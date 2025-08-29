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
    }
    
    private let imgView = UIImageView().then {
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
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 13))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        titleLabel.text = nil
        alarmSwitch.isOn = false
    }
    
    private func setupLayouts() {
        backgroundColor = .white
        selectionStyle = .none
//        [imgView, titleLabel, alarmSwitch].forEach {
//            contentView.addSubview($0)
//        }
        
        contentView.addSubview(containerStackView)
        [imgView, titleLabel, alarmSwitch].forEach { containerStackView.addArrangedSubview($0) }
        
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(18, after: imgView)
        
//        imgView.snp.makeConstraints {
//            $0.directionalVerticalEdges.equalToSuperview().inset(10)
//            $0.leading.equalToSuperview().inset(20)
//        }
//        
//        titleLabel.snp.makeConstraints {
//            $0.directionalVerticalEdges.equalToSuperview().inset(10)
//            $0.leading.equalTo(imgView.snp.trailing).offset(21)
//        }
//        
//        alarmSwitch.snp.makeConstraints {
//            $0.
//        }
    }
    
    func updateUI(
        imgName: String,
        title: String,
        isOn: Bool
    ) {
        imgView.image = UIImage(named: imgName)
        titleLabel.text = title
        alarmSwitch.isOn = isOn
    }
}
