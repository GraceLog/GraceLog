//
//  HomeCommunitySelectedCollectionViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 6/26/25.
//

import UIKit
import SnapKit
import Then

final class HomeCommunityListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: HomeCommunityListCollectionViewCell.self)
    
    override var isSelected: Bool {
        didSet {
            containerView.layer.borderColor = isSelected ? UIColor.themeColor.cgColor : UIColor.graceLightGray.cgColor
            communityLabel.textColor = isSelected ? .themeColor : .graceGray
        }
    }
    
    private var communityStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 13
        $0.alignment = .center
    }
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 32
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.graceLightGray.cgColor
        $0.backgroundColor = .clear
    }
    
    private let communityImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28
    }
    
    private let communityLabel = UILabel().then {
        $0.font = GLFont.medium10.font
        $0.textAlignment = .center
        $0.textColor = .graceGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        communityImageView.image = nil
        communityLabel.text = nil
        containerView.layer.borderColor = nil
        isSelected = false
    }
    
    private func setupLayout() {
        contentView.addSubview(communityStackView)
        containerView.addSubview(communityImageView)
        [containerView, communityLabel].forEach { communityStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        communityStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        communityImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
}

extension HomeCommunityListCollectionViewCell {
    func updateUI(imageNamed: String, communityName: String) {
        // TODO: 현재는 이미지 이름으로 -> 추후 이미지 URL을 통해 불러온 데이터로 수정 해야함
        communityImageView.image = UIImage(named: imageNamed)
        communityLabel.text = communityName
    }
}
