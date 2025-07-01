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
    
    private let bibleContentLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular24.font
        $0.numberOfLines = 4
    }
    
    private let bibleReferenceLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular14.font
    }
    
    private let containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 26, left: 30, bottom: 17, right: 30)
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
        
        addSubview(containerStackView)
        [titleLabel, bibleContentLabel, bibleReferenceLabel].forEach { containerStackView.addArrangedSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(8, after: bibleContentLabel)
    }
    
    func setData(title: String, content: String, reference: String) {
        titleLabel.text = title
        bibleContentLabel.text = content
        bibleReferenceLabel.text = reference
    }
}
