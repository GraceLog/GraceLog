//
//  DefaultVideoRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/31/25.
//

import Foundation
import RxSwift

final class DefaultVideoRepository: VideoRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchVideoList() -> Single<VideoInfo> {
        return network.request(YoutubeAPI.fetchVideo)
            .map { (responseDTO: VideoResponseDTO) in
                return VideoInfo(
                    tags: responseDTO.keywords,
                    videoList: responseDTO.videoList.map { youtubeResponse in
                        RecommendedVideo(
                            title: youtubeResponse.title,
                            imageURL: youtubeResponse.titleImageUrl,
                            videoURL: youtubeResponse.videoUrl
                        )
                    }
                )
            }
    }
}
