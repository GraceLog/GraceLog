//
//  EmptyDiaryCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 11/25/25.
//

import UIKit

final class EmptyDiaryCollectionViewCell: DiaryTimelineCollectionViewCell {
    static let reuseIdentifier = String(describing: EmptyDiaryCollectionViewCell.self)
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.bold32.font
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "오늘은 어떤 점이 감사했나요? :)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "오늘은 어떤 점이 감사했나요? :)"
    }
    
    override func setupAttributes() {
        overlayBackgroundView.backgroundColor = GLColor.emptyDiary.color
        editedDateLabel.textColor = GLColor.emptyDiary.color
    }
    
    override func setupAutoLayouts() {
        super.setupAutoLayouts()
        overlayBackgroundView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.trailing.equalToSuperview().inset(36)
            $0.centerY.equalToSuperview()
        }
    }
    
}
