//
//  AnnouncementUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import RxRelay

protocol AnnouncementUseCase {
    var announcementList: BehaviorRelay<[Announcement]> { get }
    var selectedAnnouncement: PublishRelay<Announcement> { get }
    
    func fetchAnnouncementList()
    func fetchAnnouncementDetail(_ id: Int)
}
