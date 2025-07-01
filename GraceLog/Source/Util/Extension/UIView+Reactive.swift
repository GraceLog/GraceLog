//
//  UIView+Reactive.swift
//  GraceLog
//
//  Created by 이건준 on 6/27/25.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    /// 탭 제스처 이벤트를 Observable로 방출합니다.
    var gestureTap: ControlEvent<UITapGestureRecognizer> {
        let gesture = UITapGestureRecognizer()
        base.addGestureRecognizer(gesture)
        base.isUserInteractionEnabled = true
        gesture.isEnabled = true
        gesture.cancelsTouchesInView = false
        gesture.numberOfTapsRequired = 1
        let source = gesture.rx.event
        return ControlEvent(events: source)
    }
}

