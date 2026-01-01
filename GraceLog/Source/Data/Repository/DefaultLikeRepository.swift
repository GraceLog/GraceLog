//
//  DefaultLikeRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/31/25.
//

import Foundation
import RxSwift

final class DefaultLikeRepository: LikeRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func likeToggle(postId: Int) -> Single<Bool> {
        let request = LikeDiaryRequestDTO(postId: postId)
        
        return network.request(LikeAPI.likeToggle(request))
            .map { (isLiked: Bool) in
                return isLiked
            }
    }
}
