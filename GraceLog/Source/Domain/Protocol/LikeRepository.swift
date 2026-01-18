//
//  LikeRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/31/25.
//

import Foundation
import RxSwift

protocol LikeRepository {
    func likeToggle(postId: Int) -> Single<Bool>
}
