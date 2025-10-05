//
//  SearchCommunityUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 9/21/25.
//

import RxRelay

protocol SearchCommunityUseCase {
    var popularCommunityList: BehaviorRelay<[Community]> { get }
    var roomList: BehaviorRelay<[CommunityRoom]> { get }
    var profileList: BehaviorRelay<[ProfileItem]> { get }
    
    func fetchPopularCommunity()
    func fetchRoomList()
    func fetchProfileList()
    func searchCommunity(query: String)
}
