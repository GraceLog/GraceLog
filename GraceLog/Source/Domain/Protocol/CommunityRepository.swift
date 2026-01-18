//
//  CommunityRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/25.
//

import Foundation
import RxSwift

protocol CommunityRepository {
    func fetchMyCommunityList() -> Single<[Community]>
}
