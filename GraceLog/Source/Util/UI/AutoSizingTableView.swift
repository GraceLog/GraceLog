//
//  AutoSizingTableView.swift
//  GraceLog
//
//  Created by 이건준 on 6/22/25.
//

import UIKit

final class AutoSizingTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
