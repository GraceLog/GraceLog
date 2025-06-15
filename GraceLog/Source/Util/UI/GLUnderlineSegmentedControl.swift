//
//  GLUnderlineSegmentedControl.swift
//  GraceLog
//
//  Created by 이건준 on 6/15/25.
//

import UIKit

import SnapKit
import Then

final class GLUnderlineSegmentedControl: UISegmentedControl {
  private lazy var highlightedView = UIView(
    frame: CGRect(
      x: CGFloat(selectedSegmentIndex * Int(bounds.size.width / CGFloat(numberOfSegments))),
      y: bounds.size.height - Size.highlightedHeight,
      width: bounds.size.width / CGFloat(numberOfSegments),
      height: Size.highlightedHeight
    )
  ).then {
    $0.backgroundColor = .themeColor
    addSubview($0)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    removeBackgroundAndDivider()
  }
  
  override init(items: [Any]?) {
    super.init(items: items)
    removeBackgroundAndDivider()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    underlineAnimation()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
    
  private func removeBackgroundAndDivider() {
    let image = UIImage()
    setBackgroundImage(image, for: .normal, barMetrics: .default)
    setBackgroundImage(image, for: .selected, barMetrics: .default)
    setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    setDividerImage(
      image,
      forLeftSegmentState: .selected,
      rightSegmentState: .normal,
      barMetrics: .default
    )
    backgroundColor = .clear
  }
  
  private func underlineAnimation() {
    layer.cornerRadius = 0
    let segmentIndex = CGFloat(selectedSegmentIndex)
    let segmentWidth = frame.width / CGFloat(numberOfSegments)
    let leadingDistance = segmentWidth * segmentIndex
    UIView.animate(
      withDuration: 0.1,
      animations: {
        self.highlightedView.frame.origin.x = leadingDistance
      }
    )
  }
}

extension GLUnderlineSegmentedControl {
    enum Size {
        static let highlightedHeight: CGFloat = 2
    }
}
