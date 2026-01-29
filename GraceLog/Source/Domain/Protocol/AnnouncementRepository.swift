//
//  AnnouncementRepository.swift
//  GraceLog
//
//  Created by 이상준 on 1/21/26.
//

import Foundation
import RxSwift

protocol AnnouncementRepository {
    func fetchAnnoucementList() -> Single<[Announcement]>
    func fetchAnnouncement(id: Int) -> Single<Announcement>
}
