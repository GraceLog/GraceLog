//
//  DiaryImageTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/28/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class DiaryImageTableViewCell: UITableViewCell {
    static let identifier = "DiaryImageTableViewCell"
    
    let imageAddTap = PublishRelay<Void>()
    let imageDeleteTap = PublishRelay<Int>()
    var disposeBag = DisposeBag()
    
    private var representativeImageIndex: Int? = 0
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        layout.itemSize = CGSize(width: 70, height: 70)
        return layout
    }()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.register(DiaryAddImageCollectionViewCell.self, forCellWithReuseIdentifier: DiaryAddImageCollectionViewCell.identifier)
        $0.register(DiaryImageCollectionViewCell.self, forCellWithReuseIdentifier: DiaryImageCollectionViewCell.reuseIdentifier)
    }
    
    private var images: [UIImage] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        images = []
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        
        selectionStyle = .none
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(5)
            $0.height.equalTo(110)
        }
    }
    
    func setImages(_ images: [UIImage], representativeIndex: Int? = 0) {
        self.images = images
        self.representativeImageIndex = representativeIndex
        collectionView.reloadData()
    }
}

extension DiaryImageTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryAddImageCollectionViewCell.identifier, for: indexPath) as? DiaryAddImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.updateCount(current: images.count, max: 5)
            cell.imageAddTap
                .bind(to: imageAddTap)
                .disposed(by: cell.disposeBag)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryImageCollectionViewCell.reuseIdentifier, for: indexPath) as? DiaryImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            let imageIndex = indexPath.item - 1
            let image = images[imageIndex]
            let isRepresentative = representativeImageIndex == imageIndex
            cell.updateUI(diaryImage: image, isRepresentative: isRepresentative)
            cell.deleteButton.rx.tap
                .map { imageIndex }
                .bind(to: imageDeleteTap)
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
}
