//
//  CommunityDiaryPreview.swift
//  GraceLog
//
//  Created by 이상준 on 11/21/25.
//

import Foundation

struct CommunityDiaryPreview {
    let id: Int
    let title: String
    let content: String
    let editedDate: Date
    let isLiked: Bool
    let likeCount: Int
    let commentCount: Int
    let username: String
    let profileImageURL: URL?
    let diaryImageURL: URL?
    let isCurrentUser: Bool
}
