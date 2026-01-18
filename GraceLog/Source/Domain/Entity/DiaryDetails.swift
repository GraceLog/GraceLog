//
//  DiaryDetails.swift
//  GraceLog
//
//  Created by 이상준 on 10/5/25.
//

import Foundation

struct DiaryDetails {
    let diaryId: Int
    let communityId: Int?
    let title: String
    let description: String
    let user: GraceLogUser
    let imageURLs: [URL?]
    var likeCount: Int
    var likeByMe: Bool
    let isHideLike: Bool
    let isHideComment: Bool
    let commentCount: Int
    let createdAt: Date?
}
