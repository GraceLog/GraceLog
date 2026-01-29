//
//  DefaultAnnouncementDetailUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 9/18/25.
//

import RxSwift
import RxRelay

final class DefaultAnnouncementDetailUseCase: AnnouncementDetailUseCase {
    var announcement = BehaviorRelay<Announcement?>(value: nil)
    var error = PublishRelay<Error>()
    
    private let announcementRepository: AnnouncementRepository
    private let announcementId: Int
    private let disposeBag = DisposeBag()
    
    init(
        announcementRepository: AnnouncementRepository,
        announcementId: Int
    ) {
        self.announcementRepository = announcementRepository
        self.announcementId = announcementId
    }
    
    func fetchAnnouncementDetail() {
        announcementRepository.fetchAnnouncement(id: announcementId)
            .subscribe(onSuccess: {
                self.announcement.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
