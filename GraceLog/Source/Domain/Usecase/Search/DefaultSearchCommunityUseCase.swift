//
//  DefaultSearchCommunityUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 9/21/25.
//

import RxRelay

final class DefaultSearchCommunityUseCase: SearchCommunityUseCase {
    var popularCommunityList = BehaviorRelay<[Community]>(value: [])
    var roomList = BehaviorRelay<[CommunityRoom]>(value: [])
    var profileList = BehaviorRelay<[ProfileItem]>(value: [])
    
    func fetchPopularCommunity() {
        popularCommunityList.accept([
            Community(id: 1, name: "파이어폭스",
                      logoImageURL: URL(string: "https://picsum.photos/seed/firefox/200")),
            Community(id: 2, name: "스위프트 스터디",
                      logoImageURL: URL(string: "https://picsum.photos/seed/swift/200")),
            Community(id: 3, name: "iOS 개발 크루",
                      logoImageURL: URL(string: "https://picsum.photos/seed/ios/200")),
            Community(id: 4, name: "알고리즘 클럽",
                      logoImageURL: URL(string: "https://picsum.photos/seed/algorithm/200")),
            Community(id: 5, name: "UI/UX 연구회",
                      logoImageURL: URL(string: "https://picsum.photos/seed/design/200")),
            Community(id: 6, name: "네트워킹 동아리",
                      logoImageURL: URL(string: "https://picsum.photos/seed/networking/200")),
        ])
    }
    
    func fetchRoomList() {
        let now = Date()
        let data: [CommunityRoom] = [
            .init(
                id: 101,
                title: "iOS 아키텍처 토론방",
                description: "MVVM-C, ReactorKit 적용 사례 공유",
                recentEditedDate: now.addingTimeInterval(-60 * 10), // 10분 전
                peopleCount: 128,
                imageURL: URL(string: "https://picsum.photos/seed/ios-arch/200")
            ),
            .init(
                id: 102,
                title: "취업 스터디",
                description: "이력서/포트폴리오 피드백 & 기술면접 대비",
                recentEditedDate: now.addingTimeInterval(-60 * 45), // 45분 전
                peopleCount: 73,
                imageURL: URL(string: "https://picsum.photos/seed/job/200")
            ),
            .init(
                id: 103,
                title: "알고리즘 뽀개기",
                description: "문제 풀이 코드 리뷰/같이 풀기",
                recentEditedDate: now.addingTimeInterval(-60 * 60 * 3), // 3시간 전
                peopleCount: 56,
                imageURL: URL(string: "https://picsum.photos/seed/algorithm-chat/200")
            ),
            .init(
                id: 104,
                title: "SwiftUI 스터디",
                description: "Observation/Charts/NavigationStack 최신 문법",
                recentEditedDate: now.addingTimeInterval(-60 * 60 * 6), // 6시간 전
                peopleCount: 41,
                imageURL: URL(string: "https://picsum.photos/seed/swiftui/200")
            ),
            .init(
                id: 105,
                title: "네트워킹/REST",
                description: "Interceptor, EventMonitor, 인증 토큰 전략",
                recentEditedDate: now.addingTimeInterval(-60 * 60 * 12), // 12시간 전
                peopleCount: 89,
                imageURL: URL(string: "https://picsum.photos/seed/network/200")
            ),
            .init(
                id: 106,
                title: "디자인시스템&토큰",
                description: "타이포 스케일/컬러 토큰/컴포넌트 표준화",
                recentEditedDate: now.addingTimeInterval(-60 * 60 * 24), // 하루 전
                peopleCount: 37,
                imageURL: URL(string: "https://picsum.photos/seed/designsystem/200")
            )
        ]
        roomList.accept(data)
    }
    
    func fetchProfileList() {
        profileList.accept([
            ProfileItem(
                id: 201,
                name: "김서연",
                imageURL: URL(string: "https://picsum.photos/seed/kimseoyeon/200")
            ),
            ProfileItem(
                id: 202,
                name: "이준호",
                imageURL: URL(string: "https://picsum.photos/seed/leejunho/200")
            ),
            ProfileItem(
                id: 203,
                name: "박지민",
                imageURL: URL(string: "https://picsum.photos/seed/parkjimin/200")
            ),
            ProfileItem(
                id: 204,
                name: "최유진",
                imageURL: URL(string: "https://picsum.photos/seed/choiyujin/200")
            ),
            ProfileItem(
                id: 205,
                name: "정민수",
                imageURL: URL(string: "https://picsum.photos/seed/jungminsu/200")
            ),
            ProfileItem(
                id: 206,
                name: "한소희",
                imageURL: URL(string: "https://picsum.photos/seed/hansohee/200")
            )
        ])
    }
    
    func searchCommunity(query: String) {
        let now = Date()
        let data: [CommunityRoom] = [
            .init(
                id: 101,
                title: "iOS 아키텍처 토론방",
                description: "MVVM-C, ReactorKit 적용 사례 공유",
                recentEditedDate: now.addingTimeInterval(-60 * 10), // 10분 전
                peopleCount: 128,
                imageURL: URL(string: "https://picsum.photos/seed/ios-arch/200")
            ),
            .init(
                id: 102,
                title: "취업 스터디",
                description: "이력서/포트폴리오 피드백 & 기술면접 대비",
                recentEditedDate: now.addingTimeInterval(-60 * 45), // 45분 전
                peopleCount: 73,
                imageURL: URL(string: "https://picsum.photos/seed/job/200")
            ),
            .init(
                id: 103,
                title: "알고리즘 뽀개기",
                description: "문제 풀이 코드 리뷰/같이 풀기",
                recentEditedDate: now.addingTimeInterval(-60 * 60 * 3), // 3시간 전
                peopleCount: 56,
                imageURL: URL(string: "https://picsum.photos/seed/algorithm-chat/200")
            )
        ]
        roomList.accept(data)
    }
}
