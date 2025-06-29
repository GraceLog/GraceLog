//
//  DiaryTimelineCollectionViewCell.swift
//  GraceLog
//
//  Created by 이건준 on 6/27/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

class DiaryTimelineCollectionViewCell: UICollectionViewCell {
    let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = UIColor(hex: 0xF4F4F4)
    }
    
    // MARK: - Timeline Components
    
    private let timelineContainerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = Metric.timelineSpacing
    }
    
    private let topLineContainer = UIView()
    private let bottomLineContainer = UIView()
    
    private let topLineView = UIView().then {
        $0.backgroundColor = .themeColor
    }
    
    private let editedDateLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .themeColor
    }
        
    // MARK: - Intitializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayouts()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let totalHeight = backgroundImageView.frame.height
        let labelHeight = editedDateLabel.frame.height
        let remaining = max((totalHeight - labelHeight - Metric.timelineSpacing * 2), 0) / 2
        
        topLineContainer.snp.updateConstraints {
            $0.height.equalTo(remaining)
        }
        
        bottomLineContainer.snp.updateConstraints {
            $0.height.equalTo(remaining + Metric.backgroundImageBottomInset)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        editedDateLabel.text = nil
        topLineView.isHidden = true
        bottomLineView.isHidden = true
    }
    
    func setupAutoLayouts() {
        [timelineContainerStackView, backgroundImageView].forEach { contentView.addSubview($0) }
        [topLineContainer, editedDateLabel, bottomLineContainer].forEach { timelineContainerStackView.addArrangedSubview($0) }
        
        timelineContainerStackView.snp.makeConstraints {
            $0.directionalVerticalEdges.leading.equalToSuperview()
            $0.width.equalTo(Metric.timelineWidth)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(timelineContainerStackView.snp.trailing)
            $0.top.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Metric.backgroundImageBottomInset)
        }
        
        topLineContainer.addSubview(topLineView)
        bottomLineContainer.addSubview(bottomLineView)

        [topLineView, bottomLineView].forEach {
            $0.snp.makeConstraints {
                $0.directionalVerticalEdges.centerX.equalToSuperview()
                $0.width.equalTo(1)
            }
        }
        
        [topLineContainer, bottomLineContainer].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(0)
            }
        }
    }
    
    func setupAttributes() {
        contentView.layer.masksToBounds = true
    }
}

extension DiaryTimelineCollectionViewCell {
    func configureUI(
        backgroundImageURL: URL?,
        relativeDate: String,
        exactDate: String,
        hideTopLine: Bool,
        hideBottomLine: Bool
    ) {
        backgroundImageView.kf.setImage(with: backgroundImageURL)
        topLineView.isHidden = hideTopLine
        bottomLineView.isHidden = hideBottomLine
        
        let relativeDateString = NSAttributedString(string: relativeDate + "\n", attributes: [.font: GLFont.regular14.font])
        let exactDateString = NSAttributedString(string: exactDate, attributes: [.font: GLFont.regular14.font])
        
        editedDateLabel.attributedText = NSMutableAttributedString(attributedString: relativeDateString).then {
            $0.append(exactDateString)
        }
        contentView.layoutIfNeeded()
    }
}

// MARK: - Metrics For DiaryTimelineCell

private enum Metric {
    static let backgroundImageBottomInset: CGFloat = 26
    static let timelineWidth: CGFloat = 70
    static let timelineSpacing: CGFloat = 8
}
