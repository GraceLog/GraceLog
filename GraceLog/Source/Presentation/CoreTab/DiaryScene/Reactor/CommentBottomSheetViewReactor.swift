//
//  CommentBottomSheetViewReactor.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import ReactorKit
import RxSwift

final class CommentBottomSheetViewReactor: Reactor {
    
    // MARK: - Dependency
    private let usecase: CommentUseCase
    
    // MARK: - Initial State
    let initialState: State
    
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case didTapToggleReplies(parentId: Int)
        case didEditReplyButton(parentId: Int)
        case didTapCreateButton(String)
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setParents([Comment])
        case setReplies([Int: [Comment]])
        case setExpanded(Set<Int>)
        case setSelectedParentId(Int?)
        case setError(Error)
    }
    
    // MARK: - State
    struct State {
        var parents: [Comment] = []
        var repliesByParent: [Int: [Comment]] = [:]
        var expandedParentIds: Set<Int> = []
        
        @Pulse var commentList: [CommentSection] = []
        @Pulse var selectedParentCommentID: Int?
        @Pulse var error: Error?
    }
    
    // MARK: - Init
    init(usecase: CommentUseCase) {
        self.usecase = usecase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewDidLoad:
            usecase.fetchCommentList()
            return .empty()
            
        case .didTapToggleReplies(let parentId):
            var expanded = currentState.expandedParentIds
            
            if expanded.contains(parentId) {
                expanded.remove(parentId)
                return .just(.setExpanded(expanded))
            } else {
                expanded.insert(parentId)
                usecase.fetchReplyList(parentId: parentId)
                return .just(.setExpanded(expanded))
            }
            
        case .didEditReplyButton(let parentId):
            return .just(.setSelectedParentId(parentId))
            
        case .didTapCreateButton(let comment):
            guard let parentId = currentState.selectedParentCommentID else {
                return .empty()
            }
            usecase.createComment(comment, parentId: parentId)
            return .empty()
        }
    }
    
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let parentsStream = usecase.commentList
            .map { Mutation.setParents($0) }
        
        let repliesStream = usecase.repliesByParent
            .map { Mutation.setReplies($0) }
        
        let errorStream = usecase.commentError
            .map { Mutation.setError($0) }
        
        return Observable.merge(
            mutation,
            parentsStream,
            repliesStream,
            errorStream
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setParents(let parents):
            newState.parents = parents
            
        case .setReplies(let replies):
            newState.repliesByParent = replies
            
        case .setExpanded(let expanded):
            newState.expandedParentIds = expanded
            
        case .setSelectedParentId(let parentId):
            newState.selectedParentCommentID = parentId
            
        case .setError(let error):
            newState.error = error
        }
        
        newState.commentList = Self.buildSections(
            parents: newState.parents,
            repliesDict: newState.repliesByParent,
            expanded: newState.expandedParentIds
        )
        
        return newState
    }
}

// MARK: - Section Builder
extension CommentBottomSheetViewReactor {
    private static func buildSections(
        parents: [Comment],
        repliesDict: [Int: [Comment]],
        expanded: Set<Int>
    ) -> [CommentSection] {
        
        return parents.map { parent in
            let isExpanded = expanded.contains(parent.id)
            let replies = isExpanded ? (repliesDict[parent.id] ?? []) : []
            
            let parentItem = CommentItem(
                id: parent.id,
                comment: parent.comment,
                profileImageURL: parent.profileImageURL,
                authorName: parent.authorName,
                editedDate: parent.createdAt
            )
            
            let subItems: [CommentItem] = replies.map {
                CommentItem(
                    id: $0.id,
                    comment: $0.comment,
                    profileImageURL: $0.profileImageURL,
                    authorName: $0.authorName,
                    editedDate: $0.createdAt
                )
            }
            
            return CommentSection(
                mainComment: CommentState(
                    item: parentItem,
                    isFolder: !isExpanded,
                    replyCount: parent.replyCount
                ),
                subComments: subItems
            )
        }
    }
}
