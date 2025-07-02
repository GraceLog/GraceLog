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

enum CommunityItem: IdentifiableType, Equatable {
    case community(Community, isSelected: Bool)
    
    var identity: Int {
        switch self {
        case .community(let model, _):
            return model.id
        }
    }
    
    static func == (lhs: CommunityItem, rhs: CommunityItem) -> Bool {
        switch (lhs, rhs) {
        case (.community(let lhsModel, let lhsSelected), .community(let rhsModel, let rhsSelected)):
            return lhsModel == rhsModel && lhsSelected == rhsSelected
        }
    }
    
    var community: Community {
        switch self {
        case .community(let model, _):
            return model
        }
    }
    
    var isSelected: Bool {
        switch self {
        case .community(_, let isSelected):
            return isSelected
        }
    }
}

enum HomeCommunityListSection: AnimatableSectionModelType {
    case communitySection(id: String = "community_section", items: [CommunityItem])
    
    var identity: String {
        switch self {
        case .communitySection(let id, _):
            return id
        }
    }
    
    var items: [CommunityItem] {
        switch self {
        case .communitySection(_, let items):
            return items
        }
    }
    
    init(original: HomeCommunityListSection, items: [CommunityItem]) {
        switch original {
        case .communitySection(let id, _):
            self = .communitySection(id: id, items: items)
        }
    }
}
