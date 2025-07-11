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
    var diaryList = BehaviorRelay<[MyDiaryItem]>(value: [])
    var videoList = BehaviorRelay<[HomeVideoItem]>(value: [])
    var error = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func fetchDiaryList() {
        diaryList.accept([
            MyDiaryItem(
                date: "오늘\n2/14",
                dateDesc: "오늘의 감사일기",
                title: "스터디 카페에 새로운 손님이?",
                desc: "처음에는 한숨만 나오고 절망을 느꼈다. 하지만 하나님께서는 나의 시선을 바꾸셨다. 이후로...",
                tags: ["#순종", "#도전", "#새해", "#스터디카페"],
                image: UIImage(named: "diary1")
            ),
            MyDiaryItem(
                date: "지난주\n2/7",
                dateDesc: "지난주 이시간",
                title: "어쩌다 보니 창업...",
                desc: "",
                tags: [],
                image: UIImage(named: "diary2")
            ),
            MyDiaryItem(
                date: "작년\n12/1",
                dateDesc: "작년 12월",
                title: "그럼에도 불구하고",
                desc: "",
                tags: [],
                image: UIImage(named: "diary3")
            )
        ])
    }

    func fetchVideoList() {
        videoList.accept([
            HomeVideoItem(
                title: "말씀노트",
                imageName: "content1"
            ),
            HomeVideoItem(
                title: "더메세지 랩The Message LAB",
                imageName: "content2"
            )
        ])
    }

}
