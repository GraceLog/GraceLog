//
//  GraceLogAuthenticator.swift
//  GraceLog
//
//  Created by 이상준 on 4/28/25.
//

import Foundation
import Alamofire
import RxSwift

class GLAuthenticator: Authenticator {
    typealias Credential = GLAuthenticationCredential
    private let disposeBag = DisposeBag()
    
    // MARK: - API요청 시 AuthenticatorIndicator객체가 존재하면, 요청 전에 가로채서 apply에서 Header에 bearerToken 추가
    func apply(_ credential: GLAuthenticationCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "refresh-token")
    }
    
    // MARK: API요청 후 error가 떨어진 경우, 401에러(인증에러)인 경우만 refresh가 되도록 필터링
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        return response.statusCode == 401
    }
    
    // MARK: 인증이 필요한 urlRequest에 대해서만 refresh가 되도록, 이 경우에만 true를 리턴하여 refresh 요청
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: GLAuthenticationCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
    
    func refresh(_ credential: GLAuthenticationCredential, for session: Alamofire.Session, completion: @escaping (Result<GLAuthenticationCredential, any Error>) -> Void) {
        let request = RefreshTokenRequestDTO(refreshToken: credential.refreshToken)
        
        NetworkManager()
            .request(
                AuthAPI.refresh(request)
            ).subscribe( onSuccess: { (data: SignInResponseDTO) in
                let newCredential = GLAuthenticationCredential(
                    accessToken: data.accessToken,
                    refreshToken: data.refreshToken,
                    expiredAt: Date(timeIntervalSinceNow: 60 * 120)
                )
                
                KeychainServiceImpl.shared.accessToken = data.accessToken
                KeychainServiceImpl.shared.refreshToken = data.refreshToken
                
                completion(.success(newCredential))
            }, onFailure: { _ in
                let error = APIError.doNotRetryWithError
                completion(.failure(error))
                AuthManager.shared.handleAuthenticationFailure()
            })
            .disposed(by: disposeBag)
    }
}
