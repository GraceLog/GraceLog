//
//  MyInfoHeaderView.swift
//  GraceLog
//
//  Created by 이상준 on 8/10/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class MyInfoProfileView: UIView {
    private let profileImgView = UIImageView().then {
        $0.setDimensions(width: 112, height: 112)
        $0.backgroundColor = UIColor.init(hex: 0xF0F0F0)
        $0.layer.cornerRadius = 56
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.font = GLFont.bold20.font
        $0.textAlignment = .center
    }
    
    private let emailLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular12.font
        $0.textAlignment = .center
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
        [profileImgView, nameLabel, emailLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        profileImgView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImgView.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
        }
    }
    
    func updateUI(
        imageURL: URL?,
        name: String,
        email: String
    ) {
        profileImgView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "profile")
        )
        nameLabel.text = name
        emailLabel.text = email
    }
}
