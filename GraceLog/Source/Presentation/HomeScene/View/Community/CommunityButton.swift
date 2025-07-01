//
//  CommunityButton.swift
//  GraceLog
//
//  Created by 이상준 on 2/22/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class CommunityButton: UIView {
    var model: CommunityItem?
    
    let tapEvent = PublishSubject<CommunityItem>()
    private let disposeBag = DisposeBag()
    
    private let imageContainer = UIView().then {
        $0.layer.cornerRadius = 32
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.graceLightGray.cgColor
        $0.backgroundColor = .clear
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28
    }
    
    private let titleLabel = UILabel().then {
        $0.font = GLFont.regular11.font
        $0.textAlignment = .center
        $0.textColor = .graceGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        imageContainer.addSubview(imageView)
        
        let stackView = UIStackView(arrangedSubviews: [imageContainer, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageContainer.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(imageContainer)
        }
    }
    
    func configure(model: CommunityItem, image: UIImage?, title: String) {
        self.model = model
        imageView.image = image
        titleLabel.text = title
        setSelected(model.isSelected)
    }
    
    func setSelected(_ selected: Bool) {
        imageContainer.layer.borderColor = selected ? UIColor.themeColor.cgColor : UIColor.graceLightGray.cgColor
        titleLabel.textColor = selected ? UIColor.themeColor : UIColor.graceGray
    }
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if let model = owner.model {
                    owner.tapEvent.onNext(model)
                }
            })
            .disposed(by: disposeBag)
    }
}
