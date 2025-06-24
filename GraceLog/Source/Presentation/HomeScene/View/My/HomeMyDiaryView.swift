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
    private let imgView = UIImageView().then {
        $0.image = UIImage(named: "compass")
        $0.setDimensions(width: 20, height: 20)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = .themeColor
        
        // TODO: - 유저 정보 처리 필요
        $0.text = "승렬님, 오늘도 하나님과 동행하세요"
    }
    
    lazy var diaryCollectionView = UICollectionView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
    }
    
    
    private var lineViews: [UIView] = []
    private var dateLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        addSubview(diaryCollectionView)
    }
    
    private func setupConstraints() {
        
    }
    
    
}
