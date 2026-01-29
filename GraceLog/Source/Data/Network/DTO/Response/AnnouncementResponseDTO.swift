//
//  AnnouncementResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 1/21/26.
//

import Foundation

struct AnnouncementResponseDTO: Decodable {
    let id: Int
    let title: String
    let description: String
    let createdAt: String
}
