//
//  AnnouncementUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import RxRelay

protocol AnnouncementDetailUseCase {
    var announcement: PublishRelay<Announcement> { get }
    
    func fetchAnnouncementDetail()
}
