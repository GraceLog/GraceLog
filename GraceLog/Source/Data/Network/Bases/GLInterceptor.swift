//
//  GLInterceptor.swift
//  GraceLog
//
//  Created by 이상준 on 7/17/25.
//

import Foundation

import Alamofire
import RxSwift
import CryptoKit

final class GLInterceptor: RequestInterceptor, @unchecked Sendable {
    private let disposeBag = DisposeBag()
    
    private let retryLimit = 3
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsForRetry: [(RetryResult) -> Void] = []
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        guard request.retryCount < retryLimit else { return completion(.doNotRetryWithError(error)) }
        
        requestsForRetry.append(completion)
        
        guard let refreshToken = TokenManager.shared.refreshToken else { return }
        let request = RefreshTokenRequestDTO(refreshToken: refreshToken)
        
        if !isRefreshing {
            isRefreshing = true
            
            NetworkManager()
                .request(AuthAPI.refresh(request))
                .subscribe(onSuccess: { (result: SignInResponseDTO) in
                    self.lock.lock()
                    defer {
                        self.lock.unlock()
                        self.isRefreshing = false
                        self.requestsForRetry.removeAll()
                    }
                    
                    TokenManager.shared.accessToken = result.accessToken
                    TokenManager.shared.refreshToken = result.refreshToken
                    
                    completion(.retry)
                }, onFailure: { error in
                    self.lock.lock()
                    defer {
                        self.lock.unlock()
                        self.isRefreshing = false
                        self.requestsForRetry.removeAll()
                    }
                    
                    self.handleAuthenticationFailure()
                    completion(.doNotRetryWithError(error))
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func handleAuthenticationFailure() {
        TokenManager.shared.clearTokens()
        NotificationCenterManager.authenticationDidFail.post()
    }
}
