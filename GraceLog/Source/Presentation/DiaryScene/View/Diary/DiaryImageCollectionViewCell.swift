//
//  DiaryImageCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/28/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class DiaryImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DiaryImageCollectionViewCell"
    
    let deleteButtonTap = PublishRelay<Void>()
    var disposeBag = DisposeBag()
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "photo_cancel"), for: .normal)
        $0.tintColor = .white
    }
    
    private let representativeLabel = UILabel().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        $0.text = "대표 사진"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = GLFont.regular10.font
        $0.clipsToBounds = true
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        representativeLabel.isHidden = true
        disposeBag = DisposeBag()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.addSubview(representativeLabel)
        representativeLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.top.equalToSuperview().offset(-9)
            $0.trailing.equalToSuperview().offset(9)
        }
    }
    
    private func bind() {
        deleteButton.rx.tap
            .bind(to: deleteButtonTap)
            .disposed(by: disposeBag)
    }
    
    func updateUI(with image: UIImage, isRepresentative: Bool = false) {
        imageView.image = image
        markAsRepresentative(isRepresentative)
    }
    
    private func markAsRepresentative(_ isRepresentative: Bool) {
        representativeLabel.isHidden = !isRepresentative
    }
}
