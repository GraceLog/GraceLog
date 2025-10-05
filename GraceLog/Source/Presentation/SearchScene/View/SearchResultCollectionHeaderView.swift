//
//  SearchResultCollectionHeaderView.swift
//  GraceLog
//
//  Created by 이건준 on 9/21/25.
//

import UIKit

import SnapKit
import Then

final class SearchResultCollectionHeaderView: UICollectionReusableView {
    static let identifier = String(describing: SearchResultCollectionHeaderView.self)
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.regular16.font
        $0.textColor = UIColor(hex: 0x161515) // FIXME: - GLColor로 색상 수정
        $0.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension SearchResultCollectionHeaderView {
    func configureUI(title: String) {
        titleLabel.text = title
    }
}
