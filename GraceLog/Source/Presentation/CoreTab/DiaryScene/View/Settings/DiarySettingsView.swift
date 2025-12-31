//
//  DiarySettingsView.swift
//  GraceLog
//
//  Created by 이상준 on 12/31/25.
//

import UIKit
import SnapKit
import Then

final class DiarySettingsView: UIView { 
    private let headerTitleLabel = UILabel().then {
        $0.font = GLFont.bold16.font
        $0.textColor = GLColor.textAccent.color
        $0.text = "좋아요 및 댓글설정"
    }
    
    let settingsTableView = AutoSizingTableView().then {
        $0.backgroundColor = GLColor.backgroundSub.color
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 50
        $0.register(DiaryAdditionalSettingsTableViewCell.self, forCellReuseIdentifier: DiaryAdditionalSettingsTableViewCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        addSubview(headerTitleLabel)
        addSubview(settingsTableView)
    }
    
    private func setupConstraints() {
        headerTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(30)
        }
        
        settingsTableView.snp.makeConstraints {
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
