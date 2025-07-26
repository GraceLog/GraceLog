//
//  LoginRepository.swift
//  GraceLog
//
//  Created by 이상준 on 12/29/24.
//

import Foundation
import RxSwift

protocol UserRepository {
    func fetchUser() -> Single<GraceLogUser>
    func updateUser(
        name: String,
        nickname: String,
        profileImage: URL?,
        message: String
    ) -> Single<GraceLogUser>
}
