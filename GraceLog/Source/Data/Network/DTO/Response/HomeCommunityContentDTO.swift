//
//  CommunityDTO.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation

struct HomeCommunityContentDTO: Decodable {
    let communityList: [CommunityItemDTO]
    let diaryList: [CommunityDiaryDTO]
}

struct CommunityItemDTO: Decodable {
    let id: Int
    let imageName: String
    let title: String
}
