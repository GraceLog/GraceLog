//
//  DefaultAnnouncementRepository.swift
//  GraceLog
//
//  Created by 이상준 on 1/21/26.
//

import Foundation
import RxSwift

final class DefaultAnnouncementRepository: AnnouncementRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchAnnoucementList() -> Single<[Announcement]> {
        return network.request(AnnouncementAPI.fetchAnnouncementList)
            .map { (responseDTO: [AnnouncementResponseDTO]) in
                return responseDTO.map { announcementResponseDTO in
                    return Announcement(
                        id: announcementResponseDTO.id,
                        title: announcementResponseDTO.title,
                        contents: announcementResponseDTO.description,
                        createdAt: DateFormatterFactory.dateTimeWithISO.date(from: announcementResponseDTO.createdAt)
                    )
                }
            }
    }
    
    func fetchAnnouncement(id: Int) -> Single<Announcement> {
        return network.request(AnnouncementAPI.fetchAnnouncement(id))
            .map { (responseDTO: AnnouncementResponseDTO) in
                return Announcement(
                    id: responseDTO.id,
                    title: responseDTO.title,
                    contents: responseDTO.description,
                    createdAt: DateFormatterFactory.dateTimeWithISO.date(from: responseDTO.createdAt)
                )
            }
    }
}
