//
//  HomePastDiaryCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 6/24/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class HomePastDiaryCollectionViewCell: DiaryTimelineCollectionViewCell {
    static let reuseIdentifier = String(describing: HomePastDiaryCollectionViewCell.self)
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 18, left: 21, bottom: 18, right: 21)
        $0.spacing = 4
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.medium10.font
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.bold18.font
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        contentLabel.text = nil
    }
    
    override func setupAutoLayouts() {
        super.setupAutoLayouts()
        backgroundImageView.addSubview(containerStackView)
        
        [dateLabel, contentLabel].forEach { containerStackView.addArrangedSubview($0) }
        containerStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension HomePastDiaryCollectionViewCell {
    func setData(
        backgroundImageURL: URL?,
        date: String,
        content: String,
        relativeDate: String,
        exactDate: String,
        hideTopLine: Bool,
        hideBottomLine: Bool
    ) {
        super.configureUI(
            backgroundImageURL: backgroundImageURL,
            relativeDate: relativeDate,
            exactDate: exactDate,
            hideTopLine: hideTopLine,
            hideBottomLine: hideBottomLine
        )
        dateLabel.text = date
        contentLabel.text = content
    }
}
