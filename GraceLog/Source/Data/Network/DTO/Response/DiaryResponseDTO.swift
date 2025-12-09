//
//  DiaryResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/7/25.
//

import Foundation

struct DiaryPagingResponseDTO: Decodable {
    let content: [DiaryResponseDTO]
    let size: Int
    let first: Bool
    let last: Bool
}

struct DiaryResponseDTO: Decodable {
    let postId: Int
    let title: String
    let description: String
    let postImages: [DiaryImagesInfo]
    let isHideLike: Bool
    let isHideComment: Bool
    let reserveTime: String?
    let member: UserResponseDTO
    let postCommunityId: Int?
    let keywords: [String]
    let likeCount: Int
    let likedByMe: Bool
    let commentCount: Int
    let createdAt: String
    let updatedAt: String
}

struct DiaryImagesInfo: Decodable {
    let id: Int
    let url: URL
    let fileName: String
}
