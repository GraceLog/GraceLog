//
//  HomeCommunityMyTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 2/24/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeCommunityMyDiaryTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: HomeCommunityMyDiaryTableViewCell.self)
    
    var disposeBag = DisposeBag()
    
    private let profileImgView = UIImageView().then {
        $0.setDimensions(width: 40, height: 40)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .graceLightGray
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = GLFont.bold12.font
        $0.textColor = .graceGray
    }
    
    private let diaryCardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let cardImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let overlayView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold10.font
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let contentLabel = UILabel().then {
        $0.font = GLFont.regular18.font
        $0.textColor = .white
    }
    
    lazy var likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "home_heart")
        config.title = "4"
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = GLFont.bold14.font
            outgoing.foregroundColor = .gray100
            return outgoing
        }
        config.baseForegroundColor = .gray100
        $0.configuration = config
    }
    
    lazy var commentButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "comment")
        config.title = "4"
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = GLFont.bold14.font
            outgoing.foregroundColor = .gray
            return outgoing
        }
        config.baseForegroundColor = .gray100
        $0.configuration = config
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImgView.image = nil
        cardImageView.image = nil
        usernameLabel.text = nil
        titleLabel.text = nil
        contentLabel.text = nil
        
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let userStack = UIStackView(arrangedSubviews: [profileImgView, usernameLabel])
        userStack.axis = .vertical
        userStack.spacing = 4
        userStack.alignment = .center
        
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, contentLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 4
        contentStack.alignment = .leading
        
        let interactionStack = UIStackView(arrangedSubviews: [likeButton, commentButton])
        interactionStack.axis = .horizontal
        interactionStack.spacing = 10
        interactionStack.distribution = .fillEqually
        
        [userStack, diaryCardView, interactionStack].forEach {
            contentView.addSubview($0)
        }
        
        [cardImageView, overlayView].forEach {
            diaryCardView.addSubview($0)
        }
        
        overlayView.addSubview(contentStack)
        
        userStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        diaryCardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalTo(userStack.snp.leading).offset(-12)
            $0.leading.equalToSuperview().offset(21)
            $0.height.equalTo(diaryCardView.snp.width).multipliedBy(110.0/300.0)
        }
        
        cardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(37)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        interactionStack.snp.makeConstraints {
            $0.top.equalTo(diaryCardView.snp.bottom).offset(8)
            $0.trailing.equalTo(diaryCardView.snp.trailing).offset(-18)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func updateUI(title: String, subtitle: String, likes: Int, comments: Int, isLiked: Bool) {
        titleLabel.text = title
        contentLabel .text = subtitle
        likeButton.setTitle("\(likes)", for: .normal)
        commentButton.setTitle("\(comments)", for: .normal)
        
        let heartImage = isLiked ? UIImage(named: "home_heart_selected") : UIImage(named: "home_heart")
        var config = likeButton.configuration
        config?.image = heartImage
        likeButton.configuration = config
        
        cardImageView.image = UIImage(named: "diary2")
        profileImgView.image = UIImage(named: "profile")
        
        usernameLabel.text = "나"
    }
}
