//
//  MyInfoProfileViewController.swift
//  GraceLog
//
//  Created by 이상준 on 4/15/25.
//

import UIKit
import NVActivityIndicatorView
import ReactorKit

final class ProfileEditViewController: GraceLogBaseViewController<ProfileEditViewReactor> {
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left_theme"), for: .normal)
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.themeColor, for: .normal)
        $0.titleLabel?.font = GLFont.regular16.font
    }
    
    private let profileImageView = UIImageView().then {
        $0.setDimensions(width: 112, height: 112)
        $0.layer.cornerRadius = 56
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.init(hex: 0xF0F0F0)
    }
    
    private let editButton = UIButton().then {
        $0.setDimensions(width: 30, height: 30)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .graceLightGray
        $0.setImage(UIImage(named: "edit_camera"), for: .normal)
    }
    
    private let nicknameContainerView = ProfileEditFieldView()
    private let nameContainerView = ProfileEditFieldView()
    private let messageContainerView = ProfileEditFieldView()
    
    override func setupLayouts() {
        super.setupLayouts()
        [profileImageView, editButton, nicknameContainerView, nameContainerView, messageContainerView].forEach {
            contentView.addSubview($0)
        }
        
        navigationBar.addLeftItem(backButton)
        navigationBar.addRightItem(saveButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27)
            $0.centerX.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImageView)
        }
        
        nicknameContainerView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        nameContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        messageContainerView.snp.makeConstraints {
            $0.top.equalTo(nameContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupStyles() {
        super.setupStyles()
        navigationBar.setupTitleLabel(text: "프로필 편집")
        nicknameContainerView.configure(title: "닉네임", placeholder: "ex. Peter")
        nameContainerView.configure(title: "이름", placeholder: "ex. 베드로")
        messageContainerView.configure(title: "메시지", placeholder: "ex. 잠언 16:9")
    }
    
    override func bind(reactor: ProfileEditViewReactor) {
        super.bind(reactor: reactor)
        // State
        reactor.pulse(\.$profileImageData)
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, imageData in
                guard let data = imageData,
                      let profileImage = UIImage(data: data) else {
                    owner.profileImageView.image = UIImage(named: "profile")
                    return
                }
                owner.profileImageView.image = profileImage
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$nickname)
            .take(1)
            .bind(to: nicknameContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$name)
            .take(1)
            .bind(to: nameContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$message)
            .take(1)
            .bind(to: messageContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] error in
                self?.view.makeToast(error?.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSuccessUpdateUser)
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { owner, isSuccess in
                if isSuccess {
                    reactor.action.onNext(.executeProfileEdit)
                }
            })
            .disposed(by: disposeBag)
        
        // Action
        Observable.merge(
            backButton.rx.tap.map { Reactor.Action.didTapBackButton },
            editButton.rx.tap.map { Reactor.Action.didTapProfileImageEdit },
            saveButton.rx.tap
                .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                .map { Reactor.Action.didTapSaveButton }
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        Observable.merge(
            nicknameContainerView.infoField.rx.text.orEmpty
                .distinctUntilChanged()
                .map { Reactor.Action.updateNickname($0) },
            
            nameContainerView.infoField.rx.text.orEmpty
                .distinctUntilChanged()
                .map { Reactor.Action.updateName($0) },
            
            messageContainerView.infoField.rx.text.orEmpty
                .distinctUntilChanged()
                .map { Reactor.Action.updateMessage($0) }
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
    }
}
