//
//  DiaryShareOption.swift
//  GraceLog
//
//  Created by 이건준 on 7/5/25.
//

import Foundation

enum Community: String, CaseIterable {
    case saeromchurch
    case gracelog
    case studio306
    case studiocafe
    case holyfire
    
    var title: String {
        switch self {
        case .saeromchurch:
            return "새롬교회"
        case .gracelog:
            return "Grace_log"
        case .studio306:
            return "스튜디오306"
        case .studiocafe:
            return "스튜디오카페"
        case .holyfire:
            return "홀리파이어"
        }
    }
    
    var logoImageNamed: String {
        return "diary_share_\(self)"
    }
}
