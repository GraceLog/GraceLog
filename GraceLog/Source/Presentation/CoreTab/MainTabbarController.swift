//
//  MainTabbarController.swift
//  GraceLog
//
//  Created by 이건준 on 7/5/25.
//

import UIKit

import SnapKit
import Then

final class MainTabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
    }
    
    private func setupStyles() {
        tabBar.tintColor = .themeColor
        tabBar.backgroundColor = .white
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .gray200
        appearance.shadowImage = UIImage()
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [
            .font: GLFont.medium10.font
        ]
        itemAppearance.selected.titleTextAttributes = [
            .font: GLFont.medium10.font
        ]
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}


