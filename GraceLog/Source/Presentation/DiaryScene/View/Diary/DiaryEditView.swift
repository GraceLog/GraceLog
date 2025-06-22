//
//  DiaryEditView.swift
//  GraceLog
//
//  Created by 이건준 on 6/17/25.
//

import UIKit

import SnapKit
import Then

final class DiaryEditView: UIView {
    private let containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.spacing = 32
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 0, left: 30, bottom: 43, right: 30)
    }
    
    let titleInputView = GLInputFieldView(
        title: "제목",
        placeholder: "일기 제목",
        options: .textCount
    )
    
    let descriptionInputView = GLInputTextView(
        title: "본문",
        placeholder: "오늘은 하나님께 어떤 점이 감사했나요?",
        options: .textCount
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(containerStackView)
        [titleInputView, descriptionInputView].forEach { containerStackView.addArrangedSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
