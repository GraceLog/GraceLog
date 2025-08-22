//
//  NVActivityIndicatorView+Extension.swift
//  GraceLog
//
//  Created by 이상준 on 8/22/25.
//

import RxSwift
import RxCocoa
import NVActivityIndicatorView

extension Reactive where Base: NVActivityIndicatorView {
    var isAnimating: Binder<Bool> {
        return Binder(base) { indicator, isAnimating in
            if isAnimating {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
}
