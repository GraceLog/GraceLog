//
//  DiaryImageListView.swift
//  GraceLog
//
//  Created by 이건준 on 6/18/25.
//

import UIKit

import SnapKit
import Then

final class DiaryImageListView: UIView {
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
    }
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.spacing = 14
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 32, left: 30, bottom: 34, right: 30)
    }
    
    let addImageButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.setDimensions(width: 64, height: 64)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "camera")
        config.imagePlacement = .top
        config.imagePadding = .zero
        $0.configuration = config
    }
    
    private let diaryImageLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 14
        $0.itemSize = CGSize(width: 64, height: 64)
    }
    lazy var diaryImageCollectionView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: diaryImageLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.register(DiaryImageCollectionViewCell.self, forCellWithReuseIdentifier: DiaryImageCollectionViewCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
        updateWrittenCount(count: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayouts() {
        addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        [addImageButton, diaryImageCollectionView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(64 + 32 + 34)
        }
        
        scrollView.snp.makeConstraints {
            $0.directionalEdges.height.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
}

extension DiaryImageListView {
    func updateWrittenCount(
        count: Int,
        pointColor: UIColor = .themeColor
    ) {
        let writtenCharacters = NSAttributedString(
            string: "\(count)",
            attributes: [.foregroundColor: pointColor, .font: GLFont.medium10.font]
        )
        
        let totalCharacters = NSAttributedString(
            // TODO: - 이미지 등록 최대 갯수에 관련된 로직 Reactor에서 처리 예정
            string: "/\(10)",
            attributes: [.foregroundColor: UIColor.gray200, .font: GLFont.medium10.font]
        )
        
        addImageButton.setAttributedTitle(
            NSMutableAttributedString(attributedString: writtenCharacters).then {
                $0.append(totalCharacters)
            }, for: .normal
        )
    }
}
