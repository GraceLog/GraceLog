//
//  HomeUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 3/8/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeUseCase {
    var homeMyData: BehaviorSubject<HomeContent?> { get }
    var user: BehaviorSubject<GraceLogUser?> { get }
    var error: PublishSubject<Error> { get }
    
    func fetchUser()
    func fetchHomeMyContent()
}
