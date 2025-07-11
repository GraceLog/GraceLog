//
//  HomeCommunitySelectedSection.swift
//  GraceLog
//
//  Created by 이상준 on 6/28/25.
//

import RxDataSources
import UIKit

struct Community: Equatable {
    let id: Int
    let imageName: String
    let title: String
}

enum CommunityItem: Equatable {
    case community(Community)
    
    static func == (lhs: CommunityItem, rhs: CommunityItem) -> Bool {
        switch (lhs, rhs) {
        case (.community(let lhsModel), .community(let rhsModel)):
            return lhsModel.id == rhsModel.id
        }
    }
    
    var community: Community {
        switch self {
        case .community(let model):
            return model
        }
    }
}

enum HomeCommunityListSection: SectionModelType {
    case communitySection(items: [CommunityItem])
    
    var items: [CommunityItem] {
        switch self {
        case .communitySection(let items):
            return items
        }
    }
    
    init(original: HomeCommunityListSection, items: [CommunityItem]) {
        switch original {
        case .communitySection(_):
            self = .communitySection(items: items)
        }
    }
}
