//
//  DiaryKeywordTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 4/13/25.
//

import UIKit
import SnapKit
import Then

final class DiaryKeywordTableViewCell: UITableViewCell {
    static let identifier = "DiaryKeywordTableViewCell"
    
    private let keywords = ["순종", "믿음", "사랑", "비전", "인내", "평안", "고난", "끈기"]
    private var selectedKeywords: [String] = []
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 13
        layout.sectionInset = .zero
        return layout
    }()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(29)
            $0.height.equalTo(calculateCollectionViewHeight())
            $0.bottom.equalToSuperview().inset(54)
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(DiaryKeywordCollectionViewCell.self, forCellWithReuseIdentifier: DiaryKeywordCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        let width = (UIScreen.main.bounds.width - 30 * 2 - 16 * 2) / 3
        let height = (width * 30) / 105
        
        let rowCount = ceil(CGFloat(keywords.count) / 3.0)
        
        let totalHeight = (height * rowCount) + (8 * (rowCount - 1)) + 26
        return totalHeight
    }
}

extension DiaryKeywordTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryKeywordCollectionViewCell.identifier, for: indexPath) as? DiaryKeywordCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let keyword = keywords[indexPath.row]
//        cell.updateUI(title: keywords[indexPath.row], isSelected: selectedKeywords.contains(keyword))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 3
        let height = (width * 30) / 105
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedKeyword = keywords[indexPath.row]
        
        if selectedKeywords.contains(selectedKeyword) {
            selectedKeywords.removeAll { $0 == selectedKeyword }
        } else {
            if selectedKeywords.count >= 3 {
                selectedKeywords.removeFirst()
            }
            selectedKeywords.append(selectedKeyword)
        }
        
        collectionView.reloadData()
    }
}
