//
//  Comment.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import Foundation

struct Comment {
    let id: String
    let authorName: String
    let createdAt: String
    let profileImageURL: URL?
    let comment: String
    let subComments: [Comment]
}
