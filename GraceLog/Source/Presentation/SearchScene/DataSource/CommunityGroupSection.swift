//
//  CommunityGroupSection.swift
//  GraceLog
//
//  Created by 이건준 on 1/1/26.
//

import RxDataSources

struct CommunityGroupSection {
    let date: Date
    var items: [CommunityDiaryItem]
    
    init(date: Date, items: [CommunityDiaryItem]) {
        self.date = date
        self.items = items
    }
}

extension CommunityGroupSection: AnimatableSectionModelType {
    typealias Item = CommunityDiaryItem
    typealias Identity = String
    
    var identity: String {
        DateFormatterFactory.dateWithShortKorean.string(from: date)
    }
    
    init(original: CommunityGroupSection, items: [CommunityDiaryItem]) {
        self = original
        self.items = items
    }
}
