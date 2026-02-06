//
//  CommentUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import RxRelay

protocol CommentUseCase {
    var commentList: BehaviorRelay<[Comment]> { get }
    var repliesByParent: BehaviorRelay<[Int: [Comment]]> { get }
    var commentError: PublishRelay<Error> { get }
    
    func fetchCommentList()
    func fetchReplyList(parentId: Int)
    func createComment(_ comment: String, parentId: Int)
    func clearReplies(parentId: Int)
}
