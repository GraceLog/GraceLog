//
//  MyInfoProfileViewController.swift
//  GraceLog
//
//  Created by 이상준 on 4/15/25.
//

import UIKit
import NVActivityIndicatorView
import ReactorKit
import Kingfisher

final class ProfileEditViewController: GraceLogBaseViewController, View {
    typealias Reactor = ProfileEditViewReactor
    
    var disposeBag = DisposeBag()
    
    private let navigationBar = GLNavigationBar().then {
        $0.backgroundColor = .white
        $0.setupTitleLabel(text: "프로필 편집")
    }
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "nav_chevron_left"), for: .normal)
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.themeColor, for: .normal)
        $0.titleLabel?.font = GLFont.regular16.font
    }
    
    private let profileImgView = UIImageView().then {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
    }
    
    private func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        [navigationBar, profileImgView, editButton, nicknameContainerView, nameContainerView, messageContainerView].forEach {
            view.addSubview($0)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        profileImgView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImgView)
        }
        
        nicknameContainerView.snp.makeConstraints {
            $0.top.equalTo(profileImgView.snp.bottom).offset(32)
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
        
        nicknameContainerView.configure(title: "닉네임", placeholder: "ex. Peter")
        nameContainerView.configure(title: "이름", placeholder: "ex. 베드로")
        messageContainerView.configure(title: "메시지", placeholder: "ex. 잠언 16:9")
    }
    
    private func setupNavBar() {
        navigationBar.addLeftItem(backButton)
        navigationBar.addRightItem(saveButton)
    }
    
    func bind(reactor: ProfileEditViewReactor) {
        // State
        reactor.pulse(\.$profileImage)
            .bind(to: profileImgView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$nickname)
            .distinctUntilChanged()
            .bind(to: nicknameContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$name)
            .distinctUntilChanged()
            .bind(to: nameContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$message)
            .distinctUntilChanged()
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
                // TODO: - 유저 업데이트 성공 여부에 따른 구현
                print("유저 업데이트 성공 여부 \(isSuccess)")
            })
            .disposed(by: disposeBag)
        
        // Action
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .map { Reactor.Action.didTapProfileImageEdit }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { Reactor.Action.didTapSaveButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nicknameContainerView.infoField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nameContainerView.infoField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        messageContainerView.infoField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateMessage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
