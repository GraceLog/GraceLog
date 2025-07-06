//
//  HomeSection.swift
//  GraceLog
//
//  Created by 이상준 on 3/6/25.
//

import Foundation
import RxDataSources

enum HomeSection: Int, CaseIterable {
    case diary
    case contentList
}

enum CommunitySection: Int, CaseIterable {
    case community
}

typealias HomeDataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>

enum HomeSectionModel {
    case diary([MyDiaryItem])
    case contentList([HomeVideoItem])
    case communityButtons([CommunityItem])
    case communityPosts(String, [CommunityDiaryItem])
}

extension HomeSectionModel: SectionModelType {
    typealias Item = Any
    
    var items: [Item] {
        switch self {
        case .diary(let items):
            return [items]
        case .contentList(let items):
            return items
        case .communityButtons(let items):
            return [items]
        case .communityPosts(_, let items):
            return items
        }
    }
    
    init(original: HomeSectionModel, items: [Any]) {
        switch original {
        case .diary:
            self = .diary(items as? [MyDiaryItem] ?? [])
        case .contentList:
            self = .contentList(items as? [HomeVideoItem] ?? [])
        case .communityButtons:
            self = .communityButtons(items as? [CommunityItem] ?? [])
        case let .communityPosts(date, _):
            self = .communityPosts(date, items as? [CommunityDiaryItem] ?? [])
        }
    }
}

extension HomeSectionModel: Equatable {
    static func == (lhs: HomeSectionModel, rhs: HomeSectionModel) -> Bool {
        switch (lhs, rhs) {
        case (.diary(let lhsItems), .diary(let rhsItems)):
            return lhsItems.count == rhsItems.count
        case (.contentList(let lhsItems), .contentList(let rhsItems)):
            return lhsItems.count == rhsItems.count
        case (.communityButtons(let lhsItems), .communityButtons(let rhsItems)):
            return lhsItems.count == rhsItems.count
        case (.communityPosts(let lhsDate, let lhsItems), .communityPosts(let rhsDate, let rhsItems)):
            return lhsDate == rhsDate && lhsItems.count == rhsItems.count
        default:
            return false
        }
    }
}
