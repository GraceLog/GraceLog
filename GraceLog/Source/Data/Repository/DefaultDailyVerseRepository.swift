//
//  DefaultDailyVerseRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/31/25.
//

import Foundation
import RxSwift

final class DefaultDailyVerseRepository: DailyVerseRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchDailyVerse() -> Single<DailyVerse> {
        return network.request(DailyVerseAPI.fetchDailyVerse)
            .map { (responseDTO: DailyVerseResponseDTO) in
                return DailyVerse(
                    content: responseDTO.text,
                    reference: "\(responseDTO.book) \(responseDTO.chapter):\(responseDTO.verse)"
                )
            }
    }
}
