//
//  MyInfoUseCase.swift
//  GraceLog
//
//  Created by 이상준 on 5/23/25.
//

import Foundation
import RxSwift
import RxRelay

protocol MyInfoUseCase {
    var updateUserResult: PublishRelay<Bool> { get }
    
    func updateUser(
        name: String,
        nickname: String,
        profileImage: Data?,
        message: String
    )
}
