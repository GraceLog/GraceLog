//
//  CommentBottomSheetViewReactor.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import ReactorKit

final class CommentBottomSheetViewReactor: Reactor {
    private let usecase: CommentUseCase
    let initialState: State
    
    enum Action {
        case didTapFolderButton((Int, Bool)?)
        case didEditButton(String)
    }
    
    enum Mutation {
        case setCommentList([CommentSection])
    }
    
    struct State {
        @Pulse var commentList: [CommentSection]
    }
    
    init(usecase: CommentUseCase) {
        self.usecase = usecase
        self.initialState = State(
            commentList: []
        )
        usecase.fetchCommentList()
    }
}

extension CommentBottomSheetViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapFolderButton(let result):
            guard let (sectionIndex, isFolder) = result else {
                return .empty()
            }
            var currentCommentList = currentState.commentList
            currentCommentList[sectionIndex].mainComment.isFolder = isFolder
            
            return .just(.setCommentList(currentCommentList))
        case .didEditButton(let comment):
            usecase.createComment(comment)
            return .empty()
        }
    }
    
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let commentMutation = usecase.commentList
            .map { commentList -> [CommentSection] in
                commentList.map {
                    CommentSection(
                        mainComment: CommentState(
                            item: CommentItem(
                                id: $0.id,
                                comment: $0.comment,
                                profileImageURL: $0.profileImageURL,
                                authorName: $0.authorName,
                                editedDate: $0.createdAt
                            ),
                            isFolder: false
                        ),
                        subComments: $0.subComments.map {
                            CommentItem(
                                id: $0.id,
                                comment: $0.comment,
                                profileImageURL: $0.profileImageURL,
                                authorName: $0.authorName,
                                editedDate: $0.createdAt
                            )
                        }
                    )
                }
            }
            .map { Mutation.setCommentList($0) }
        return Observable.merge(commentMutation, mutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCommentList(let commentList):
            newState.commentList = commentList
        }
        
        return newState
    }
    
}
