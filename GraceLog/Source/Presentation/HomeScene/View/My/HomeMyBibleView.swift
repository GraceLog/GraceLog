//
//  HomeMyBibleView.swift
//  GraceLog
//
//  Created by 이상준 on 6/25/25.
//

import UIKit

import SnapKit
import Then

final class HomeMyBibleView: UIView {
    private let titleLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.font = GLFont.bold14.font
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
        $0.spacing = 12
        $0.alignment = .leading
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        addSubview(stackView)
        [titleLabel, descLabel, paragraphLabel].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().offset(-17)
        }
    }
    
    func setData(title: String, desc: String, paragraph: String) {
        titleLabel.text = title
        descLabel.text = desc
        paragraphLabel.text = paragraph
    }
}
