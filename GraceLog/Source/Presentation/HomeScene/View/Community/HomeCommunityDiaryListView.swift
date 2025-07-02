//
//  HomeCommunityDiaryListView.swift
//  GraceLog
//
//  Created by 이상준 on 6/26/25.
//

import UIKit
import SnapKit
import Then

final class HomeCommunityDiaryListView: UIView {
    let diaryTableView = AutoSizingTableView().then {
        $0.backgroundColor = UIColor(hex: 0xF4F4F4)
        $0.separatorStyle = .none
        $0.sectionHeaderHeight = .leastNonzeroMagnitude
        $0.sectionFooterHeight = .leastNonzeroMagnitude
        $0.sectionHeaderTopPadding = 0
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 150
        $0.estimatedRowHeight = 150
        $0.register(HomeCommunityDateHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeCommunityDateHeaderView.reuseIdentifier)
        $0.register(HomeCommunityMyDiaryTableViewCell.self, forCellReuseIdentifier: HomeCommunityMyDiaryTableViewCell.reuseIdentifier)
        $0.register(HomeCommunityUserDiaryTableViewCell.self, forCellReuseIdentifier: HomeCommunityUserDiaryTableViewCell.reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        addSubview(diaryTableView)
        
        diaryTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
