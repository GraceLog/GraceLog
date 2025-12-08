//
//  VideoResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 12/7/25.
//

import Foundation

struct VideoResponseDTO: Decodable {
    let keywords: [String]
    let videoList: [YoutubeResponse]
    
    enum CodingKeys: String, CodingKey {
        case keywords
        case videoList = "youTubeResponses"
    }
}

struct YoutubeResponse: Decodable {
    let title: String
    let titleImageUrl: URL?
    let videoUrl: URL?
}
