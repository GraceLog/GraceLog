//
//  GraceLogResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 4/27/25.
//

import Foundation

struct GraceLogResponseDTO<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T?
}
