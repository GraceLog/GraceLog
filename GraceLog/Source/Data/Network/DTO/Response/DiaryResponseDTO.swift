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
    let numberOfElements: Int
    let sort: [String]
    let empty: Bool
    let pageable: Pageable
}

struct Pageable: Decodable {
    let unpaged: Bool
    let pageNumber: Int
    let offset: Int
    let pageSize: Int
    let sort: [String]
    let paged: Bool
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
    let url: String
    let fileName: String
}
