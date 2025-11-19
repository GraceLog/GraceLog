//
//  CAGradientLayer+Extension.swift
//  GraceLog
//
//  Created by 이상준 on 10/15/25.
//

import UIKit

extension CAGradientLayer {
    func setVerticalGradient(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    ) {
        self.colors = colors.map { $0.cgColor }
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    /// 다크 오버레이 그라디언트 (상단 밝음 → 하단 어두움)
    static func darkOverlayGradient() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.setVerticalGradient(
            colors: [
                UIColor(red: 0, green: 0, blue: 0, alpha: 0.2),
                UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
            ],
            locations: [0, 1]
        )
        return gradientLayer
    }
}
