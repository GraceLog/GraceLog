//
//  MyInfoButtonTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/21/25.
//

import UIKit
import Then
import SnapKit

final class MyInfoButtonTableViewCell: UITableViewCell {
    static let identifier = "MyInfoButtonTableViewCell"
    
    private let button = UIButton().then {
        $0.backgroundColor = .white
        $0.titleLabel?.font = GLFont.regular15.font
        $0.titleLabel?.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func updateUI(title: String, textColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
    }
}
