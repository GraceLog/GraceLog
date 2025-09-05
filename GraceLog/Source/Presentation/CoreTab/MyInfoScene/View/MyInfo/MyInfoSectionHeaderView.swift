//
//  CommonSectionHeaderView.swift
//  GraceLog
//
//  Created by 이상준 on 3/20/25.
//

import UIKit
import Then
import SnapKit

final class MyInfoSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = String(describing: MyInfoSectionHeaderView.self)
    
    private let titleLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.font = GLFont.bold12.font
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(40)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
