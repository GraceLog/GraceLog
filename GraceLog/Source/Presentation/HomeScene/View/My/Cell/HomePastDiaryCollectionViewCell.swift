//
//  HomePastDiaryCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 6/24/25.
//

import UIKit

import SnapKit
import Then

final class HomePastDiaryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: HomePastDiaryCollectionViewCell.self)
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(hex: 0xF4F4F4)
    }
    
    private let overlayView = UIView()
    
    private let dateDescLabel = UILabel().then {
        $0.font = GLFont.medium10.font
        $0.textColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.bold18.font
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 25
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(overlayView)
        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [dateDescLabel, titleLabel].forEach {
            overlayView.addSubview($0)
        }
        
        
        dateDescLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(37)
            $0.leading.trailing.equalTo(contentView).inset(26)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateDescLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(contentView).inset(26)
            $0.bottom.lessThanOrEqualTo(contentView).offset(-37)
        }
    }
    
    func setData(item: MyDiaryItem) {
        imageView.image = item.image
        titleLabel.text = item.title
        dateDescLabel.text = item.dateDesc
    }
}
