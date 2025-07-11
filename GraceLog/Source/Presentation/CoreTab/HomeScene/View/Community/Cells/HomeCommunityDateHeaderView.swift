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
        $0.textAlignment = .center
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(13)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(editedDate: String) {
        dateLabel.text = editedDate
    }
}
