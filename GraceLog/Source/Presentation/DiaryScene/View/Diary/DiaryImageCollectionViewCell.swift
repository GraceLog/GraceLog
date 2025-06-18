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
    static let reuseIdentifier = String(describing: DiaryImageCollectionViewCell.self)
    
    var disposeBag = DisposeBag()
    
    private let diaryImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "photo_cancel"), for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let representativeLabel = UILabel().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        $0.text = "대표 사진"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = GLFont.regular10.font
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        diaryImageView.image = nil
        representativeLabel.isHidden = true
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return super.point(inside: point, with: event) || deleteButton.frame.contains(point)
    }
    
    private func configureUI() {
        backgroundColor = .white
        
        contentView.addSubview(diaryImageView)
        diaryImageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        diaryImageView.addSubview(representativeLabel)
        representativeLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.centerY.equalTo(snp.top)
            $0.centerX.equalTo(snp.trailing)
        }
    }
    
    func updateUI(diaryImage: UIImage, isRepresentative: Bool = false) {
        diaryImageView.image = diaryImage
        markAsRepresentative(isRepresentative)
    }
    
    private func markAsRepresentative(_ isRepresentative: Bool) {
        representativeLabel.isHidden = !isRepresentative
    }
}
