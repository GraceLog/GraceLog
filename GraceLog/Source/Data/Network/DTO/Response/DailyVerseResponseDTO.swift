//
//  DailyVerseResponseDTO.swift
//  GraceLog
//
//  Created by 이상준 on 11/21/25.
//

import Foundation

struct DailyVerseResponseDTO: Decodable {
    let verseId: Int
    let book: String
    let chapter: String
    let verse: String
    let text: String
    let createdAt: String
    let updatedAt: String
}
