//
//  DefaultHomeRepository.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import Alamofire
import RxSwift

final class DefaultHomeRepository: HomeRepository {
    func fetchHomeMyContent() -> Single<HomeContent> {
        return .create { single in
            if let content = Bundle.main.decodeMockJSON(HomeContentDTO.self, from: "HomeMyData") {
                
                let diaryItems = content.diaryList.map { dto in
                    return MyDiaryItem(
                        date: dto.date,
                        dateDesc: dto.dateDesc,
                        title: dto.title,
                        desc: dto.desc,
                        tags: dto.tags,
                        image: UIImage(named: dto.imageName)
                    )
                }
                
                let videoItems = content.videoList.map { dto in
                    return HomeVideoItem(
                        title: dto.title,
                        imageName: dto.imageName
                    )
                }
                
                let homeContent = HomeContent(
                    diaryList: diaryItems,
                    videoList: videoItems
                )
                single(.success(homeContent))
            } else {
                single(.failure(NSError(domain: "com.gracelog.error", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to load HomeMyData.json"])))
            }
            return Disposables.create()
        }
    }
    
    func fetchHomeCommunityContent() -> Single<HomeCommunityContent> {
        return .create { single in
            if let content = Bundle.main.decodeMockJSON(HomeCommunityContentDTO.self, from: "HomeCommunityData") {
                let communityItems = content.communityList.map { dto in
                    return Community(
                        id: dto.id,
                        imageName: dto.imageName,
                        title: dto.title
                    )
                }
                
                let communityDiaries = content.diaryList.map { diaryDTO in
                    let diaryItems = diaryDTO.items.map { itemDTO in
                        return CommunityDiaryItem(
                            id: itemDTO.id,
                            type: CommunityDiaryItemType(rawValue: itemDTO.type) ?? .others,
                            username: itemDTO.username,
                            title: itemDTO.title,
                            subtitle: itemDTO.subtitle,
                            likes: itemDTO.likes,
                            comments: itemDTO.comments,
                            isLiked: itemDTO.isLike
                        )
                    }
                    
                    return CommunityDiary(date: diaryDTO.date, items: diaryItems)
                }
                
                let communityContent = HomeCommunityContent(
                    communityList: communityItems,
                    diaryList: communityDiaries
                )
                single(.success(communityContent))
            } else {
                single(.failure(NSError(domain: "com.gracelog.error", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to load HomeCommunityData.json"])))
            }
            return Disposables.create()
        }
    }
}
