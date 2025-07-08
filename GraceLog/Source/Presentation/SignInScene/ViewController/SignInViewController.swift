//
//  LoginViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/28/24.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import Toast_Swift
import NVActivityIndicatorView

import GoogleSignIn
import RxSwift
import RxCocoa

import KakaoSDKAuth
import KakaoSDKUser

import CryptoKit
import AuthenticationServices

final class SignInViewController: UIViewController {
    var disposeBag = DisposeBag()
    fileprivate var currentNonce: String?
    
    private let sloganLabel = UILabel().then {
        $0.text = "감사가 채우는 하루"
        $0.textColor = .themeColor
        $0.font = GLFont.regular24.font
    }
    
    private let logoImgView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    private let startLabel = UILabel().then {
        $0.text = "시작하기"
        $0.textColor = .themeColor
        $0.font = GLFont.regular14.font
        $0.textAlignment = .center
        $0.setDimensions(width: 74, height: 38)
    }
    
    private let leftLine = UIView().then {
        $0.backgroundColor = .themeColor
        $0.setDimensions(width: 78, height: 1)
    }
    
    private let rightLine = UIView().then {
        $0.backgroundColor = .themeColor
        $0.setDimensions(width: 78, height: 1)
    }
    
    private lazy var appleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "apple"), for: .normal)
        $0.setDimensions(width: 60, height: 60)
    }
    
    private lazy var googleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "google"), for: .normal)
        $0.setDimensions(width: 60, height: 60)
    }
    
    private lazy var kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "kakao"), for: .normal)
        $0.setDimensions(width: 60, height: 60)
    }
    
    private let copyrightLabel = UILabel().then {
        $0.text = "Copyright Ⓒ 에끌레시아 All Rights Reserved."
        $0.textColor = .themeColor
        $0.font = GLFont.regular12.font
    }
    
    private let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .black, padding: 0).then {
        $0.isHidden = true
    }
    
    init(reactor: SignInReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.3,
            options: .curveEaseIn
        ) {
            [self.startLabel, self.leftLine, self.rightLine,
             self.appleLoginButton, self.googleLoginButton, self.kakaoLoginButton].forEach {
                $0.alpha = 1
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        let loginStack = UIStackView(arrangedSubviews: [appleLoginButton, googleLoginButton, kakaoLoginButton])
        loginStack.axis = .horizontal
        loginStack.distribution = .fillEqually
        loginStack.spacing = 27
        
        [sloganLabel, logoImgView, startLabel, leftLine, rightLine, loginStack, copyrightLabel, activityIndicator].forEach {
            view.addSubview($0)
        }
        
        logoImgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(163)
            $0.height.equalTo(142)
        }
        
        sloganLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(logoImgView.snp.top).offset(-27)
        }
        
        startLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(logoImgView.snp.bottom).offset(50)
        }
        
        leftLine.snp.makeConstraints {
            $0.centerY.equalTo(startLabel)
            $0.right.equalTo(startLabel.snp.left)
        }
        
        rightLine.snp.makeConstraints {
            $0.centerY.equalTo(startLabel)
            $0.left.equalTo(startLabel.snp.right)
        }
        
        
        loginStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(startLabel.snp.bottom).offset(16)
        }
        
        copyrightLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeArea).inset(20)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        [startLabel, leftLine, rightLine, appleLoginButton, googleLoginButton, kakaoLoginButton].forEach {
            $0.alpha = 0
        }
    }
}

extension SignInViewController: View {
    func bind(reactor: SignInReactor) {
        // Action
        googleLoginButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                
            }
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.handleAppleLogin()
            }
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.handleKakaoLogin()
            }
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.user }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] user in
                if let user = user {
                    print("받은 유저 정보: \(user)")
                }
            })
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
    }
}

extension SignInViewController {
    private func handleAppleLogin() {
        startSignInWithAppleFlow()
    }
    
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
}

extension SignInViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce else { return }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        reactor?.action.onNext(.appleLogin)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In failed: \(error.localizedDescription)")
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
