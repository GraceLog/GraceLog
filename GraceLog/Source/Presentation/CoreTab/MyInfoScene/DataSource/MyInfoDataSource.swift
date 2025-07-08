//
//  MyInfoDataSource.swift
//  GraceLog
//
//  Created by 이상준 on 3/15/25.
//

import Foundation
import RxDataSources
import UIKit

struct ProfileItem {
    let imageUrl: String
    let name: String
    let email: String
}

struct MyInfoItem {
    let icon: String
    let title: String
    let type: MyInfoItemType
}

enum MyInfoItemType {
    case myProfile
    case myGraceLog
    case favoriteVerse
    case communityManagement
    case memberManagement
    case pushSetting
    case pushList
    case noticeBoard
    case versionInfo
    case inquiry
    case logout
    case withdrawal
}

protocol SectionItem {}
extension ProfileItem: SectionItem {}
extension MyInfoItem: SectionItem {}

enum MyInfoSection {
    case profile(items: [ProfileItem])
    case myInfo(title: String, items: [MyInfoItem])
    case community(title: String, items: [MyInfoItem])
    case notification(title: String, items: [MyInfoItem])
    case customerService(title: String, items: [MyInfoItem])
    case logout(title: String, items: [MyInfoItem])
    case withdrawal(title: String, items: [MyInfoItem])
}

extension MyInfoSection: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .profile(let items):
            return items
        case .myInfo(_, let items),
                .community(_, let items),
                .notification(_, let items),
                .customerService(_, let items),
                .logout(_, let items),
                .withdrawal(_, let items):
            return items
        }
    }
    
    var title: String? {
        switch self {
        case .profile:
            return nil
        case .myInfo(let title, _),
                .community(let title, _),
                .notification(let title, _),
                .customerService(let title, _),
                .logout(let title, _),
                .withdrawal(let title, items: _):
            return title
        }
    }
    
    init(original: MyInfoSection, items: [SectionItem]) {
        switch original {
        case .profile:
            self = .profile(items: items as! [ProfileItem])
        case .myInfo(let title, _):
            self = .myInfo(title: title, items: items as! [MyInfoItem])
        case .community(let title, _):
            self = .community(title: title, items: items as! [MyInfoItem])
        case .notification(let title, _):
            self = .notification(title: title, items: items as! [MyInfoItem])
        case .customerService(let title, _):
            self = .customerService(title: title, items: items as! [MyInfoItem])
        case .logout(let title, _):
            self = .logout(title: title, items: items as! [MyInfoItem])
        case .withdrawal(let title, _):
            self = .withdrawal(title: title, items: items as! [MyInfoItem])
        }
    }
}
