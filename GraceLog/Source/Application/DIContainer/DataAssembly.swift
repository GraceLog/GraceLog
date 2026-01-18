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
        
        container.register(CommunityRepository.self) { resolver in
            return DefaultCommunityRepository(network: network)
        }
        
        container.register(DiaryRepository.self) { resolver in
            return DefaultDiaryRepository(network: network)
        }
        
        container.register(DailyVerseRepository.self) { resolver in
            return DefaultDailyVerseRepository(network: network)
        }
        
        container.register(VideoRepository.self) { resolver in
            return DefaultVideoRepository(network: network)
        }
        
        container.register(LikeRepository.self) { resolver in
            return DefaultLikeRepository(network: network)
        }
    }
}
