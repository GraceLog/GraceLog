//
//  Color.swift
//  GraceLog
//
//  Created by 이건준 on 7/15/25.
//

import UIKit

protocol AppColor {
    var color: UIColor { get }
    var darkModeColor: UIColor { get }
    var lightModeColor: UIColor { get }
}

extension AppColor {
    var color: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark ? darkModeColor : lightModeColor
        }
    }
}
