//
//  HomeLatestDiaryCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 6/24/25.
//

import UIKit

import SnapKit
import Then

final class HomeLatestDiaryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: HomeLatestDiaryCollectionViewCell.self)
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(hex: 0xF4F4F4)
    }
    
    private let overlayView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.bold14.font
        $0.numberOfLines = 0
    }
    
    private let dateDescLabel = UILabel().then {
        $0.font = GLFont.medium10.font
        $0.textColor = .white
    }
    
    private lazy var descLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.regular18.font
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
        
        [dateDescLabel, titleLabel, descLabel].forEach {
            overlayView.addSubview($0)
        }
        
        dateDescLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(18)
            $0.leading.trailing.equalTo(contentView).inset(21)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateDescLabel.snp.bottom)
            $0.leading.trailing.equalTo(contentView).inset(21)
        }
        
        descLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(22)
            $0.trailing.equalTo(contentView).inset(34)
            $0.centerY.equalTo(contentView)
        }
    }
    
    func setData(item: MyDiaryItem) {
        imageView.image = item.image
        titleLabel.text = item.title
        dateDescLabel.text = item.dateDesc
        descLabel.text = item.desc
    }
}
