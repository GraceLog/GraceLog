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
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchDailyVerse() -> Single<DailyVerse> {
        return network.request(DailyVerseAPI.fetchDailyVerse)
            .map { (responseDTO: DailyVerseResponseDTO) in
                return DailyVerse(
                    content: responseDTO.text,
                    reference: "\(responseDTO.book) \(responseDTO.chapter):\(responseDTO.verse)"
                )
            }
    }
    
    func fetchMyDiaryList() -> Single<[MyDiaryPreview]> {
        let request = MyDiaryListRequestDTO(sortOrder: "DESC", count: 3)
        
        return network.request(DiaryAPI.fetchMyDiaryList(request))
            .map { (responseDTO: [DiaryResponseDTO]) in
                return responseDTO.map { diaryResponseDTO in
                    return MyDiaryPreview(
                        id: diaryResponseDTO.postId,
                        editedDate: DateFormatterFactory.dateFromServerString(diaryResponseDTO.updatedAt) ?? Date(),
                        title: diaryResponseDTO.title,
                        content: diaryResponseDTO.description,
                        imageURL: diaryResponseDTO.postImages.first?.url
                    )
                }
            }
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
    
    func fetchHomeCommunityDiaryList(
        communityId: Int,
        cursorId: Int?,
        size: Int
    ) -> Single<[CommunityDiaryPreview]> {
        let reqeust = CommunityDiaryListRequestDTO(
            communityId: communityId,
            cursorId: cursorId,
            size: size
        )
        
        return network.request(DiaryAPI.fetchCommunityDiaryList(reqeust))
            .map { (responseDTO: DiaryPagingResponseDTO) in
                return responseDTO.content.map { diaryResponseDTO in
                    return CommunityDiaryPreview(
                        id: diaryResponseDTO.postId,
                        title: diaryResponseDTO.title,
                        content: diaryResponseDTO.description,
                        editedDate: DateFormatterFactory.dateFromServerString(diaryResponseDTO.updatedAt) ?? Date(),
                        isLiked: diaryResponseDTO.likedByMe,
                        likeCount: diaryResponseDTO.likeCount,
                        commentCount: diaryResponseDTO.commentCount,
                        username: diaryResponseDTO.member.name,
                        profileImageURL: diaryResponseDTO.member.profileImage,
                        diaryImageURL: diaryResponseDTO.postImages.first?.url,
                        isCurrentUser: UserManager.shared.id == diaryResponseDTO.member.memberId
                    )
                }
            }
    }
    
    func likeToggle(postId: Int) -> Single<Bool> {
        let request = LikeDiaryRequestDTO(postId: postId)
        
        return network.request(LikeAPI.likeToggle(request))
            .map { (isLiked: Bool) in
                return isLiked
            }
    }
    
    func fetchVideoList() -> RxSwift.Single<VideoInfo> {
        return network.request(YoutubeAPI.fetchVideo)
            .map { (responseDTO: VideoResponseDTO) in
                return VideoInfo(
                    tags: responseDTO.keywords,
                    videoList: responseDTO.videoList.map { youtubeResponse in
                        RecommendedVideo(
                            title: youtubeResponse.title,
                            imageURL: youtubeResponse.titleImageUrl,
                            videoURL: youtubeResponse.videoUrl
                        )
                    }
                )
            }
    }
}
