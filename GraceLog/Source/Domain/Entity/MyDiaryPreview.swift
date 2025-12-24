//
//  MyDiaryPreview.swift
//  GraceLog
//
//  Created by 이상준 on 3/6/25.
//

import Foundation

struct MyDiaryPreview {
    let id: Int
    let editedDate: Date?
    let title: String
    let content: String
    let imageURL: URL?
}

extension MyDiaryPreview {
    static var empty: MyDiaryPreview {
        MyDiaryPreview(
            id: 0,
            editedDate: nil,
            title: "",
            content: "",
            imageURL: nil
        )
    }
}
