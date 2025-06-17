//
//  String+Extension.swift
//  GraceLog
//
//  Created by 이상준 on 2/22/25.
//

import UIKit

extension String {
    func toDiaryDateAttributedString(
        regularFont: UIFont = GLFont.regular12.font,
        boldFont: UIFont = GLFont.bold15.font,
        color: UIColor = .themeColor
    ) -> NSAttributedString {
        let components = self.components(separatedBy: "\n")
        guard components.count == 2 else { return NSAttributedString(string: self) }
        
        let attributedString = NSMutableAttributedString()
        
        let part1 = NSAttributedString(
            string: components[0] + "\n",
            attributes: [
                .font: regularFont,
                .foregroundColor: color
            ]
        )
        
        let part2 = NSAttributedString(
            string: components[1],
            attributes: [
                .font: boldFont,
                .foregroundColor: color
            ]
        )
        
        attributedString.append(part1)
        attributedString.append(part2)
        
        return attributedString
    }
}
