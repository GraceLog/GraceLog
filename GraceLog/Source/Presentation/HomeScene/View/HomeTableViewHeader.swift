//
//  HomeTableViewHeader.swift
//  GraceLog
//
//  Created by 이상준 on 2/8/25.
//

import UIKit
import Then
import SnapKit

final class HomeTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "HomeTableViewHeader"
    
    private let titleLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.font = GLFont.bold12.font
    }
    
    private let descLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular24.font
        $0.numberOfLines = 4
    }
    
    private let paragraphLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular14.font
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .leading
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        addSubview(stackView)
        [titleLabel, descLabel, paragraphLabel].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 26, left: 30, bottom: 8, right: 30))
        }
    }
    
    func configure(title: String, desc: String, paragraph: String?) {
        titleLabel.text = title
        descLabel.text = desc
        
        if let paragraph = paragraph {
            paragraphLabel.text = paragraph
            paragraphLabel.isHidden = false
        } else {
            paragraphLabel.isHidden = true
        }
    }
}

