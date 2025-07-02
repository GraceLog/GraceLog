//
//  HomeCommunitySelectedView.swift
//  GraceLog
//
//  Created by 이상준 on 6/26/25.
//

import UIKit

import SnapKit
import Then

final class HomeCommunityListView: UIView {
    private let communityListLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 9
        $0.sectionInset = UIEdgeInsets(top: 27, left: 18, bottom: 23, right: 18)
        $0.itemSize = CGSize(width: 64, height: 87)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: communityListLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
        $0.isScrollEnabled = true
        $0.clipsToBounds = false
        $0.register(HomeCommunityListCollectionViewCell.self, forCellWithReuseIdentifier: HomeCommunityListCollectionViewCell.reuseIdentifier)
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
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.equalTo(140)
        }
    }
}
