//
//  CommonButtonCell.swift
//  GraceLog
//
//  Created by 이상준 on 4/5/25.
//

import UIKit
import SnapKit
import Then

final class CommonButtonTableViewCell: UITableViewCell {
    static let identifier = "CommonButtonTableViewCell"
    
    private let button = UIButton().then {
        $0.setHeight(45)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .themeColor
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = GLFont.extraBold18.font
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(29)
            $0.bottom.equalToSuperview().inset(13)
        }
    }
    
    func updateUI(title: String) {
        button.setTitle(title, for: .normal)
    }
}
