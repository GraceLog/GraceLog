//
//  HomeCommunitySelectedSection.swift
//  GraceLog
//
//  Created by 이상준 on 6/28/25.
//

import RxDataSources
import UIKit

struct CommunityItem: Equatable {
    let id: Int
    let imageName: String
    let title: String
    var isSelected: Bool = false
   
    static func == (lhs: CommunityItem, rhs: CommunityItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct HomeCommunitySelectedSection {
    var items: [CommunityItem]
    
    init(items: [CommunityItem]) {
        self.items = items
    }
}

extension HomeCommunitySelectedSection: SectionModelType {
    init(original: HomeCommunitySelectedSection, items: [CommunityItem]) {
        self = original
        self.items = items
    }
}

extension HomeCommunitySelectedSection {
    static func makeSection(from communities: [CommunityItem], selectedId: Int?) -> HomeCommunitySelectedSection {
        let updatedItems = communities.map { community in
            CommunityItem(
                id: community.id,
                imageName: community.imageName,
                title: community.title,
                isSelected: community.id == selectedId
            )
        }
        return HomeCommunitySelectedSection(items: updatedItems)
    }
}
