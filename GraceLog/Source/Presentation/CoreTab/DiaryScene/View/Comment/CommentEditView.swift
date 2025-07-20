//
//  CommentEditView.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import UIKit

import SnapKit
import Then

final class CommentEditView: UIView {
    private let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.distribution = .fill
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 17, left: 20, bottom: 17, right: 29)
    }
    
    let commentSendButton = UIButton().then {
        $0.backgroundColor = UIColor(hex: 0xFE5F51)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.setDimensions(width: 36, height: 26)
        $0.setImage(.arrowUpWhite, for: .normal)
    }
    
    private lazy var rightContainerView = UIView().then {
        let container = UIStackView(arrangedSubviews: [commentSendButton])
        container.axis = .horizontal
        container.alignment = .center
        container.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 3)
        container.isLayoutMarginsRelativeArrangement = true
        
        $0.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        $0.frame = CGRect(x: 0, y: 0, width: 36 + 3, height: .zero)
    }
    
    lazy var commentTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "승렬님을 위해서 댓글 달기",
            attributes: [
                .foregroundColor : UIColor(hex: 0x8C8C8C),
                .font : GLFont.regular14.font
            ]
        )
        $0.font = GLFont.regular14.font
        $0.textColor = .black
        $0.layer.borderWidth = 1.25
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor(hex: 0x8C8C8C).cgColor
        $0.leftView = UIView(frame: .init(x: .zero, y: .zero, width: 15, height: .zero))
        $0.leftViewMode = .always
        $0.setHeight(32)
        $0.rightView = rightContainerView
        $0.rightViewMode = .always
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.backgroundColor = .gray
        $0.setDimensions(width: 40, height: 40)
        $0.layer.cornerRadius = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        [profileImageView, commentTextField].forEach { containerStackView.addArrangedSubview($0) }
    }
}
