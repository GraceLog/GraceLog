//
//  GLInputFieldView.swift
//  GraceLog
//
//  Created by 이건준 on 6/18/25.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit
import Then

final class GLInputFieldView: UIView {
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
    
    lazy var textField = UITextField().then {
        $0.setHeight(40)
        $0.backgroundColor = UIColor(white: 1, alpha: 0.1)
        $0.font = GLFont.regular14.font
        $0.textColor = .black
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.delegate = self
    }
    
    private let textCountLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = .gray200
        $0.textAlignment = .center
    }
    
    init(
        title: String? = nil,
        placeholder: String? = nil,
        options: GLInputFieldViewOption = [],
        maxLength: Int? = 30
    ) {
        self.title = title
        self.placeholder = placeholder
        self.maxLength = options.contains(.textCount) ? maxLength : nil
        super.init(frame: .zero)
        setupStyles(options: options)
        setupLayouts()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles(options: GLInputFieldViewOption) {
        titleLabel.text = title
        
        if let placeholder = placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.gray200]
            )
        }
        
        if options.contains(.textCount) {
            textField.do {
                $0.setRightLabel(textCountLabel, rightPadding: 12)
                $0.rightViewMode = .always
            }
            updateWrittenCount(count: 0)
        }
    }
    
    private func setupLayouts() {
        addSubview(containerStackView)
        
        if let _ = title {
            containerStackView.addArrangedSubview(titleLabel)
        }
        containerStackView.addArrangedSubview(textField)
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func bind() {
        textField.rx.text.orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, inputText in
                owner.updateWrittenCount(count: inputText.count)
                owner.text.accept(inputText)
            }
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .bind(to: didEndEditing)
            .disposed(by: disposeBag)
    }
}

extension GLInputFieldView {
    struct GLInputFieldViewOption: OptionSet {
        let rawValue: UInt
        
        static let textCount = GLInputFieldViewOption(rawValue: 1 << 0) // 글자수 세기
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
        
        textField.setRightLabel(textCountLabel, rightPadding: 12)
    }
}

extension GLInputFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return updatedText.count <= maxLength ?? 0
    }
}
