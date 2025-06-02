//
//  MyInfoProfileViewController.swift
//  GraceLog
//
//  Created by 이상준 on 4/15/25.
//

import UIKit
import SnapKit
import Then
import Toast_Swift
import NVActivityIndicatorView

import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileEditViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    typealias Reactor = ProfileEditViewReactor
    
    private let saveBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    private let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .black, padding: 0).then {
        $0.isHidden = true
    }
    
    private let profileImgView = UIImageView().then {
        $0.setDimensions(width: 112, height: 112)
        $0.layer.cornerRadius = 56
        $0.clipsToBounds = true
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
        configureUI()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        [profileImgView, editButton, nicknameContainerView, nameContainerView, messageContainerView].forEach {
            view.addSubview($0)
        }
        
        profileImgView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(27)
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
    
    func bind(reactor: ProfileEditViewReactor) {
        // State
        reactor.state
            .map { ($0.selectedImage, $0.profileImageURL) }
            .distinctUntilChanged { lhs, rhs in
                return lhs.0 === rhs.0 && lhs.1 == rhs.1
            }
            .bind(onNext: { [weak self] selectedImage, profileImageURL in
                if let selectedImage = selectedImage {
                    self?.profileImgView.image = selectedImage
                } else if !profileImageURL.isEmpty, let url = URL(string: profileImageURL) {
                    self?.profileImgView.sd_setImage(
                        with: url,
                        placeholderImage: UIImage(named: "profile")
                    )
                } else {
                    self?.profileImgView.image = UIImage(named: "profile")
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.nickname }
            .distinctUntilChanged()
            .bind(to: nicknameContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.name }
            .distinctUntilChanged()
            .bind(to: nameContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.message }
            .distinctUntilChanged()
            .bind(to: messageContainerView.infoField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .bind(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.error }
            .subscribe(onNext: { [weak self] error in
                self?.view.makeToast(error?.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.saveSuccess }
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.view.makeToast("프로필이 성공적으로 수정되었습니다")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    owner.reactor?.coordinator?.didFinishProfileEdit()
                }
            })
            .disposed(by: disposeBag)
        
        // Action
        reactor.action.onNext(.viewDidLoad)
        
        editButton.rx.tap
            .map { Reactor.Action.didTapProfileImageEdit }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveBarButtonItem.rx.tap
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
