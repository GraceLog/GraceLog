//
//  ProfileEditTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 4/15/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ProfileEditFieldView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = .gray200
    }
    
    let infoField = UITextField().then {
        $0.font = GLFont.semiBold16.font
        $0.textColor = .black
    }
    
    private let dividerView = UIView().then {
        $0.setHeight(1)
        $0.backgroundColor = .gray200
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabel, infoField, dividerView].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(23)
            $0.top.equalToSuperview().offset(26)
            $0.width.equalTo(50)
        }
        
        infoField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, placeholder: String) {
        titleLabel.text = title
        infoField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: UIColor.gray200,
            .font: GLFont.regular16.font
        ])
    }
}
