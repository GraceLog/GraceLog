//
//  CommunityDiaryDTO.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation

struct CommunityDiaryDTO: Decodable {
    let date: String
    let items: [CommunityDiaryItemDTO]
}

enum CommunityDiaryItemType: String {
    case me = "me"
    case others = "others"
}

struct CommunityDiaryItemDTO: Decodable {
    let id: String
    let type: CommunityDiaryItemType.RawValue
    let username: String
    let title: String
    let subtitle: String
    let likes: Int
    let comments: Int
    let isLike: Bool
}
