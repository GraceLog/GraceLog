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
            let userReportRepository = resolver.resolve(UserRepository.self)!
            
            return DefaultSignInUseCase(
                authRepository: authRepository,
                userRepository: userReportRepository
            )
        }
        
        // CoreTab
        // Home
        container.register(HomePersonalUseCase.self) { resolver in
            let dailyVerseRepository = resolver.resolve(DailyVerseRepository.self)!
            let diaryRepository = resolver.resolve(DiaryRepository.self)!
            let videoRepository = resolver.resolve(VideoRepository.self)!
            
            return DefaultHomePersonalUseCase(
                dailyVerseRepository: dailyVerseRepository,
                diaryRepository: diaryRepository,
                videoRepository: videoRepository
            )
        }
        
        container.register(HomeCommunityUseCase.self) { resolver in
            let diaryRepository = resolver.resolve(DiaryRepository.self)!
            let communityRepository = resolver.resolve(CommunityRepository.self)!
            let likeRepository = resolver.resolve(LikeRepository.self)!
            
            return DefaultHomeCommunityUseCase(
                diaryRepository: diaryRepository,
                communityRepository: communityRepository,
                likeRepository: likeRepository
            )
        }
        
        // Diary
        container.register(DiaryUseCase.self) { resolver in
            let communityRepository = resolver.resolve(CommunityRepository.self)!
            let diaryRepository = resolver.resolve(DiaryRepository.self)!
            
            return DefaultDiaryUseCase(
                communityRepository: communityRepository,
                diaryRepository: diaryRepository
            )
        }
        
        // DiaryDetails
        container.register(DiaryDetailsUseCase.self) { (resolver, diaryId: Int) in
            let diaryRepository = resolver.resolve(DiaryRepository.self)!
            let likeRepository = resolver.resolve(LikeRepository.self)!
            
            return DefaultDiaryDetailsUseCase(
                diaryRepository: diaryRepository,
                likeRepository: likeRepository,
                diaryId: diaryId
            )
        }
        
        // MyInfo
        container.register(MyInfoUseCase.self) { resolver in
            let userRepository = resolver.resolve(UserRepository.self)!
            return DefaultMyInfoUseCase(userRepository: userRepository)
        }
        
        container.register(AnnouncementListUseCase.self) { resolver in
            let announcementRepository = resolver.resolve(AnnouncementRepository.self)!
            return DefaultAnnouncementListUseCase(announcementRepository: announcementRepository)
        }
        
        container.register(AnnouncementDetailUseCase.self) { resolver, announcementId in
            let announcementRepository = resolver.resolve(AnnouncementRepository.self)!
            return DefaultAnnouncementDetailUseCase(
                announcementRepository: announcementRepository,
                announcementId: announcementId
            )
        }
    }
}
