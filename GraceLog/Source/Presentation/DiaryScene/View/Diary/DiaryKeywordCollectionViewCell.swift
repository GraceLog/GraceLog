//
//  DiaryKeywordCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 4/13/25.
//

import UIKit
import SnapKit
import Then

final class DiaryKeywordCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiaryKeywordCollectionViewCell"
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = .gray200
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray200.cgColor
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func updateUI(title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            contentView.backgroundColor = .themeColor.withAlphaComponent(0.1)
            contentView.layer.borderColor = UIColor.themeColor.cgColor
            titleLabel.textColor = .themeColor
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderColor = UIColor.gray200.cgColor
            titleLabel.textColor = .gray200
        }
    }
}
