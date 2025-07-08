//
//  MyInfoViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 3/15/25.
//

import Foundation
import ReactorKit
import RxSwift

final class MyInfoViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case refreshData
        case itemSelected(at: IndexPath)
    }
    
    enum Mutation {
        case setSections([MyInfoSection])
        case selectItem(MyInfoItemType)
    }
    
    struct State {
        var sections: [MyInfoSection] = []
        var selectedItem: MyInfoItemType?
    }
    
    let initialState = State()
    
    weak var coordinator: MyInfoCoordinator?
    
    init(coordinator: MyInfoCoordinator? = nil) {
        self.coordinator = coordinator
    }
}

extension MyInfoViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad, .refreshData:
            let sections = createSections()
            return .just(.setSections(sections))
        case .itemSelected(let indexPath):
            let item = currentState.sections[indexPath.section].items[indexPath.row]
            
            if let myInfoItem = item as? MyInfoItem {
                switch myInfoItem.type {
                case .myProfile:
                    coordinator?.showProfileEditVC()
                    return .empty()
                default:
                    return .empty()
                }
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
        case .selectItem(let itemType):
            newState.selectedItem = itemType
        }
        
        return newState
    }
    
    private func createSections() -> [MyInfoSection] {
        let user = AuthManager.shared.getUser()
        
        let profileItems = [
            ProfileItem(
                imageUrl: user?.profileImage ?? "",
                name: user?.name ?? "",
                email: user?.email ?? ""
            )
        ]
        
        let myInfoItems = [
            MyInfoItem(icon: "user", title: "프로필 조회 및 수정", type: .myProfile),
            MyInfoItem(icon: "coffee", title: "나의 감사일기", type: .myGraceLog),
            MyInfoItem(icon: "heart", title: "좋아요 및 댓글 단 감사일기", type: .favoriteVerse)
        ]
        
        let communityItems = [
            MyInfoItem(icon: "home", title: "공동체 관리", type: .communityManagement),
            MyInfoItem(icon: "users", title: "친구 관리", type: .memberManagement)
        ]
        
        let notificationItems = [
            MyInfoItem(icon: "notification", title: "알림 설정", type: .pushSetting),
            MyInfoItem(icon: "list", title: "알림 목록", type: .pushList)
        ]
        
        let customerServiceItems = [
            MyInfoItem(icon: "flag", title: "공지사항", type: .noticeBoard),
            MyInfoItem(icon: "info", title: "버전 정보", type: .versionInfo),
            MyInfoItem(icon: "message", title: "문의하기", type: .inquiry)
        ]
        
        let logoutItems = [
            MyInfoItem(icon: "", title: "로그아웃", type: .logout),
        ]
        
        let withdrawalItem = [
            MyInfoItem(icon: "", title: "탈퇴하기", type: .withdrawal)
        ]
        
        return [
            .profile(items: profileItems),
            .myInfo(title: "\(AuthManager.shared.getUser()?.name ?? "")님의 Grace Log", items: myInfoItems),
            .community(title: "공동체 및 친구관리", items: communityItems),
            .notification(title: "푸시 알림 설정", items: notificationItems),
            .customerService(title: "고객센터", items: customerServiceItems),
            .logout(title: "계정 설정", items: logoutItems),
            .withdrawal(title: "", items: withdrawalItem)
        ]
    }
}

// MARK: - For Coordinator
extension MyInfoViewReactor {
    func pushMyInfoEdit() {
        self.coordinator?.showProfileEditVC()
    }
}
