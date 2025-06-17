//
//  DiarySettingsTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 4/13/25.
//

import UIKit
import SnapKit
import Then

final class DiarySettingsTableViewCell: UITableViewCell {
    static let identifier = "DiarySettingsTableViewCell"
    
    private let imgView = UIImageView().then {
        $0.setDimensions(width: 24, height: 24)
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "settings")
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = GLFont.regular16.font
        $0.text = "추가 설정"
    }
    
    private let rightImgView = UIImageView().then {
        $0.setDimensions(width: 20, height: 20)
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "chevron_right_black")
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
        
        [imgView, rightImgView, titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        imgView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().offset(39)
        }
        
        rightImgView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(22)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imgView.snp.trailing).offset(26)
            $0.trailing.equalTo(rightImgView.snp.leading).offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
