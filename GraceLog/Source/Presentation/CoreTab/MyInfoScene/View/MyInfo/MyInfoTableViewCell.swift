//
//  MyInfoTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class MyInfoTableViewCell: UITableViewCell {
    static let identifier = String(describing: MyInfoTableViewCell.self)
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let iconImageView = UIImageView().then {
        $0.setDimensions(width: 20, height: 20)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = GLFont.regular15.font
    }
    
    private let disclosureView = UIImageView().then {
        $0.setDimensions(width: 20, height: 20)
        $0.image = UIImage(named: "chevron_right")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyles()
        setupLayouts()
        setupConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 15))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    private func setupStyles() {
        backgroundColor = .white
        selectionStyle = .none
        separatorInset = .init(top: 0, left: 61, bottom: 0, right: 0)
    }
    
    private func setupLayouts() {
        contentView.addSubview(containerStackView)
        [iconImageView, titleLabel, disclosureView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstarints() {
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(20, after: iconImageView)
    }
    
    func updateUI(
        imageName: String,
        title: String
    ) {
        iconImageView.image = UIImage(named: imageName)
        titleLabel.text = title
    }
}
