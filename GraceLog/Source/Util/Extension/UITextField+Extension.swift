//
//  UITextField+Extension.swift
//  GraceLog
//
//  Created by 이건준 on 6/18/25.
//

import UIKit

extension UITextField {

    /// UILabel을 우측 패딩을 포함한 rightView로 설정
    func setRightLabel(_ label: UILabel, rightPadding: CGFloat = 8) {
        label.sizeToFit()
        let labelSize = label.intrinsicContentSize

        let wrapperView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: labelSize.width + rightPadding,
            height: max(labelSize.height, self.frame.height)
        ))

        label.frame = CGRect(
            x: 0,
            y: (wrapperView.frame.height - labelSize.height) / 2,
            width: labelSize.width,
            height: labelSize.height
        )

        wrapperView.addSubview(label)

        self.rightView = wrapperView
        self.rightViewMode = .always
    }
}
