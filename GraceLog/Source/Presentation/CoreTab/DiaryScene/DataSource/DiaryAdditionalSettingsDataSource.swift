//
//  DiaryAdditionalSettingsDataSource.swift
//  GraceLog
//
//  Created by 이상준 on 4/21/25.
//

import Foundation
import RxDataSources
import RxSwift

struct DiaryAdditionalSettingSectionItem {
    let title: String
    let desc: String
    var isOn: Bool
}

struct DiaryAdditionalSettingsSection {
    var header: String
    var items: [Item]
}

extension DiaryAdditionalSettingsSection: SectionModelType {
    typealias Item = DiaryAdditionalSettingSectionItem
    
    init (original: DiaryAdditionalSettingsSection, items: [Item]) {
        self = original
        self.items = items
    }
}
