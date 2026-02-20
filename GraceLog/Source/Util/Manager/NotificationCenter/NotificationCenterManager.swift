//
//  NotificationCenterManager.swift
//  GraceLog
//
//  Created by 이상준 on 1/9/26.
//

import Foundation
import UIKit

enum NotificationCenterManager: NotificationCenterHandler {
    case authenticationDidFail
    case reloadHomeMyDiaryList
    case reloadHomeCommunityDiaryList
    case reloadMyInfo
    case reloadCommunityList
    
    var name: Notification.Name {
        switch self {
        case .authenticationDidFail:
            return Notification.Name("authenticationDidFail")
        case .reloadHomeMyDiaryList:
            return Notification.Name("reloadHomeMyDiaryList")
        case .reloadHomeCommunityDiaryList:
            return Notification.Name("reloadHomeCommunityDiaryList")
        case .reloadMyInfo:
            return Notification.Name("reloadMyInfo")
        case .reloadCommunityList:
            return Notification.Name("reloadCommunityList")
        }
    }
}
