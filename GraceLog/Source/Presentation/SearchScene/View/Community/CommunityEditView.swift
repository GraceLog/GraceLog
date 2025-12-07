//
//  CommunityEditView.swift
//  GraceLog
//
//  Created by 이건준 on 11/18/25.
//

import UIKit

import SnapKit
import Then

final class CommunityEditView: UIView {
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 24, left: 30, bottom: 35, right: 30)
    }
    
    let communityTitleEditView = GLInputFieldView(
        title: "공동체 이름",
        descriptionText: "공동체 이름은 개설 이후에도 변경할 수 있습니다.",
        placeholder: "제목을 입력해주세요",
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
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.addArrangedSubview(communityTitleEditView)
    }
}
