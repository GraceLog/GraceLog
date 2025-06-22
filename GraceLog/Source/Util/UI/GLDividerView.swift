//
//  GLDividerView.swift
//  GraceLog
//
//  Created by 이건준 on 6/17/25.
//

import UIKit
 
import SnapKit

final class GLDividerView: UIView {
    
    lazy var lineView = UIView().then { view in
        view.backgroundColor = .graceLightGray
    }
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 10000, height: 1))
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        self.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension UIStackView {
    func addArrangedDividerSubViews(_ views: [UIView], exclude: [Int]? = []) {
        self.addArrangedSubviews(views, exclude ?? [], divider: { GLDividerView() })
    }
}
