//
//  DiaryTitleTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/25/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class DiaryTitleTableViewCell: UITableViewCell {
    static let identifier = "DiaryTitleTableViewCell"
    
    var reactor: DiaryViewReactor?
    var disposeBag = DisposeBag()
    
    private let maxLength = 30
    
    private let titleField = UITextField().then {
        $0.setHeight(40)
        $0.backgroundColor = UIColor(white: 1, alpha: 0.1)
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .black
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.attributedPlaceholder = NSAttributedString(string: "일기 제목", attributes: [.foregroundColor: UIColor.gray200])
    }
    
    private let countLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray200
        $0.text = "0/30"
        $0.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        titleField.delegate = self
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with reactor: DiaryViewReactor, title: String) {
        self.reactor = reactor
        
        titleField.text = title
        updateCount(text: title)
    }
    
    private func configureUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: titleField.frame.height))
        paddingView.addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(50)
        }
        
        titleField.rightView = countLabel
        titleField.rightViewMode = .always
        
        contentView.addSubview(titleField)
        titleField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(29)
            $0.bottom.equalToSuperview().inset(22)
        }
    }
    
    private func bind() {
        titleField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.updateCount(text: String(text.prefix(self.maxLength)))
            })
            .disposed(by: disposeBag)
        
        titleField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(titleField.rx.text.orEmpty)
            .map { String($0.prefix(self.maxLength)) }
            .subscribe(onNext: { [weak self] text in
                if let reactor = self?.reactor {
                    reactor.action.onNext(.updateTitle(text))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCount(text: String) {
        let count = min(text.count, maxLength)
        countLabel.text = "\(count)/\(maxLength)"
    }
}

extension DiaryTitleTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        if string.isEmpty {
            return true
        }

        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return updatedText.count <= maxLength
    }
}
