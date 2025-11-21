//
//  CommunityResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/19/25.
//

import Foundation

struct CommunityResponseDTO: Decodable {
    let id: Int
    let name: String
    let imageURL: URL
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "titleImage"
        case createdAt
        case updatedAt
    }
}
