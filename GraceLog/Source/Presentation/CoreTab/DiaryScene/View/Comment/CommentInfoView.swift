//
//  CommentInfoView.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import UIKit

import SnapKit
import Then

final class CommentInfoView: UIView {
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.setDimensions(width: 40, height: 40)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .gray
    }
    
    private let contentStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 6
    }
    
    // MARK: - 댓글작성 정보관련 UI
    
    private let editedInfoStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private let authorNameLabel = UILabel().then {
        $0.font = GLFont.bold12.font
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    private let editedDateLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = UIColor(hex: 0xD9D9D9)
        $0.textAlignment = .left
    }
    
    private let commentLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [authorNameLabel, editedDateLabel, UIView()].forEach { editedInfoStackView.addArrangedSubview($0) }
        [editedInfoStackView, commentLabel].forEach { contentStackView.addArrangedSubview($0) }
        [profileImageView, contentStackView].forEach { addSubview($0) }
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.directionalVerticalEdges.trailing.equalToSuperview()
        }
    }
}

extension CommentInfoView {
    func configureUI(
        profileImageURL: URL?,
        authorName: String?,
        editedDate: String?,
        comment: String?
    ) {
        profileImageView.kf.setImage(with: profileImageURL)
        authorNameLabel.text = authorName
        editedDateLabel.text = editedDate
        commentLabel.text = comment
    }
}
