//
//  FetchCommentListResponseDTO.swift
//  GraceLog
//
//  Created by 이건준 on 1/29/26.
//

import Foundation

struct FetchCommentListResponseDTO: Decodable {
    let id: Int
    let content: String
    let writer: Writer
    let parentId: Int
    let replies: [String]
    let replyCount: Int
    let createdAt: String
    let updatedAt: String
}

struct Writer: Decodable {
    let memberId: Int
    let email: String
    let name: String
    let nickname: String
    let profileImage: String
    let message: String
    let createdAt: String
    let updatedAt: String
}
