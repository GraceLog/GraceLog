//
//  DiaryPostRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/6/25.
//

import Foundation

struct PostDiaryRequestDTO: Encodable {
    let title: String
    let description: String
    let keywordList: [String]
    let selectedCommunityIdList: [Int]
    let reserveTime: Date
    let isHideLike: Bool
    let isHideComment: Bool
}
