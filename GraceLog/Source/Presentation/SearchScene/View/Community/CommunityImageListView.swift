//
//  CommunityImageListView.swift
//  GraceLog
//
//  Created by 이건준 on 11/14/25.
//

import UIKit

import SnapKit
import Then

final class CommunityImageListView: UIView {
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 24, left: 30, bottom: 33, right: 30)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = GLColor.textAccent.color
        $0.textAlignment = .left
        $0.text = "프로필 사진"
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = GLColor.iconSub.color
        $0.textAlignment = .left
        $0.text = "프로필 사진은 그룹 프로필로 표시 됩니다."
    }
    
    let imageListView = DiaryImageListView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
        
        [titleLabel, descriptionLabel, imageListView].forEach { containerStackView.addArrangedSubview($0) }
        containerStackView.setCustomSpacing(10, after: descriptionLabel)
    }
}
