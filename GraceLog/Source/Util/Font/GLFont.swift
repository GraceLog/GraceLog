//
//  GLFont.swift
//  GraceLog
//
//  Created by 이건준 on 6/16/25.
//

import UIKit

enum GLFont: FontStylable {
    /// Pretendard-Bold
    case bold10
    case bold12
    case bold14
    case bold15
    case bold16
    case bold17
    case bold18
    case bold20
    
    /// Pretendard-ExtraBold
    case extraBold18
    
    /// Pretendard-SemiBold
    case semiBold16
    
    /// Pretendard-Regular
    case regular10
    case regular11
    case regular12
    case regular14
    case regular15
    case regular16
    case regular18
    case regular24
    
    /// Pretendard-Medium
    case medium10
    
    /// Pretendard-Light
    case light11
    
    var fontName: FontName { .pretendard }
    
    var fontStyle: FontStyle {
        switch self {
        case .bold10, .bold12, .bold14, .bold15, .bold16, .bold17, .bold18, .bold20:
            return .bold
        case .extraBold18:
            return .extraBold
        case .semiBold16:
            return .semiBold
        case .regular10, .regular11, .regular12, .regular14, .regular15, .regular16, .regular18, .regular24:
            return .regular
        case .medium10:
            return .medium
        case .light11:
            return .light
        }
    }
    
    var font: UIFont {
        switch self {
        case .bold10:
            return .customFont(font: .pretendard, style: fontStyle, size: 10)
        case .bold12:
            return .customFont(font: .pretendard, style: fontStyle, size: 12)
        case .bold14:
            return .customFont(font: .pretendard, style: fontStyle, size: 14)
        case .bold15:
            return .customFont(font: .pretendard, style: fontStyle, size: 15)
        case .bold16:
            return .customFont(font: .pretendard, style: fontStyle, size: 16)
        case .bold17:
            return .customFont(font: .pretendard, style: fontStyle, size: 17)
        case .bold18:
            return .customFont(font: .pretendard, style: fontStyle, size: 18)
        case .bold20:
            return .customFont(font: .pretendard, style: fontStyle, size: 20)
        case .extraBold18:
            return .customFont(font: .pretendard, style: fontStyle, size: 18)
        case .semiBold16:
            return .customFont(font: .pretendard, style: fontStyle, size: 16)
        case .regular10:
            return .customFont(font: .pretendard, style: fontStyle, size: 10)
        case .regular11:
            return .customFont(font: .pretendard, style: fontStyle, size: 11)
        case .regular12:
            return .customFont(font: .pretendard, style: fontStyle, size: 12)
        case .regular14:
            return .customFont(font: .pretendard, style: fontStyle, size: 14)
        case .regular15:
            return .customFont(font: .pretendard, style: fontStyle, size: 15)
        case .regular16:
            return .customFont(font: .pretendard, style: fontStyle, size: 16)
        case .regular18:
            return .customFont(font: .pretendard, style: fontStyle, size: 18)
        case .regular24:
            return .customFont(font: .pretendard, style: fontStyle, size: 24)
        case .medium10:
            return .customFont(font: .pretendard, style: fontStyle, size: 10)
        case .light11:
            return .customFont(font: .pretendard, style: fontStyle, size: 11)
        }
    }
    
    
}
