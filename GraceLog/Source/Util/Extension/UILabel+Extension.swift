//
//  UILabel+Extension.swift
//  GraceLog
//
//  Created by 이상준 on 4/9/25.
//

import UIKit

extension UILabel {
    // 라벨 텍스트 색상 적용
    func setTextWithColoredPart(fullText: String, coloredPart: String, color: UIColor, defaultColor: UIColor = .gray200) {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: coloredPart) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
            
            let fullRange = NSRange(location: 0, length: fullText.count)
            attributedString.addAttribute(.foregroundColor, value: defaultColor, range: fullRange)
            
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        
        self.attributedText = attributedString
    }
    
    /// UILabel이 실제로 표시하는 줄 수 계산
    var currentNumberOfLines: Int {
        guard let text = self.text, !text.isEmpty else { return 0 }
        
        let maxWidth = self.bounds.width > 0 ? self.bounds.width : UIScreen.main.bounds.width
        let textHeight = (text as NSString).boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: self.font as Any],
            context: nil
        ).height
        
        return Int(ceil(Double(textHeight) / Double(self.font.lineHeight)))
    }
}
