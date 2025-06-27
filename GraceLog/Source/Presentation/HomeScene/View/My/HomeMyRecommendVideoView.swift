//
//  HomeRecommendVideoView.swift
//  GraceLog
//
//  Created by 이상준 on 6/25/25.
//

import UIKit

import SnapKit
import Then

final class HomeMyRecommendVideoView: UIView {
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.spacing = 5
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: .zero, left: 20, bottom: 45.74, right: 20)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.font = GLFont.bold14.font
        $0.text = "추천영상"
    }
    
    let recommendedTagLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular24.font
        $0.numberOfLines = 0
    }
    
    lazy var recommendVideoTableView = AutoSizingTableView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(HomeRecommendVideoTableViewCell.self, forCellReuseIdentifier: HomeRecommendVideoTableViewCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.sectionHeaderHeight = .leastNonzeroMagnitude
        $0.sectionFooterHeight = .leastNonzeroMagnitude
        $0.sectionHeaderTopPadding = .zero
        $0.rowHeight = 24 + 8 + 195.56 + 20.44
        $0.estimatedRowHeight = 24 + 8 + 195.56 + 20.44
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        addSubview(containerStackView)
        [titleLabel, recommendedTagLabel, recommendVideoTableView].forEach { containerStackView.addArrangedSubview($0) }
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(7, after: recommendedTagLabel)
    }
}
