//
//  FontStylable.swift
//  GraceLog
//
//  Created by 이건준 on 6/16/25.
//

import UIKit

protocol FontStylable {
    var fontName: FontName { get }
    var fontStyle: FontStyle { get }
    var font: UIFont { get }
}
