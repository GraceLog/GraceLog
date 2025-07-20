//
//  CommentToggleButton.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import UIKit

import SnapKit
import Then

final class CommentToggleButton: UIControl {
    // MARK: - State
    enum State: Equatable {
        case folded(replyCount: Int)
        case unfolded
    }
    
    var currentState: State = .unfolded {
        didSet {
            updateUI(state: currentState)
        }
    }

    // MARK: - UI
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 9
    }
    
    private let textLabel = UILabel().then {
        $0.font = GLFont.bold12.font
        $0.textColor = UIColor(hex: 0x8C8C8C)
        $0.textAlignment = .left
    }
    
    private let underline = UIView().then {
        $0.backgroundColor = .black
        $0.setDimensions(width: 40, height: 0.5)
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(containerStackView)
        [underline, textLabel].forEach { containerStackView.addArrangedSubview($0) }
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func updateUI(state: State) {
        switch state {
        case .folded(let replyCount):
            textLabel.text = "\(replyCount)개의 답글 보기"
        case .unfolded:
            textLabel.text = "댓글 가리기"
        }
    }
}
