//
//  CommentTableViewCell.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import UIKit

import SnapKit
import Then

final class CommentTableViewCell: UITableViewCell {
    static let identifier = String(describing: CommentTableViewCell.self)
    
    private let commentInfoView = CommentInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentInfoView.configureUI(profileImageURL: nil, authorName: nil, editedDate: nil, comment: nil)
    }
    
    private func configureUI() {
        selectionStyle = .none
        
        contentView.addSubview(commentInfoView)
        commentInfoView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(75)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

extension CommentTableViewCell {
    func configureUI(
        profileImageURL: URL?,
        authorName: String,
        editedDate: String,
        comment: String
    ) {
        commentInfoView.configureUI(profileImageURL: profileImageURL, authorName: authorName, editedDate: editedDate, comment: comment)
    }
}
