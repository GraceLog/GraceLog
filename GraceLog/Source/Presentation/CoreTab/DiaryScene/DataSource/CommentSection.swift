//
//  CommentSection.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import RxDataSources

struct CommentSection: AnimatableSectionModelType {
    var mainComment: CommentState
    var subComments: [CommentItem]
    
    var identity: String {
        return mainComment.item.identity
    }
    
    var items: [CommentItem] {
        return mainComment.isFolder ? [] : subComments
    }
    
    init(mainComment: CommentState, subComments: [CommentItem]) {
        self.mainComment = mainComment
        self.subComments = subComments
    }
    
    init(original: CommentSection, items: [CommentItem]) {
        self = original
        self.subComments = items
    }
}

struct CommentState {
    let item: CommentItem
    var isFolder: Bool
}

struct CommentItem {
    let id: Identity
    let comment: String
    let profileImageURL: URL?
    let authorName: String
    let editedDate: String
}

extension CommentItem: IdentifiableType, Equatable {
    var identity: String {
        return id
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
