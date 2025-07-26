//
//  DefaultFireStoreRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/30/24.
//

import Foundation
import RxSwift

final class DefaultUserRepository: UserRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchUser() -> Single<GraceLogUser> {
        return network.request(UserAPI.fetchUser)
            .map { (responseDTO: UserResponseDTO) in
                return GraceLogUser(
                    id: responseDTO.memberId,
                    name: responseDTO.name,
                    nickname: responseDTO.nickname,
                    profileImage: responseDTO.profileImage,
                    email: responseDTO.email,
                    message: responseDTO.message
                )
            }
    }
    
    func updateUser(name: String, nickname: String, profileImage: URL?, message: String) -> Single<GraceLogUser> {
        let request = UpdateUserRequestDTO(
            name: name,
            nickname: nickname,
            profileImage: profileImage,
            message: message
        )
        
        return network.request(UserAPI.updateUser(request))
            .map { (responseDTO: UserResponseDTO) in
                return GraceLogUser(
                    id: responseDTO.memberId,
                    name: responseDTO.name,
                    nickname: responseDTO.nickname,
                    profileImage: responseDTO.profileImage,
                    email: responseDTO.email,
                    message: responseDTO.message
                )
            }
    }
}
