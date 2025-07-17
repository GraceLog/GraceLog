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

final class GLInterceptor: RequestInterceptor {
    private let disposeBag = DisposeBag()
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode,
              !(200..<300).contains(statusCode)
        else {
            completion(.doNotRetry)
            return
        }
        
        guard statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
          }
        
        guard let refreshToken = KeychainServiceImpl.shared.refreshToken else { return }
        let request = RefreshTokenRequestDTO(refreshToken: refreshToken)
        NetworkManager()
            .request(AuthAPI.refresh(request))
            .subscribe(onSuccess: { (result: SignInResponseDTO) in
                KeychainServiceImpl.shared.accessToken = result.accessToken
                KeychainServiceImpl.shared.refreshToken = result.refreshToken
                
                completion(.retry)
            }, onFailure: { error in
                completion(.doNotRetryWithError(error))
            })
            .disposed(by: disposeBag)
    }
}
