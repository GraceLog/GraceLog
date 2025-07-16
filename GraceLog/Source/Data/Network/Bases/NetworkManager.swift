//
//  NetworkManager.swift
//  GraceLog
//
//  Created by 이상준 on 4/28/25.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    private let session: Session
    private let interceptor: AuthenticationInterceptor<GLAuthenticator>
    
    init() {
        var credential: GLAuthenticationCredential?
        
        if let accessToken = KeychainServiceImpl.shared.accessToken,
           let refreshToken = KeychainServiceImpl.shared.refreshToken {
            credential = GLAuthenticationCredential(
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiredAt: Date(timeIntervalSinceNow: 60 * 120)
            )
        }
        
        self.interceptor = AuthenticationInterceptor(
            authenticator: GLAuthenticator(),
            credential: credential
        )
        
        self.session = Session(interceptor: interceptor)
    }
}

extension NetworkManager {
    func request<T: Decodable>(
        _ target: TargetType
    ) -> Single<NetworkResult<T>> {
        return .create { single in
            self.session.request(target)
                .responseDecodable(of: GLResponseDTO<T>.self) { response in
                    switch response.result {
                    case .success(let glResponse):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.networkError))
                            return
                        }
                        
                        let result = self.judgeStatus(by: statusCode, response: glResponse)
                        single(.success(result))
                        
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    private func judgeStatus<T: Decodable>(
        by statusCode: Int,
        response: GLResponseDTO<T>
    ) -> NetworkResult<T> {
        
        switch statusCode {
        case 200..<300:
            if let data = response.data {
                return .success(data)
            } else {
                return .success(GLEmptyResponse() as! T)
            }
        case 400..<500:
            let errorMessage = response.message
            print("📱 클라이언트 에러 (\(statusCode)): \(errorMessage)")
            return .requestError(errorMessage)
            
        case 500..<600:
            let errorMessage = response.message
            print("🧑🏻‍💻 서버 에러 (\(statusCode)): \(errorMessage)")
            return .serverError
        default:
            print("📡 네트워크 오류")
            return .networkError
        }
    }
}
