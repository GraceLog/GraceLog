//
//  DataAssembly.swift
//  GraceLog
//
//  Created by 이건준 on 7/12/25.
//

import Swinject

struct DataAssembly: Assembly {
    func assemble(container: Container) {
        let network = NetworkManager()
        
        container.register(AuthRepository.self) { resolver in
            return DefaultAuthRepository(network: network)
        }
        
        container.register(UserRepository.self) { resolver in
            return DefaultUserRepository(network: network)
        }
        
        container.register(HomeRepository.self) { resolver in
            return DefaultHomeRepository()
        }
    }
}
