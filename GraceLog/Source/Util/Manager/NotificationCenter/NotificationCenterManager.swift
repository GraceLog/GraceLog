//
//  NotificationCenterManager.swift
//  GraceLog
//
//  Created by 이상준 on 1/9/26.
//

import Foundation
import UIKit

enum NotificationCenterManager: NotificationCenterHandler {
    case reloadHomeMyDiaryList
    case reloadHomeCommunityDiaryList
    case reloadMyInfo
    
    var name: Notification.Name {
        switch self {
        case .reloadHomeMyDiaryList:
            return Notification.Name("reloadHomeMyDiaryList")
        case .reloadHomeCommunityDiaryList:
            return Notification.Name("reloadHomeCommunityDiaryList")
        case .reloadMyInfo:
            return Notification.Name("reloadMyInfo")
        }
    }
}
