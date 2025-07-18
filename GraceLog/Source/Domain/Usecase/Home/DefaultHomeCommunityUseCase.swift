//
//  DefaultHomeCommunityUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 7/6/25.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultHomeCommunityUseCase: HomeCommunityUseCase {
    var diaryList = BehaviorRelay<[CommunityDiary]>(value: [])
    var communityList = BehaviorRelay<[Community]>(value: [])
    
    var likeDiaryResult = PublishRelay<Bool>()
    var unlikeDiaryResult = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchDiaryList(community: Community) {
        print("선택한 커뮤니티 정보: \(community)")
        
        diaryList.accept([
            .init(id: "1", title: "제목1", content: "내용1", editedDate: Date(timeIntervalSinceNow: 24 * 60 * 60), isLiked: true, likeCount: 3, commentCount: 2, username: "이상준", profileImageURL: URL(string: "https://cdn.imweb.me/thumbnail/20240206/8e66c2cb5284d.jpg"), diaryImageURL: URL(string: "https://marketplace.canva.com/MQp8I/MAGdTAMQp8I/1/tl/canva-cute-kawaii-dinosaur-character-illustration-MAGdTAMQp8I.png"), isCurrentUser: true),
            .init(id: "2", title: "제목2", content: "내용2", editedDate: Date(timeIntervalSinceNow: 24 * 60), isLiked: true, likeCount: 3, commentCount: 2, username: "이건준", profileImageURL: URL(string: "https://cdn.imweb.me/thumbnail/20240206/f520d5bdbd28e.jpg"), diaryImageURL: URL(string: "https://static.cdn.kmong.com/gigs/F1zfb1718452618.jpg"), isCurrentUser: false),
            .init(id: "3", title: "제목3", content: "내용3", editedDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60), isLiked: true, likeCount: 3, commentCount: 2, username: "문진우", profileImageURL: URL(string: "https://www.icreta.com/files/attach/images/319/275/055/8e2c1590a474a9afb78c4cb23a9af5b2.jpg"), diaryImageURL: URL(string: "https://d2ur3228349jyd.cloudfront.net/assets/img/characters/mv/pochacco.png"), isCurrentUser: true),
            .init(id: "4", title: "제목4", content: "내용4", editedDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60), isLiked: true, likeCount: 3, commentCount: 2, username: "신범철", profileImageURL: URL(string: "https://thumbnail.10x10.co.kr/webimage/image/basic600/659/B006593970.jpg?cmd=thumb&w=400&h=400&fit=true&ws=false"), diaryImageURL: URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2017%2F07%2Fgame-characters-pikachu.jpg?w=1260&cbr=1&q=90&fit=max"), isCurrentUser: true),
            .init(id: "5", title: "제목5", content: "내용5", editedDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60), isLiked: true, likeCount: 3, commentCount: 2, username: "승렬", profileImageURL: URL(string: "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/944/eabb97e854d5e5927a69d311701cc211_res.jpeg"), diaryImageURL: URL(string: "https://marketplace.canva.com/bAeSM/MAFiY_bAeSM/1/tl/canva-cute-happy-frog-character-MAFiY_bAeSM.png"), isCurrentUser: false),
            .init(id: "6", title: "제목6", content: "내용6", editedDate: Date(timeIntervalSinceNow: 24), isLiked: true, likeCount: 3, commentCount: 2, username: "나", profileImageURL: nil, diaryImageURL: URL(string: "https://png.pngtree.com/png-vector/20200222/ourmid/pngtree-kawaii-cute-orange-illustration-character-png-image_2151427.jpg"), isCurrentUser: false)
        ].shuffled())
    }
    
    func fetchCommunityList() {
        communityList.accept(Community.allCases)
    }
    
    func likeDiary(id: String) {
        // TODO: - 감사일기 좋아요에 대한 서버 연동
        print("좋아요한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        likeDiaryResult.accept(result)
    }
    
    func unlikeDiary(id: String) {
        // TODO: - 감사일기 좋아요 해제에 대한 서버 연동
        print("좋아요 해제한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        unlikeDiaryResult.accept(result)
    }
}

struct CommunityDiary {
    let id: String
    let title: String
    let content: String
    let editedDate: Date
    let isLiked: Bool
    let likeCount: Int
    let commentCount: Int
    let username: String
    let profileImageURL: URL?
    let diaryImageURL: URL?
    let isCurrentUser: Bool
}
