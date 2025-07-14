//
//  DefaultAuthRepository.swift
//  GraceLog
//
//  Created by 이상준 on 4/27/25.
//

import Foundation
import RxSwift

final class DefaultAuthRepository: AuthRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func signIn(provider: SignInProvider, token: String) -> Single<SignInResult> {
        let request = SignInRequestDTO(provider: provider, token: token)
        
        return network.request(AuthAPI.signIn(request))
            .map { (responseDTO: SignInResponseDTO) in
                return SignInResult(
                    accessToken: responseDTO.accessToken,
                    refreshToken: responseDTO.refreshToken,
                    isExist: responseDTO.isExist
                )
            }
    }
    
    func refresh(refreshToken: String) -> Single<SignInResult> {
        let request = RefreshTokenRequestDTO(refreshToken: refreshToken)
        
        return network.request(AuthAPI.refresh(request))
            .map { (responseDTO: SignInResponseDTO) in
                return SignInResult(
                    accessToken: responseDTO.accessToken,
                    refreshToken: responseDTO.refreshToken,
                    isExist: responseDTO.isExist
                )
            }
    }
}
