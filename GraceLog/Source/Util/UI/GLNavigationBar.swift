//
//  GLNavigationBar.swift
//  GraceLog
//
//  Created by 이상준 on 6/16/25.
//

import UIKit
import SnapKit
import Then

final class GLNavigationBar: UIView {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    
    private let leftStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 10
    }
    
    private let rightStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .trailing
        $0.spacing = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(containerView)
        [leftStackView, titleLabel, rightStackView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupTitleLabel(
        text: String? = nil,
        color: UIColor = .black,
        font: UIFont = GLFont.bold16.font
    ) {
        titleLabel.text = text
        titleLabel.textColor = color
        titleLabel.font = font
        titleLabel.isHidden = text?.isEmpty ?? true
    }
    
    func addLeftItem(_ view: UIView) {
        leftStackView.addArrangedSubview(view)
    }
    
    func addRightItem(_ view: UIView) {
        rightStackView.addArrangedSubview(view)
    }
    
    func clearAllItems() {
        leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func clearLeftItems() {
        leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func clearRightItems() {
        rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
