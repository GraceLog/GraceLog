//
//  HomeLatestDiaryCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 6/24/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class HomeLatestDiaryCollectionViewCell: DiaryTimelineCollectionViewCell {
    static let reuseIdentifier = String(describing: HomeLatestDiaryCollectionViewCell.self)
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.bold14.font
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let todayGratitudeLabel = UILabel().then {
        $0.font = GLFont.medium10.font
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "오늘의 감사일기"
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.regular18.font
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentLabel.text = nil
    }
    
    override func setupAutoLayouts() {
        super.setupAutoLayouts()
        backgroundImageView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(18)
            $0.directionalHorizontalEdges.equalToSuperview().inset(21)
        }
        
        [todayGratitudeLabel, titleLabel, contentLabel].forEach { containerView.addSubview($0) }
        todayGratitudeLabel.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(todayGratitudeLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension HomeLatestDiaryCollectionViewCell {
    func setData(
        backgroundImageURL: URL?,
        title: String,
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
        titleLabel.text = title
        contentLabel.text = content
    }
}
