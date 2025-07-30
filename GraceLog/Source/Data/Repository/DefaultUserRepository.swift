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
                    profileImageURL: URL(string: responseDTO.profileImage ?? ""),
                    email: responseDTO.email,
                    message: responseDTO.message
                )
            }
    }
    
    // TODO: - Multipart Form Data로 호출하도록 수정
    func updateUser(
        name: String,
        nickname: String,
        profileImageURL: URL?,
        message: String
    ) -> Single<GraceLogUser> {
        let request = UpdateUserRequestDTO(
            name: name,
            nickname: nickname,
            profileImage: profileImageURL?.absoluteString,
            message: message
        )
        
        return network.request(UserAPI.updateUser(request))
            .map { (responseDTO: UserResponseDTO) in
                return GraceLogUser(
                    id: responseDTO.memberId,
                    name: responseDTO.name,
                    nickname: responseDTO.nickname,
                    profileImageURL: URL(string: responseDTO.profileImage ?? ""),
                    email: responseDTO.email,
                    message: responseDTO.message
                )
            }
    }
}
