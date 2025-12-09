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
                    title: responseDTO.title,
                    description: responseDTO.description,
                    user: GraceLogUser(
                        id: responseDTO.member.memberId,
                        name: responseDTO.member.name,
                        nickname: responseDTO.member.nickname,
                        profileImageURL: responseDTO.member.profileImage,
                        email: responseDTO.member.email,
                        message: responseDTO.member.message
                    ),
                    imageURLs: responseDTO.postImages.map { $0.url },
                    likeCount: responseDTO.likeCount,
                    likeByMe: responseDTO.likedByMe,
                    isHideLike: responseDTO.isHideLike,
                    isHideComment: responseDTO.isHideComment,
                    commentCount: responseDTO.commentCount,
                    createdAt: DateFormatterFactory.dateFromISO8601String(responseDTO.createdAt) ?? Date()
                )
            }
    }
    
    func fetchDateRangeDiaryList(startDate: Date, endDate: Date, communityId: Int, memberId: Int) -> Single<[DiaryDetails]> {
        let request = DateRangeDiaryListRequestDTO(startDate: startDate, endDate: endDate, communityId: communityId, memberId: memberId)
        
        return network.request(DiaryAPI.fetchDateRangeDiaryList(request))
            .map { (responseDTO: [DiaryResponseDTO]) in
                return responseDTO.map { diaryResponseDTO in
                    return DiaryDetails(
                        diaryId: diaryResponseDTO.postId,
                        title: diaryResponseDTO.title,
                        description: diaryResponseDTO.description,
                        user: GraceLogUser(
                            id: diaryResponseDTO.member.memberId,
                            name: diaryResponseDTO.member.name,
                            nickname: diaryResponseDTO.member.nickname,
                            profileImageURL: diaryResponseDTO.member.profileImage,
                            email: diaryResponseDTO.member.email,
                            message: diaryResponseDTO.member.message
                        ),
                        imageURLs: diaryResponseDTO.postImages.map { $0.url },
                        likeCount: diaryResponseDTO.likeCount,
                        likeByMe: diaryResponseDTO.likedByMe,
                        isHideLike: diaryResponseDTO.isHideLike,
                        isHideComment: diaryResponseDTO.isHideComment,
                        commentCount: diaryResponseDTO.commentCount,
                        createdAt: DateFormatterFactory.dateFromISO8601String(diaryResponseDTO.createdAt) ?? Date()
                    )
                }
            }
    }
    
    func postDiary(
        title: String,
        description: String,
        keywordList: [String],
        selectedCommunityIdList: [Int],
        reserveTime: Date,
        isHideLike: Bool,
        isHideComment: Bool,
        images: [Data]
    ) -> Single<Void> {
        let request = PostDiaryRequestDTO(
            title: title,
            description: description,
            keywordList: keywordList,
            selectedCommunityIdList: selectedCommunityIdList,
            reserveTime: reserveTime,
            isHideLike: isHideLike,
            isHideComment: isHideComment
        )
        
        let multipartFormData = MultipartFormData()
        
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(request) {
            multipartFormData.append(
                jsonData,
                withName: "createPostRequest",
                mimeType: "application/json"
            )
        }
        
        for (index, imageData) in images.enumerated() {
            multipartFormData.append(
                imageData,
                withName: "images",
                fileName: "image\(index).jpg",
                mimeType: "image/jpeg"
            )
        }
        
        return network.requestMultipart(DiaryAPI.postDiary(request), multipartFormData: multipartFormData)
    }
    
    func likeToggle(postId: Int) -> Single<Bool> {
        let request = LikeDiaryRequestDTO(postId: postId)
        
        return network.request(LikeAPI.likeToggle(request))
            .map { (responseDTO: GLResponseDTO<Bool>) in
                return responseDTO.data ?? false
            }
    }
}
