//
//  VideoRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/31/25.
//

import Foundation
import RxSwift

protocol VideoRepository {
    func fetchVideoList() -> Single<VideoInfo>
}
