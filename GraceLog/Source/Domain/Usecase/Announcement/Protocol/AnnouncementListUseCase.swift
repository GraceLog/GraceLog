//
//  AnnouncementListUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 9/17/25.
//

import RxRelay

protocol AnnouncementListUseCase {
    var announcementList: BehaviorRelay<[Announcement]> { get }
    
    func fetchAnnouncementList()
}
