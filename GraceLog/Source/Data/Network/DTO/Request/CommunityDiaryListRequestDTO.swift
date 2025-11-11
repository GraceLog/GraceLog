//
//  ComunityDiaryListRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/6/25.
//

import Foundation

struct CommunityDiaryListRequestDTO: Encodable {
    let startDate: Date
    let endDate: Date
    let communityId: Int
}
