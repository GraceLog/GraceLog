//
//  DefaultCommentUseCase.swift.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import RxSwift
import RxRelay

final class DefaultCommentUseCase: CommentUseCase {
    private let commentRepository: CommentRepository
    private let postId: Int
    private let disposeBag = DisposeBag()
    var commentList = BehaviorRelay<[Comment]>(value: [])
    let repliesByParent = BehaviorRelay<[Int: [Comment]]>(value: [:])
    var commentError = PublishRelay<Error>()
    
    init(commentRepository: CommentRepository, postId: Int) {
        self.commentRepository = commentRepository
        self.postId = postId
    }
    
    init(diaryID: Int) {
        self.diaryID = diaryID
    }
    
    func fetchCommentList() {
        commentRepository.fetchCommentList(postId: postId)
            .subscribe(with: self, onSuccess: { owner, comments in
                owner.commentList.accept(comments)
            }, onFailure: { owner, error in
                owner.commentError.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchReplyList(parentId: Int) {
        commentRepository.fetchReplyList(parentId: parentId)
            .subscribe(with: self, onSuccess: { owner, replies in
                var dict = owner.repliesByParent.value
                dict[parentId] = replies
                owner.repliesByParent.accept(dict)
            }, onFailure: { owner, error in
                owner.commentError.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func clearReplies(parentId: Int) {
        var dict = repliesByParent.value
        dict[parentId] = nil
        repliesByParent.accept(dict)
    }
    
    func createComment(_ comment: String, parentId: Int) {
        commentRepository.createComment(
            request: .init(content: comment, parentId: parentId),
            postId: postId
        )
        .subscribe(with: self, onSuccess: { owner, _ in
            owner.fetchReplyList(parentId: parentId)
        }, onFailure: { owner, error in
            owner.commentError.accept(error)
        })
        .disposed(by: disposeBag)
        
    }
}
