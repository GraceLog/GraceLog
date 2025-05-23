//
//  MyInfoUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 5/23/25.
//

import Foundation
import RxSwift

protocol MyInfoUseCase {
    func updateUser(user: GraceLogUser) -> Single<GraceLogUser>
}
