//
//  CreateCommentRequestDTO.swift
//  GraceLog
//
//  Created by 이건준 on 1/29/26.
//

import Foundation

struct CreateCommentRequestDTO: Encodable {
    let content: String
    let parentId: Int
}
