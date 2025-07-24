//
//  ProfileHeaderView.swift
//  GraceLog
//
//  Created by 이상준 on 3/15/25.
//

import UIKit
import SnapKit
import Then
import SDWebImage

final class ProfileTableViewCell: UITableViewCell {
    static let identifier = "ProfileTableViewCell"
    
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
        $0.text = UserManager.shared.username
    }
    
    private let emailLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular12.font
        $0.textAlignment = .center
        $0.text = UserManager.shared.userEmail
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        [profileImgView, nameLabel, emailLabel].forEach {
            addSubview($0)
        }
        
        profileImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(27)
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
    
    func updateUI(with profileItem: ProfileItem) {
        if let imageUrl = URL(string: profileItem.imageUrl) {
            profileImgView.sd_setImage(with: imageUrl)
        } else {
            profileImgView.image = UIImage(named: "profile")
        }
        
        nameLabel.text = profileItem.name
        emailLabel.text = profileItem.email
    }
}
