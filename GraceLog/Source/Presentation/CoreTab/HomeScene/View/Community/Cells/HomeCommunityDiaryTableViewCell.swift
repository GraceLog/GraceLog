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
    
    var diaryType: CommunityDiaryItemType = .others {
        didSet {
            setupConstraints(diaryType: diaryType)
        }
    }
    
    let profileImgView = UIImageView().then {
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
    
    let diaryCardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
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
    
    private lazy var userStackView = UIStackView(arrangedSubviews: [profileImgView, usernameLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    
    private lazy var interactionStackView = UIStackView(arrangedSubviews: [likeButton, commentButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayouts()
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
    
    private func setupLayouts() {
        backgroundColor = .clear
        selectionStyle = .none
        
        [userStackView, diaryCardView, interactionStackView].forEach {
            contentView.addSubview($0)
        }
        
        [cardImageView, overlayView].forEach {
            diaryCardView.addSubview($0)
        }
        
        overlayView.addSubview(contentStackView)
    }
    
    private func setupConstraints(diaryType: CommunityDiaryItemType) {
        userStackView.snp.removeConstraints()
        diaryCardView.snp.removeConstraints()
        interactionStackView.snp.removeConstraints()
        
        switch diaryType {
        case .me:
            userStackView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.trailing.equalToSuperview().inset(20)
            }
            
            diaryCardView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.trailing.equalTo(userStackView.snp.leading).offset(-12)
                $0.leading.equalToSuperview().inset(21)
            }
            
            cardImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            overlayView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            contentStackView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(37)
                $0.leading.trailing.equalToSuperview().inset(25)
            }
            
            interactionStackView.snp.makeConstraints {
                $0.top.equalTo(diaryCardView.snp.bottom).offset(8)
                $0.trailing.equalTo(diaryCardView.snp.trailing).offset(-18)
                $0.bottom.equalToSuperview().inset(10)
            }
        case .others:
            userStackView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.leading.equalToSuperview().inset(20)
            }
            
            diaryCardView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.leading.equalTo(userStackView.snp.trailing).offset(12)
                $0.trailing.equalToSuperview().inset(20)
            }
            
            cardImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            overlayView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            contentStackView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(37)
                $0.leading.trailing.equalToSuperview().inset(25)
            }
            
            interactionStackView.snp.makeConstraints {
                $0.top.equalTo(diaryCardView.snp.bottom).offset(8)
                $0.leading.equalTo(diaryCardView.snp.leading).offset(23)
                $0.bottom.equalToSuperview().inset(10)
            }
        }
    }
    
    func updateUI(username: String, title: String, subtitle: String, likes: Int, comments: Int, isLiked: Bool) {
        setupConstraints(diaryType: diaryType)
        usernameLabel.text = username
        titleLabel.text = title
        contentLabel .text = subtitle
        likeButton.setTitle("\(likes)", for: .normal)
        commentButton.setTitle("\(comments)", for: .normal)
        
        let heartImage = isLiked ? UIImage(named: "home_heart_selected") : UIImage(named: "home_heart")
        likeButton.setImage(heartImage, for: .normal)
        
        cardImageView.image = UIImage(named: "diary2")
        profileImgView.image = UIImage(named: "profile")
    }
}
