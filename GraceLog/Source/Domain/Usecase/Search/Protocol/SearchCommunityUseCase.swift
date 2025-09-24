//
//  SearchCommunityUseCase.swift
//  GraceLog
//
//  Created by 이건준 on 9/21/25.
//

import RxRelay

protocol SearchCommunityUseCase {
    var popularCommunityList: BehaviorRelay<[Community]> { get }
    var chattingList: BehaviorRelay<[CommunityChatting]> { get }
    var profileList: BehaviorRelay<[ProfileItem]> { get }
    
    func fetchPopularCommunity()
    func fetchChattingList()
    func fetchProfileList()
    func searchCommunity(query: String)
}
