//
//  DiaryDetails.swift
//  GraceLog
//
//  Created by 이상준 on 10/5/25.
//

import Foundation

struct DiaryDetails {
    let id: Int
    let title: String
    let description: String
    let authorId: Int
    let authorNickname: String
    let imageURLs: [URL?]
    let likeCount: Int
    let isLiked: Bool
    let isHideLike: Bool
    let isHideComment: Bool
    let commentCount: Int
    let createdAt: Date
}
