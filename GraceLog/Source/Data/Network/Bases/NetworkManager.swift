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
    static let shared = NetworkManager()
    
    let session: Session
    private let interceptor: AuthenticationInterceptor<GLAuthenticator>
    private let authenticator: GLAuthenticator
    
    private init() {
        self.authenticator = GLAuthenticator()
        
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
            authenticator: authenticator,
            credential: credential
        )
        
        self.session = Session(interceptor: interceptor)
    }
}

extension NetworkManager {
    //  MARK: - 인증이 필요없는 API
    func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: JSONEncoding = .default,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        return .create { single in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
            .responseDecodable(of: GLResponseDTO<T>.self) { response in
                let result = self.handleResponse(response)
                switch result {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - 인증이 필요한 API
    func authenticatedRequest<T: Decodable>(
        _ target: TargetType
    ) -> Single<T> {
        return .create { single in
            self.session.request(target).responseDecodable(of: GLResponseDTO<T>.self) { response in
                let result = self.handleResponse(response)
                switch result {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func handleResponse<T: Decodable>(_ response: DataResponse<GLResponseDTO<T>, AFError>) -> Result<T, APIError> {
        switch response.result {
        case .success(let value):
            if value.code == 200 {
                if let data = value.data {
                    return .success(data)
                } else {
                    return .failure(.decodingError)
                }
            } else {
                return .failure(.network(statusCode: value.code, message: value.message))
            }
        case .failure(let error):
            return .failure(handleAFError(error))
        }
    }
    
    private func handleAFError(_ error: AFError) -> APIError {
        switch error {
        case .responseSerializationFailed:
            return .decodingError
        case .sessionTaskFailed(let sessionError):
            if let urlError = sessionError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    return .network(statusCode: -1, message: "인터넷 연결을 확인해주세요")
                case .timedOut:
                    return .network(statusCode: -2, message: "요청 시간이 초과되었습니다")
                default:
                    return .network(statusCode: urlError.errorCode, message: urlError.localizedDescription)
                }
            }
            return .unknown
        default:
            return .unknown
        }
    }
}
