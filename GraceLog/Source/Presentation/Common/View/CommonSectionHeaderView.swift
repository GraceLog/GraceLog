//
//  CommonSectionHeaderView.swift
//  GraceLog
//
//  Created by 이상준 on 4/5/25.
//

import UIKit
import SnapKit

final class CommonSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CommonSectionHeaderView"
    
    private var bottomOffSet: Constraint?
    
    private let titleLabel = UILabel().then {
        $0.textColor = .themeColor
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            bottomOffSet = $0.bottom.equalToSuperview().inset(8).constraint
            $0.leading.equalToSuperview().offset(30)
        }
    }
    
    func setTitle(_ title: String, font: UIFont) {
        titleLabel.text = title
        titleLabel.font = font
    }
}
