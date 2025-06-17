//
//  DiaryDescriptionTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 3/26/25.
//

import UIKit
import Then
import SnapKit
import UITextView_Placeholder
import RxSwift
import RxCocoa
import ReactorKit

final class DiaryDescriptionTableViewCell: UITableViewCell {
    static let identifier = "DiaryDescriptionTableViewCell"
    
    private var reactor: DiaryViewReactor?
    var disposeBag = DisposeBag()
    
    private let descriptionTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.font = GLFont.regular14.font
        $0.textColor = .black
        $0.placeholder = "오늘은 하나님께 어떤 점이 감사했나요?"
        $0.placeholderColor = .gray200
        $0.textContainerInset = UIEdgeInsets(top: 11, left: 15, bottom: 11, right: 15)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.layer.cornerRadius = 10
        $0.returnKeyType = .next
        $0.isScrollEnabled = true
    }
    
    private let countLabel = UILabel().then {
        $0.font = GLFont.regular14.font
        $0.textColor = .gray200
        $0.text = "0/500"
        $0.textAlignment = .right
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        descriptionTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(0)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(descriptionTextView.snp.width).multipliedBy(355.0/334.0).priority(.high)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(descriptionTextView.snp.trailing).inset(9)
            $0.bottom.equalTo(descriptionTextView.snp.bottom).inset(13)
        }
    }
    
    func configure(with reactor: DiaryViewReactor, description: String) {
        self.reactor = reactor
        descriptionTextView.text = description
        updateCount(text: description)
    }
    
    private func updateCount(text: String) {
        let count = min(text.count, 500)
        countLabel.text = "\(count)/500"
    }
}

extension DiaryDescriptionTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return false }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.count > 500 {
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        if text.count > 500 {
            let index = text.index(text.startIndex, offsetBy: 500)
            textView.text = String(text[..<index])
        }
        
        updateCount(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let reactor = self.reactor {
            reactor.action.onNext(.updateDescription(textView.text))
        }
    }
}
