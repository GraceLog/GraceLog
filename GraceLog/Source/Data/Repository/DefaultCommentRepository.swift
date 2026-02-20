//
//  DefaultCommentRepository.swift
//  GraceLog
//
//  Created by 이건준 on 1/29/26.
//

import RxSwift

final class DefaultCommentRepository: CommentRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchCommentList(postId: Int) -> RxSwift.Single<[Comment]> {
        return network.request(CommentAPI.fetchCommentList(postId: postId))
            .map { (responses: [FetchCommentListResponseDTO]) in
                return responses.map { response in
                    Comment(
                        id: response.id,
                        authorName: response.writer.name,
                        createdAt: response.createdAt,
                        profileImageURL: URL(string: response.writer.profileImage),
                        comment: response.content,
                        replyCount: response.replyCount,
                        subComments: []
                    )
                }
            }
    }
    
    func fetchReplyList(parentId: Int) -> RxSwift.Single<[Comment]> {
        network.request(CommentAPI.fetchReplyList(parentId: parentId))
            .map { (responses: [FetchCommentListResponseDTO]) in
                return responses.map { response in
                    Comment(
                        id: response.id,
                        authorName: response.writer.name,
                        createdAt: response.createdAt,
                        profileImageURL: URL(string: response.writer.profileImage),
                        comment: response.content,
                        replyCount: response.replyCount,
                        subComments: []
                    )
                }
            }
    }
    
    func createComment(request: CreateCommentRequestDTO, postId: Int) -> RxSwift.Single<GLEmptyResponse> {
        network.request(CommentAPI.createComment(postId: postId, request: request))
    }
}
