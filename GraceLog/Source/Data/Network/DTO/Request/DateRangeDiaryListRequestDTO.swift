//
//  ComunityDiaryListRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/6/25.
//

import Foundation

struct DateRangeDiaryListRequestDTO: Encodable {
    let startDate: Date
    let endDate: Date
    let communityId: Int
    let memberId: Int
}
