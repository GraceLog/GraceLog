//
//  GLColor.swift
//  GraceLog
//
//  Created by 이건준 on 7/15/25.
//

import UIKit

enum GLColor: AppColor {
    /// 배경 색상
    case backgroundMain
    case backgroundSub
    
    /// 텍스트 색상
    case textMain
    case textSub
    case textAccent
    case textBasic
    case textHome
    
    /// 아이콘 색상
    case iconMain
    case iconSub
    case iconAccent
    
    /// 공용
    case emptyDiary
    
    var darkModeColor: UIColor {
        switch self {
        case .backgroundMain:
            return UIColor(hex: 0x161515)
        case .backgroundSub:
            return UIColor(hex: 0x1A1A1A)
        case .textMain:
            return UIColor(hex: 0xFFFFFF)
        case .textSub:
            return UIColor(hex: 0xD8D8D8)
        case .textAccent:
            return UIColor(hex: 0xFE5F51)
        case .textBasic:
            return UIColor(hex: 0xFFFFFF)
        case .textHome:
            return UIColor(hex: 0x8C8C8C)
        case .iconMain:
            return UIColor(hex: 0xFFFFFF)
        case .iconSub:
            return UIColor(hex: 0x8C8C8C)
        case .iconAccent:
            return UIColor(hex: 0xFE5F51)
        case .emptyDiary:
            return UIColor(hex: 0xD8D8D8)
        }
    }
    
    var lightModeColor: UIColor {
        switch self {
        case .backgroundMain:
            return UIColor(hex: 0xF4F4F4)
        case .backgroundSub:
            return UIColor(hex: 0xFFFFFF)
        case .textMain:
            return UIColor(hex: 0x161515)
        case .textSub:
            return UIColor(hex: 0x414141)
        case .textAccent:
            return UIColor(hex: 0xFE5F51)
        case .textBasic:
            return UIColor(hex: 0x000000)
        case .textHome:
            return UIColor(hex: 0x414141)
        case .iconMain:
            return UIColor(hex: 0x161515)
        case .iconSub:
            return UIColor(hex: 0x8C8C8C)
        case .iconAccent:
            return UIColor(hex: 0xFE5F51)
        case .emptyDiary:
            return UIColor(hex: 0xD8D8D8)
        }
    }
}
