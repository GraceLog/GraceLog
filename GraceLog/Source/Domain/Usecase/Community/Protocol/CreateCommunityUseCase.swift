//
//  CreateCommunityUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 12/6/25.
//

import RxRelay

protocol CreateCommunityUseCase {
    var maxImageCount: Int { get }
    var createCommunityResult: PublishRelay<Result<Void, CreateCommunityError>> { get }
    
    func createCommunity(title: String, images: [DiaryImage])
}
