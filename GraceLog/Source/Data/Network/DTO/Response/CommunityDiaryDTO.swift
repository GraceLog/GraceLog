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

struct CommunityDiaryItemDTO: Decodable {
    let id: Int
    let type: String
    let username: String
    let title: String
    let subtitle: String
    let likes: Int
    let comments: Int
}
