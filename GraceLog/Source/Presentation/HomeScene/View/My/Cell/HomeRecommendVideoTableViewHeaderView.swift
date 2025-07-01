//
//  HomeTableViewHeader.swift
//  GraceLog
//
//  Created by 이상준 on 2/8/25.
//

import UIKit
import Then
import SnapKit

final class HomeRecommendVideoTableViewHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = String(describing: HomeRecommendVideoTableViewHeaderView.self)
    
    private let titleLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.font = GLFont.bold14.font
    }
    
    private let descLabel = UILabel().then {
        $0.textColor = .graceGray
        $0.font = GLFont.regular24.font
        $0.numberOfLines = 4
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
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
        [titleLabel, descLabel].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, desc: String) {
        titleLabel.text = title
        descLabel.text = desc
    }
}
