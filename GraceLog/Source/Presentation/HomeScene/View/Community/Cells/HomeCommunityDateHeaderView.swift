//
//  HomeCommunityDateHeaderView.swift
//  GraceLog
//
//  Created by 이상준 on 2/24/25.
//

import UIKit
import SnapKit
import Then

final class HomeCommunityDateHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = String(describing: HomeCommunityDateHeaderView.self)
    
    private let dateLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = .themeColor
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-8)
            $0.centerX.equalToSuperview()

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(date: String) {
        dateLabel.text = date
    }
}
