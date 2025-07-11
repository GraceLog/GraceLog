//
//  HomeCommunitySelectedSection.swift
//  GraceLog
//
//  Created by 이상준 on 6/28/25.
//

import RxDataSources
import UIKit

struct CommunityItem {
    let id: Int
    let imageName: String
    let title: String
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
