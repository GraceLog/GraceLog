//
//  HomeCommunitySelectedView.swift
//  GraceLog
//
//  Created by 이상준 on 6/26/25.
//

import UIKit

import SnapKit
import Then

<<<<<<< HEAD:GraceLog/Source/Presentation/CoreTab/HomeScene/View/Community/HomeCommunitySelectedView.swift
final class HomeCommunityListView: UIView {
=======
final class HomeCommunitySelectedView: UIView {
>>>>>>> 4cb0873 ([FEAT] HomeCommunitySelectedView 구현 및 적용):GraceLog/Source/Presentation/HomeScene/View/Community/HomeCommunitySelectedView.swift
    private let communityListLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 9
        $0.sectionInset = UIEdgeInsets(top: 27, left: 18, bottom: 23, right: 18)
        $0.itemSize = CGSize(width: 64, height: 87)
    }
    
<<<<<<< HEAD:GraceLog/Source/Presentation/CoreTab/HomeScene/View/Community/HomeCommunitySelectedView.swift
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: communityListLayout).then {
=======
    lazy var collectionView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: communityListLayout).then {
>>>>>>> 4cb0873 ([FEAT] HomeCommunitySelectedView 구현 및 적용):GraceLog/Source/Presentation/HomeScene/View/Community/HomeCommunitySelectedView.swift
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
        $0.isScrollEnabled = true
        $0.clipsToBounds = false
<<<<<<< HEAD:GraceLog/Source/Presentation/CoreTab/HomeScene/View/Community/HomeCommunitySelectedView.swift
        $0.register(HomeCommunityListCollectionViewCell.self, forCellWithReuseIdentifier: HomeCommunityListCollectionViewCell.reuseIdentifier)
=======
        $0.register(HomeCommunitySelectedCollectionViewCell.self, forCellWithReuseIdentifier: HomeCommunitySelectedCollectionViewCell.reuseIdentifier)
>>>>>>> 4cb0873 ([FEAT] HomeCommunitySelectedView 구현 및 적용):GraceLog/Source/Presentation/HomeScene/View/Community/HomeCommunitySelectedView.swift
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
<<<<<<< HEAD:GraceLog/Source/Presentation/CoreTab/HomeScene/View/Community/HomeCommunitySelectedView.swift
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.equalTo(140)
=======
        
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(140)
        }
        
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
>>>>>>> 4cb0873 ([FEAT] HomeCommunitySelectedView 구현 및 적용):GraceLog/Source/Presentation/HomeScene/View/Community/HomeCommunitySelectedView.swift
        }
    }
}
