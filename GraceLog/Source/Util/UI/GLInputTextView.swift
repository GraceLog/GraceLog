//
//  GLInputTextView.swift
//  GraceLog
//
//  Created by 이건준 on 6/18/25.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit
import Then

final class GLInputTextView: UIView {
    private let disposeBag = DisposeBag()
    
    private let title: String?
    private let maxLength: Int?
    private let placeholder: String?
    
    var text = PublishRelay<String>()
    var didEndEditing = PublishRelay<Void>()
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .themeColor
        $0.font = GLFont.bold14.font
    }
    
    lazy var textView = UITextView().then {
        $0.backgroundColor = .white
        $0.font = GLFont.regular14.font
        $0.textColor = .black
        $0.placeholderColor = .gray200
        $0.textContainerInset = UIEdgeInsets(top: 11, left: 15, bottom: 11, right: 15)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.layer.cornerRadius = 10
        $0.returnKeyType = .next
        $0.isScrollEnabled = true
        $0.delegate = self
        $0.setHeight(355)
    }
    
    private let textCountLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = .gray200
        $0.textAlignment = .center
    }
    
    init(
        title: String? = nil,
        placeholder: String? = nil,
        options: GLInputTextViewOption = [],
        maxLength: Int? = 500
    ) {
        self.title = title
        self.placeholder = placeholder
        self.maxLength = options.contains(.textCount) ? maxLength : nil
        super.init(frame: .zero)
        setupStyles(options: options)
        setupLayouts(options: options)
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles(options: GLInputTextViewOption) {
        titleLabel.text = title
        
        if let placeholder = placeholder {
            textView.placeholder = placeholder
        }
        
        if options.contains(.textCount) {
            updateWrittenCount(count: 0)
        }
    }
    
    private func setupLayouts(options: GLInputTextViewOption) {
        addSubview(containerStackView)
        
        if let _ = title {
            containerStackView.addArrangedSubview(titleLabel)
        }
        containerStackView.addArrangedSubview(textView)
        
        if options.contains(.textCount) {
            addSubview(textCountLabel)
            textCountLabel.snp.makeConstraints {
                $0.trailing.equalTo(textView.snp.trailing).offset(-15)
                $0.bottom.equalTo(textView.snp.bottom).offset(-11)
            }
        }
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func bind() {
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(with: self) { owner, inputText in
                owner.updateWrittenCount(count: inputText.count)
                owner.text.accept(inputText)
            }
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .bind(to: didEndEditing)
            .disposed(by: disposeBag)
    }
}

extension GLInputTextView {
    struct GLInputTextViewOption: OptionSet {
        let rawValue: UInt
        
        static let textCount = GLInputTextViewOption(rawValue: 1 << 0) // 글자수 세기
    }
    
    private func updateWrittenCount(
        count: Int,
        pointColor: UIColor = .gray200
    ) {
        let writtenCharacters = NSAttributedString(
            string: "\(count)",
            attributes: [.foregroundColor: pointColor]
        )
        
        let totalCharacters = NSAttributedString(
            string: "/\(maxLength ?? 0)",
            attributes: [.foregroundColor: UIColor.gray200]
        )
        
        textCountLabel.attributedText = NSMutableAttributedString(attributedString: writtenCharacters).then {
            $0.append(totalCharacters)
        }
    }
}

extension GLInputTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        return updatedText.count <= maxLength ?? 0
    }
}

