//
//  DataAssembly.swift
//  GraceLog
//
//  Created by 이건준 on 7/12/25.
//

import Swinject

struct DataAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthRepository.self) { resolver in
            let authService = AuthService()
            return DefaultAuthRepository(authService: authService)
        }
        
        container.register(UserRepository.self) { resolver in
            let userService = UserService()
            return DefaultUserRepository(userService: userService)
        }
        
        container.register(HomeRepository.self) { resolver in
            return DefaultHomeRepository()
        }
    }
}
