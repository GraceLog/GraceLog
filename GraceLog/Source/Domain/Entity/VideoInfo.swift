//
//  VideoInfo.swift
//  GraceLog
//
//  Created by 이상준 on 12/7/25.
//

import Foundation

struct VideoInfo {
    let tags: [String]
    let videoList: [RecommendedVideo]
}

struct RecommendedVideo {
    let title: String
    let imageURL: URL?
    let videoURL: URL?
}
