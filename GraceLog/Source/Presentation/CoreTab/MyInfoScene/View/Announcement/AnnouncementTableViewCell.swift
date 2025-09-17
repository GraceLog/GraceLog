//
//  AnnouncementTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import UIKit
import SnapKit
import Then

final class AnnouncementTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AnnouncementTableViewCell.self)
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 14
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold14.font
        $0.textColor = GLColor.textMain.color
    }
    
    private let createdAtLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = GLColor.textSub.color
    }
    
    private let topStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 35
    }
    
    private let contentsLabel = UILabel().then {
        $0.font = GLFont.regular12.font
        $0.textColor = GLColor.textSub.color
        $0.numberOfLines = 2
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabel, createdAtLabel].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        [topStackView, contentsLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(14)
            $0.directionalHorizontalEdges.equalToSuperview().inset(30)
        }
    }
}

extension AnnouncementTableViewCell {
    func configureUI(
        title: String,
        createdAt: Date,
        contents: String
    ) {
        titleLabel.text = title
        createdAtLabel.text = DateformatterFactory.dateWithDot.string(from: createdAt)
        contentsLabel.text = contents
    }
}
