//
//  HomeVideoTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 2/8/25.
//

import UIKit
import Then
import SnapKit

final class HomeRecommendTableViewCell: UITableViewCell {
    static let identifier = "HomeRecommendTableViewCell"
    
    private let contentTitleLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = .graceGray
    }
    
    private let contentImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
        
        [contentTitleLabel, contentImgView].forEach { addSubview($0) }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        contentImgView.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(contentImgView.snp.width).multipliedBy(0.5625)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(title: String, image: UIImage) {
        contentTitleLabel.text = title
        contentImgView.image = image
    }
}
