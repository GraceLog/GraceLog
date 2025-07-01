//
//  HomeMyDiaryView.swift
//  GraceLog
//
//  Created by 이상준 on 6/24/25.
//

import UIKit

import SnapKit
import Then

final class HomeMyDiaryView: UIView {
    private let diaryImageView = UIImageView().then {
        $0.image = UIImage(named: "compass")
        $0.setDimensions(width: 20, height: 20)
    }
    
    private let greetingLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = .themeColor
        
        // TODO: - 유저 정보 처리 필요
        $0.text = "승렬님, 오늘도 하나님과 동행하세요"
    }
    
    lazy var diaryCollectionView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = .zero
    }).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
        
        $0.register(HomeLatestDiaryCollectionViewCell.self, forCellWithReuseIdentifier: HomeLatestDiaryCollectionViewCell.reuseIdentifier)
        $0.register(HomePastDiaryCollectionViewCell.self, forCellWithReuseIdentifier: HomePastDiaryCollectionViewCell.reuseIdentifier)
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
        
        let diaryTopStackView = UIStackView(arrangedSubviews: [diaryImageView, greetingLabel])
        diaryTopStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
        }
        
        [diaryTopStackView, diaryCollectionView].forEach { addSubview($0) }
        
        diaryTopStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(14 + 19 + 37)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        diaryCollectionView.snp.makeConstraints {
            $0.top.equalTo(diaryTopStackView.snp.bottom).offset(19)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(31)
        }
    }
}
