//
//  HomeNavBarTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 2/8/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import SDWebImage

final class HomeNavBarTableViewHeader: UIView {
    let segmentTapped = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    private let userButton = UIButton().then {
        $0.titleLabel?.font = GLFont.bold18.font
        $0.setTitle("승렬", for: .normal)
        $0.setTitleColor(.themeColor, for: .normal)
    }
    
    private let userLineView = UIView().then {
        $0.backgroundColor = .themeColor
        $0.setHeight(2)
    }
    
    private let groupButton = UIButton().then {
        $0.titleLabel?.font = GLFont.bold18.font
        $0.setTitle("공동체", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private let groupLineView = UIView().then {
        $0.backgroundColor = .clear
        $0.setHeight(2)
    }
    
    private let bellButton = UIButton().then {
        $0.setImage(UIImage(named: "bell"), for: .normal)
        $0.tintColor = .black
        $0.setDimensions(width: 24, height: 24)
    }
    
    private let profileButton = UIButton().then {
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.setBackgroundImage(UIImage(named: "profile"), for: .normal)
        $0.setDimensions(width: 32, height: 32)
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
        backgroundColor = .white
        
        let userButtonStack = UIStackView(arrangedSubviews: [userButton, userLineView]).then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .center
        }
        
        let groupButtonStack = UIStackView(arrangedSubviews: [groupButton, groupLineView]).then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .center
        }
        
        let rightStack = UIStackView(arrangedSubviews: [bellButton, profileButton]).then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
        }
        
        let mainStack = UIStackView(arrangedSubviews: [userButtonStack, groupButtonStack]).then {
            $0.axis = .horizontal
            $0.spacing = 30
        }
        
        addSubview(mainStack)
        addSubview(rightStack)
        
        mainStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        userLineView.snp.makeConstraints {
            $0.width.equalTo(userButton).offset(24)
            $0.centerX.equalTo(userButton)
        }
        
        groupLineView.snp.makeConstraints {
            $0.width.equalTo(groupButton).offset(24)
            $0.centerX.equalTo(groupButton)
        }
        
        rightStack.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        bellButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
    
    func updateUser(user: GraceLogUser) {
        userButton.setTitle(user.name, for: .normal)
        
        if let imageUrl = URL(string: user.profileImage) {
            profileButton.sd_setBackgroundImage(with: imageUrl, for: .normal, placeholderImage: UIImage(named: "profile"))
        } else {
            profileButton.setBackgroundImage(UIImage(named: "profile"), for: .normal)
        }
    }
    
    private func bind() {
        userButton.rx.tap
            .map { true }
            .bind(to: segmentTapped)
            .disposed(by: disposeBag)
        
        groupButton.rx.tap
            .map { false }
            .bind(to: segmentTapped)
            .disposed(by: disposeBag)
        
        segmentTapped
            .subscribe(onNext: { [weak self] isUserSelected in
                self?.updateUI(isUserSelected: isUserSelected)
            })
            .disposed(by: disposeBag)
    }
    
    func updateUI(isUserSelected: Bool) {
        userLineView.backgroundColor = isUserSelected ? .themeColor : .clear
        groupLineView.backgroundColor = isUserSelected ? .clear : .themeColor
        
        userButton.setTitleColor(isUserSelected ? .themeColor : .black, for: .normal)
        groupButton.setTitleColor(isUserSelected ? .black : .themeColor, for: .normal)
    }
}
