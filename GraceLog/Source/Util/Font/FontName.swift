//
//  FontName.swift
//  GraceLog
//
//  Created by 이건준 on 6/16/25.
//

import UIKit

enum FontName: String {
    case pretendard = "Pretendard"
}

enum FontStyle: String {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    case thin = "Thin"
}

extension UIFont {
    /**
     미리 정의된 `FontName` `FontStyle` 열거형을 사용해 원하는 폰트를 가져온다
     - Parameters:
        - font: 폰트 종류  (*i.e.* Pretendard, Osward)
        - style: 폰트 스타일 (*i.e* regular, semibold)
        - size: 폰트 크기
     - Returns: {font}-{style} 이름의 폰트가 있는 경우 해당 폰트 반환, 폰트가 없는 경우 기본 시스템 폰트 반환
     */
    static func customFont(font: FontName, style: FontStyle, size: CGFloat) -> UIFont {
        
        let customFontName: String = "\(font.rawValue)-\(style.rawValue)"
        guard let font = UIFont(name: customFontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
}
