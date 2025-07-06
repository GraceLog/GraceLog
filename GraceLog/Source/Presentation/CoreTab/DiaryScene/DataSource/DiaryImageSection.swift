//
//  DiaryImageSection.swift
//  GraceLog
//
//  Created by 이건준 on 6/20/25.
//

import RxDataSources
import UIKit

struct DiaryImage: Equatable {
    let id: UUID
    let image: UIImage
}

enum DiaryImageItem: IdentifiableType, Equatable {
    case image(DiaryImage)

    var identity: String {
        switch self {
        case .image(let model): return model.id.uuidString
        }
    }

    static func == (lhs: DiaryImageItem, rhs: DiaryImageItem) -> Bool {
        lhs.identity == rhs.identity
    }

    var image: UIImage {
        switch self {
        case .image(let model): return model.image
        }
    }
}


enum DiaryImageSection: AnimatableSectionModelType {
    case imageSection(id: String = UUID().uuidString, items: [DiaryImageItem])

    var identity: String {
        switch self {
        case .imageSection(let id, _): return id
        }
    }

    var items: [DiaryImageItem] {
        switch self {
        case .imageSection(_, let items): return items
        }
    }

    init(original: DiaryImageSection, items: [DiaryImageItem]) {
        switch original {
        case .imageSection(let id, _):
            self = .imageSection(id: id, items: items)
        }
    }
}

