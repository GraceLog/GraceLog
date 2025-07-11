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

final class HomeCommunityDiaryTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: HomeCommunityDiaryTableViewCell.self)
    
    var disposeBag = DisposeBag()
    
    private let mainContainerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.backgroundColor = .clear
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: .zero, left: 20, bottom: .zero, right: 20)
        $0.spacing = 10
    }
    
    private let diaryContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let cardImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    // MARK: - User Info UI
    
    private lazy var userInfoContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let profileImageView = UIImageView().then {
        $0.setDimensions(width: 40, height: 40)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .graceLightGray
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = GLFont.bold12.font
        $0.textColor = .graceGray
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - Content UI
    
    private let overlayBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 18, left: 21, bottom: 18, right: 21)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.bold10.font
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let contentLabel = UILabel().then {
        $0.font = GLFont.regular18.font
        $0.textColor = .white
    }
    
    // MARK: - Action Button UI
    
    private let flexibleView = UIView()
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [likeButton, commentButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: .zero, left: 24, bottom: .zero, right: 24)
        $0.backgroundColor = .clear
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
        setupLayouts()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        cardImageView.image = nil
        usernameLabel.text = nil
        titleLabel.text = nil
        contentLabel.text = nil
        [userInfoContainerView, diaryContainerView].forEach { mainContainerStackView.removeArrangedSubview($0)
            $0.removeFromSuperview() }
        buttonStackView.removeArrangedSubview(flexibleView)
        flexibleView.removeFromSuperview()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: .init(top: .zero, left: .zero, bottom: 24, right: .zero))
    }
    
    private func setupLayouts() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(mainContainerStackView)
        
        [userInfoContainerView, diaryContainerView].forEach {
            mainContainerStackView.addArrangedSubview($0)
        }
        
        [profileImageView, usernameLabel].forEach {
            userInfoContainerView.addSubview($0)
        }
        
        [cardImageView, buttonStackView].forEach {
            diaryContainerView.addSubview($0)
        }
        
        [overlayBackgroundView, contentStackView].forEach { cardImageView.addSubview($0) }
    }
    
    private func setupConstraints() {
        mainContainerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        cardImageView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-6)
            $0.directionalHorizontalEdges.top.equalToSuperview()
        }
        
        overlayBackgroundView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func updateUI(
        username: String,
        title: String,
        content: String,
        likeCount: Int,
        commentCount: Int,
        isLiked: Bool,
        isCurrentUser: Bool,
        profileImageURL: URL?,
        cardImageURL: URL?
    ) {
        usernameLabel.text = username
        titleLabel.text = title
        contentLabel .text = content
        likeButton.setTitle("\(likeCount)", for: .normal)
        commentButton.setTitle("\(commentCount)", for: .normal)
        
        let heartImage = isLiked ? UIImage(named: "home_heart_selected") : UIImage(named: "home_heart")
        likeButton.setImage(heartImage, for: .normal)
        
        cardImageView.kf.setImage(with: cardImageURL)
        profileImageView.kf.setImage(with: profileImageURL, placeholder: UIImage(named: "profile"))
        
        adjustLayoutForCurrentUser(isCurrentUser)
    }
    
    private func adjustLayoutForCurrentUser(_ isCurrentUser: Bool) {
        let subviews = isCurrentUser ? [diaryContainerView, userInfoContainerView] : [userInfoContainerView, diaryContainerView]
        subviews.forEach { mainContainerStackView.addArrangedSubview($0) }
        
        if isCurrentUser {
            buttonStackView.addArrangedSubview(flexibleView)
        } else {
            buttonStackView.insertArrangedSubview(flexibleView, at: 0)
        }
    }

}
