//
//  DiaryResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/7/25.
//

import Foundation

struct DiaryResponseDTO: Decodable {
    let postId: Int
    let title: String
    let description: String
    let postImages: [DiaryImagesInfo]
    let isHideLike: Bool
    let isHideComment: Bool
    let reservationTime: Date
    let member: UserResponseDTO
    let postCommunityId: Int
    let keywords: [String]
    let likeCount: Int
    let likeByMe: Bool
    let commentCount: Int
    let createdAt: Date
    let updatedAt: Date
}

struct DiaryImagesInfo: Decodable {
    let id: Int
    let url: URL
    let fileName: String
}
