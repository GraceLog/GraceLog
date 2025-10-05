//
//  CommunityRoomCollectionViewCell.swift
//  GraceLog
//
//  Created by 이건준 on 10/5/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class CommunityRoomCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CommunityRoomCollectionViewCell.self)
    
    private let communityImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 30
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = .black // FIXME: - GLColor로 색상 수정
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = UIColor(hex: 0x414141) // FIXME: - GLColor로 색상 수정
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let peopleCountLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = .gray // FIXME: - GLColor로 색상 수정
    }
    
    private let recentEditedDateLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = UIColor(hex: 0x414141) // FIXME: - GLColor로 색상 수정
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        communityImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        peopleCountLabel.text = nil
        recentEditedDateLabel.text = nil
    }
    
    private func configureUI() {
        [communityImageView, titleLabel, descriptionLabel, peopleCountLabel, recentEditedDateLabel].forEach { contentView.addSubview($0) }
        communityImageView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.centerY.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(communityImageView.snp.trailing).offset(15)
            $0.top.equalTo(communityImageView)
        }
        
        peopleCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        recentEditedDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(peopleCountLabel.snp.trailing)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(14.16)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension CommunityRoomCollectionViewCell {
    func configureUI(
        title: String,
        description: String,
        editedDate: Date?,
        peopleCount: Int,
        imageURL: URL?
    ) {
        titleLabel.text = title
        descriptionLabel.text = description
        recentEditedDateLabel.text = DateformatterFactory.dateWithDot.string(from: editedDate!)
        peopleCountLabel.text = "\(peopleCount)"
        communityImageView.kf.setImage(with: imageURL)
    }
}
