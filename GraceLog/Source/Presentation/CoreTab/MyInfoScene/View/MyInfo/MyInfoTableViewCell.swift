//
//  MyInfoTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class MyInfoTableViewCell: UITableViewCell {
    static let identifier = "MyInfoTableViewCell"
    
    private let imgView = UIImageView().then {
        $0.setDimensions(width: 20, height: 20)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = GLFont.regular15.font
    }
    
    private let disclosureView = UIImageView().then {
        $0.setDimensions(width: 20, height: 20)
        $0.image = UIImage(named: "chevron_right_black")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .white
        
        [imgView, titleLabel, disclosureView].forEach {
            contentView.addSubview($0)
        }
        
        imgView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(imgView.snp.trailing).offset(21)
        }
        
        disclosureView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(13)
        }
    }
    
    func updateUI(imgName: String, title: String) {
        imgView.image = UIImage(named: imgName)
        titleLabel.text = title
    }
}
