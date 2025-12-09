//
//  CommunityDiaryListRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/19/25.
//

import Foundation

struct CommunityDiaryListRequestDTO: Encodable {
    let communityId: Int
    let cursorId: Int?
    let size: Int
}
