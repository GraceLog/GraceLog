//
//  DefaultHomeUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultHomeUseCase: HomeUseCase {
    var dailyVerse = BehaviorRelay<DailyVerse?>(value: nil)
    var diaryList = BehaviorRelay<[MyDiary]>(value: [])
    var videoList = BehaviorRelay<[RecommendedVideo]>(value: [])
    var videoTagList = BehaviorRelay<[VideoTag]>(value: [])
    
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchDiaryList() {
        diaryList.accept([
//            MyDiary(
//                editedDate: Date(),
//                title: "스터디 카페에 새로운 손님이?",
//                content: "처음에는 한숨만 나오고 절망을 느꼈다. 하지만 하나님께서는 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로",
//                imageURL: URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")
//            ),
//            MyDiary(
//                editedDate: Date().addingTimeInterval(-86400 * 7),
//                title: "지난주 이시간",
//                content: "어쩌다 보니 창업어쩌다 보니 창업어쩌다 보니 창업",
//                imageURL: URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")
//            ),
//            MyDiary(
//                editedDate: Date().addingTimeInterval(-86400 * 365),
//                title: "작년 12월",
//                content: "그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고",
//                imageURL: URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")
//            ),
//            MyDiary(
//                editedDate: Date().addingTimeInterval(-86400 * 7 + 100),
//                title: "지난주 + 100",
//                content: "그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고",
//                imageURL: URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")
//            ),
//            MyDiary(
//                editedDate: Date().addingTimeInterval(-86400 * 365 + 100),
//                title: "작년 + 100",
//                content: "그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고",
//                imageURL: URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")
//            )
        ])
    }

    func fetchVideoList() {
        videoList.accept([
            RecommendedVideo(
                title: "말씀노트",
                imageURL: URL(string: "https://pimg.mk.co.kr/meet/neds/2017/11/image_readmed_2017_740612_15101228583092607.jpg")
            ),
            RecommendedVideo(
                title: "더메세지 랩The Message LAB",
                imageURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX4sCVSr1te6gasrpW9pSDUrQ46cf9rP7t8w&s")
            )
        ])
        
        videoTagList.accept([
            VideoTag(name: "순종"),
            VideoTag(name: "도전")
        ])
    }

    func fetchDailyVerse() {
        dailyVerse.accept(
            DailyVerse(
                content:"순종이 제사보다 낫고\n듣는 것이 숫양의 기름보다 나으니",
                reference: "사무엘상 5:22"
            )
        )
    }
}
