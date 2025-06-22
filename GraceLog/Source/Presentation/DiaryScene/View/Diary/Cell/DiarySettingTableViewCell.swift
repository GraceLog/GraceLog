//
//  DiarySettingTableViewCell.swift
//  GraceLog
//
//  Created by 이건준 on 6/22/25.
//

import UIKit

import SnapKit
import Then

final class DiarySettingTableViewCell: UITableViewCell {
    static let identifier = String(describing: DiarySettingTableViewCell.self)
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let settingImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.setDimensions(width: 24, height: 24)
    }
    
    private let settingTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = GLFont.regular16.font
    }
    
    private let accesoryImageView = UIImageView().then {
        $0.image = UIImage(named: "chevron_right_black")
        $0.contentMode = .scaleAspectFit
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        contentView.addSubview(containerStackView)
        [settingImageView, settingTitleLabel, accesoryImageView].forEach { containerStackView.addArrangedSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(26, after: settingImageView)
    }
}

extension DiarySettingTableViewCell {
    func configureUI(imageNamed: String, title: String) {
        settingImageView.image = UIImage(named: imageNamed)
        settingTitleLabel.text = title
    }
}
