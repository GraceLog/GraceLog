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
    private let authenticatedSession: Session
    private let unauthenticatedSession: Session
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
        
        self.authenticatedSession = Session(interceptor: interceptor)
        self.unauthenticatedSession = Session.default
    }
}

extension NetworkManager {
    func request<T: Decodable>(
        _ target: TargetType
    ) -> Single<T> {
        return .create { single in
            let session = target.headers?.keys.contains(HTTPHeaderField.authenticationToken.rawValue) == true
            ? self.authenticatedSession
            : self.unauthenticatedSession
            
            session.request(target)
                .validate(statusCode: 200...500)
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
    
    private func handleResponse<T: Decodable>(_ response: DataResponse<GLResponseDTO<T>, AFError>) -> Result<T, APIError> {
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200..<300:
                break
            case 400..<500:
                let message = getErrorMessage(from: response) ?? "클라이언트 오류"
                return .failure(.clientError(statusCode: statusCode, message: message))
            case 500..<600:
                let message = getErrorMessage(from: response) ?? "서버 오류"
                return .failure(.serverError(statusCode: statusCode, message: message))
            default:
                return .failure(.unknown)
            }
        }
        
        switch response.result {
        case .success(let value):
            if let data = value.data {
                return .success(data)
            } else {
                return .failure(.network(message: value.message))
            }
        case .failure(let error):
            return .failure(handleAFError(error))
        }
    }
    
    private func getErrorMessage<T: Decodable>(from response: DataResponse<GLResponseDTO<T>, AFError>) -> String? {
        switch response.result {
        case .success(let value):
            return value.message
        case .failure:
            return nil
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
                    return .network(message: "인터넷 연결을 확인해주세요")
                case .timedOut:
                    return .network(message: "요청 시간이 초과되었습니다")
                default:
                    return .network(message: urlError.localizedDescription)
                }
            }
            return .unknown
        default:
            return .unknown
        }
    }
}
