//
//  AutoSizingCollectionView.swift
//  GraceLog
//
//  Created by 이건준 on 6/20/25.
//

import UIKit

final class AutoSizingCollectionView: UICollectionView {

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
