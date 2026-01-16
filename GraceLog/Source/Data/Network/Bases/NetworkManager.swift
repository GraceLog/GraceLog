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
    
    init() {
        self.session = Session(
            configuration: .default,
            interceptor: GLInterceptor(),
            eventMonitors: [GLAPILogger()]
        )
    }
}

extension NetworkManager {
    func request<T: Decodable>(
        _ target: TargetType
    ) -> Single<T> {
        return .create { single in
            self.session.request(target)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GLResponseDTO<T>.self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = self.judgeStatus(
                            by: response.response?.statusCode ?? 0,
                            response: value
                        )
                        
                        switch result {
                        case .success(let data):
                            single(.success(data))
                        case .failure(let error):
                            single(.failure(error))
                        }
                        
                    case .failure(let afError):
                        let glError = self.convertToGLError(afError)
                        single(.failure(glError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func request(
        _ target: TargetType,
        images: [Data],
        bodyFieldName: String = "request",
        imageFieldName: String = "images"
    ) -> Single<Void> {
        return .create { single in
            self.session.upload(
                multipartFormData: { multipartFormData in
                    if case .body(let requestBody) = target.parameters,
                       let encodableRequest = requestBody {
                        let encoder = JSONEncoder()
                        encoder.dateEncodingStrategy = .iso8601
                        
                        if let jsonData = try? encoder.encode(encodableRequest) {
                            multipartFormData.append(
                                jsonData,
                                withName: bodyFieldName,
                                mimeType: "application/json"
                            )
                        }
                    }
                    
                    for (index, imageData) in images.enumerated() {
                        multipartFormData.append(
                            imageData,
                            withName: imageFieldName,
                            fileName: "image\(index).jpeg",
                            mimeType: "image/jpeg"
                        )
                    }
                },
                to: target.baseURL + target.path,
                method: target.method,
                headers: target.headers.httpHeaders
            )
            .responseDecodable(of: GLResponseDTO<GLEmptyResponse>.self) { response in
                switch response.result {
                case .success(let value):
                    let result = self.judgeStatus(
                        by: response.response?.statusCode ?? 0,
                        response: value
                    )
                    
                    switch result {
                    case .success:
                        single(.success(()))
                    case .failure(let error):
                        single(.failure(error))
                    }
                    
                case .failure(let afError):
                    let glError = self.convertToGLError(afError)
                    single(.failure(glError))
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func judgeStatus<T: Decodable>(
        by statusCode: Int,
        response: GLResponseDTO<T>
    ) -> Result<T, GLError> {
        
        switch statusCode {
        case 200..<300:
            if let data = response.data {
                return .success(data)
            } else {
                return .success(GLEmptyResponse() as! T)
            }
        case 400..<500:
            let code = response.code
            let errorMessage = response.message
            return .failure(.requestError(code: code, message: errorMessage))
            
        case 500..<600:
            return .failure(.serverError)
            
        default:
            return .failure(.unknownError)
        }
    }
    
    private func convertToGLError(_ afError: AFError) -> GLError {
        switch afError {
        case .sessionTaskFailed(let urlError as URLError) where urlError.code == .notConnectedToInternet:
            return .networkError
        case .responseSerializationFailed:
            return .decodedError
        default:
            return .afError(afError)
        }
    }
}
