//
//  DefaultDiaryRepository.swift
//  GraceLog
//
//  Created by 이상준 on 11/8/25.
//

import Foundation
import Alamofire
import RxSwift

final class DefaultDiaryRepository: DiaryRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchDiary(diaryId: Int) -> Single<DiaryDetails> {
        return network.request(DiaryAPI.fetchDiary(diaryId: diaryId))
            .map { (responseDTO: DiaryResponseDTO) in
                return DiaryDetails(
                    diaryId: responseDTO.postId,
                    communityId: responseDTO.postCommunityId,
                    title: responseDTO.title,
                    description: responseDTO.description,
                    user: GraceLogUser(
                        id: responseDTO.member.memberId,
                        name: responseDTO.member.name,
                        nickname: responseDTO.member.nickname,
                        profileImageURL: URL(string: responseDTO.member.profileImage),
                        email: responseDTO.member.email,
                        message: responseDTO.member.message
                    ),
                    imageURLs: responseDTO.postImages.compactMap { URL(string: $0.url) },
                    likeCount: responseDTO.likeCount,
                    likeByMe: responseDTO.likedByMe,
                    isHideLike: responseDTO.isHideLike,
                    isHideComment: responseDTO.isHideComment,
                    commentCount: responseDTO.commentCount,
                    createdAt: DateFormatterFactory.dateTimeWithISO.date(from: responseDTO.createdAt)
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
                        editedDate: DateFormatterFactory.dateTimeWithISO.date(from: diaryResponseDTO.updatedAt),
                        title: diaryResponseDTO.title,
                        content: diaryResponseDTO.description,
                        imageURL: nil
                    )
                }
            }
    }
    
    
    func fetchDateRangeDiaryList(startDate: String, endDate: String, communityId: Int?, memberId: Int) -> Single<[DiaryDetails]> {
        let request = DateRangeDiaryListRequestDTO(startDate: startDate, endDate: endDate, communityId: communityId, memberId: memberId)
        
        return network.request(DiaryAPI.fetchDateRangeDiaryList(request))
            .map { (responseDTO: DiaryPagingResponseDTO) in
                return responseDTO.content.map { content in
                    return DiaryDetails(
                        diaryId: content.postId,
                        communityId: content.postCommunityId,
                        title: content.title,
                        description: content.description,
                        user: GraceLogUser(
                            id: content.member.memberId,
                            name: content.member.name,
                            nickname: content.member.nickname,
                            profileImageURL: URL(string: content.member.profileImage),
                            email: content.member.email,
                            message: content.member.message
                        ),
                        imageURLs: content.postImages.compactMap { URL(string: $0.url) },
                        likeCount: content.likeCount,
                        likeByMe: content.likedByMe,
                        isHideLike: content.isHideLike,
                        isHideComment: content.isHideComment,
                        commentCount: content.commentCount,
                        createdAt: DateFormatterFactory.dateTimeWithISO.date(from: content.createdAt)
                    )
                }
            }
    }
    
    func fetchCommunityDiaryList(communityId: Int, cursorId: Int?, size: Int) -> Single<CommunityDiaryPreViewInfo> {
        let request = CommunityDiaryListRequestDTO(
            communityId: communityId,
            cursorId: cursorId,
            size: size
        )
        
        return network.request(DiaryAPI.fetchCommunityDiaryList(request))
            .map { (responseDTO: DiaryPagingResponseDTO) in
                let diaryList = responseDTO.content.map { diaryResponseDTO in
                    return CommunityDiaryPreview(
                        id: diaryResponseDTO.postId,
                        title: diaryResponseDTO.title,
                        content: diaryResponseDTO.description,
                        editedDate: DateFormatterFactory.dateTimeWithISO.date(from: diaryResponseDTO.updatedAt),
                        isLiked: diaryResponseDTO.likedByMe,
                        likeCount: diaryResponseDTO.likeCount,
                        commentCount: diaryResponseDTO.commentCount,
                        username: diaryResponseDTO.member.name,
                        profileImageURL: URL(string: diaryResponseDTO.member.profileImage),
                        diaryImageURL: nil,
                        isCurrentUser: UserManager.shared.id == diaryResponseDTO.member.memberId
                    )
                }
                
                return CommunityDiaryPreViewInfo(
                    diaryList: diaryList,
                    isLastPage: responseDTO.last
                )
            }
    }
    
    func createDiary(
        images: [Data],
        title: String,
        description: String,
        keywordList: [String]?,
        selectedCommunityIdList: [Int]?,
        reserveTime: Date?,
        isHideLike: Bool,
        isHideComment: Bool
    ) -> Single<GLEmptyResponse> {
        let request = CreateDiaryRequestDTO(
            title: title,
            description: description,
            keywordList: keywordList,
            selectedCommunityIdList: selectedCommunityIdList,
            reserveTime: reserveTime,
            isHideLike: isHideLike,
            isHideComment: isHideComment
        )
        
        return network.request(
            DiaryAPI.createDiary(request),
            images: images,
            bodyFieldName: "createPostRequest",
            imageFieldName: "images"
        )
    }
    
    func deleteDiary(diaryId: Int) -> Single<Bool> {
        return network.request(DiaryAPI.deleteDiary(diaryId: diaryId))
            .map { (isDeleted: Bool) in
                return isDeleted
            }
    }
}
