//
//  SearchCommunitySection.swift
//  GraceLog
//
//  Created by 이건준 on 9/21/25.
//

import RxDataSources

enum SearchCommunityItem: IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        switch self {
        case .community(let community):
            return community.id
        case .chatting(let communityChatting):
            return communityChatting.id
        case .profile(let profileItem):
            return profileItem.id
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    case community(Community)
    case chatting(CommunityChatting)
    case profile(ProfileItem)
}

enum SearchCommunitySection: AnimatableSectionModelType {
    case primary(isSearching: Bool, items: [SearchCommunityItem])
    case secondary(isSearching: Bool, items: [SearchCommunityItem])
    
    typealias Item = SearchCommunityItem
    
    init(original: SearchCommunitySection, items: [Item]) {
        switch original {
        case let .primary(isSearching, _):
            self = .primary(isSearching: isSearching, items: items)
        case let .secondary(isSearching, _):
            self = .secondary(isSearching: isSearching, items: items)
        }
    }
    
    var identity: String {
        switch self {
        case let .primary(isSearching, _):
            return isSearching ? "primary.search" : "primary.default"
        case let .secondary(isSearching, _):
            return isSearching ? "secondary.search" : "secondary.default"
        }
    }
    
    var items: [Item] {
        switch self {
        case let .primary(_, items):
            return items
        case let .secondary(_, items):
            return items
        }
    }
    
    var title: String {
        switch self {
        case let .primary(isSearching, _):
            return isSearching ? "프로필" : "자주찾는 공동체"
        case let .secondary(isSearching, _):
            return isSearching ? "공동체방" : ""
        }
    }
}

