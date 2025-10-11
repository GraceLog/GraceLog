//
//  DefaultDiaryDetailsUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 10/5/25.
//

import RxRelay

final class DefaultDiaryDetailsUseCase: DiaryDetailsUseCase {
    var diary = PublishRelay<DiaryDetails>()
    var selectedDateDiaryList = BehaviorRelay<[DiaryDetails]>(value: [])
    var likeDiaryResult = PublishRelay<Bool>()
    var unlikeDiaryResult = PublishRelay<Bool>()
    
    private let diaryId: Int
    
    init(diaryId: Int) {
        self.diaryId = diaryId
    }
    
    func fetchDiaryDetails(diaryId: Int?) {
        let targetId = diaryId ?? self.diaryId
        
        let diaryList = [
            DiaryDetails(
                id: 1,
                title: "스터디 카페에 새로운 손님이?",
                description: "처음에는 한숨만 나오고 절망을 느꼈다. 하지만 하나님께서는 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로",
                authorId: 1,
                authorNickname: "승렬",
                imageURLs: [URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")],
                likeCount: 0,
                isLiked: false,
                isHideLike: true,
                isHideComment: false,
                commentCount: 5,
                createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? Date()
            ),
            DiaryDetails(
                id: 2,
                title: "편안한 퇴근길\nfeat. 현대버스",
                description: "회사에서 퇴근하고 나와보니 비가 부슬 부슬 내린다. 오늘 많은 일들이 있었다. 클라이언트사에서 직접 방문해 오전에 회의가 있었고, 이와 관련해 서울 성수에서 같은 프로그램에 참여하는 모든 기업을 대상으로 두 시간이 넘는 오리엔테이션이 진행되었다.\n\n평소에 절대적인 수면량이 많지 않다보니 퇴근할 즈음에는 배터리(체력)이 거의 소진된다. 그래서 요즘에는 지하철이 아닌 버스를 타면서 자고간다..\n\n근데 오늘은 왠걸? 현대자동차에서 나온 최신 버스가 광역버스로 왔다. 최신형의 맨 앞줄 간격은 이전보다 더욱 넓어졌기 때문에 리무진 급으로 다리를 뻗고 갈 수 있고, 시트의 폭신함은 더욱 개선되어 편하게 하남에 갈 수 있다. 오늘 정말 힘들었는데.. 이렇게 좋은 버스를 보내주신 예수님께 정말 감사하다. 어릴 때부터 버스와 기차를 좋아하는 걸 아시고 자취 시절부터 원없이 버스와 기차를 타면서 하남과 포항을 왕복했다. 별 것 아닌 것처럼 보일 수 있지만 나에게는 정말 감사한 부분이다.\n\n(아래 여백 채우는 문장입니다.)",
                authorId: 1,
                authorNickname: "승렬",
                imageURLs: [URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")],
                likeCount: 10,
                isLiked: true,
                isHideLike: false,
                isHideComment: false,
                commentCount: 5,
                createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 6)) ?? Date()
            ),
            DiaryDetails(
                id: 3,
                title: "그럼에도 불구하고",
                description: "그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고",
                authorId: 1,
                authorNickname: "승렬",
                imageURLs: [URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")],
                likeCount: 5,
                isLiked: false,
                isHideLike: false,
                isHideComment: true,
                commentCount: 6,
                createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 9)) ?? Date()
            ),
        ]
        
        if let foundDiary = diaryList.first(where: { $0.id == targetId }) {
            diary.accept(foundDiary)
        }
    }
    
    func fetchSelectedDateDiaryDetails(startDate: String, endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            selectedDateDiaryList.accept([])
            return
        }
        
        let diaryList = [
            DiaryDetails(
                id: 1,
                title: "스터디 카페에 새로운 손님이?",
                description: "처음에는 한숨만 나오고 절망을 느꼈다. 하지만 하나님께서는 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로 나의 시선을 바꾸셨다. 이후로",
                authorId: 1,
                authorNickname: "승렬",
                imageURLs: [URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")],
                likeCount: 0,
                isLiked: false,
                isHideLike: true,
                isHideComment: false,
                commentCount: 5,
                createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? Date()
            ),
            DiaryDetails(
                id: 2,
                title: "편안한 퇴근길\nfeat. 현대버스",
                description: "회사에서 퇴근하고 나와보니 비가 부슬 부슬 내린다. 오늘 많은 일들이 있었다. 클라이언트사에서 직접 방문해 오전에 회의가 있었고, 이와 관련해 서울 성수에서 같은 프로그램에 참여하는 모든 기업을 대상으로 두 시간이 넘는 오리엔테이션이 진행되었다.\n\n평소에 절대적인 수면량이 많지 않다보니 퇴근할 즈음에는 배터리(체력)이 거의 소진된다. 그래서 요즘에는 지하철이 아닌 버스를 타면서 자고간다..\n\n근데 오늘은 왠걸? 현대자동차에서 나온 최신 버스가 광역버스로 왔다. 최신형의 맨 앞줄 간격은 이전보다 더욱 넓어졌기 때문에 리무진 급으로 다리를 뻗고 갈 수 있고, 시트의 폭신함은 더욱 개선되어 편하게 하남에 갈 수 있다. 오늘 정말 힘들었는데.. 이렇게 좋은 버스를 보내주신 예수님께 정말 감사하다. 어릴 때부터 버스와 기차를 좋아하는 걸 아시고 자취 시절부터 원없이 버스와 기차를 타면서 하남과 포항을 왕복했다. 별 것 아닌 것처럼 보일 수 있지만 나에게는 정말 감사한 부분이다.\n\n(아래 여백 채우는 문장입니다.)",
                authorId: 1,
                authorNickname: "승렬",
                imageURLs: [URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")],
                likeCount: 10,
                isLiked: true,
                isHideLike: false,
                isHideComment: false,
                commentCount: 5,
                createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 6)) ?? Date()
            ),
            DiaryDetails(
                id: 3,
                title: "그럼에도 불구하고",
                description: "그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고그럼에도 불구하고",
                authorId: 1,
                authorNickname: "승렬",
                imageURLs: [URL(string: "https://png.pngtree.com/png-vector/20250703/ourlarge/pngtree-a-large-green-tree-isolated-illustration-on-transparent-background-part-5-png-image_16692036.webp")],
                likeCount: 5,
                isLiked: false,
                isHideLike: false,
                isHideComment: true,
                commentCount: 6,
                createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 9)) ?? Date()
            ),
        ]
        
        let filteredList = diaryList.filter { diary in
            diary.createdAt >= start && diary.createdAt <= end
        }
        
        selectedDateDiaryList.accept(filteredList)
    }
    
    func likeDiary(id: Int) {
        print("좋아요한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        likeDiaryResult.accept(result)
    }
    
    func unlikeDiary(id: Int) {
        print("좋아요 해제한 감사일기 id \(id)")
        
        let result = [true, false].shuffled()[0]
        unlikeDiaryResult.accept(result)
    }
}
