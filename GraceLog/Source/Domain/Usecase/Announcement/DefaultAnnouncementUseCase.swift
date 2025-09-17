//
//  DefaultAnnouncementUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import RxRelay

final class DefaultAnnouncementUseCase: AnnouncementUseCase {
    var announcementList = BehaviorRelay<[Announcement]>(value: [])
    var selectedAnnouncement = PublishRelay<Announcement>()
    
    func fetchAnnouncementList() {
        announcementList.accept([
            Announcement(id: 1, title: "Grace Log 베타 테스트 시작!", contents: "Grace Log의 베타 테스트가 시작되었습니다. 테스트 참가를 희망하시는 분들은 문의하기를 통해 관리자에게 신청해주세요!", createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 7))!),
            Announcement(id: 2, title: "디자인 고도화 작업", contents: "현재 Gract Log는 디자인 틀이 완성된 상태입니다. 앞으로 로고와 아이콘 그리고 인터페이스에 대한 고도화 작업을 진행할 예정입니다.", createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 7))!),
            Announcement(id: 3, title: "전체적인 틀 변경은 없습니다", contents: "디자인 고도화 작업을 진행한다고 해서 전체적인 틀은 바뀌지 않습니다. 눈썹라인 그리고 아이셰도우 그리는 것처럼 디테일을 손 볼 예정이에요!", createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 17))!)
        ])
    }
    
    func fetchAnnouncementDetail(_ id: Int) {
        if let announcement = announcementList.value.first(where: { $0.id == id }) {
            selectedAnnouncement.accept(announcement)
        }
    }
}
