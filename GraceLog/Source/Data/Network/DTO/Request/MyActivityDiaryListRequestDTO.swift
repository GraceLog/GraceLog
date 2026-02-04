//
//  MyActivityDiaryListRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 1/30/26.
//

import Foundation

struct MyActivityDiaryListRequestDTO: Encodable {
    let cursorId: Int
    let size: Int
}
