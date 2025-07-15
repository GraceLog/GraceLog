//
//  GraceLogResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 4/27/25.
//

import Foundation

struct GLResponseDTO<T: Decodable>: Decodable {
    let code: String
    let message: String
    let data: T?
}
