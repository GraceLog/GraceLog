//
//  CommunityDiaryPreview.swift
//  GraceLog
//
//  Created by 이상준 on 11/21/25.
//

import Foundation

struct CommunityDiaryPreViewInfo {
    let diaryList: [CommunityDiaryPreview]
    let isLastPage: Bool
}

struct CommunityDiaryPreview {
    let id: Int
    let title: String
    let content: String
    let editedDate: Date?
    var isLiked: Bool
    var likeCount: Int
    let commentCount: Int
    let userId: Int
    let username: String
    let profileImageURL: URL?
    let diaryImageURL: URL?
    let isCurrentUser: Bool
    let communityId: Int?
}
