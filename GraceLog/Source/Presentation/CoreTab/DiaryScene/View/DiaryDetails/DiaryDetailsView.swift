//
//  DiaryDetailsView.swift
//  GraceLog
//
//  Created by 이상준 on 6/8/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class DiaryDetailsView: UIView {
    private(set) var isExpanded = false
    private let collapsedLines = 3
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    private let gradientLayer = CAGradientLayer.darkOverlayGradient()
    
    private let optionView = UIImageView().then {
        $0.image = UIImage(named: "more")
        $0.setDimensions(width: 24, height: 24)
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private let categoryLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.regular14.font
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.extraBold24.font
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    lazy var descriptionLabel = VerticalAlignLabel().then {
        $0.textColor = .white
        $0.font = GLFont.regular14.font
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    let moreButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "chevron_down")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        config.baseForegroundColor = .white
        config.imagePlacement = .bottom
        config.imagePadding = 7
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        var attString = AttributedString("이어서 더보기")
        attString.font = GLFont.bold14.font
        config.attributedTitle = attString
        
        $0.configuration = config
        $0.tintColor = .white
        $0.isHidden = true
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 40
    }
    
    let likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "diary_heart")
        config.imagePlacement = .top
        config.imagePadding = 7
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = GLFont.semiBold14.font
            return outgoing
        }
        $0.configuration = config
        $0.tintColor = .white
    }
    
    let commentButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "diary_comment")
        config.imagePlacement = .top
        config.imagePadding = 7
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = GLFont.semiBold14.font
            return outgoing
        }
        $0.configuration = config
        $0.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    private func setupStyles() {
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    private func setupLayouts() {
        addSubview(backgroundImageView)
        backgroundImageView.layer.addSublayer(gradientLayer)
        [optionView, mainStackView].forEach { backgroundImageView.addSubview($0) }
        
        [likeButton, commentButton].forEach { bottomStackView.addArrangedSubview($0) }
        [
            categoryLabel,
            titleLabel,
            descriptionLabel,
            moreButton,
            bottomStackView
        ].forEach { mainStackView.addArrangedSubview($0) }
        
        mainStackView.setCustomSpacing(12, after: categoryLabel)
        mainStackView.setCustomSpacing(40, after: titleLabel)
        mainStackView.setCustomSpacing(24, after: descriptionLabel)
        mainStackView.setCustomSpacing(40, after: moreButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        optionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(17)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(optionView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(31)
            $0.trailing.equalToSuperview().inset(48)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.height.equalTo(47)
        }
    }
    
    private func updateGradientFrame() {
        gradientLayer.frame = backgroundImageView.bounds
    }
    
    func updateMoreButton(title: String, imageName: String) {
        var config = moreButton.configuration ?? UIButton.Configuration.plain()
        
        var attString = AttributedString(title)
        attString.font = GLFont.bold14.font
        config.attributedTitle = attString
        
        config.image = UIImage(named: imageName)?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        moreButton.configuration = config
    }
}

extension DiaryDetailsView {
    func configure(
        category: String,
        title: String,
        description: String,
        backgroundImageURL: URL?,
        isHideLike: Bool,
        isHideComment: Bool,
        isLiked: Bool,
        likeCount: Int,
        commentCount: Int
    ) {
        descriptionLabel.text = description
        moreButton.isHidden = descriptionLabel.currentNumberOfLines <= 3
        
        setExpanded(false)
        categoryLabel.text = category
        titleLabel.text = title
        
        backgroundImageView.kf.setImage(with: backgroundImageURL)
        
        let heartImage = isLiked ? UIImage(named: "diary_heart_selected") : UIImage(named: "diary_heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.setTitle("\(likeCount)", for: .normal)
        likeButton.tintColor = isLiked ? GLColor.textAccent.color : UIColor.white
        likeButton.isHidden = isHideLike
        
        commentButton.setTitle("\(commentCount)", for: .normal)
        commentButton.isHidden = isHideComment
    }
    
    func setExpanded(_ expanded: Bool) {
        isExpanded = expanded
        
        if !moreButton.isHidden {
            descriptionLabel.numberOfLines = expanded ? 0 : 3
        }
        
        updateMoreButton(
            title: expanded ? "접기" : "이어서 더보기",
            imageName: expanded ? "chevron_up" : "chevron_down"
        )
        UIView.animate(
            withDuration: 0.3,
            delay: 0.03,
            options: [.curveEaseInOut]
        ) { self.descriptionLabel.sizeToFit() }
    }
}
