//
//  DefaultAnnouncementUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 9/13/25.
//

import RxSwift
import RxRelay

final class DefaultAnnouncementListUseCase: AnnouncementListUseCase {
    var announcementList = BehaviorRelay<[Announcement]>(value: [])
    var error = PublishRelay<Error>()
    
    private let announcementRepository: AnnouncementRepository
    private let disposeBag = DisposeBag()
    
    init(announcementRepository: AnnouncementRepository) {
        self.announcementRepository = announcementRepository
    }
    
    func fetchAnnouncementList() {
        announcementRepository.fetchAnnoucementList()
            .subscribe(onSuccess: {
                self.announcementList.accept($0)
            }, onFailure: {
                self.error.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
