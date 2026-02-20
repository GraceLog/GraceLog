//
//  CommentRepository.swift
//  GraceLog
//
//  Created by 이건준 on 1/29/26.
//

import RxSwift

protocol CommentRepository {
    func fetchCommentList(postId: Int) -> Single<[Comment]>
    func fetchReplyList(parentId: Int) -> Single<[Comment]>
    func createComment(request: CreateCommentRequestDTO, postId: Int) -> Single<GLEmptyResponse>
}
