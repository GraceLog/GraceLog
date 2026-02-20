//
//  DiaryExistenceDatesRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 1/30/26.
//

import Foundation

struct DiaryExistenceDatesRequestDTO: Encodable {
    let startDate: String
    let endDate: String
    let communityId: Int?
    let memberId: Int?
    let cursorId: Int?
    let size: Int?
}
