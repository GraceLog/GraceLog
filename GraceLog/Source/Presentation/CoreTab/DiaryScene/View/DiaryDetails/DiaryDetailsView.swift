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
    private var isExpanded = false
    
    private var contentTextViewHeightConstraint: Constraint?
    private let collapsedLines = 10
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(named: "diary1")
    }
    
    private let gradientLayer = CAGradientLayer()
    
    private let contentView = UIView()
    
    private let categoryLabel = UILabel().then {
        $0.text = "오늘의 감사일기"
        $0.textColor = .white
        $0.font = GLFont.regular14.font
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = GLFont.extraBold24.font
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private let descriptionTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.font = GLFont.regular14.font
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 19)
        $0.verticalScrollIndicatorInsets = .zero
    }
    
    let moreButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "chevron_down")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        config.title = "이어서 더보기"
        config.baseForegroundColor = .white
        config.imagePlacement = .bottom
        config.imagePadding = 7
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = GLFont.bold14.font
            return outgoing
        }
        $0.configuration = config
        $0.tintColor = .white
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 40
    }
    
    private let optionView = UIImageView().then {
        $0.image = UIImage(named: "diary_more")
        $0.setDimensions(width: 24, height: 24)
    }
    
    lazy var likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "diary_heart")
        config.title = "24"
        config.baseForegroundColor = .white
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
    
    lazy var commentButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "diary_comment")
        config.title = "9"
        config.baseForegroundColor = .white
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
        setupGradient()
        setupLayouts()
        setupConstraints()
        setupInitialCollapsedState()
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
        
        addSubview(contentView)
        contentView.addSubview(optionView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(bottomStackView)
        
        [likeButton, commentButton].forEach {
            bottomStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(descriptionTextView)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        optionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(17)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(31)
            $0.trailing.equalToSuperview().inset(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(31)
            $0.trailing.equalToSuperview().inset(48)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(47)
            $0.bottom.equalToSuperview().inset(29)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.leading.equalToSuperview().inset(31)
            $0.trailing.equalToSuperview().inset(48)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-40)
        }
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.9).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    private func updateGradientFrame() {
        gradientLayer.frame = backgroundImageView.bounds
    }
    
    private func setupInitialCollapsedState() {
        applyCollapsedState()
    }
    
    private func applyCollapsedState() {
        let lineHeight = descriptionTextView.font?.lineHeight ?? 21
        let maxHeight = lineHeight * CGFloat(collapsedLines)
        
        descriptionTextView.snp.makeConstraints {
            contentTextViewHeightConstraint = $0.height.lessThanOrEqualTo(maxHeight).constraint
        }
    }
    
    private func checkMoreButtonVisibility() {
        guard !descriptionTextView.text.isEmpty else {
            moreButton.isHidden = true
            return
        }
        
        let lineHeight = descriptionTextView.font?.lineHeight ?? 21
        let maxHeight = lineHeight * CGFloat(collapsedLines)
        
        let textViewWidth = descriptionTextView.bounds.width
        
        let textSize = (descriptionTextView.text as NSString).boundingRect(
            with: CGSize(width: textViewWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: descriptionTextView.font ?? GLFont.regular14.font],
            context: nil
        )
        
        let actualHeight = ceil(textSize.height)
        moreButton.isHidden = actualHeight < maxHeight + 5
    }
    
    func toggleExpansion() {
        isExpanded.toggle()
        
        if isExpanded {
            contentTextViewHeightConstraint?.deactivate()
            
            var config = moreButton.configuration
            config?.title = "접기"
            config?.image = UIImage(named: "chevron_up")?.withTintColor(.white, renderingMode: .alwaysTemplate)
            moreButton.configuration = config
        } else {
            applyCollapsedState()
            
            var config = moreButton.configuration
            config?.title = "이어서 더보기"
            config?.image = UIImage(named: "chevron_down")?.withTintColor(.white, renderingMode: .alwaysTemplate)
            moreButton.configuration = config
        }
    }
}

extension DiaryDetailsView {
    func configure(
        title: String,
        description: String,
        backgroundImageURL: URL?,
        likeCount: Int,
        commentCount: Int
    ) {
        titleLabel.text = title
        descriptionTextView.text = description
        backgroundImageView.kf.setImage(with: backgroundImageURL)
        
        likeButton.setTitle("\(likeCount)", for: .normal)
        commentButton.setTitle("\(commentCount)", for: .normal)
        
        contentTextViewHeightConstraint?.activate()
        
        setNeedsLayout()
        layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.checkMoreButtonVisibility()
        }
    }
}
