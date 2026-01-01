//
//  DefaultCommunityRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/25.
//

import Foundation
import Alamofire
import RxSwift

final class DefaultCommunityRepository: CommunityRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchMyCommunityList() -> Single<[Community]> {
        return network.request(CommunityAPI.fetchMyCommunityList)
            .map { (responseDTO: [CommunityResponseDTO]) in
                return responseDTO.map { communityResponseDTO in
                    return Community(
                        id: communityResponseDTO.id,
                        name: communityResponseDTO.name,
                        logoImageURL: communityResponseDTO.imageURL
                    )
                }
            }
    }
}
