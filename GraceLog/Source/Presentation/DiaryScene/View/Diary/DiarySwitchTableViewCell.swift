//
//  DiarySwitchTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/26/25.
//

import UIKit
import Then
import SnapKit

final class DiarySwitchTableViewCell: UITableViewCell {
    static let identifier = "DiarySwitchTableViewCell"
    
    private let logoImgView = UIImageView().then {
        $0.setDimensions(width: 40, height: 40)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = GLFont.regular16.font
    }
    
    private let shareSwitch = UISwitch().then {
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
        selectionStyle = .none
        
        contentView.addSubview(logoImgView)
        logoImgView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(shareSwitch)
        shareSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(50)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImgView.snp.trailing).offset(18)
            $0.centerY.equalToSuperview()
        }
    }
    
    func updateUI(imageUrl: String, title: String, isOn: Bool) {
        logoImgView.image = UIImage(named: imageUrl)
        titleLabel.text = title
        shareSwitch.isOn = isOn
    }
}
