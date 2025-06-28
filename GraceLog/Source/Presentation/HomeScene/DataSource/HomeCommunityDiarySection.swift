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

enum CommunityItemType: String {
    case regular
    case my
}

struct CommunityDiaryItem {
    let id: Int
    let type: CommunityItemType
    let username: String
    let title: String
    let subtitle: String
    var likes: Int
    var comments: Int
    var isLiked: Bool = false
}

enum HomeCommunityDiaryItem: Equatable {
    case diary(CommunityDiaryItem)
    case dateHeader(String)
    
    static func == (lhs: HomeCommunityDiaryItem, rhs: HomeCommunityDiaryItem) -> Bool {
        switch (lhs, rhs) {
        case (.diary(let lhsItem), .diary(let rhsItem)):
            return lhsItem.username == rhsItem.username &&
                   lhsItem.title == rhsItem.title &&
                   lhsItem.subtitle == rhsItem.subtitle
        case (.dateHeader(let lhsDate), .dateHeader(let rhsDate)):
            return lhsDate == rhsDate
        default:
            return false
        }
    }
    
    var diaryItem: CommunityDiaryItem? {
        switch self {
        case .diary(let item): return item
        case .dateHeader: return nil
        }
    }
    
    var dateHeader: String? {
        switch self {
        case .diary: return nil
        case .dateHeader(let date): return date
        }
    }
}

struct HomeCommunityDiarySection {
    let date: String
    var items: [HomeCommunityDiaryItem]
    
    init(date: String, items: [HomeCommunityDiaryItem]) {
        self.date = date
        self.items = items
    }
}

extension HomeCommunityDiarySection: SectionModelType {
    init(original: HomeCommunityDiarySection, items: [HomeCommunityDiaryItem]) {
        self = original
        self.items = items
    }
}

extension HomeCommunityDiarySection {
    static func makeSections(from diaryList: [CommunityDiary]) -> [HomeCommunityDiarySection] {
        return diaryList.map { diary in
            let items = diary.items.map { HomeCommunityDiaryItem.diary($0) }
            return HomeCommunityDiarySection(date: diary.date, items: items)
        }
    }
}
