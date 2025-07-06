//
//  DiaryKeywordView.swift
//  GraceLog
//
//  Created by 이건준 on 6/20/25.
//

import UIKit

import SnapKit
import Then

final class DiaryKeywordView: UIView {
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 19, left: 30, bottom: 54, right: 30)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "대표 키워드"
        $0.font = GLFont.bold14.font
        $0.textColor = .themeColor
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "중복 선택할 수 있어요!"
        $0.font = GLFont.regular12.font
        $0.textColor = .gray200
    }
    
    private let keywordCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 10
        $0.minimumLineSpacing = 13
        $0.sectionInset = .zero
    }
    
    lazy var keywordCollectionView = AutoSizingCollectionView(
        frame: .zero,
        collectionViewLayout: keywordCollectionViewLayout
    ).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .white
        $0.register(DiaryKeywordCollectionViewCell.self, forCellWithReuseIdentifier: DiaryKeywordCollectionViewCell.identifier)
        $0.allowsMultipleSelection = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        addSubview(containerStackView)
        [titleLabel, descriptionLabel, keywordCollectionView]
            .forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(20, after: descriptionLabel)
    }
}
