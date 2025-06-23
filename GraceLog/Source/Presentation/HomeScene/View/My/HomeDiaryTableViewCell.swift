//
//  HomeDiaryCell.swift
//  GraceLog
//
//  Created by 이상준 on 2/8/25.
//

import UIKit
import Then
import SnapKit

final class HomeDiaryTableViewCell: UITableViewCell {
    static let identifier = "HomeDiaryTableViewCell"
    
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
    
    private let diaryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 26
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    private var lineViews: [UIView] = []
    private var dateLabels: [UILabel] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        let compassStack = UIStackView(arrangedSubviews: [imgView, titleLabel])
        compassStack.axis = .horizontal
        compassStack.spacing = 4
        
        contentView.addSubview(compassStack)
        compassStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.leading.trailing.equalToSuperview().inset(74)
        }
        
        contentView.addSubview(diaryStackView)
        diaryStackView.snp.makeConstraints {
            $0.top.equalTo(compassStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(74)
            $0.trailing.equalToSuperview().offset(-23)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with diaryList: [MyDiaryItem]) {
        cleanupViews()
        setupDiaryItems(diaryList)
    }
    
    func setTitle(username: String) {
        titleLabel.text = "\(username)님, 오늘도 하나님과 동행하세요"
    }
    
    private func cleanupViews() {
        diaryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        lineViews.forEach { $0.removeFromSuperview() }
        dateLabels.forEach { $0.removeFromSuperview() }
        lineViews.removeAll()
        dateLabels.removeAll()
    }
    
    private func setupDiaryItems(_ items: [MyDiaryItem]) {
        var previousDateLabel: UILabel?
        
        items.enumerated().forEach { index, item in
            let cardView = createCardView(item: item, index: index)
            let dateLabel = createDateLabel(item: item, alignedTo: cardView)
            
            if let previousLabel = previousDateLabel {
                createLineView(from: previousLabel, to: dateLabel)
            }
            
            previousDateLabel = dateLabel
        }
    }
    
    private func createCardView(item: MyDiaryItem, index: Int) -> DiaryCardView {
        let style: DiaryCardView.Style = index == 0 ? .latest : .past
        let cardView = DiaryCardView(style: style, item: item)
        diaryStackView.addArrangedSubview(cardView)
        return cardView
    }
    
    private func createDateLabel(item: MyDiaryItem, alignedTo cardView: DiaryCardView) -> UILabel {
        let dateLabel = UILabel()
        dateLabel.attributedText = item.date.toDiaryDateAttributedString()
        dateLabel.numberOfLines = 2
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        dateLabels.append(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(cardView)
            $0.leading.equalToSuperview().offset(21)
        }
        
        return dateLabel
    }
    
    private func createLineView(from previousLabel: UILabel, to currentlabel: UILabel) {
        let lineView = UIView()
        lineView.backgroundColor = .themeColor
        contentView.addSubview(lineView)
        lineViews.append(lineView)
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.centerX.equalTo(currentlabel)
            $0.top.equalTo(previousLabel.snp.bottom).offset(6)
            $0.bottom.equalTo(currentlabel.snp.top).offset(-6)
        }
    }
}
