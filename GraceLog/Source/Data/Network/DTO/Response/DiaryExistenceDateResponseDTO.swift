//
//  DiaryExistenceDatesResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 1/31/26.
//

import Foundation

struct DiaryExistenceDateResponseDTO: Decodable {
    let date: String
    let isExistPost: Bool
}
