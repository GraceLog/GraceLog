//
//  HomeCommunityDiarySection.swift
//  GraceLog
//
//  Created by 이상준 on 6/28/25.
//

import RxDataSources
import UIKit

struct CommunityDiary {
    let date: String
    var items: [CommunityDiaryItem]
}

struct CommunityDiaryItem {
    let id: String
    let isCurrentUser: Bool
    let username: String
    let title: String
    let content: String
    var likeCount: Int
    var commentCount: Int
    var isLiked: Bool
    let profileImageURL: URL?
    let cardImageURL: URL?
    
    init(from: Diary) {
        self.id = from.id
        self.isCurrentUser = from.isCurrentUser
        self.username = from.username
        self.title = from.title
        self.content = from.content
        self.likeCount = from.likeCount
        self.commentCount = from.commentCount
        self.isLiked = from.isLiked
        self.profileImageURL = from.profileImageURL
        self.cardImageURL = from.diaryImageURL
    }
}

struct HomeCommunityDiarySection {
    let date: String
    var items: [CommunityDiaryItem]
    
    init(date: String, items: [CommunityDiaryItem]) {
        self.date = date
        self.items = items
    }
}

extension HomeCommunityDiarySection: SectionModelType {
    init(original: HomeCommunityDiarySection, items: [CommunityDiaryItem]) {
        self = original
        self.items = items
    }
}
