//
//  LoginViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/28/24.
//

import UIKit

import AuthenticationServices
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import NVActivityIndicatorView
import ReactorKit
import SnapKit
import Then

final class SignInViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 27
    }
    
    private let lineContainerView = UIView()
    
    private let sloganLabel = UILabel().then {
        $0.text = "감사가 채우는 하루"
        $0.textColor = .themeColor
        $0.font = GLFont.regular24.font
        $0.textAlignment = .center
    }
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let startLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "시작하기"
        $0.textColor = .themeColor
        $0.font = GLFont.regular14.font
        $0.textAlignment = .center
        $0.setDimensions(width: 74, height: 38)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .themeColor
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "apple"), for: .normal)
        $0.setDimensions(width: 60, height: 60)
    }
    
    private let googleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "google"), for: .normal)
        $0.setDimensions(width: 60, height: 60)
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "kakao"), for: .normal)
        $0.setDimensions(width: 60, height: 60)
    }
    
    private lazy var buttonStackView = UIStackView(
        arrangedSubviews: [appleLoginButton, googleLoginButton, kakaoLoginButton]
    ).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 27
        $0.alpha = 0
    }
    
    private let copyrightLabel = UILabel().then {
        $0.text = "Copyright Ⓒ 에끌레시아 All Rights Reserved."
        $0.textColor = .themeColor
        $0.font = GLFont.regular12.font
        $0.textAlignment = .center
    }
    
    private let activityIndicator = NVActivityIndicatorView(
        frame: .zero,
        type: .ballSpinFadeLoader,
        color: .black,
        padding: 0
    )
    
    init(reactor: SignInReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.3,
            options: .curveEaseIn
        ) {
            self.buttonStackView.alpha = 1
        }
    }
    
    private func setupStyles() {
        view.backgroundColor = .white
    }
    
    private func setupLayouts() {
        [sloganLabel, logoImageView, lineContainerView, buttonStackView].forEach { containerStackView.addArrangedSubview($0) }
        [containerStackView, copyrightLabel, activityIndicator].forEach { view.addSubview($0) }
        [lineView, startLabel].forEach { lineContainerView.addSubview($0) }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        containerStackView.snp.makeConstraints {
            $0.center.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        copyrightLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(containerStackView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeArea).offset(-20)
        }
        
        lineContainerView.snp.makeConstraints {
            $0.height.equalTo(38)
            $0.width.equalToSuperview()
        }
        
        startLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.directionalHorizontalEdges.equalToSuperview().inset(80)
            $0.centerY.equalTo(startLabel)
        }
        
        containerStackView.setCustomSpacing(18, after: lineContainerView)
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40)
        }
    }
}

extension SignInViewController: View {
    func bind(reactor: SignInReactor) {
        // Action
        googleLoginButton.rx.tap
            .throttle(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .bind(with: self) { owner, _ in
                owner.handleGoogleLogin()
            }
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .throttle(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .bind(with: self) { owner, _ in
                owner.handleAppleLogin()
            }
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .throttle(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .bind(with: self) { owner, _ in
                owner.handleKakaoLogin()
            }
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSuccessSignIn)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, isSuccess in
                if !isSuccess {
                    owner.view.makeToast("로그인에 실패했습니다, 다시 시도해주세요.")
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SignInViewController {
    // MARK: 애플 로그인 - https://developer.apple.com/documentation/AuthenticationServices/implementing-user-authentication-with-sign-in-with-apple
    private func handleAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: 카카오 로그인 - https://developers.kakao.com/docs/latest/ko/kakaologin/ios#login-with-kakao-talk-sample
    private func handleKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("카카오톡 로그인 에러: \(error)")
                    return
                }
                
                guard let token = oauthToken?.accessToken else {
                    print("카카오 액세스 토큰을 가져오지 못했습니다")
                    return
                }
                
                self?.reactor?.action.onNext(.kakaoLogin(token: token))
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print("카카오 계정 로그인 에러: \(error)")
                    return
                }
                
                guard let token = oauthToken?.accessToken else {
                    print("카카오 액세스 토큰을 가져오지 못했습니다")
                    return
                }
                self?.reactor?.action.onNext(.kakaoLogin(token: token))
            }
        }
    }
    
    // MARK: 구글 로그인 - https://developers.google.com/identity/sign-in/ios/backend-auth?hl=ko
    private func handleGoogleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            signInResult.user.refreshTokensIfNeeded { [weak self] user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                
                guard let token = user.idToken?.tokenString else {
                    print("구글 토큰을 가져오지 못했습니다.")
                    return
                }
                
                self?.reactor?.action.onNext(.googleLogin(token: token))
            }
        }
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let identityToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: identityToken, encoding: .utf8) else {
                print("애플 토큰을 가져오지 못했습니다")
                return
            }
            reactor?.action.onNext(.appleLogin(token: idTokenString))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패: \(error.localizedDescription)")
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

