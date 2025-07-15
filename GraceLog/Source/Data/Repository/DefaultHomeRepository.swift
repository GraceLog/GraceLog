//
//  DefaultHomeRepository.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import Alamofire
import RxSwift

final class DefaultHomeRepository: HomeRepository {
    func fetchHomeMyContent() -> Single<Void> {
        return .never()
    }
    
    func fetchHomeCommunityContent() -> Single<HomeCommunityContent> {
        return .never()
    }
}
