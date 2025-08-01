//
//  ProfileEditViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 4/15/25.
//

import ReactorKit
import RxSwift
import RxCocoa

final class ProfileEditViewReactor: Reactor {
    enum Action {
        case updateProfileImage(UIImage?)
        case updateNickname(String)
        case updateName(String)
        case updateMessage(String)
        case didTapProfileImageEdit
        case didTapSaveButton
    }
    
    enum Mutation {
        case setProfileImageURL(URL?)
        case setSelectedImage(UIImage?)
        case setNickname(String)
        case setName(String)
        case setMessage(String)
        case setError(Error)
        case setUpdateUserResult(Bool)
    }
    
    struct State {
        var profileImageURL: URL?
        var nickname: String
        var name: String
        var message: String
        
        @Pulse var selectedImage: UIImage?
        @Pulse var isSuccessUpdateUser: Bool?
        @Pulse var error: Error?
    }
    
    var initialState: State
    weak var coordinator: ProfileEditCoordinator?
    private let usecase: DefaultMyInfoUseCase
    
    init(coordinator: ProfileEditCoordinator? = nil, useCase: DefaultMyInfoUseCase) {
        self.coordinator = coordinator
        self.usecase = useCase
        
        self.initialState = State(
            profileImageURL: UserManager.shared.profileImageURL,
            nickname: UserManager.shared.nickname,
            name: UserManager.shared.name,
            message: UserManager.shared.message,
            selectedImage: nil,
            isSuccessUpdateUser: nil,
            error: nil
        )
    }
}

extension ProfileEditViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateProfileImage(let image):
            return .just(.setSelectedImage(image))
        case .updateNickname(let nickname):
            return .just(.setNickname(nickname))
        case .updateName(let name):
            return .just(.setName(name))
        case .updateMessage(let message):
            return .just(.setMessage(message))
        case .didTapProfileImageEdit:
            coordinator?.showImagePicker { [weak self] image in
                self?.action.onNext(.updateProfileImage(image))
            }
            return .empty()
        case .didTapSaveButton:
            usecase.updateUser(
                name: currentState.name,
                nickname: currentState.nickname,
                profileImage: currentState.selectedImage?.pngData(),
                message: currentState.message
            )
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        Observable.merge(
            usecase.updateUserResult.map { .setUpdateUserResult($0) },
            mutation
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProfileImageURL(let url):
            newState.profileImageURL = url
            newState.selectedImage = nil
        case .setSelectedImage(let image):
            newState.selectedImage = image
        case .setNickname(let nickname):
            newState.nickname = nickname
        case .setName(let name):
            newState.name = name
        case .setMessage(let message):
            newState.message = message
        case .setError(let error):
            newState.error = error
        case .setUpdateUserResult(let isSuccess):
            newState.isSuccessUpdateUser = isSuccess
        }
        
        return newState
    }
}
