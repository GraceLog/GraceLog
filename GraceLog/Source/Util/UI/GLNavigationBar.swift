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
    
    private let leftStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private let rightStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private let titleLabel = UILabel()
    
    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title?.isEmpty ?? true
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var titleFont: UIFont = .systemFont(ofSize: 17) {
        didSet {
            titleLabel.font = titleFont
        }
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
        
        leftStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func updateLeftStackViewConstraints(leading: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil) {
        leftStackView.snp.updateConstraints {
            if let leading = leading {
                $0.leading.equalToSuperview().offset(leading)
            }
        }
        
        if let top = top, let bottom = bottom {
            leftStackView.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(leading ?? 0)
                $0.top.equalToSuperview().offset(top)
                $0.bottom.equalToSuperview().offset(bottom)
            }
        } else if let top = top {
            leftStackView.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(leading ?? 0)
                $0.top.equalToSuperview().offset(top)
            }
        } else if let bottom = bottom {
            leftStackView.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(leading ?? 0)
                $0.bottom.equalToSuperview().offset(bottom)
            }
        }
    }
    
    func updateRightStackViewConstraints(trailing: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil) {
        rightStackView.snp.updateConstraints {
            if let trailing = trailing {
                $0.trailing.equalToSuperview().offset(trailing)
            }
        }
        
        if let top = top, let bottom = bottom {
            rightStackView.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(trailing ?? 0)
                $0.top.equalToSuperview().offset(top)
                $0.bottom.equalToSuperview().offset(bottom)
            }
        } else if let top = top {
            rightStackView.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(trailing ?? 0)
                $0.top.equalToSuperview().offset(top)
            }
        } else if let bottom = bottom {
            rightStackView.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(trailing ?? 0)
                $0.bottom.equalToSuperview().offset(bottom)
            }
        }
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
