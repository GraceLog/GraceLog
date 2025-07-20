//
//  CommentUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import RxRelay

protocol CommentUseCase {
    var commentList: BehaviorRelay<[Comment]> { get }
    
    func fetchCommentList()
    func createComment(_ comment: String)
}
