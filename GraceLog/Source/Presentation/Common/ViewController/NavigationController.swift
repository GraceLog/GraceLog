//
//  NavigationController.swift
//  GraceLog
//
//  Created by 이건준 on 7/5/25.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.isHidden = true
        self.navigationBar.prefersLargeTitles = false
        self.navigationBar.isTranslucent = false
        
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
