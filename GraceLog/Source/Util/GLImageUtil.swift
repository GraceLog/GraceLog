//
//  GLImageUtil.swift
//  GraceLog
//
//  Created by 이상준 on 8/10/25.
//

import Alamofire
import RxSwift

final class GLImageUtil {
    static let shared = GLImageUtil()
    
    private init() {}
    
    func loadImageData(from url: URL) -> Single<Data> {
        return Single.create { single in
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
