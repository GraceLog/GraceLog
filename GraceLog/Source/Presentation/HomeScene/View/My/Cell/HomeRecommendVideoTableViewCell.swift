//
//  HomeVideoTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 2/8/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class HomeRecommendVideoTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: HomeRecommendVideoTableViewCell.self)
    var disposeBag = DisposeBag()
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = .graceGray
    }
    
    let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 25
        $0.isUserInteractionEnabled = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: .init(top: .zero, left: .zero, bottom: 20.44, right: .zero))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        thumbnailImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    private func configureUI() {
        backgroundColor = UIColor(hex: 0xF4F4F4)
        contentView.backgroundColor = UIColor(hex: 0xF4F4F4)
        
        selectionStyle = .none
        
        contentView.addSubview(containerStackView)
        [titleLabel, thumbnailImageView].forEach { containerStackView.addArrangedSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension HomeRecommendVideoTableViewCell {
    func configureUI(title: String, thumbnailImageURL: URL?) {
        titleLabel.text = title
        thumbnailImageView.kf.setImage(with: thumbnailImageURL)
    }
}
