//
//  DomainAssembly.swift
//  GraceLog
//
//  Created by 이건준 on 7/12/25.
//

import Swinject

struct DomainAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        // Auth
        container.register(SignInUseCase.self) { resolver in
            let authRepository = resolver.resolve(AuthRepository.self)!
            return DefaultSignInUseCase(authRepository: authRepository)
        }
        
        // CoreTab 
        // Home
        container.register(HomeUseCase.self) { resolver in
            let homeRepository = resolver.resolve(HomeRepository.self)!
            let userRepository = resolver.resolve(UserRepository.self)!
            return DefaultHomeUseCase(
                homeRepository: homeRepository,
                userRepository: userRepository
            )
        }
        
        container.register(HomeCommunityUseCase.self) { resolver in
            let homeRepository = resolver.resolve(HomeRepository.self)!
            return DefaultHomeCommunityUseCase(homeRepository: homeRepository)
        }
        
        // Diary
        container.register(DiaryUseCase.self) { resolver in
            return DefaultDiaryUseCase()
        }
        
        // MyInfo
        container.register(MyInfoUseCase.self) { resolver in
            let userRepository = resolver.resolve(UserRepository.self)!
            return DefaultMyInfoUseCase(userRepository: userRepository)
        }
    }
}
