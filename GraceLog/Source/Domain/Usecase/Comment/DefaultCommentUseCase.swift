//
//  DefaultCommentUseCase.swift.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import RxRelay

final class DefaultCommentUseCase: CommentUseCase {
    var commentList = BehaviorRelay<[Comment]>(value: [])
    
    func fetchCommentList() {
        commentList.accept([
            Comment(
                id: "1",
                authorName: "이건준",
                createdAt: "조금 전",
                profileImageURL: URL(string: ""),
                comment: "지금도 매일 감사하고 있어? 요즘에는 하나님과 너의 삶과 관련해서 어떤 얘기를 나눠?",
                subComments: [
                    Comment(
                        id: "5",
                        authorName: "승렬",
                        createdAt: "방금",
                        profileImageURL: URL(string: ""),
                        comment: "오늘 새벽예배 말씀에서 들었어! 감사는 우리의 믿음이랑 직결되는 부분이라고 해~",
                        subComments: []
                    )
                ]
            ),
            Comment(
                id: "2",
                authorName: "신범철",
                createdAt: "조금 전",
                profileImageURL: URL(string: ""),
                comment: "하루 하루 작은 것에 감사함을 느끼기 시작했어~ 이 부분을 기도하면서 하나님과 나누는 중이야. ",
                subComments: []
            ),
            Comment(
                id: "3",
                authorName: "이상준",
                createdAt: "25주 전",
                profileImageURL: URL(string: ""),
                comment: "그거 정말 잘됐다!! 너 처음에 불평만 하고 아무것도 안하려고 했잖아 ㅋㅋㅋ. 소식 들으니 좋네~ 계속해서 주님께 들고 나아가보자. 절대로 너가 했다고 생각하지 말고!! 늘 겸손하기~",
                subComments: [
                    Comment(
                        id: "6",
                        authorName: "문진우",
                        createdAt: "2초 전",
                        profileImageURL: URL(string: ""),
                        comment: "매순간 순간마다 감사하면서 살아가는 삶을 살고 싶어! 특별히 사랑하는 예수님과 함께",
                        subComments: []
                    ),
                    Comment(
                        id: "7",
                        authorName: "김규리",
                        createdAt: "6초 전",
                        profileImageURL: URL(string: ""),
                        comment: "지금도 매일 감사하고 있어? 요즘에는 하나님과 너의 삶과 관련해서 어떤 얘기를 나눠?",
                        subComments: []
                    )
                ]
            )
        ])
    }
    
    func createComment(_ comment: String) {
        print("생성된 댓글: \(comment)")
    }
}
