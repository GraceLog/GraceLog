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
    lazy var recommendVideoTableView = AutoSizingTableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
        $0.sectionFooterHeight = .leastNonzeroMagnitude
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(HomeRecommendVideoTableViewCell.self, forCellReuseIdentifier: HomeRecommendVideoTableViewCell.reuseIdentifier)
        $0.register(HomeRecommendVideoTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeRecommendVideoTableViewHeaderView.reuseIdentifier)
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
        
        addSubview(recommendVideoTableView)
        recommendVideoTableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
