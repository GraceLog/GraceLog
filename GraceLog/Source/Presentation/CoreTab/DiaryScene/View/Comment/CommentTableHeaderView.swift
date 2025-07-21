//
//  CommentTableHeaderView.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class CommentTableHeaderView: UITableViewHeaderFooterView {
    static let identifier = String(describing: CommentTableHeaderView.self)
    var disposeBag = DisposeBag()

    let commentInfoView = CommentInfoView()
    let replyButton = UIButton().then {
        $0.setTitle("답장하기", for: .normal)
        $0.setTitleColor(UIColor(hex: 0x8C8C8C), for: .normal)
        $0.titleLabel?.font = GLFont.bold12.font
        $0.contentHorizontalAlignment = .leading
    }
    let commentToggleButton = CommentToggleButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentInfoView.configureUI(profileImageURL: nil, authorName: nil, editedDate: nil, comment: nil)
        disposeBag = DisposeBag()
    }
    
    private func configureUI() {
        [commentInfoView, replyButton, commentToggleButton].forEach { contentView.addSubview($0) }
        commentInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        
        replyButton.snp.makeConstraints {
            $0.top.equalTo(commentInfoView.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(75)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        commentToggleButton.snp.makeConstraints {
            $0.top.equalTo(replyButton.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(75)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
}

extension CommentTableHeaderView {
    func configureUI(
        profileImageURL: URL?,
        authorName: String,
        editedDate: String,
        comment: String
    ) {
        commentInfoView.configureUI(profileImageURL: profileImageURL, authorName: authorName, editedDate: editedDate, comment: comment)
    }
}
