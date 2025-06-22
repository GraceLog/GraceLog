//
//  DiarySwitchTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/26/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class DiaryShareTableViewCell: UITableViewCell {
    static let identifier = String(describing: DiaryShareTableViewCell.self)
    let disposeBag = DisposeBag()
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let logoImageView = UIImageView().then {
        $0.setDimensions(width: 40, height: 40)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = GLFont.regular16.font
    }
    
    let shareSwitchButton = UISwitch().then {
        $0.onTintColor = .themeColor
        $0.setDimensions(width: 51, height: 31)
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        titleLabel.text = nil
        shareSwitchButton.isOn = false
    }
    
    private func configureUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(containerStackView)
        [logoImageView, titleLabel, shareSwitchButton].forEach { containerStackView.addArrangedSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        containerStackView.setCustomSpacing(18, after: logoImageView)
    }
    
    func updateUI(imageNamed: String, title: String, isOn: Bool) {
        logoImageView.image = UIImage(named: imageNamed)
        titleLabel.text = title
        shareSwitchButton.isOn = isOn
    }
}
