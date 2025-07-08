//
//  DiarySettingMenuView.swift
//  GraceLog
//
//  Created by 이건준 on 6/22/25.
//

import UIKit

import SnapKit
import Then

final class DiarySettingView: UIView {
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 18, left: 30, bottom: 18, right: 30)
    }
    
    lazy var diarySettingTableView = AutoSizingTableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.sectionHeaderHeight = .leastNonzeroMagnitude
        $0.sectionFooterHeight = .leastNonzeroMagnitude
        $0.rowHeight = 24
        $0.estimatedRowHeight = 24
        $0.register(DiarySettingTableViewCell.self, forCellReuseIdentifier: DiarySettingTableViewCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(diarySettingTableView)
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
