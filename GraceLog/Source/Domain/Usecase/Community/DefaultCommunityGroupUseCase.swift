//
//  DefaultCommunityGroupUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 12/29/25.
//

import Foundation

final class DefaultCommunityGroupUseCase: CommunityGroupUseCase {
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
}
