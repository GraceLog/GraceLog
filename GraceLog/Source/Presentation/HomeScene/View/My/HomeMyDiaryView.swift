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
    
    lazy var diaryCollectionView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
        
        $0.register(HomeLatestDiaryCollectionViewCell.self, forCellWithReuseIdentifier: HomeLatestDiaryCollectionViewCell.reuseIdentifier)
        $0.register(HomePastDiaryCollectionViewCell.self, forCellWithReuseIdentifier: HomePastDiaryCollectionViewCell.reuseIdentifier)
    }
    
    private var diaryItems: [MyDiaryItem] = []
    private var lineViews: [UIView] = []
    private var dateLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        let compassStack = UIStackView(arrangedSubviews: [imgView, titleLabel])
        compassStack.axis = .horizontal
        compassStack.spacing = 4
        
        addSubview(compassStack)
        compassStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.trailing.equalToSuperview().inset(74)
        }
        
        addSubview(diaryCollectionView)
        diaryCollectionView.snp.makeConstraints {
            $0.top.equalTo(compassStack.snp.bottom).offset(19)
            $0.leading.equalToSuperview().offset(70)
            $0.trailing.equalToSuperview().offset(-23)
            $0.bottom.equalToSuperview().offset(-31)
        }
    }
    
    func updateDateLabelsAndLines(with items: [MyDiaryItem]) {
        self.diaryItems = items
        
        DispatchQueue.main.async {
            self.setupDateLabelsAndLines()
        }
    }
    
    private func setupDateLabelsAndLines() {
        var previousDateLabel: UILabel?
        
        diaryItems.enumerated().forEach { index, item in
            guard let cell = diaryCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) else { return }
            
            let dateLabel = createDateLabel(item: item, alignedTo: cell)
            
            if let previousLabel = previousDateLabel {
                createLineView(from: previousLabel, to: dateLabel)
            }
            
            previousDateLabel = dateLabel
        }
    }
    
    private func createDateLabel(item: MyDiaryItem, alignedTo cell: UICollectionViewCell) -> UILabel {
        let dateLabel = UILabel()
        dateLabel.attributedText = item.date.toDiaryDateAttributedString()
        dateLabel.numberOfLines = 2
        dateLabel.textAlignment = .center
        addSubview(dateLabel)
        dateLabels.append(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(cell)
            $0.leading.equalToSuperview().offset(21)
        }
        
        return dateLabel
    }
    
    private func createLineView(from previousLabel: UILabel, to currentLabel: UILabel) {
        let lineView = UIView()
        lineView.backgroundColor = .themeColor
        addSubview(lineView)
        lineViews.append(lineView)
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.centerX.equalTo(currentLabel)
            $0.top.equalTo(previousLabel.snp.bottom).offset(6)
            $0.bottom.equalTo(currentLabel.snp.top).offset(-6)
        }
    }
}
