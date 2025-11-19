//
//  MyDiaryListRequestDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/6/25.
//

import Foundation

struct MyDiaryListRequestDTO: Encodable {
    let sortOrder: String
    let count: Int
}
