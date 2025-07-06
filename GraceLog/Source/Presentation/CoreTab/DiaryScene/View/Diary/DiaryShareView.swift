//
//  DiaryShareView.swift
//  GraceLog
//
//  Created by 이건준 on 6/22/25.
//

import UIKit

import SnapKit
import Then

final class DiaryShareView: UIView {
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 19, left: 30, bottom: 32 - 12, right: 30)
        $0.spacing = 19
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "공동체에게 공유"
        $0.font = GLFont.bold14.font
        $0.textColor = .themeColor
    }
    
    lazy var diaryShareTableView = AutoSizingTableView().then {
        $0.register(DiaryShareTableViewCell.self, forCellReuseIdentifier: DiaryShareTableViewCell.identifier)
        $0.rowHeight = 40 + 12
        $0.estimatedRowHeight = 40 + 12
        $0.sectionHeaderHeight = .leastNonzeroMagnitude
        $0.sectionFooterHeight = .leastNonzeroMagnitude
        $0.separatorStyle = .none
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
        [titleLabel, diaryShareTableView].forEach { containerStackView.addArrangedSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
