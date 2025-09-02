//
//  MyInfoDataSource.swift
//  GraceLog
//
//  Created by 이상준 on 3/15/25.
//

import Foundation
import RxDataSources
import UIKit

struct MyInfoItem {
    let icon: String
    let title: String
    let type: MyInfoItemType
}

enum MyInfoItemType {
    case myProfile
    case myGraceLog
    case favoriteVerse
    case pushSetting
    case pushList
    case noticeBoard
    case inquiry
    case logout
    case withdrawal
}

protocol SectionItem {}
extension MyInfoItem: SectionItem {}

enum MyInfoSection {
    case myInfo(title: String, items: [MyInfoItem])
    case pushNotification(title: String, items: [MyInfoItem])
    case customerService(title: String, items: [MyInfoItem])
    case logout(title: String, items: [MyInfoItem])
    case withdrawal(title: String, items: [MyInfoItem])
}

extension MyInfoSection: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .myInfo(_, let items),
                .pushNotification(_, let items),
                .customerService(_, let items),
                .logout(_, let items),
                .withdrawal(_, let items):
            return items
        }
    }
    
    var title: String? {
        switch self {
        case .myInfo(let title, _),
                .pushNotification(let title, _),
                .customerService(let title, _),
                .logout(let title, _),
                .withdrawal(let title, items: _):
            return title
        }
    }
    
    init(original: MyInfoSection, items: [SectionItem]) {
        switch original {
        case .myInfo(let title, _):
            self = .myInfo(title: title, items: items as! [MyInfoItem])
        case .pushNotification(let title, _):
            self = .pushNotification(title: title, items: items as! [MyInfoItem])
        case .customerService(let title, _):
            self = .customerService(title: title, items: items as! [MyInfoItem])
        case .logout(let title, _):
            self = .logout(title: title, items: items as! [MyInfoItem])
        case .withdrawal(let title, _):
            self = .withdrawal(title: title, items: items as! [MyInfoItem])
        }
    }
}
